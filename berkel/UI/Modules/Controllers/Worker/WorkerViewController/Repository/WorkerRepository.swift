//
//  WorkerRepository.swift
//  berkel
//
//  Created by Onur Yilmaz on 2.09.2023.
//

import FirebaseFirestore

protocol IWorkerRepository: AnyObject {

    func getWorkerList(season: String, cursor: [String]?, limit: Int) -> FirestoreResponseType<[WorkerModel]>
}

final class WorkerRepository: BaseRepository, IWorkerRepository {

    func getWorkerList(season: String, cursor: [String]?, limit: Int) -> FirestoreResponseType<[WorkerModel]> {
        let db = WorkerService.list(season: season)
        return getDocuments(
            db,
            order: db.order,
            cursor: cursor,
            limit: limit
        )
    }
}
