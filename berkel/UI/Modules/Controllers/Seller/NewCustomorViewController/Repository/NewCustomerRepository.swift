//
//  NewCustomerRepository.swift
//  berkel
//
//  Created by Onur Yilmaz on 19.11.2023.
//

import FirebaseFirestore

protocol INewCustomerRepository: AnyObject {

    func saveNewCustomer(data: CustomerModel) -> FirestoreResponseType<CustomerModel>
}

final class NewCustomerRepository: BaseRepository, INewCustomerRepository {

    func saveNewCustomer(data: CustomerModel) -> FirestoreResponseType<CustomerModel> {
        let db: DocumentReference = CustomerService.save.collectionReference.document()
        let key = db.documentID
        
        var tempData = data
        tempData.id = key
        
        return self.setData(db, data: tempData)
    }
}
