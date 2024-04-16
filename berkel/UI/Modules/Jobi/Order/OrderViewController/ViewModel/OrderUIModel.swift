//
//  OrderUIModel.swift
//  berkel
//
//  Created by Onur Yilmaz on 7.03.2024.
//

import UIKit

protocol IOrderUIModel {
    
    var season: String { get }

    init()
} 

struct OrderUIModel: IOrderUIModel {

	// MARK: Definitions

	// MARK: Initialize
    init() { }
    // MARK: Computed Props
    
    var season: String {
        return UserDefaultsManager.shared.getStringValue(key: .season) ?? "unknown"
    }
}

// MARK: Props
extension OrderUIModel {

}
