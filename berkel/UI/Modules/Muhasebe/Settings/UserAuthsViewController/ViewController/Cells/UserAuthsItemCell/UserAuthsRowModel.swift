//
//  UserAuthsRowModel.swift
//  berkel
//
//  Created by Onur Yilmaz on 11.01.2024.
//

import Foundation

struct UserAuthsRowModel {

    var userModel: UserModel

    var isAdmin: Bool {
        switch otherModule {
        case .accouting:
            return userModel.isAdmin
        case .jobi:
            return userModel.isStockAdmin ?? false
        }
    }
}
