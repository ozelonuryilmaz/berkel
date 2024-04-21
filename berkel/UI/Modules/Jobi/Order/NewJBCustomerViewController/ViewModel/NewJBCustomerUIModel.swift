//
//  NewJBCustomerUIModel.swift
//  berkel
//
//  Created by Onur Yilmaz on 16.04.2024.
//  Copyright (c) 2024 Berkel IOS Development Team. All rights reserved.[OY-2024]
//

import UIKit

protocol INewJBCustomerUIModel {

    var data: JBCustomerModel { get }
    var errorMessage: String? { get }

    var isUpdatedCustomer: Bool { get }
    var navigationTitle: String { get }

    init(data: NewJBCustomerPassData)

    mutating func setName(_ name: String)
    mutating func setPhone(_ phone: String)
    mutating func setDesc(_ desc: String)

    func getName() -> String
    func getPhone() -> String
    func getDesc() -> String
}

struct NewJBCustomerUIModel: INewJBCustomerUIModel {

    // MARK: Definitions
    private let customerInformation: IJBCustomerListTableViewCellUIModel?

    private var name: String = ""
    private var phone: String = ""
    private var desc: String? = nil

    // MARK: Initialize
    init(data: NewJBCustomerPassData) {
        self.customerInformation = data.customerInformation
        self.setName(self.customerInformation?.name ?? "")
        self.setPhone(self.customerInformation?.phoneNumber ?? "")
        self.setDesc(self.customerInformation?.desc ?? "")
    }

    var data: JBCustomerModel {
        return JBCustomerModel(id: customerInformation?.id,
                               name: self.name,
                               phoneNumber: self.phone,
                               description: self.desc,
                               date: Date().dateFormatterApiResponseType())
    }

    var isUpdatedCustomer: Bool {
        return customerInformation != nil
    }

    var navigationTitle: String {
        return isUpdatedCustomer ? "Müşteri Güncelle" : "Yeni Müşteri Ekle"
    }

    var errorMessage: String? {
        if name.isEmpty {
            return "Lütfen müşteri giriniz"
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
extension NewJBCustomerUIModel {

}
