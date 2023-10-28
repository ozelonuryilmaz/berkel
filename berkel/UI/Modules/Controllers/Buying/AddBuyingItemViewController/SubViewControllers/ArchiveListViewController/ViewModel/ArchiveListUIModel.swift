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

    var archiveSegmentType: ArchiveSegmentType { get }

    var isHaveAnyKantarFisi: Bool { get }
    var isHaveAnyCek: Bool { get }
    var isHaveAnyDekont: Bool { get }
    var isHaveAnyDiger: Bool { get }

    init(data: ArchiveListPassData)

    mutating func setArchive(imagePathType: ImagePathType, data: [SellerImageModel])
    mutating func setArchiveType(index: Int)

    // for Table View
    func getNumberOfItemsInSection() -> Int
    func getCellUIModel(at index: Int) -> ArchiveListTableViewCellUIModel
}

struct ArchiveListUIModel: IArchiveListUIModel {

    // MARK: Definitions
    let sellerId: String

    // MARK: Initialize
    init(data: ArchiveListPassData) {
        self.sellerId = data.sellerId
    }

    var archiveSegmentType: ArchiveSegmentType = .kantarFisi

    private var kantarFisi: [ArchiveListTableViewCellUIModel] = []
    private var cek: [ArchiveListTableViewCellUIModel] = []
    private var dekont: [ArchiveListTableViewCellUIModel] = []
    private var diger: [ArchiveListTableViewCellUIModel] = []

    var season: String {
        return UserDefaultsManager.shared.getStringValue(key: .season) ?? "unknown"
    }

    var isHaveAnyKantarFisi: Bool {
        return !kantarFisi.isEmpty
    }

    var isHaveAnyCek: Bool {
        return !cek.isEmpty
    }

    var isHaveAnyDekont: Bool {
        return !dekont.isEmpty
    }

    var isHaveAnyDiger: Bool {
        return !diger.isEmpty
    }

    // MARK: Computed Props
    mutating func setArchiveType(index: Int) {
        self.archiveSegmentType = ArchiveSegmentType(rawValue: index) ?? .kantarFisi
    }
}

// MARK: Props
extension ArchiveListUIModel {

    mutating func setArchive(imagePathType: ImagePathType, data: [SellerImageModel]) {
        let archiveListTableViewCellUIModel: [ArchiveListTableViewCellUIModel] = data.compactMap({ sellerImageModel in
            return ArchiveListTableViewCellUIModel(imageUrl: sellerImageModel.imageUrl,
                                                   date: sellerImageModel.date?.dateTimeFormatFull() ?? "",
                                                   productName: sellerImageModel.buyingProductName,
                                                   desc: sellerImageModel.description ?? "")
        })

        switch imagePathType {
        case .kantarFisi:
            self.kantarFisi = archiveListTableViewCellUIModel
        case .cek:
            self.cek = archiveListTableViewCellUIModel
        case .dekont:
            self.dekont = archiveListTableViewCellUIModel
        case .diger:
            self.diger = archiveListTableViewCellUIModel
        }
    }
}

enum ArchiveSegmentType: Int {
    case kantarFisi = 0
    case cek = 1
    case dekont = 2
    case diger = 3
}

// MARK: TableView Helper
extension ArchiveListUIModel {

    func getNumberOfItemsInSection() -> Int {
        switch self.archiveSegmentType {
        case .kantarFisi:
            return self.kantarFisi.count
        case .cek:
            return self.cek.count
        case .dekont:
            return self.dekont.count
        case .diger:
            return self.diger.count
        }
    }

    func getCellUIModel(at index: Int) -> ArchiveListTableViewCellUIModel {
        switch self.archiveSegmentType {
        case .kantarFisi:
            return self.kantarFisi[index]
        case .cek:
            return self.cek[index]
        case .dekont:
            return self.dekont[index]
        case .diger:
            return self.diger[index]
        }
    }
}
