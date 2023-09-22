//
//  BaseRepository.swift
//  berkel
//
//  Created by Onur Yilmaz on 5.09.2023.
//

import Foundation
import Combine
import FirebaseFirestore

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

        // Source parametresini server olarak ayarla
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

}


/*
 
 
 //setSanFranciscoData(city: City(name: "Onur", state: "Aktif"))
 //addSanFranciscoDocument(city: City(name: "Onur", state: "Aktif"))
 self.setSanFranciscoData(city: City(name: "Onur", state: UUID().uuidString))
 
 func setSanFranciscoData(city: City) {
     let onErrorCompletion: (Subscribers.Completion<Error>) -> Void = { completion in
         switch completion {
         case .finished: print("🏁 finished")
         case .failure(let error): print("❗️ failure: \(error)")
         }
     }

     let onValue: () -> Void = {
         print("✅ value")
     }

     // Add a new document in collection "cities"
     (db.collection("cities")
         .document("SF")
         .setData(from: city) as AnyPublisher<Void, Error>) // Note: you can use (as Void) for simple setData({})
     .sink(receiveCompletion: onErrorCompletion, receiveValue: onValue)
         .store(in: &cancelBag)
 }

 // Add a new document with a generated id.
 func addSanFranciscoDocument(city: City) {
     (db.collection("cities")
         .addDocument(data: [
         "name": city.name ?? "nil",
         "state": city.state ?? "nil"
     ]) as AnyPublisher<DocumentReference, Error>)

         .sink(receiveCompletion: { completion in
         switch completion {
         case .finished:
             print("🏁 finished")
         case .failure(let error):
             print("❗️ failure: \(error)")
         }
     }, receiveValue: { value in
         print("** \(value.documentID)")
     })
         .store(in: &cancelBag)

 }

 func getDocument() {
     db.collection("seaons")
         .document("SF")
         .getDocument()
         .sink(receiveCompletion: { (completion) in
         switch completion {
         case .finished: print("🏁 finished")
         case .failure(let error): print("❗️ failure: \(error)")
         }
     }) { document in
         print("Document data: \(document.data())")
     }.store(in: &cancelBag)
 }

 func getCollection() {
     db.collection("seasons")
         .document("2022-2023")
         .collection("buying")
         .getDocuments()
         .sink(receiveCompletion: { (completion) in
         switch completion {
         case .finished: print("🏁 finished")
         case .failure(let error): print("❗️ failure: \(error)")
         }
     }, receiveValue: { value in
         value.documents.forEach { ss in
             print("***\(ss.documentID), \(ss.data())")
         }
     }).store(in: &cancelBag)
 }
 */
