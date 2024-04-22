//
//  NewOrderRepository.swift
//  berkel
//
//  Created by Onur Yilmaz on 16.04.2024.
//  Copyright (c) 2024 Berkel IOS Development Team. All rights reserved.[OY-2024]
//

import FirebaseFirestore

protocol INewOrderRepository: AnyObject {

    func saveNewOrder(data: OrderModel, season: String) -> FirestoreResponseType<OrderModel>
}

final class NewOrderRepository: BaseRepository, INewOrderRepository {

    func saveNewOrder(data: OrderModel, season: String) -> FirestoreResponseType<OrderModel> {
        let db: DocumentReference = OrderService.order(season: season).collectionReference.document()
        let key = db.documentID

        var tempData = data
        tempData.id = key

        return self.setData(db, data: tempData)
    }
}
