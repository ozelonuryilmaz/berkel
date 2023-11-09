//
//  WorkerPaymentRepository.swift
//  berkel
//
//  Created by Onur Yilmaz on 4.11.2023.
//

import FirebaseFirestore

protocol IWorkerPaymentRepository: AnyObject {

    func saveNewPayment(season: String,
                        workerId: String,
                        data: WorkerPaymentModel) -> FirestoreResponseType<WorkerPaymentModel>
}

final class WorkerPaymentRepository: BaseRepository, IWorkerPaymentRepository {

    func saveNewPayment(season: String,
                        workerId: String,
                        data: WorkerPaymentModel) -> FirestoreResponseType<WorkerPaymentModel> {

        let db: DocumentReference = WorkerService.payment(season: season, workerId: workerId).collectionReference.document()
        let key = db.documentID

        var tempData = data
        tempData.id = key

        return self.setData(db, data: tempData)
    }
}
