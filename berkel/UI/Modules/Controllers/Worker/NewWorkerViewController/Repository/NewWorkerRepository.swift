//
//  NewWorkerRepository.swift
//  berkel
//
//  Created by Onur Yilmaz on 31.10.2023.
//

import FirebaseFirestore

protocol INewWorkerRepository: AnyObject {

    func saveNewWorker(data: WorkerModel, season: String) -> FirestoreResponseType<WorkerModel>
}

final class NewWorkerRepository: BaseRepository, INewWorkerRepository {

    func saveNewWorker(data: WorkerModel, season: String) -> FirestoreResponseType<WorkerModel> {
        let db: DocumentReference = WorkerService.save(season: season).collectionReference.document()
        let key = db.documentID

        var tempData = data
        tempData.id = key

        return self.setData(db, data: tempData)
    }
}
