//
//  NewCustomerPassData.swift
//  berkel
//
//  Created by Onur Yilmaz on 19.11.2023.
//

import Foundation

struct NewCustomerPassData: ICoordinatorPassData {

    // eğer müşteri bilgileri geliyorsa güncelleştirme yap
    let customerInformation: ICustomerListTableViewCellUIModel?
}
