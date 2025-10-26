import Foundation

enum AppError: Error {
    case noInternet
    case serverError
    case unknown
}

extension AppError {
    var errorType: ErrorType {
        switch self {
        case .noInternet: .noInternet
        case .serverError: .serverError
        default: .serverError
        }
    }
}
