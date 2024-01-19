//
//  AddSellerRepository.swift
//  berkel
//
//  Created by Onur Yilmaz on 15.09.2023.
//

import FirebaseFirestore

protocol IAddSellerRepository: AnyObject {

    func saveNewSeller(data: AddSellerModel) -> FirestoreResponseType<AddSellerModel>
    func updateSeller(data: AddSellerModel) -> FirestoreResponseType<Bool>
}

final class AddSellerRepository: BaseRepository, IAddSellerRepository {

    func saveNewSeller(data: AddSellerModel) -> FirestoreResponseType<AddSellerModel> {
        let db: DocumentReference = SellerListService.save.collectionReference.document()
        let key = db.documentID
        
        var tempData = data
        tempData.id = key
        
        return self.setData(db, data: tempData)
    }
    
    func updateSeller(data: AddSellerModel) -> FirestoreResponseType<Bool> {
        let db = SellerListService.update(id: data.id ?? "").documentReference
        return updateData(db, data: ["name": data.name ?? "",
                                     "tckn": data.tckn ?? "",
                                     "phoneNumber": data.phoneNumber ?? "",
                                     "description": data.description ?? "",
                                     "date": data.date ?? ""])
    }
}
