//
//  PhoneCallHelper.swift
//  berkel
//
//  Created by Onur Yilmaz on 22.09.2023.
//

import UIKit

struct PhoneCallHelper {

    static let shared = PhoneCallHelper()

    private init() { }

    func makeACall(phoneNumber: String) {
        if phoneNumber.isValid(regex: .phone) {
            if let url = URL(string: "tel:\(phoneNumber.onlyDigits())"),
                UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
            }
        }
    }
}
