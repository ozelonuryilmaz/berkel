//
//  NewSellerImageUIModel.swift
//  berkel
//
//  Created by Onur Yilmaz on 23.10.2023.
//

import UIKit

protocol INewSellerImageUIModel {

    var imagePathType: ImagePathType { get }
    var imagePageType: ImagePageType { get }
    var season: String { get }
    var userId: String? { get }

    var date: String? { get }
    var desc: String? { get }
    var imageData: Data? { get }

    var navTitle: String { get }

    init(data: NewSellerImagePassData)

    // Setter
    mutating func setDate(date: String?)
    mutating func setImageData(_ data: Data?)
    mutating func setDesc(_ text: String)
}

struct NewSellerImageUIModel: INewSellerImageUIModel {

    // MARK: Definitions
    let imagePathType: ImagePathType
    let imagePageType: ImagePageType

    // MARK: Initialize
    init(data: NewSellerImagePassData) {
        self.imagePathType = data.imagePathType
        self.imagePageType = data.imagePageType
    }

    var date: String? = Date().dateFormatterApiResponseType()
    var desc: String? = nil
    var imageData: Data? = nil

    var userId: String? {
        return UserManager.shared.userId
    }

    var season: String {
        return UserDefaultsManager.shared.getStringValue(key: .season) ?? "unknown"
    }

    var navTitle: String {
        switch self.imagePathType {
        case .kantarFisi:
            return "Fiş Resmi Ekle"
        case .cek:
            return "Çek Resmi Ekle"
        case .dekont:
            return "Dekont Resmi Ekle"
        case .diger:
            return "Diğer Resim Ekle"
        }
    }

    // MARK: Computed Props
}

// MARK: Props
extension NewSellerImageUIModel {

}

// MARK: Setter
extension NewSellerImageUIModel {

    mutating func setDate(date: String?) {
        self.date = date
    }

    mutating func setImageData(_ data: Data?) {
        self.imageData = data
    }

    mutating func setDesc(_ text: String) {
        self.desc = text
    }
}
