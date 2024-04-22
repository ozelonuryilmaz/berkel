//
//  NewJBCustomerRepository.swift
//  berkel
//
//  Created by Onur Yilmaz on 16.04.2024.
//  Copyright (c) 2024 Berkel IOS Development Team. All rights reserved.[OY-2024]
//

import FirebaseFirestore

protocol INewJBCustomerRepository: AnyObject {

    func saveNewCustomer(data: JBCustomerModel) -> FirestoreResponseType<JBCustomerModel>
    func updateCustomer(data: JBCustomerModel) -> FirestoreResponseType<Bool>
}

final class NewJBCustomerRepository: BaseRepository, INewJBCustomerRepository {

    func saveNewCustomer(data: JBCustomerModel) -> FirestoreResponseType<JBCustomerModel> {
        let db: DocumentReference = JBCustomerService.customer.collectionReference.document()
        let key = db.documentID

        var tempData = data
        tempData.id = key

        return self.setData(db, data: tempData)
    }

    func updateCustomer(data: JBCustomerModel) -> FirestoreResponseType<Bool> {
        let db = JBCustomerService.update(id: data.id ?? "").documentReference
        return updateData(db, data: ["name": data.name,
                                     "phoneNumber": data.phoneNumber,
                                     "description": data.description ?? "",
                                     "date": data.date ?? ""])
    }
}
