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
        let body = try req.content.decode(CreateUserDto.Request.self)
        try CreateUserDto.Request.validate(content: req)

        let count = try await User.query(on: req.db)
            .filter(\.$username, .equal, body.username)
            .count()

        guard count == 0 else {
            throw Abort(.conflict)
        }

        let digest = try await req.password.async.hash(body.password)
        let user = User(username: body.username, password: digest)
        try await user.save(on: req.db)
        return CreateUserDto.Response(
            user: .init(
                id: user.id!,
                username: user.username
            )
        )
    }

    func login(req: Request) async throws -> LoginDto.Response {
        let body = try req.content.decode(LoginDto.Request.self)
        try LoginDto.Request.validate(content: req)
        let user = try await User.query(on: req.db)
            .filter(\.$username, .equal, body.username)
            .first()

        guard let user = user else {
            throw Abort(.notFound)
        }

        guard let isValidPassword = try? req.password.verify(body.password, created: user.password),
            isValidPassword
        else {
            throw Abort(.unauthorized)
        }

        // Todo: generate JWT Token

        return .init(
            user: .init(
                id: user.id!,
                username: user.username
            ),
            token: ""
        )
    }
}
