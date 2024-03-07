//
//  WorkerChartsRepository.swift
//  berkel
//
//  Created by Onur Yilmaz on 8.01.2024.
//

import Foundation

protocol IWorkerChartsRepository: AnyObject {

    func getList(season: String) -> FirestoreResponseType<[WorkerModel]>
    func getCollection(season: String, workerId: String) -> FirestoreResponseType<[WorkerCollectionModel]>
    func getPayment(season: String, workerId: String) -> FirestoreResponseType<[WorkerPaymentModel]>
}

final class WorkerChartsRepository: BaseRepository, IWorkerChartsRepository {

    func getList(season: String) -> FirestoreResponseType<[WorkerModel]> {
        let db = WorkerService.list(season: season)
        return getDocuments(db, order: db.order)
    }

    func getCollection(season: String, workerId: String) -> FirestoreResponseType<[WorkerCollectionModel]> {
        let db = WorkerService.collection(season: season, workerId: workerId)
        return getDocuments(db, order: db.order)
    }

    func getPayment(season: String, workerId: String) -> FirestoreResponseType<[WorkerPaymentModel]> {
        let db = WorkerService.payment(season: season, workerId: workerId)
        return getDocuments(db, order: db.order)
    }
}
