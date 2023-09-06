//
//  BuyingRepository.swift
//  berkel
//
//  Created by Onur Yilmaz on 2.09.2023.
//  Copyright (c) 2023 Emlakjet IOS Development Team. All rights reserved.[EC-2021]
//

import Foundation

protocol IBuyingRepository: AnyObject {

    func getBuyingList(completionHandler: @escaping FirestoreCompletion) -> FirestoreResponseType<[BuyingResponseModel]>
}

final class BuyingRepository: BaseRepository, IBuyingRepository {
    
    func getBuyingList(completionHandler: @escaping FirestoreCompletion) -> FirestoreResponseType<[BuyingResponseModel]> {
        return getDocuments(BuyingService.list,
                            completionHandler: completionHandler)
    }
}
