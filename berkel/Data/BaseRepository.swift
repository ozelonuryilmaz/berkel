//
//  BaseRepository.swift
//  berkel
//
//  Created by Onur Yilmaz on 5.09.2023.
//

import Foundation
import Combine
import FirebaseFirestore
import FirebaseStorage

typealias FirestoreResponseType<ResultData: Codable> = PassthroughSubject<ResultData, Error>

protocol IBaseRepository: AnyObject { }

class BaseRepository: IBaseRepository {

    var cancelBag = Set<AnyCancellable>()

    deinit {
        print("killed: \(type(of: self))")
    }

    // Collection içerisinde verileri getirir.
    func getDocuments<T: Codable>(_ db: CollectionServiceType, order: String, cursor: [String]? = nil, limit: Int? = nil) -> FirestoreResponseType<[T]> {

        var ref = db.collectionReference.order(by: order, descending: true)

        if cursor != nil {
            ref = ref.start(after: cursor!)
        }

        if limit != nil {
            ref = ref.limit(to: limit!)
        }

        let subject = FirestoreResponseType<[T]>()

        let onErrorCompletion: (Subscribers.Completion<Error>) -> Void = { completion in
            switch completion {
            case .failure(let error):
                subject.send(completion: .failure(error))
            case .finished:
                subject.send(completion: .finished)
            }
        }

        let onValue: (([T]) -> Void) = { snapshot in
            subject.send(snapshot)
        }

        // Sarak ayarlaource parametresini server ol
        // Tek bir seferlik verileri çekmek için kullanıldı. Cache iptal edildi.
        let source = FirestoreSource.server

        ref.getDocuments(source: source, as: T.self)
            .sink(receiveCompletion: onErrorCompletion,
                  receiveValue: onValue)
            .store(in: &cancelBag)

        return subject
    }

    // Documents'e veri ekler
    func setData<T: Codable>(_ db: DocumentReference, data: T) -> FirestoreResponseType<T> {
        let subject = FirestoreResponseType<T>()

        let onErrorCompletion: (Subscribers.Completion<Error>) -> Void = { completion in
            switch completion {
            case .finished:
                subject.send(completion: .finished)
            case .failure(let error):
                subject.send(completion: .failure(error))
            }
        }

        let onValue: () -> Void = {
            subject.send(data)
        }

        db.setData(from: data)
            .sink(receiveCompletion: onErrorCompletion,
                  receiveValue: onValue)
            .store(in: &cancelBag)

        return subject
    }

    // update data
    func updateData(_ db: DocumentReference, data: [AnyHashable: Any]) -> FirestoreResponseType<Bool> {
        let subject = FirestoreResponseType<Bool>()

        let onErrorCompletion: (Subscribers.Completion<Error>) -> Void = { completion in
            switch completion {
            case .finished:
                subject.send(completion: .finished)
            case .failure(let error):
                subject.send(completion: .failure(error))
            }
        }

        let onValue: () -> Void = {
            subject.send(true)
        }

        db.updateData(data)
            .sink(receiveCompletion: onErrorCompletion,
                  receiveValue: onValue)
            .store(in: &cancelBag)

        return subject
    }

    // save image and return image url
    func putData(_ db: StorageReference, data: Data) -> FirestoreResponseType<String> {
        let subject = FirestoreResponseType<String>()

        db.putData(data, metadata: nil) { (metadata, error) in
            if let error = error {
                subject.send(completion: .failure(error))
            } else {
                db.downloadURL(completion: { (url, error) in
                    if let error = error {
                        subject.send(completion: .failure(error))
                    } else if let imageUrl = url?.absoluteString {
                        subject.send(imageUrl)
                        subject.send(completion: .finished)
                    } else {
                        subject.send(completion: .failure(NSError(domain: "Image Url'e Ulaşılamadı", code: 50)))
                    }
                })
            }
        }

        return subject
    }
}
