//
//  DateFormatHelper.swift
//  berkel
//
//  Created by Onur Yilmaz on 20.09.2023.
//

import Foundation

struct DateFormatHelper {

    private init() { }
    
    // Bu dateFormat'ı kesinlikle değiştirme! Veri tabanına sabit format kaydediliyor!!!!
    static func createFormatterApiResponseType() -> DateFormatter {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "tr_TR")
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter
    }


    static func createFormatterAppDisplayType() -> DateFormatter {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "tr_TR")
        formatter.dateFormat = "dd.MM.yyyy"
        return formatter
    }
    
    static func createFormatterAppDisplayNameType() -> DateFormatter {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "tr_TR")
        formatter.dateFormat = "dd MMMM yyyy"
        return formatter
    }

    static func createFormatterHourMinute() -> DateFormatter {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "tr_TR")
        formatter.dateFormat = "HH:mm"
        return formatter
    }

    static func createFormatterDateTime() -> DateFormatter {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "tr_TR")
        formatter.dateFormat = "dd MMMM yyyy HH:mm"
        return formatter
    }
}
