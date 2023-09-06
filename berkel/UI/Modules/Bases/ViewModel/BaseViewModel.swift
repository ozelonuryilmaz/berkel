//
//  BaseViewModel.swift
//  berkel
//
//  Created by Onur Yilmaz on 1.09.2023.
//

import Foundation
import Combine

enum ErrorState {
    case Error(errorType: NetworkingError)
    case ErrorComplete
}

enum NetworkingError: CustomStringConvertible {
    case COMMON_ERROR_MESSAGE
    case CUSTOM_ERROR

    var description: String {
        switch self {
        case .COMMON_ERROR_MESSAGE:
            return "networkConnectionMessage"
        case .CUSTOM_ERROR:
            return "common error"
        }
    }
}


class BaseViewModel {

    deinit {
        print("killed: \(type(of: self))")
    }

    var cancellables = Set<AnyCancellable>()

    // ErrorStateSubject, Observable, Signal, Resource, CustomError gibi tiplerin Combine'da karşılıkları yoktur.
    // Bunun yerine, Combine'da tanımlanan Publisher, Subscriber, AnyPublisher, AnySubscriber, Result, Fail gibi tipleri kullanabilirsiniz.
    // Ayrıca, Combine'da Future, Just, Empty gibi kolaylık sağlayan yayıncı tipleri de vardır.

    func handleResourceToAPIState<CONTENT: Codable, RESPONSE: Codable>(
        errorState: AnySubscriber<ErrorState?, Never>,
        response: CurrentValueSubject<RESPONSE?, Never>,
        request: PassthroughSubject<CONTENT, Never>
    ) {
        // Combine'da disposeBag yerine AnyCancellable tipinde bir değişken tanımlayabilirsiniz.
        // Bu değişkeni aboneliklerinizi iptal etmek için kullanabilirsiniz.
        // Ayrıca, iptal edilebilir kümesi (Set<AnyCancellable>) kullanarak birden fazla iptal edilebilir nesneyi yönetebilirsiniz.


        // request yayıncısına abone olmak için sink metodunu kullanabilirsiniz.
        // Bu metot size bir AnyCancellable nesnesi döndürür. Bu nesneyi iptal etmek için cancellables kümesine ekleyebilirsiniz.
        request
            .sink(receiveCompletion: { completion in
            // completion durumuna göre errorState değerini güncelleyebilirsiniz
            switch completion {
            case .finished:
                break
            case .failure(let error):
                break
            }
        }, receiveValue: { result in
            
        }).store(in: &cancellables)
    }


}
