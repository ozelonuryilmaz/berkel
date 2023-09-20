//
//  AddSellerRepository.swift
//  berkel
//
//  Created by Onur Yilmaz on 15.09.2023.
//  Copyright (c) 2023 Emlakjet IOS Development Team. All rights reserved.[EC-2021]
//

import FirebaseFirestore

protocol IAddSellerRepository: AnyObject {

    func saveNewSeller(data: AddSellerModel) -> FirestoreResponseType<AddSellerModel>
}

final class AddSellerRepository: BaseRepository, IAddSellerRepository {

    func saveNewSeller(data: AddSellerModel) -> FirestoreResponseType<AddSellerModel> {
        let db: DocumentReference = SellerService.save.collectionReference.document()
        let key = db.documentID
        
        var tempData = data
        tempData.id = key
        
        return self.setData(db, data: tempData)
    }
}
