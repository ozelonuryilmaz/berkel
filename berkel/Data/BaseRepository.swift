//
//  BaseRepository.swift
//  berkel
//
//  Created by Onur Yilmaz on 5.09.2023.
//

import Foundation
import Combine
import CombineFirebaseFirestore

typealias FirestoreResponseType<ResultData: Codable> = PassthroughSubject<ResultData, Error>

protocol IBaseRepository: AnyObject { }

class BaseRepository: IBaseRepository {

    var cancelBag = Set<AnyCancellable>()

    deinit {
        print("killed: \(type(of: self))")
    }

    // Collection içerisinde verileri getirir.
    func getDocuments<T: Codable>(_ db: CollectionServiceType) -> FirestoreResponseType<[T]> {
        let subject = FirestoreResponseType<[T]>()

        db.collectionReference
            .getDocuments(as: T.self)
            .sink(receiveCompletion: { result in
            switch result {
            case .failure(let error):
                subject.send(completion: .failure(error))
            case .finished:
                break
            }
        }, receiveValue: { snapshot in
            subject.send(snapshot)
        }).store(in: &cancelBag)

        return subject
    }
}
