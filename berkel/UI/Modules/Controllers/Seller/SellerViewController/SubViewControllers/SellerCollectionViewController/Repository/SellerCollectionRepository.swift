//
//  SellerCollectionRepository.swift
//  berkel
//
//  Created by Onur Yilmaz on 24.11.2023.
//

import FirebaseFirestore

protocol ISellerCollectionRepository: AnyObject {
    
    func saveNewCollection(season: String,
                           sellerId: String,
                           data: SellerCollectionModel) -> FirestoreResponseType<SellerCollectionModel>
}

final class SellerCollectionRepository: BaseRepository, ISellerCollectionRepository {

    func saveNewCollection(season: String,
                           sellerId: String,
                           data: SellerCollectionModel) -> FirestoreResponseType<SellerCollectionModel> {
        let db: DocumentReference = SellerService.collection(season: season,
                                                             sellerId: sellerId).collectionReference.document()
        let key = db.documentID

        var tempData = data
        tempData.id = key

        return self.setData(db, data: tempData)
    }
}
