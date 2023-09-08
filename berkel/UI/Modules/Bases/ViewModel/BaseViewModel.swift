//
//  BaseViewModel.swift
//  berkel
//
//  Created by Onur Yilmaz on 1.09.2023.
//

import Foundation
import Combine


typealias ErrorStateSubject = PassthroughSubject<ErrorState, Never>

enum ErrorState {
    case Error(errorType: NetworkingError)
    case ErrorComplete
}

enum NetworkingError: CustomStringConvertible {
    case COMMON_ERROR_MESSAGE(error: Error)
    case UNDEFINED_RESPONSE_TYPE

    var description: String {
        switch self {
        case .COMMON_ERROR_MESSAGE(let error):
            return "Bir hata oluştu. \(error)"
        case .UNDEFINED_RESPONSE_TYPE:
            return "Undefined Response"
        }
    }
}

class BaseViewModel {

    deinit {
        print("killed: \(type(of: self))")
    }

    var cancelBag = Set<AnyCancellable>()

    func handleResourceToFirestoreState<CONTENT: Codable>(
        request: PassthroughSubject<CONTENT, Error>,
        response: CurrentValueSubject<CONTENT, Never>?,
        callbackLoading: ((Bool) -> Void)? = nil,
        callbackSuccess: (() -> Void)? = nil,
        callbackComplete: (() -> Void)? = nil,
        callbackError: (() -> Void)? = nil
    ) {

        callbackLoading?(true)

        request.sink(receiveCompletion: { result in

            switch result {
            case .failure(_):
                callbackError?()
            case .finished:
                callbackComplete?()
                callbackLoading?(false)
            }

        }, receiveValue: { value in
            response?.send(value)
            callbackSuccess?()
        }).store(in: &cancelBag)
    }

}
