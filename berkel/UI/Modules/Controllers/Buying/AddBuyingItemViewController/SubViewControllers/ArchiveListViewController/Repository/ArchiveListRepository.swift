//
//  ArchiveListRepository.swift
//  berkel
//
//  Created by Onur Yilmaz on 26.10.2023.
//  Copyright (c) 2023 Emlakjet IOS Development Team. All rights reserved.[EC-2021]
//

import Foundation
import FirebaseFirestore

protocol IArchiveListRepository: AnyObject {

    func getArchiveList(season: String, sellerId: String, imagePathType: ImagePathType) -> FirestoreResponseType<[SellerImageModel]>
}

final class ArchiveListRepository: BaseRepository, IArchiveListRepository {

    func getArchiveList(season: String, sellerId: String, imagePathType: ImagePathType) -> FirestoreResponseType<[SellerImageModel]> {
        let db = SellerImageService.image(sellerId: sellerId, season: season, imagePathType: imagePathType)
        return getDocuments(db, order: db.order)
    }
}
