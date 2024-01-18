//
//  WorkerDetailRepository.swift
//  berkel
//
//  Created by Onur Yilmaz on 4.11.2023.
//

import FirebaseFirestore

protocol IWorkerDetailRepository: AnyObject {

    func getCollection(season: String, workerId: String) -> FirestoreResponseType<[WorkerCollectionModel]>
    func getPayment(season: String, workerId: String) -> FirestoreResponseType<[WorkerPaymentModel]>

    func updateCollectionCalc(season: String, workerId: String, collectionId: String, isCalc: Bool) -> FirestoreResponseType<Bool>
    func updateBuyingActive(season: String, workerId: String, isActive: Bool) -> FirestoreResponseType<Bool>
    
    func deletePayment(season: String, workerId: String, paymentId: String) -> FirestoreResponseType<Bool>
}

final class WorkerDetailRepository: BaseRepository, IWorkerDetailRepository {

    func getCollection(season: String, workerId: String) -> FirestoreResponseType<[WorkerCollectionModel]> {
        let db = WorkerService.collection(season: season, workerId: workerId)
        return getDocuments(db, order: db.order)
    }

    func getPayment(season: String, workerId: String) -> FirestoreResponseType<[WorkerPaymentModel]> {
        let db = WorkerService.payment(season: season, workerId: workerId)
        return getDocuments(db, order: db.order)
    }

    func updateCollectionCalc(season: String, workerId: String, collectionId: String, isCalc: Bool) -> FirestoreResponseType<Bool> {
        let db = WorkerService.worker(season: season, workerId: workerId, collectionId: collectionId).documentReference
        return updateData(db, data: ["isCalc": isCalc])
    }

    func updateBuyingActive(season: String, workerId: String, isActive: Bool) -> FirestoreResponseType<Bool> {
        let db = WorkerService.collection(season: season, workerId: workerId).documentReference
        return updateData(db, data: ["isActive": isActive])
    }
    
    func deletePayment(season: String, workerId: String, paymentId: String) -> FirestoreResponseType<Bool> {
        let db = WorkerService.deletePayment(season: season, workerId: workerId, paymentId: paymentId).documentReference
        return deleteData(db)
    }
}
