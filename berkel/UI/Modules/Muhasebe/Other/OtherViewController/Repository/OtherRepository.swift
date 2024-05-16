//
//  OtherRepository.swift
//  berkel
//
//  Created by Onur Yilmaz on 19.01.2024.
//

import Foundation

protocol IOtherRepository: AnyObject {

    func getOtherList(season: String, cursor: [String]?, limit: Int) -> FirestoreResponseType<[OtherModel]>
}

final class OtherRepository: BaseRepository, IOtherRepository {

    func getOtherList(season: String, cursor: [String]?, limit: Int) -> FirestoreResponseType<[OtherModel]> {
        switch otherModule {
        case .accouting:
            let db = OtherService.list(season: season)
            return getDocuments(
                db,
                order: db.order,
                cursor: cursor,
                limit: limit
            )
        case .jobi:
            let db = JobiOtherService.list(season: season)
            return getDocuments(
                db,
                order: db.order,
                cursor: cursor,
                limit: limit
            )
        }
    }
}
