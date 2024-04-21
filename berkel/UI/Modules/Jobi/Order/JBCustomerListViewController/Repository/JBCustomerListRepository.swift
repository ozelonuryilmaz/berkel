//
//  JBCustomerListRepository.swift
//  berkel
//
//  Created by Onur Yilmaz on 16.04.2024.
//  Copyright (c) 2024 Berkel IOS Development Team. All rights reserved.[OY-2024]
//

import Foundation

protocol IJBCustomerListRepository: AnyObject {
    func getCustomerList(cursor: [String]?, limit: Int) -> FirestoreResponseType<[JBCustomerModel]>
}

final class JBCustomerListRepository: BaseRepository, IJBCustomerListRepository {

    func getCustomerList(cursor: [String]?, limit: Int) -> FirestoreResponseType<[JBCustomerModel]> {
        return getDocuments(JBCustomerService.list,
                            order: JBCustomerService.list.order,
                            cursor: cursor,
                            limit: limit)
    }
}
