//
//  AddBuyingItemRepository.swift
//  berkel
//
//  Created by Onur Yilmaz on 14.09.2023.
//  Copyright (c) 2023 Emlakjet IOS Development Team. All rights reserved.[EC-2021]
//

import Foundation

protocol IAddBuyingItemRepository: AnyObject {

    func getBuyingItemList(cursor: [String]?, limit: Int) -> FirestoreResponseType<[AddBuyingItemResponseModel]>
}

final class AddBuyingItemRepository: BaseRepository, IAddBuyingItemRepository {
    
    func getBuyingItemList(cursor: [String]?, limit: Int) -> FirestoreResponseType<[AddBuyingItemResponseModel]> {
        return getDocuments(BuyingItemService.list,
                            order: BuyingItemService.list.order,
                            cursor: cursor,
                            limit: limit)
    }
}
