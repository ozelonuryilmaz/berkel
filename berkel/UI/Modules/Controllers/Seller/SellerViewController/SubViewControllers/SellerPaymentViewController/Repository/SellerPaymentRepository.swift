//
//  SellerPaymentRepository.swift
//  berkel
//
//  Created by Onur Yilmaz on 24.11.2023.
//

import FirebaseFirestore

protocol ISellerPaymentRepository: AnyObject {

    func saveNewPayment(season: String,
                        sellerId: String,
                        data: SellerPaymentModel) -> FirestoreResponseType<SellerPaymentModel>
}

final class SellerPaymentRepository: BaseRepository, ISellerPaymentRepository {

    func saveNewPayment(season: String,
                        sellerId: String,
                        data: SellerPaymentModel) -> FirestoreResponseType<SellerPaymentModel> {
        let db: DocumentReference = SellerService.payment(season: season, sellerId: sellerId).collectionReference.document()
        let key = db.documentID

        var tempData = data
        tempData.id = key

        return self.setData(db, data: tempData)
    }
}
