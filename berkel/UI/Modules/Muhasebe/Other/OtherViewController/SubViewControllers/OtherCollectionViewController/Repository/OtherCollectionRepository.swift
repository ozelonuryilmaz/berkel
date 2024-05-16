//
//  OtherCollectionRepository.swift
//  berkel
//
//  Created by Onur Yilmaz on 28.01.2024.
//

import FirebaseFirestore

protocol IOtherCollectionRepository: AnyObject {

    func saveNewCollection(season: String,
                           otherId: String,
                           data: OtherCollectionModel) -> FirestoreResponseType<OtherCollectionModel>
}

final class OtherCollectionRepository: BaseRepository, IOtherCollectionRepository {

    func saveNewCollection(season: String,
                           otherId: String,
                           data: OtherCollectionModel) -> FirestoreResponseType<OtherCollectionModel> {
        switch otherModule {
        case .accouting:
            let db: DocumentReference = OtherService.collection(season: season,
                                                                otherId: otherId).collectionReference.document()
            let key = db.documentID
            var tempData = data
            tempData.id = key
            return self.setData(db, data: tempData)
        case .jobi:
            let db: DocumentReference = JobiOtherService.collection(season: season,
                                                                otherId: otherId).collectionReference.document()
            let key = db.documentID
            var tempData = data
            tempData.id = key
            return self.setData(db, data: tempData)
        }
    }
}
