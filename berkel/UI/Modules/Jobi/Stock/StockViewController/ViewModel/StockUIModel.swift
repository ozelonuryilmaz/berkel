//
//  StockUIModel.swift
//  berkel
//
//  Created by Onur Yilmaz on 7.03.2024.
//

import UIKit

protocol IStockUIModel {
    
    var season: String { get }

    init()
} 

struct StockUIModel: IStockUIModel {

	// MARK: Definitions

	// MARK: Initialize
    init() { }

    // MARK: Computed Props
    var season: String {
        return UserDefaultsManager.shared.getStringValue(key: .season) ?? "unknown"
    }
}

// MARK: Props
extension StockUIModel {

}
