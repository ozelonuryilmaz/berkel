//
//  NewCustomerUIModel.swift
//  berkel
//
//  Created by Onur Yilmaz on 19.11.2023.
//

import UIKit

protocol INewCustomerUIModel {

    var data: CustomerModel { get }
    var errorMessage: String? { get }

    var isUpdatedCustomer: Bool { get }
    var navigationTitle: String { get }

    init(data: NewCustomerPassData)

    mutating func setName(_ name: String)
    mutating func setPhone(_ phone: String)
    mutating func setDesc(_ desc: String)

    func getName() -> String
    func getPhone() -> String
    func getDesc() -> String
}

struct NewCustomerUIModel: INewCustomerUIModel {

    // MARK: Definitions
    private let customerInformation: ICustomerListTableViewCellUIModel?

    private var name: String = ""
    private var phone: String = ""
    private var desc: String? = nil

    // MARK: Initialize
    init(data: NewCustomerPassData) {
        self.customerInformation = data.customerInformation
        self.setName(self.customerInformation?.name ?? "")
        self.setPhone(self.customerInformation?.phoneNumber ?? "")
        self.setDesc(self.customerInformation?.desc ?? "")
    }

    var data: CustomerModel {
        return CustomerModel(id: customerInformation?.id,
                             name: self.name,
                             phoneNumber: self.phone,
                             description: self.desc,
                             date: Date().dateFormatterApiResponseType())
    }

    var isUpdatedCustomer: Bool {
        return customerInformation != nil
    }

    var navigationTitle: String {
        return isUpdatedCustomer ? "Müşteriyi Güncelle" : "Yeni Müşteri Ekle"
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
extension NewCustomerUIModel {

}
