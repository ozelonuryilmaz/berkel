//
//  CavusListRepository.swift
//  berkel
//
//  Created by Onur Yilmaz on 31.10.2023.
//

import Foundation

protocol ICavusListRepository: AnyObject {

    func getCavusList(cursor: [String]?, limit: Int) -> FirestoreResponseType<[CavusModel]>
}

final class CavusListRepository: BaseRepository, ICavusListRepository {

    func getCavusList(cursor: [String]?, limit: Int) -> FirestoreResponseType<[CavusModel]> {
        return getDocuments(CavusService.list,
                            order: CavusService.list.order,
                            cursor: cursor,
                            limit: limit)
    }
}
