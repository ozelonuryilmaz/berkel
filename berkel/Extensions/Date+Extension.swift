//
//  Date+Extension.swift
//  berkel
//
//  Created by Onur Yilmaz on 20.09.2023.
//

import Foundation


extension Date {

    // NOT: Veritabanına sadece "yyyy-MM-dd'T'HH:mm:ss" formatta Tarih kaydedilmeli !!!!
    
    // "yyyy-MM-dd'T'HH:mm:ss"
    func dateFormatterApiResponseType() -> String {
        return DateFormatHelper.createFormatterApiResponseType().string(from: self)
    }
}
