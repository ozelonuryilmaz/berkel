//
//  NewSellerRepository.swift
//  berkel
//
//  Created by Onur Yilmaz on 22.11.2023.
//

import FirebaseFirestore

protocol INewSellerRepository: AnyObject {

    func saveNewSeller(data: SellerModel, season: String) -> FirestoreResponseType<SellerModel>
}

final class NewSellerRepository: BaseRepository, INewSellerRepository {

    func saveNewSeller(data: SellerModel, season: String) -> FirestoreResponseType<SellerModel> {
        let db: DocumentReference = SellerService.save(season: season).collectionReference.document()
        let key = db.documentID

        var tempData = data
        tempData.id = key

        return self.setData(db, data: tempData)
    }
}
