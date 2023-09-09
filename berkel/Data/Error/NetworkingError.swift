//
//  NetworkingError.swift
//  berkel
//
//  Created by Onur Yilmaz on 9.09.2023.
//

import Foundation
import Combine

typealias ErrorStateSubject = CurrentValueSubject<NetworkingError?, Never>


enum NetworkingError: CustomStringConvertible {
    case COMMON_ERROR(error: Error)
    case UNDEFINED_RESPONSE_TYPE

    var description: String {
        switch self {
        case .COMMON_ERROR(let error):
            return "Bir sorun oluştu.\n\(error.localizedDescription)"
        case .UNDEFINED_RESPONSE_TYPE:
            return "Tanımlanamayan server dönüşü"
        }
    }
}
