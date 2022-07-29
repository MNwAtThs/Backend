import Fluent
import Foundation
import SwiftUI
import Vapor

//let twilioClient = twilio( accountSid: "ACXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX", authToken: "your_auth_token")

//Same Concept as an Interface in JS
protocol IValidateResponse {
    var isValid: Bool { get }
    var phonenumber: String? { get }

}

struct validateResponse: IValidateResponse {
    var isValid: Bool
    var phonenumber: String?

    init(isValid: Bool, phonenumber: String?) {
        self.isValid = isValid
        self.phonenumber = phonenumber
    }
}

struct sendSmsResponse: IValidateResponse {
    var isValid: Bool

    var phonenumber: String?

    //let messageSid = await twilioClient.sendMessage(to: "", from: "", body: "");
}

class defaultformat {
    //validate()
    //format()
    //sendSmsResponse()
}
