//
//  JBCPriceRepository.swift
//  berkel
//
//  Created by Onur Yilmaz on 21.04.2024.
//  Copyright (c) 2024 Berkel IOS Development Team. All rights reserved.[OY-2024]
//

import Foundation

protocol IJBCPriceRepository: AnyObject {
    func getPrices(customerId: String, season: String, stockId: String, subStockId: String) -> FirestoreResponseType<[JBCPriceModel]>
}

final class JBCPriceRepository: BaseRepository, IJBCPriceRepository {

    func getPrices(customerId: String, season: String, stockId: String, subStockId: String) -> FirestoreResponseType<[JBCPriceModel]> {
        let db = JBCustomerService.prices(customerId: customerId, 
                                          season: season,
                                          stockId: stockId,
                                          subStockId: subStockId)
        return getDocuments(db, order: db.order)
    }
}
