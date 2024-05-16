//
//  OtherSellerListRepository.swift
//  berkel
//
//  Created by Onur Yilmaz on 19.01.2024.
//

import Foundation

protocol IOtherSellerListRepository: AnyObject {

    func getOtherSellerList(cursor: [String]?, limit: Int) -> FirestoreResponseType<[OtherSellerModel]>
}

final class OtherSellerListRepository: BaseRepository, IOtherSellerListRepository {

    func getOtherSellerList(cursor: [String]?, limit: Int) -> FirestoreResponseType<[OtherSellerModel]> {
        switch otherModule {
        case .accouting:
            let db = OtherSellerService.list
            return getDocuments(db,
                                order: db.order,
                                cursor: cursor,
                                limit: limit)
        case .jobi:
            let db = JobiOtherSellerService.list
            return getDocuments(db,
                                order: db.order,
                                cursor: cursor,
                                limit: limit)
        }
        
    }
}
