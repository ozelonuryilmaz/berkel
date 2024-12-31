//
//  JBCustomerHistoryUIModel.swift
//  berkel
//
//  Created by Onur Yilmaz on 15.09.2024.
//  Copyright (c) 2024 Berkel IOS Development Team. All rights reserved.[OY-2024]
//

import UIKit

protocol IJBCustomerHistoryUIModel {

    var season: String { get }
    var customerName: String { get }

    init(data: JBCustomerHistoryPassData)

}

struct JBCustomerHistoryUIModel: IJBCustomerHistoryUIModel {

    // MARK: Definitions
    let season: String
    let customerModel: JBCustomerModel

    // MARK: Initialize
    init(data: JBCustomerHistoryPassData) {
        self.season = data.season
        self.customerModel = data.customerModel
    }

    // MARK: Computed Props

    var customerName: String {
        return customerModel.name
    }
}

// MARK: Props
extension JBCustomerHistoryUIModel {

}
