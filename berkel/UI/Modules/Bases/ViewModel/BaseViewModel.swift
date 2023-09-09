//
//  BaseViewModel.swift
//  berkel
//
//  Created by Onur Yilmaz on 1.09.2023.
//

import Foundation
import Combine

class BaseViewModel {

    var cancelBag = Set<AnyCancellable>()

    deinit {
        print("killed: \(type(of: self))")
    }

    func handleResourceToFirestoreState<CONTENT: Codable, RESPONSE: Codable>(
        request: PassthroughSubject<CONTENT, Error>,
        response: CurrentValueSubject<RESPONSE?, Never>,
        errorState: ErrorStateSubject,
        callbackLoading: ((Bool) -> Void)? = nil,
        callbackSuccess: (() -> Void)? = nil,
        callbackComplete: (() -> Void)? = nil
    ) {

        callbackLoading?(true)

        request.sink(receiveCompletion: { result in

            switch result {
            case .failure(let error):
                errorState.value = .COMMON_ERROR(error: error)
                callbackComplete?()
                callbackLoading?(false)
            case .finished:
                callbackComplete?()
                callbackLoading?(false)
            }

        }, receiveValue: { value in
            if let castValue = value as? RESPONSE { // Tip dönüşümü karışmaması için RESPONSE eklendi.
                response.value = castValue
                // CurrentValueSubject<[BuyingResponseModel]?, Never>(nil)
                // ..Never>?(nil) araya ? konulduğunda data(value) yakalanamıyor
                callbackSuccess?()
            } else {
                errorState.value = .UNDEFINED_RESPONSE_TYPE
            }
        }).store(in: &cancelBag)
    }

}
