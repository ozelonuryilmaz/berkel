//
//  ProductListRepository.swift
//  berkel
//
//  Created by Onur Yilmaz on 18.11.2023.
//

import FirebaseFirestore

protocol IProductListRepository: AnyObject {

    func getProductList() -> FirestoreResponseType<[ProductListModel]>
    func saveProduct(data: ProductListModel) -> FirestoreResponseType<ProductListModel>
}

final class ProductListRepository: BaseRepository, IProductListRepository {

    func getProductList() -> FirestoreResponseType<[ProductListModel]> {
        switch otherModule {
        case .accouting:
            let db = ProductItemService.list
            return getDocuments(db,
                                order: db.order)
        case .jobi:
            let db = JobiProductItemService.list
            return getDocuments(db,
                                order: db.order)
        }
        
        
    }
    
    func saveProduct(data: ProductListModel) -> FirestoreResponseType<ProductListModel> {
        switch otherModule {
        case .accouting:
            let db: DocumentReference = ProductItemService.save.collectionReference.document()
            let key = db.documentID

            var tempData = data
            tempData.id = key

            return self.setData(db, data: tempData)
        case .jobi:
            let db: DocumentReference = JobiProductItemService.save.collectionReference.document()
            let key = db.documentID

            var tempData = data
            tempData.id = key

            return self.setData(db, data: tempData)
        }
        
    }
}
