//
//  NewOrderUIModel.swift
//  berkel
//
//  Created by Onur Yilmaz on 16.04.2024.
//  Copyright (c) 2024 Berkel IOS Development Team. All rights reserved.[OY-2024]
//

import UIKit

protocol INewOrderUIModel {

    var jbCustomerName: String { get }
    
    var newOrderData: OrderModel { get }
    var errorMessage: String? { get }

    var season: String { get }

	 init(data: NewOrderPassData)

    // Setter
    mutating func setDesc(_ value: String)
}

struct NewOrderUIModel: INewOrderUIModel {

	// MARK: Definitions
    private let customerModel: JBCustomerModel

	// MARK: Initialize
    init(data: NewOrderPassData) {
        self.customerModel = data.customerModel
    }

    // MARK: Computed Props
    var userId: String? {
        return UserManager.shared.userId
    }

    var season: String {
        return UserDefaultsManager.shared.getStringValue(key: .season) ?? "unknown"
    }
    
    var jbCustomerName: String {
        return customerModel.name
    }

    private var desc: String = ""

    var newOrderData: OrderModel {
        return OrderModel(userId: userId,
                          jbCustomerName: customerModel.name,
                          jbCustomerId: customerModel.id,
                          desc: desc,
                          isActive: true,
                          date: Date().dateFormatterApiResponseType())
    }
}

// MARK: Props
extension NewOrderUIModel {

    var errorMessage: String? {

        if desc.isEmpty {
            return "Lütfen sipariş açıklamasını giriniz"
        }

        return nil
    }
}

// MARK: Setter
extension NewOrderUIModel {

    mutating func setDesc(_ value: String) {
        self.desc = value
    }
}
