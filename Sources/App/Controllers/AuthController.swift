import Redis
import Shared
import Vapor

struct AuthController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let group = routes.grouped("auth")  // this will be /auth
        group.post("register", use: register)  // this will be /auth/register
        group.post("login", use: login)  // this will be /auth/login

        let protected = group.grouped(UserAuthenticator())
        protected.post("logout", use: logout)
    }
}

extension AuthController {
    func register(req: Request) async throws -> Response {
        // validate body
        let body = try req.content.decode(CreateUserDto.Request.self)
        try CreateUserDto.Request.validate(content: req)

        // check if user already exists
        let count = try await User.query(on: req.db).group(.or) { group in
            group
                .filter(\.$username, .equal, body.username)
                .filter(\.$email, .equal, body.email)
        }
        .count()

        guard count == 0 else {
            throw Abort(.custom(code: 400, reasonPhrase: "username or email already in use"))
        }

        // hash password
        let digest = try await req.password.async.hash(body.password)

        // save user to db
        let user = User(username: body.username, email: body.email, password: digest)
        try await user.save(on: req.db)

        // return saved user
        let dto = CreateUserDto.Response(
            user: .init(from: user)
        )

        let response: Response = .init(status: .created)
        try response.content.encode(dto)
        return response
    }

    func login(req: Request) async throws -> LoginDto.Response {
        // validate body
        let body = try req.content.decode(LoginDto.Request.self)
        try LoginDto.Request.validate(content: req)

        // check user exists
        let user = try await User.query(on: req.db)
            .filter(\.$username, .equal, body.username)
            .first()

        guard let user = user,
            let userId = user.id
        else {
            throw Abort(.notFound)
        }

        // check if password matches
        guard let isValidPassword = try? req.password.verify(body.password, created: user.password),
            isValidPassword
        else {
            throw Abort(.unauthorized)
        }

        // create and sign JWT payload
        let payload = UserTokenPayload(
            subject: .init(value: userId.uuidString)
        )
        let jwt = try req.jwt.sign(payload)

        let _ = try await req.redis.sadd([jwt], to: .usertoken(.uuid(userId))).get()
        // _ = try await req.redis.expire(redisKey, after: .hours(1)).get()

        // return logged in user and saved JWT token
        return .init(
            user: .init(from: user),
            token: jwt
        )
    }

    func logout(req: Request) async throws -> Response {
        let user = try req.auth.require(User.self)

        guard let token = req.headers.bearerAuthorization?.token,
            let userId = user.id
        else {
            throw Abort(.unauthorized)
        }

        let _ = try await req.redis.srem([token], from: .usertoken(.uuid(userId))).get()

        return .init(status: .noContent, body: .empty)
    }
}
