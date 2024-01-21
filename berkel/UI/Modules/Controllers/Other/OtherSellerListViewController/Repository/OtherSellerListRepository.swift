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
        return getDocuments(OtherSellerService.list,
                            order: OtherSellerService.list.order,
                            cursor: cursor,
                            limit: limit)
    }
}
