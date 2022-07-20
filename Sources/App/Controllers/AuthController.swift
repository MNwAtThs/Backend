import Redis
import Shared
import Vapor

struct AuthController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let group = routes.grouped("auth")  // this will be /auth
        group.post("register", use: register)  // this will be /auth/register
        group.post("login", use: login)  // this will be /auth/login
    }
}

extension AuthController {
    func register(req: Request) async throws -> CreateUserDto.Response {
        // validate body
        let body = try req.content.decode(CreateUserDto.Request.self)
        try CreateUserDto.Request.validate(content: req)

        // check if user already exists
        let count = try await User.query(on: req.db)
            .filter(\.$username, .equal, body.username)
            .count()
        guard count == 0 else {
            throw Abort(.conflict)
        }

        // hash password
        let digest = try await req.password.async.hash(body.password)

        // save user to db
        let user = User(username: body.username, email: body.email, password: digest)
        try await user.save(on: req.db)

        // return saved user
        return CreateUserDto.Response(
            user: .init(
                id: user.id!,
                username: user.username
            )
        )
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

        let redisKey: RedisKey = "usertoken:\(jwt)"
        try await req.redis.set(redisKey, toJSON: payload)
        // _ = try await req.redis.expire(redisKey, after: .hours(1)).get()

        // return logged in user and saved JWT token
        return .init(
            user: .init(
                id: user.id!,
                username: user.username,
                email: user.email
            ),
            token: jwt
        )
    }
}
