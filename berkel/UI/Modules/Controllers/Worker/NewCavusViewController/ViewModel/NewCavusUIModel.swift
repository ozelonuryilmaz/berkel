//
//  NewCavusUIModel.swift
//  berkel
//
//  Created by Onur Yilmaz on 31.10.2023.
//

import UIKit

protocol INewCavusUIModel {

    var data: CavusModel { get }
    var errorMessage: String? { get }

    var isUpdatedCavus: Bool { get }
    var navigationTitle: String { get }

    init(data: NewCavusPassData)

    mutating func setName(_ name: String)
    mutating func setPhone(_ phone: String)
    mutating func setDesc(_ desc: String)

    func getName() -> String
    func getPhone() -> String
    func getDesc() -> String
}

struct NewCavusUIModel: INewCavusUIModel {

    // MARK: Definitions
    private let cavusInformation: ICavusListTableViewCellUIModel?

    private var name: String = ""
    private var phone: String = ""
    private var desc: String? = nil

    // MARK: Initialize
    init(data: NewCavusPassData) {
        self.cavusInformation = data.cavusInformation
        self.setName(self.cavusInformation?.name ?? "")
        self.setPhone(self.cavusInformation?.phoneNumber ?? "")
        self.setDesc(self.cavusInformation?.desc ?? "")
    }

    var data: CavusModel {
        return CavusModel(id: cavusInformation?.id,
                          name: self.name,
                          phoneNumber: self.phone,
                          description: self.desc,
                          date: Date().dateFormatterApiResponseType())
    }

    var isUpdatedCavus: Bool {
        return cavusInformation != nil
    }

    var navigationTitle: String {
        return isUpdatedCavus ? "Çavuşu Güncelle" : "Yeni Çavuş Ekle"
    }

    var errorMessage: String? {
        if name.isEmpty {
            return "Lütfen Ad Soyad giriniz"
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

    mutating func setPhone(_ phone: String) {
        self.phone = phone
    }

    mutating func setDesc(_ desc: String) {
        self.desc = desc
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
extension NewCavusUIModel {

}
