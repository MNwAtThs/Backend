import Vapor

struct AuthController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let group = routes.grouped("auth")
        group.post("register", use: register)
        group.post("login", use: login)
    }
}

extension AuthController {
    func register(req: Request) async throws -> String {
        // handle registration
        let user = User()
        try await user.save(on: req.db)
        return "register"
    }

    func login(req: Request) async throws -> String {
        // handle login
        return "login"
    }
}