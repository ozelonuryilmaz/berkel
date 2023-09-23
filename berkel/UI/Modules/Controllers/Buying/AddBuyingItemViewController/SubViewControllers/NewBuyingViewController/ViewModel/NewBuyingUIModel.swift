//
//  NewBuyingUIModel.swift
//  berkel
//
//  Created by Onur Yilmaz on 23.09.2023.
//  Copyright (c) 2023 Emlakjet IOS Development Team. All rights reserved.[EC-2021]
//

import UIKit

protocol INewBuyingUIModel {
    
    var sellerName: String { get }
    var sellerTCKN: String { get }
    var sellerId: String { get }

	 init(data: NewBuyingPassData)

} 

struct NewBuyingUIModel: INewBuyingUIModel {

	// MARK: Definitions
    private let seller: AddBuyingItemResponseModel

	// MARK: Initialize
    init(data: NewBuyingPassData) {
        self.seller = data.seller
    }

    // MARK: Computed Props
    var sellerName: String {
        return seller.name
    }
    
    var sellerTCKN: String {
        return seller.tckn
    }
    
    var sellerId: String {
        return seller.id
    }
}

// MARK: Props
extension NewBuyingUIModel {

}
