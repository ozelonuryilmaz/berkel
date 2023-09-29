//
//  BuyingRepository.swift
//  berkel
//
//  Created by Onur Yilmaz on 2.09.2023.
//  Copyright (c) 2023 Emlakjet IOS Development Team. All rights reserved.[EC-2021]
//

import Foundation

protocol IBuyingRepository: AnyObject {

    func getBuyingList(season: String, cursor: [String]?, limit: Int) -> FirestoreResponseType<[NewBuyingModel]>
}

final class BuyingRepository: BaseRepository, IBuyingRepository {

    func getBuyingList(season: String, cursor: [String]?, limit: Int) -> FirestoreResponseType<[NewBuyingModel]> {
        let db = NewBuyingService.list(season: season)
        return getDocuments(
            db,
            order: db.order,
            cursor: cursor,
            limit: limit
        )
    }
}
