//
//  ArchiveListRepository.swift
//  berkel
//
//  Created by Onur Yilmaz on 26.10.2023.
//

import Foundation
import FirebaseFirestore

protocol IArchiveListRepository: AnyObject {

    func getArchiveList(season: String, sellerId: String, imagePathType: ImagePathType) -> FirestoreResponseType<[SellerImageModel]>
    
    func getArchiveList(season: String, customerId: String, imagePathType: ImagePathType) -> FirestoreResponseType<[CustomerImageModel]>
}

final class ArchiveListRepository: BaseRepository, IArchiveListRepository {

    func getArchiveList(season: String, sellerId: String, imagePathType: ImagePathType) -> FirestoreResponseType<[SellerImageModel]> {
        let db = SellerImageService.buyingImage(sellerId: sellerId, season: season, imagePathType: imagePathType)
        return getDocuments(db, order: db.order)
    }
    
    func getArchiveList(season: String, customerId: String, imagePathType: ImagePathType) -> FirestoreResponseType<[CustomerImageModel]> {
        let db = SellerImageService.sellerImage(customerId: customerId, season: season, imagePathType: imagePathType)
        return getDocuments(db, order: db.order)
    }
}
