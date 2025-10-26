import Foundation

enum ErrorType {
    case noInternet
    case serverError
    
    var imageName: String {
        switch self {
        case .noInternet: "no_internet"
        case .serverError: "server_error"
        }
    }
    
    var message: String {
        switch self {
        case .noInternet: "Нет интернета"
        case .serverError: "Ошибка сервера"
        }
    }
}
