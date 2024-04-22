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

    func getArchiveList(season: String, cavusId: String, imagePathType: ImagePathType) -> FirestoreResponseType<[WorkerImageModel]>

    func getArchiveList(season: String, otherSellerId: String, imagePathType: ImagePathType) -> FirestoreResponseType<[OtherSellerImageModel]>

    func getArchiveList(season: String, jbCustomerId: String, imagePathType: ImagePathType) -> FirestoreResponseType<[OrderImageModel]>
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

    func getArchiveList(season: String, cavusId: String, imagePathType: ImagePathType) -> FirestoreResponseType<[WorkerImageModel]> {
        let db = SellerImageService.workerImage(cavusId: cavusId, season: season, imagePathType: imagePathType)
        return getDocuments(db, order: db.order)
    }

    func getArchiveList(season: String, otherSellerId: String, imagePathType: ImagePathType) -> FirestoreResponseType<[OtherSellerImageModel]> {
        let db = SellerImageService.otherImage(otherSellerId: otherSellerId, season: season, imagePathType: imagePathType)
        return getDocuments(db, order: db.order)
    }

    func getArchiveList(season: String, jbCustomerId: String, imagePathType: ImagePathType) -> FirestoreResponseType<[OrderImageModel]> {
        let db = SellerImageService.orderImage(jbCustomerId: jbCustomerId, season: season, imagePathType: imagePathType)
        return getDocuments(db, order: db.order)
    }
}
