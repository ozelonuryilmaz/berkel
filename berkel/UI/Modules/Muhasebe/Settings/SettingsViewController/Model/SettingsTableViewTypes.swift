//
//  SettingsTableViewTypes.swift
//  berkel
//
//  Created by Onur Yilmaz on 10.12.2023.
//

import Foundation

// MARK: SettingsSectionType
enum SettingsSectionType: Int {
    case list = 0
    case gelirGider = 1
    case ayarlar = 2
    case hesap = 3

    var sectionTitle: String {
        switch self {
        case .list:
            return "Listeler"
        case .gelirGider:
            return "Gelir Gider Çizelgeleri"
        case .ayarlar:
            return "Ayarlar"
        case .hesap:
            return "Hesap"
        }
    }
}

// MARK: SettingsCellType
enum SettingsCellType {
    case saticiList
    case cavusList
    case musteriList
    case jbMusteriList
    case otherList
    case alisGelirGiderCizergesi
    case isciGelirGiderCizergesi
    case satisGelirGiderCizergesi
    case otherGelirGiderCizergesi
    case userAuths
    case sezonlar
    case moduleSelection
    case cikisYap

    var rowTitle: String {
        switch self {
        case .saticiList:
            return "Satıcı Listesi"
        case .cavusList:
            return "Çavuş Listesi"
        case .musteriList, .jbMusteriList:
            return "Müşteri Listesi"
        case .otherList:
            return "Hizmet Listesi"
        case .alisGelirGiderCizergesi:
            return "Alış Çizelgesi"
        case .isciGelirGiderCizergesi:
            return "İşçi Çizelgesi"
        case .satisGelirGiderCizergesi:
            return "Satış Çizelgesi"
        case .otherGelirGiderCizergesi:
            return "Hizmet Çizelgesi"
        case .userAuths:
            return "Kullanıcı Yetkilendir"
        case .sezonlar:
            return "Sezon Değiştir"
        case .moduleSelection:
            return "Uygulama Değiştir"
        case .cikisYap:
            return "Çıkış Yap"
        }
    }
}
