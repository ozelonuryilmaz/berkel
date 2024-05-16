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
        switch otherModule {
        case .accouting:
            let db = OtherSellerCategoryItemService.list
            return getDocuments(db,
                                order: db.order)
        case .jobi:
            let db = JobiOtherSellerCategoryItemService.list
            return getDocuments(db,
                                order: db.order)
        }
        
    }
    
    func saveOtherSellerCategory(data: OtherSellerCategoryListModel) -> FirestoreResponseType<OtherSellerCategoryListModel> {
        switch otherModule {
        case .accouting:
            let db: DocumentReference = OtherSellerCategoryItemService.save.collectionReference.document()
            let key = db.documentID

            var tempData = data
            tempData.id = key

            return self.setData(db, data: tempData)
        case .jobi:
            let db: DocumentReference = JobiOtherSellerCategoryItemService.save.collectionReference.document()
            let key = db.documentID

            var tempData = data
            tempData.id = key

            return self.setData(db, data: tempData)
        }
        
    }
}
