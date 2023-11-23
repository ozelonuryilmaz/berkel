//
//  CustomerListRepository.swift
//  berkel
//
//  Created by Onur Yilmaz on 19.11.2023.
//

import Foundation

protocol ICustomerListRepository: AnyObject {

    func getCustomerList(cursor: [String]?, limit: Int) -> FirestoreResponseType<[CustomerModel]>
}

final class CustomerListRepository: BaseRepository, ICustomerListRepository {

    func getCustomerList(cursor: [String]?, limit: Int) -> FirestoreResponseType<[CustomerModel]> {
        return getDocuments(CustomerService.list,
                            order: CustomerService.list.order,
                            cursor: cursor,
                            limit: limit)
    }
}
