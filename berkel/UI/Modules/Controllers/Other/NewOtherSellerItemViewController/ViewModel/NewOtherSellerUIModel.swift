//
//  NewOtherSellerUIModel.swift
//  berkel
//
//  Created by Onur Yilmaz on 19.01.2024.
//

import UIKit

protocol INewOtherSellerUIModel {


    var data: OtherSellerModel { get }
    var errorMessage: String? { get }

    var isUpdatedOtherSeller: Bool { get }
    var navigationTitle: String { get }


    init(data: NewOtherSellerPassData)

    mutating func setCategory(id: String, name: String)
    mutating func setName(_ name: String)
    mutating func setPhone(_ phone: String)
    mutating func setDesc(_ desc: String)

    func getCategoryName() -> String
    func getName() -> String
    func getPhone() -> String
    func getDesc() -> String
}

struct NewOtherSellerUIModel: INewOtherSellerUIModel {

    // MARK: Definitions
    private let otherSellerInformation: IOtherSellerListTableViewCellUIModel?

    private var categoryId: String? = nil
    private var categoryName: String = ""
    private var name: String = ""
    private var phone: String = ""
    private var desc: String? = nil

    // MARK: Initialize
    init(data: NewOtherSellerPassData) {
        self.otherSellerInformation = data.otherSellerInformation
        self.setCategory(id: self.otherSellerInformation?.categoryId ?? "",
                         name: self.otherSellerInformation?.categoryName ?? "")
        self.setName(self.otherSellerInformation?.name ?? "")
        self.setPhone(self.otherSellerInformation?.phoneNumber ?? "")
        self.setDesc(self.otherSellerInformation?.desc ?? "")
    }

    // MARK: Computed Props

    var data: OtherSellerModel {
        return OtherSellerModel(id: otherSellerInformation?.id,
                                categoryId: categoryId,
                                categoryName: categoryName,
                                name: self.name,
                                phoneNumber: self.phone,
                                description: self.desc,
                                date: Date().dateFormatterApiResponseType())
    }

    var isUpdatedOtherSeller: Bool {
        return otherSellerInformation != nil
    }

    var navigationTitle: String {
        return isUpdatedOtherSeller ? "Diğer Satıcıyı Güncelle" : "Yeni Diğer Satıcı Ekle"
    }

    var errorMessage: String? {
        if categoryName.isEmpty || true == categoryId?.isEmpty {
            return "Lütfen kategori seçiniz"
        }

        if name.isEmpty {
            return "Lütfen Ad Soyad giriniz"
        }

        if phone.isEmpty {
            return "Lütfen telefon numarası giriniz"
        }
        return nil
    }

    // MARK: Computed Props
    mutating func setCategory(id: String, name: String) {
        self.categoryId = id
        self.categoryName = name
    }

    mutating func setName(_ name: String) {
        self.name = name
    }

    mutating func setPhone(_ phone: String) {
        self.phone = phone
    }

    mutating func setDesc(_ desc: String) {
        self.desc = desc
    }

    func getCategoryName() -> String {
        return categoryName
    }

    func getName() -> String {
        return name
    }

    func getPhone() -> String {
        return phone
    }

    func getDesc() -> String {
        return desc ?? ""
    }
}

// MARK: Props
extension NewOtherSellerUIModel {

}
