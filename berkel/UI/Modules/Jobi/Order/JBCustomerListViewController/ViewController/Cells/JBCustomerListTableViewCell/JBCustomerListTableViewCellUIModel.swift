//
//  JBCustomerListTableViewCellUIModel.swift
//  berkel
//
//  Created by Onur Yilmaz on 21.04.2024.
//

import Foundation

protocol IJBCustomerListTableViewCellUIModel {
    
    var customerModel: JBCustomerModel { get }

    var id: String? { get }
    var name: String { get }
    var desc: String? { get }
    var phoneNumber: String { get }
}

struct JBCustomerListTableViewCellUIModel: IJBCustomerListTableViewCellUIModel {

    let customerModel: JBCustomerModel
    
    var id: String? {
        return customerModel.id
    }
    
    var name: String {
        return customerModel.name
    }
    
    var desc: String? {
        return customerModel.description
    }
    
    var phoneNumber: String {
        return customerModel.phoneNumber
    }
    
}
