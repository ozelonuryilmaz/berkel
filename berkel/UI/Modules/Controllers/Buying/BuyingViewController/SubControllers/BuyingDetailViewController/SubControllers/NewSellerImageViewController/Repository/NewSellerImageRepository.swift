//
//  NewSellerImageRepository.swift
//  berkel
//
//  Created by Onur Yilmaz on 23.10.2023.
//  Copyright (c) 2023 Emlakjet IOS Development Team. All rights reserved.[EC-2021]
//

import Foundation
import FirebaseFirestore
import FirebaseStorage

protocol INewSellerImageRepository: AnyObject {

    func saveImage(sellerId: String, season: String, imagePathType: ImagePathType, imageData: Data) -> FirestoreResponseType<String>
    func saveSellerImage(sellerId: String, season: String, imagePathType: ImagePathType, data: SellerImageModel) -> FirestoreResponseType<SellerImageModel>
}

final class NewSellerImageRepository: BaseRepository, INewSellerImageRepository {

    func saveImage(sellerId: String, season: String, imagePathType: ImagePathType, imageData: Data) -> FirestoreResponseType<String> {
        // let imageData = image.jpegData(compressionQuality: 0.9)!
        let db: StorageReference = SellerImageService.image(sellerId: sellerId,
                                                            season: season,
                                                            imagePathType: imagePathType).storageReference
        return putData(db, data: imageData)
    }

    func saveSellerImage(sellerId: String, season: String, imagePathType: ImagePathType, data: SellerImageModel) -> FirestoreResponseType<SellerImageModel> {
        let db: DocumentReference = SellerImageService.image(sellerId: sellerId, season: season, imagePathType: imagePathType).collectionReference.document()

        let key = db.documentID
        var tempData = data
        tempData.id = key

        return self.setData(db, data: tempData)
    }
}
