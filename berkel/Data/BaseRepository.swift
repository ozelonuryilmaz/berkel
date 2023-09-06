//
//  BaseRepository.swift
//  berkel
//
//  Created by Onur Yilmaz on 5.09.2023.
//

import Foundation
import Combine
import CombineFirebaseFirestore

typealias FirestoreResponseType<ResultData: Codable> = PassthroughSubject<ResultData, Never>
typealias FirestoreCompletion = (Subscribers.Completion<Error>) -> Void


protocol IBaseRepository: AnyObject { }

class BaseRepository: IBaseRepository {

    var cancelBag = Set<AnyCancellable>()

    deinit {
        print("killed: \(type(of: self))")
    }

    // Collection içerisinde verileri getirir.
    func getDocuments<T: Codable>(_ db: CollectionServiceType,
                                  completionHandler: @escaping FirestoreCompletion) -> FirestoreResponseType<[T]> {
        let subject = FirestoreResponseType<[T]>()

        db.collectionReference
            .getDocuments(as: T.self)
            .sink(receiveCompletion: { (completion) in
            completionHandler(completion)
        }, receiveValue: { snapshot in
            subject.send(snapshot)
        }).store(in: &cancelBag)

        return subject
    }
}
