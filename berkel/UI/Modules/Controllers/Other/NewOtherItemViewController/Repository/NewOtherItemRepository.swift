//
//  NewOtherItemRepository.swift
//  berkel
//
//  Created by Onur Yilmaz on 19.01.2024.
//

import FirebaseFirestore

protocol INewOtherItemRepository: AnyObject {

    func saveNewOther(data: OtherModel, season: String) -> FirestoreResponseType<OtherModel>
}

final class NewOtherItemRepository: BaseRepository, INewOtherItemRepository {

    func saveNewOther(data: OtherModel, season: String) -> FirestoreResponseType<OtherModel> {
        let db: DocumentReference = OtherService.save(season: season).collectionReference.document()
        let key = db.documentID

        var tempData = data
        tempData.id = key

        return self.setData(db, data: tempData)
    }
}
