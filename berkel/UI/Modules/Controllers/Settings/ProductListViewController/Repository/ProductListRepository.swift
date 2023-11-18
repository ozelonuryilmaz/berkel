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
        return getDocuments(ProductItemService.list,
                            order: ProductItemService.list.order)
    }
    
    func saveProduct(data: ProductListModel) -> FirestoreResponseType<ProductListModel> {
        let db: DocumentReference = ProductItemService.save.collectionReference.document()
        let key = db.documentID

        var tempData = data
        tempData.id = key

        return self.setData(db, data: tempData)
    }
}
