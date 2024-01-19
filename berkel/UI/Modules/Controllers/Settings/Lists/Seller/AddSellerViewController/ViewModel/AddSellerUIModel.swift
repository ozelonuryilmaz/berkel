//
//  AddSellerUIModel.swift
//  berkel
//
//  Created by Onur Yilmaz on 15.09.2023.
//

import UIKit

protocol IAddSellerUIModel {

    var data: AddSellerModel { get }
    var errorMessage: String? { get }

    var isUpdatedSeller: Bool { get }
    var navigationTitle: String { get }

    init(data: AddSellerPassData)

    mutating func setName(_ name: String)
    mutating func setTC(_ tc: String)
    mutating func setPhone(_ phone: String)
    mutating func setDesc(_ desc: String)

    func getName() -> String
    func getTC() -> String
    func getPhone() -> String
    func getDesc() -> String
}

struct AddSellerUIModel: IAddSellerUIModel {

    // MARK: Definitions
    private let sellerInformation: IAddBuyingItemTableViewCellUIModel?

    private var name: String = ""
    private var tc: String = ""
    private var phone: String = ""
    private var desc: String? = nil

    // MARK: Initialize
    init(data: AddSellerPassData) {
        self.sellerInformation = data.sellerInformation
        self.setName(sellerInformation?.name ?? "")
        self.setTC(sellerInformation?.tc ?? "")
        self.setPhone(sellerInformation?.phoneNumber ?? "")
        self.setDesc(sellerInformation?.desc ?? "")
    }

    var data: AddSellerModel {
        return AddSellerModel(id: sellerInformation?.id,
                              name: self.name,
                              tckn: self.tc,
                              phoneNumber: self.phone,
                              description: self.desc,
                              date: Date().dateFormatterApiResponseType())
    }

    var isUpdatedSeller: Bool {
        return sellerInformation != nil
    }

    var navigationTitle: String {
        return isUpdatedSeller ? "Satıcıyı Güncelle" : "Yeni Satıcı Ekle"
    }

    var errorMessage: String? {
        if name.isEmpty {
            return "Lütfen Ad Soyad giriniz"
        }

        if tc.isEmpty || tc.count < 11 {
            return "Lütfen TC giriniz"
        }

        if phone.isEmpty {
            return "Lütfen telefon numarası giriniz"
        }

        return nil
    }

    // MARK: Computed Props
    mutating func setName(_ name: String) {
        self.name = name
    }

    mutating func setTC(_ tc: String) {
        self.tc = tc
    }

    mutating func setPhone(_ phone: String) {
        self.phone = phone
    }

    mutating func setDesc(_ desc: String) {
        self.desc = desc
    }


    func getName() -> String {
        return name
    }

    func getTC() -> String {
        return tc
    }

    func getPhone() -> String {
        return phone
    }

    func getDesc() -> String {
        return desc ?? ""
    }
}

// MARK: Props
extension AddSellerUIModel {

}
