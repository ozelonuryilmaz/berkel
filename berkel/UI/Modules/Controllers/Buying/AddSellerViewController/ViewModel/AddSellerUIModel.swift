//
//  AddSellerUIModel.swift
//  berkel
//
//  Created by Onur Yilmaz on 15.09.2023.
//  Copyright (c) 2023 Emlakjet IOS Development Team. All rights reserved.[EC-2021]
//

import UIKit

protocol IAddSellerUIModel {
    
    var data: AddSellerModel { get }
    var errorMessage: String? { get }
    
    init(data: AddSellerPassData)

    mutating func setName(_ name: String)
    mutating func setTC(_ tc: String)
    mutating func setPhone(_ phone: String)
    mutating func setDesc(_ desc: String)
}

struct AddSellerUIModel: IAddSellerUIModel {

    // MARK: Definitions
    private var name: String = ""
    private var tc: String = ""
    private var phone: String = ""
    private var desc: String? = nil

    // MARK: Initialize
    init(data: AddSellerPassData) {

    }

    var data: AddSellerModel {
        return AddSellerModel(name: self.name, tckn: self.tc, phoneNumber: self.phone, description: self.desc, date: Date().dateFormatterApiResponseType())
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
}

// MARK: Props
extension AddSellerUIModel {

}
