//
//  ArchiveListUIModel.swift
//  berkel
//
//  Created by Onur Yilmaz on 26.10.2023.
//  Copyright (c) 2023 Emlakjet IOS Development Team. All rights reserved.[EC-2021]
//

import UIKit

protocol IArchiveListUIModel {

    var sellerId: String { get }
    var season: String { get }

    init(data: ArchiveListPassData)

}

struct ArchiveListUIModel: IArchiveListUIModel {

    // MARK: Definitions
    let sellerId: String

    // MARK: Initialize
    init(data: ArchiveListPassData) {
        self.sellerId = data.sellerId
    }

    var season: String {
        return UserDefaultsManager.shared.getStringValue(key: .season) ?? "unknown"
    }

    // MARK: Computed Props
}

// MARK: Props
extension ArchiveListUIModel {

}
