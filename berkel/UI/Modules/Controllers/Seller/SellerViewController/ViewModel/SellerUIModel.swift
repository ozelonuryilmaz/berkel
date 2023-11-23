//
//  SellerUIModel.swift
//  berkel
//
//  Created by Onur Yilmaz on 2.09.2023.
//

import UIKit

protocol ISellerUIModel {

    var season: String { get }

    init()

}

struct SellerUIModel: ISellerUIModel {

    // MARK: Definitions

    // MARK: Initialize
    init() {

    }

    var season: String {
        return UserDefaultsManager.shared.getStringValue(key: .season) ?? "unknown"
    }

    // MARK: Computed Props
}

// MARK: Props
extension SellerUIModel {

}
