//
//  OtherDetailPaymentTableViewCellUIModel.swift
//  berkel
//
//  Created by Onur Yilmaz on 4.02.2024.
//

import Foundation

protocol IOtherDetailPaymentTableViewCellUIModel {

    var payment: OtherPaymentModel { get }
    var isActive: Bool { get }
}

struct OtherDetailPaymentTableViewCellUIModel: IOtherDetailPaymentTableViewCellUIModel {

    let payment: OtherPaymentModel
    let isActive: Bool
}
