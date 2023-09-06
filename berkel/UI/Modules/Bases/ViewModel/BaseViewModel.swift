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
        callbackLoading: ((Bool) -> Void)?,
        callbackSuccess: ((CONTENT) -> Void)?,
        callbackError: (() -> Void)?
    ) {

        callbackLoading?(true)

        request.sink(receiveCompletion: { result in

            switch result {
            case .failure(_):
                callbackError?()
            case .finished:
                break
            }

            callbackLoading?(false)
        }, receiveValue: { value in
            
            callbackSuccess?(value)
            callbackLoading?(false)
        }).store(in: &cancelBag)
    }

}
