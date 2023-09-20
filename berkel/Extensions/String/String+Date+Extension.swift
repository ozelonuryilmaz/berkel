//
//  String+Date+Extension.swift
//  berkel
//
//  Created by Onur Yilmaz on 20.09.2023.
//

import Foundation

extension String {

    // veritabanına "yyyy-MM-dd'T'HH:mm:ss" tipiyle kaydedilirken ""yyyy-MM-ddTHH:mm:ss"" dönüşüyor
    func getApiResponseTypeDate() -> Date? {
        let format = "yyyy-MM-dd HH:mm:ss"
        let formatCount = format.count
        let sub = self[0..<formatCount]
        return DateFormatHelper.createFormatterApiResponseType().date(from: sub)
    }


    // "dd.MM.yyyy"
    func dateFormatToAppDisplayType() -> String? {
        if let date = getApiResponseTypeDate() {
            return DateFormatHelper.createFormatterAppDisplayType().string(from: date)
        }
        return nil
    }

    // "HH:mm"
    func timeFormatHourMinute() -> String? {
        if let date = getApiResponseTypeDate() {
            return DateFormatHelper.createFormatterHourMinute().string(from: date)
        }
        return nil
    }

    // dd MMMM yyyy HH:mm
    func dateTimeFormatFull() -> String? {
        if let date = getApiResponseTypeDate() {
            return DateFormatHelper.createFormatterDateTime().string(from: date)
        }
        return nil
    }

}
