//
//  OrderPaymentRepository.swift
//  berkel
//
//  Created by Onur Yilmaz on 16.04.2024.
//  Copyright (c) 2024 Berkel IOS Development Team. All rights reserved.[OY-2024]
//

import FirebaseFirestore

protocol IOrderPaymentRepository: AnyObject {
    func savePayment(data: OrderPaymentModel, season: String) -> FirestoreResponseType<OrderPaymentModel>
}

final class OrderPaymentRepository: BaseRepository, IOrderPaymentRepository {

    func savePayment(data: OrderPaymentModel, season: String) -> FirestoreResponseType<OrderPaymentModel> {
        let db: DocumentReference = OrderService.customerPayments(season: season,
                                                                  customerId: data.customerId ?? "",
                                                                  orderId: data.orderId ?? "").collectionReference.document()
        let key = db.documentID

        var tempData = data
        tempData.id = key

        return self.setData(db, data: tempData)
    }
}
