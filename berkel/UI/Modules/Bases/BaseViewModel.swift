//
//  BaseViewModel.swift
//  berkel
//
//  Created by Onur Yilmaz on 1.09.2023.
//

import Foundation

class BaseViewModel {
    
    deinit {
        print("killed: \(type(of: self))")
    }
}
