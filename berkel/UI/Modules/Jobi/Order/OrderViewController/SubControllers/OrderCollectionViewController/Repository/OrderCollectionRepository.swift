//
//  OrderCollectionRepository.swift
//  berkel
//
//  Created by Onur Yilmaz on 16.04.2024.
//  Copyright (c) 2024 Berkel IOS Development Team. All rights reserved.[OY-2024]
//

import FirebaseFirestore

protocol IOrderCollectionRepository: AnyObject {
    func saveOrder(data: OrderCollectionModel, season: String) -> FirestoreResponseType<OrderCollectionModel>
}

final class OrderCollectionRepository: BaseRepository, IOrderCollectionRepository {

    func saveOrder(data: OrderCollectionModel, season: String) -> FirestoreResponseType<OrderCollectionModel> {
        let db: DocumentReference = OrderService.customerCollections(season: season,
                                                                     customerId: data.customerId ?? "",
                                                                     orderId: data.orderId ?? "").collectionReference.document()
        let key = db.documentID

        var tempData = data
        tempData.id = key

        return self.setData(db, data: tempData)
    }
}
