//
//  NewSellerImagePassData.swift
//  berkel
//
//  Created by Onur Yilmaz on 23.10.2023.
//

import Foundation

enum ImagePageType {
    case buying(sellerId: String, buyingId: String, buyingProductName: String)
    case worker(cavusId: String, workerId: String, workerProductName: String)
    case seller(customerId: String, sellerId: String, sellerProductName: String)
    case other(otherSellerId: String, otherId: String, otherSellerProductName: String)
    case order(jbCustomerId: String, orderId: String, orderName: String)
}

enum ImagePathType: String {
    case kantarFisi = "kantarFisi"
    case cek = "cek"
    case dekont = "dekont"
    case diger = "diger"
}

struct NewSellerImagePassData: ICoordinatorPassData {

    let imagePageType: ImagePageType
    let imagePathType: ImagePathType
}

