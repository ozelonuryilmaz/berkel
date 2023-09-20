//
//  AddBuyingItemRepository.swift
//  berkel
//
//  Created by Onur Yilmaz on 14.09.2023.
//  Copyright (c) 2023 Emlakjet IOS Development Team. All rights reserved.[EC-2021]
//

import Foundation

protocol IAddBuyingItemRepository: AnyObject {

    func getBuyingItemList() -> FirestoreResponseType<[AddBuyingItemResponseModel]>
}

final class AddBuyingItemRepository: BaseRepository, IAddBuyingItemRepository {
    
    func getBuyingItemList() -> FirestoreResponseType<[AddBuyingItemResponseModel]> {
        return getDocuments(BuyingItemService.list)
    }
}
