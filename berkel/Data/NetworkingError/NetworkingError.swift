//
//  NetworkingError.swift
//  berkel
//
//  Created by Onur Yilmaz on 9.09.2023.
//

import Foundation
import Combine

typealias ErrorStateSubject = CurrentValueSubject<NetworkingError?, Never>
typealias ScreenStateSubject<T> = CurrentValueSubject<T?, Never>


enum NetworkingError: CustomStringConvertible {
    case COMMON_ERROR(error: Error)
    case UNDEFINED_RESPONSE_TYPE

    var description: String {
        switch self {
        case .COMMON_ERROR(let error):
            return "Bir Sorun Oluştu\n\n\(error.localizedDescription)"
        case .UNDEFINED_RESPONSE_TYPE:
            return "Tanımlanamayan server dönüşü"
        }
    }
}
