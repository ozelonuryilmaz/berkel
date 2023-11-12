//
//  WorkerService.swift
//  berkel
//
//  Created by Onur Yilmaz on 2.11.2023.
//

import FirebaseFirestore

enum WorkerService {

    case list(season: String)
    case save(season: String)
    case collection(season: String, workerId: String)
    case payment(season: String, workerId: String)
    case worker(season: String, workerId: String, collectionId: String)
}

extension WorkerService: CollectionServiceType {

    var order: String {
        switch self {
        case .list(_), .collection(_,_), .payment(_,_):
            return "date"
        default:
            return ""
        }
    }

    var collectionReference: CollectionReference {
        switch self {
        case .save(let season), .list(let season):

            return Firestore
                .firestore()
                .collection("data")
                .document(season)
                .collection("worker")


        case .collection(let season, let workerId):

            return Firestore
                .firestore()
                .collection("data")
                .document(season)
                .collection("worker")
                .document(workerId)
                .collection("collections")
            
        case .payment(let season, let workerId):

            return Firestore
                .firestore()
                .collection("data")
                .document(season)
                .collection("worker")
                .document(workerId)
                .collection("payments")
            
        default:
            return Firestore
                .firestore()
                .document("")
                .collection("")
        }
    }
}


extension WorkerService: DocumentServiceType {

    var documentReference: DocumentReference {
        switch self {
        case .worker(let season, let workerId, let collectionId):

            return Firestore
                .firestore()
                .collection("data")
                .document(season)
                .collection("worker")
                .document(workerId)
                .collection("collections")
                .document(collectionId)
            
        case .collection(let season, let workerId):
            return Firestore
                .firestore()
                .collection("data")
                .document(season)
                .collection("worker")
                .document(workerId)

        default:
            return Firestore
                .firestore()
                .document("")
        }
    }


}
