//
//  NewOtherSellerRepository.swift
//  berkel
//
//  Created by Onur Yilmaz on 19.01.2024.
//

import FirebaseFirestore

protocol INewOtherSellerRepository: AnyObject {

    func saveNewOtherSeller(data: OtherSellerModel) -> FirestoreResponseType<OtherSellerModel>
    func updateOtherSeller(data: OtherSellerModel) -> FirestoreResponseType<Bool>
}

final class NewOtherSellerRepository: BaseRepository, INewOtherSellerRepository {

    func saveNewOtherSeller(data: OtherSellerModel) -> FirestoreResponseType<OtherSellerModel> {
        let db: DocumentReference = OtherSellerService.save.collectionReference.document()
        let key = db.documentID

        var tempData = data
        tempData.id = key

        return self.setData(db, data: tempData)
    }

    func updateOtherSeller(data: OtherSellerModel) -> FirestoreResponseType<Bool> {
        let db = OtherSellerService.update(id: data.id ?? "").documentReference
        return updateData(db, data: ["name": data.name,
                                     "categoryId": data.categoryId ?? "",
                                     "categoryName": data.categoryName,
                                     "phoneNumber": data.phoneNumber,
                                     "description": data.description ?? "",
                                     "date": data.date ?? ""])
    }
}
