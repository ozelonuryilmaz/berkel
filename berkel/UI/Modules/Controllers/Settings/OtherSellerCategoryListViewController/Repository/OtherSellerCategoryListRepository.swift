//
//  OtherSellerCategoryListRepository.swift
//  berkel
//
//  Created by Onur Yilmaz on 21.01.2024.
//

import FirebaseFirestore

protocol IOtherSellerCategoryListRepository: AnyObject {

    func getOtherSellerCategoryList() -> FirestoreResponseType<[OtherSellerCategoryListModel]>
    func saveOtherSellerCategory(data: OtherSellerCategoryListModel) -> FirestoreResponseType<OtherSellerCategoryListModel>
}

final class OtherSellerCategoryListRepository: BaseRepository, IOtherSellerCategoryListRepository {

    func getOtherSellerCategoryList() -> FirestoreResponseType<[OtherSellerCategoryListModel]> {
        return getDocuments(OtherSellerCategoryItemService.list,
                            order: OtherSellerCategoryItemService.list.order)
    }
    
    func saveOtherSellerCategory(data: OtherSellerCategoryListModel) -> FirestoreResponseType<OtherSellerCategoryListModel> {
        let db: DocumentReference = OtherSellerCategoryItemService.save.collectionReference.document()
        let key = db.documentID

        var tempData = data
        tempData.id = key

        return self.setData(db, data: tempData)
    }
}
