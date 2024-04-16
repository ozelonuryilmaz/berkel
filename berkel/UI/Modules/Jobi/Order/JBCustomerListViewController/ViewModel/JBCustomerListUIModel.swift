//
//  JBCustomerListUIModel.swift
//  berkel
//
//  Created by Onur Yilmaz on 16.04.2024.
//  Copyright (c) 2024 Berkel IOS Development Team. All rights reserved.[OY-2024]
//

import UIKit

protocol IJBCustomerListUIModel {
    
    var season: String { get }

	 init(data: JBCustomerListPassData)

} 

struct JBCustomerListUIModel: IJBCustomerListUIModel {

	// MARK: Definitions

	// MARK: Initialize
    init(data: JBCustomerListPassData) {

    }

    // MARK: Computed Props
    var season: String {
        return UserDefaultsManager.shared.getStringValue(key: .season) ?? "unknown"
    }
}

// MARK: Props
extension JBCustomerListUIModel {

}
