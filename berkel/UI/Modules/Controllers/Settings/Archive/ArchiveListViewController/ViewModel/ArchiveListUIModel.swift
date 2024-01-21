//
//  ArchiveListUIModel.swift
//  berkel
//
//  Created by Onur Yilmaz on 26.10.2023.
//

import UIKit

protocol IArchiveListUIModel {

    var imagePageType: ImagePageType { get }
    var season: String { get }

    var archiveSegmentType: ArchiveSegmentType { get }

    var isHaveAnyKantarFisi: Bool { get }
    var isHaveAnyCek: Bool { get }
    var isHaveAnyDekont: Bool { get }
    var isHaveAnyDiger: Bool { get }

    init(data: ArchiveListPassData)

    mutating func setArchive(imagePathType: ImagePathType, data: [SellerImageModel])
    mutating func setArchive(imagePathType: ImagePathType, data: [CustomerImageModel])
    mutating func setArchive(imagePathType: ImagePathType, data: [WorkerImageModel])
    mutating func setArchive(imagePathType: ImagePathType, data: [OtherSellerImageModel])
    mutating func setArchiveType(index: Int)

    // for Table View
    func getNumberOfItemsInSection() -> Int
    func getCellUIModel(at index: Int) -> ArchiveListTableViewCellUIModel
}

struct ArchiveListUIModel: IArchiveListUIModel {

    // MARK: Definitions
    let imagePageType: ImagePageType

    // MARK: Initialize
    init(data: ArchiveListPassData) {
        self.imagePageType = data.imagePageType
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
    
    mutating func setArchive(imagePathType: ImagePathType, data: [CustomerImageModel]) {
        let archiveListTableViewCellUIModel: [ArchiveListTableViewCellUIModel] = data.compactMap({ customerImageModel in
            return ArchiveListTableViewCellUIModel(imageUrl: customerImageModel.imageUrl,
                                                   date: customerImageModel.date?.dateTimeFormatFull() ?? "",
                                                   productName: customerImageModel.sellerProductName,
                                                   desc: customerImageModel.description ?? "")
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
    
    mutating func setArchive(imagePathType: ImagePathType, data: [WorkerImageModel]) {
        let archiveListTableViewCellUIModel: [ArchiveListTableViewCellUIModel] = data.compactMap({ workerImageModel in
            return ArchiveListTableViewCellUIModel(imageUrl: workerImageModel.imageUrl,
                                                   date: workerImageModel.date?.dateTimeFormatFull() ?? "",
                                                   productName: workerImageModel.workerProductName,
                                                   desc: workerImageModel.description ?? "")
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
    
    mutating func setArchive(imagePathType: ImagePathType, data: [OtherSellerImageModel]) {
        let archiveListTableViewCellUIModel: [ArchiveListTableViewCellUIModel] = data.compactMap({ otherSellerImageModel in
            return ArchiveListTableViewCellUIModel(imageUrl: otherSellerImageModel.imageUrl,
                                                   date: otherSellerImageModel.date?.dateTimeFormatFull() ?? "",
                                                   productName: otherSellerImageModel.otherProductName,
                                                   desc: otherSellerImageModel.description ?? "")
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
