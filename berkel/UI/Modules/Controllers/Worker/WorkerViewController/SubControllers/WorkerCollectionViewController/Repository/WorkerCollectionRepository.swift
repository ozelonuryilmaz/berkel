//
//  WorkerCollectionRepository.swift
//  berkel
//
//  Created by Onur Yilmaz on 4.11.2023.
//

import FirebaseFirestore

protocol IWorkerCollectionRepository: AnyObject {

    func saveNewCollection(season: String,
                           workerId: String,
                           data: WorkerCollectionModel) -> FirestoreResponseType<WorkerCollectionModel>
}

final class WorkerCollectionRepository: BaseRepository, IWorkerCollectionRepository {

    func saveNewCollection(season: String,
                           workerId: String,
                           data: WorkerCollectionModel) -> FirestoreResponseType<WorkerCollectionModel> {

        let db: DocumentReference = WorkerService.collection(season: season, workerId: workerId).collectionReference.document()
        let key = db.documentID

        var tempData = data
        tempData.id = key

        return self.setData(db, data: tempData)
    }
}
