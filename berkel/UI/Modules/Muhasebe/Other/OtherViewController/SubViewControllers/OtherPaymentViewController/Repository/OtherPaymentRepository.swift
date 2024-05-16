//
//  OtherPaymentRepository.swift
//  berkel
//
//  Created by Onur Yilmaz on 30.01.2024.
//

import FirebaseFirestore

protocol IOtherPaymentRepository: AnyObject {

    func saveNewPayment(season: String,
                        otherId: String,
                        data: OtherPaymentModel) -> FirestoreResponseType<OtherPaymentModel>
}

final class OtherPaymentRepository: BaseRepository, IOtherPaymentRepository {

    func saveNewPayment(season: String,
                        otherId: String,
                        data: OtherPaymentModel) -> FirestoreResponseType<OtherPaymentModel> {
        switch otherModule {
        case .accouting:
            let db: DocumentReference = OtherService.payment(season: season, otherId: otherId).collectionReference.document()
            let key = db.documentID

            var tempData = data
            tempData.id = key

            return self.setData(db, data: tempData)
        case .jobi:
            let db: DocumentReference = JobiOtherService.payment(season: season, otherId: otherId).collectionReference.document()
            let key = db.documentID

            var tempData = data
            tempData.id = key

            return self.setData(db, data: tempData)
        }
    }
}
