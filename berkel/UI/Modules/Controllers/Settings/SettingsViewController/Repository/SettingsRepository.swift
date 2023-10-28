//
//  SettingsRepository.swift
//  berkel
//
//  Created by Onur Yilmaz on 2.09.2023.
//

import Foundation

protocol ISettingsRepository: AnyObject {

    func getBuyingList() -> FirestoreResponseType<[SettingsResponseModel]>
}

final class SettingsRepository: BaseRepository, ISettingsRepository {

    func getBuyingList() -> FirestoreResponseType<[SettingsResponseModel]> {
        return getDocuments(SettingsService.list, order: "date")
    }
}
