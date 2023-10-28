//
//  ArchiveDetailUIModel.swift
//  berkel
//
//  Created by Onur Yilmaz on 26.10.2023.
//

import UIKit

protocol IArchiveDetailUIModel {

    var date: String { get }
    var productName: String { get }
    var imageUrl: String { get }

    init(data: ArchiveDetailPassData)

}

struct ArchiveDetailUIModel: IArchiveDetailUIModel {

    // MARK: Definitions
    let date: String
    let productName: String
    let imageUrl: String

    // MARK: Initialize
    init(data: ArchiveDetailPassData) {
        self.date = data.date
        self.productName = data.productName
        self.imageUrl = data.imageUrl
    }

    // MARK: Computed Props
}

// MARK: Props
extension ArchiveDetailUIModel {

}
