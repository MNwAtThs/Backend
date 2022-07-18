
import Vapor

/// Register your application's routes here.
public func routes(_ router: Router) throws {
    let userController = UserController()
    
    // GET /users
    router.get("users", use: userController.list) 
    
    // POST /users
    router.post("users", use: userController.create)
    
    // PATCH /users/$id
    router.patch("users", User.parameter, use: userController.update)
    
    // DELETE /users/$id
    router.delete("users", User.parameter, use: userController.delete) 
}
