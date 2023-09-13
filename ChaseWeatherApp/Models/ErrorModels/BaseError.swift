import Foundation

//Basic template for standarizing error messages.
class BaseError: Error {
    let title: String
    let message: String
    
    init(errorTitle: String, errorMessage: String) {
        title = errorTitle
        message = errorMessage
    }
}
