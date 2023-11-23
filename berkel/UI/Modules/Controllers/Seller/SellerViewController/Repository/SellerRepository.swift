//
//  SellerRepository.swift
//  berkel
//
//  Created by Onur Yilmaz on 2.09.2023.
//

import FirebaseFirestore

protocol ISellerRepository: AnyObject {

    func getSellerList(season: String, cursor: [String]?, limit: Int) -> FirestoreResponseType<[SellerModel]>
}

final class SellerRepository: BaseRepository, ISellerRepository {

    func getSellerList(season: String, cursor: [String]?, limit: Int) -> FirestoreResponseType<[SellerModel]> {
        let db = SellerService.list(season: season)
        return getDocuments(
            db,
            order: db.order,
            cursor: cursor,
            limit: limit
        )
    }
}
