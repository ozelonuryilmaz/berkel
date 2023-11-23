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

    init(data: NewCustomerPassData)

    mutating func setName(_ name: String)
    mutating func setPhone(_ phone: String)
    mutating func setDesc(_ desc: String)
}

struct NewCustomerUIModel: INewCustomerUIModel {

    // MARK: Definitions
    private var name: String = ""
    private var phone: String = ""
    private var desc: String? = nil

    // MARK: Initialize
    init(data: NewCustomerPassData) {

    }

    var data: CustomerModel {
        return CustomerModel(name: self.name,
                             phoneNumber: self.phone,
                             description: self.desc,
                             date: Date().dateFormatterApiResponseType())
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
}

// MARK: Props
extension NewCustomerUIModel {

}
