import Vapor

struct AuthController: RouteCollection {
  func boot(routes: RoutesBuilder) throws {
    let group = routes.grouped("auth")  // this will be /auth
    group.post("register", use: register)  // this will be /auth/register
    group.post("login", use: login)  // this will be /auth/login
  }
}

extension AuthController {
  // this handles the registration of a new user on /auth/register
  // now if we make a request to /auth/register a new user will be saved to the database
  func register(req: Request) async throws -> String {
    // handle registration
    let user = User(
      username: "TESTUSERFORDB",
      password: "",
      phone: ""
    )
    try await user.save(on: req.db)  //save the user to the database
    return "i can add anything i want in here and this will be in the response"  // this is the server response
  }

  // this handles the login of an existing user on /auth/login
  func login(req: Request) async throws -> String {
    // handle login

    return "login"
  }
}
