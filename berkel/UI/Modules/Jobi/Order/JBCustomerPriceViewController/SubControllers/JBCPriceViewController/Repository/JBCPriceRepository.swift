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
    func cancelCustomerPrice(season: String, priceModel: JBCPriceModel) -> FirestoreResponseType<Bool>
}

final class JBCPriceRepository: BaseRepository, IJBCPriceRepository {

    func getPrices(customerId: String, season: String, stockId: String, subStockId: String) -> FirestoreResponseType<[JBCPriceModel]> {
        let db = JBCustomerService.prices(id: nil,
                                          customerId: customerId, 
                                          season: season,
                                          stockId: stockId,
                                          subStockId: subStockId)
        return getDocuments(db, order: db.order)
    }
    
    func cancelCustomerPrice(season: String, priceModel: JBCPriceModel) -> FirestoreResponseType<Bool> {
        let db = JBCustomerService.prices(id: priceModel.id ?? "-",
                                          customerId: priceModel.customerId ?? "-",
                                          season: season,
                                          stockId: priceModel.stockId ?? "-",
                                          subStockId: priceModel.subStockId ?? "-").documentReference
        return updateData(db, data: ["isActive": false])
    }
}
