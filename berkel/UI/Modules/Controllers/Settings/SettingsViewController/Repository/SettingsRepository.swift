//
//  SettingsRepository.swift
//  berkel
//
//  Created by Onur Yilmaz on 2.09.2023.
//  Copyright (c) 2023 Emlakjet IOS Development Team. All rights reserved.[EC-2021]
//

import Foundation

protocol ISettingsRepository: AnyObject {

    func getBuyingList() -> FirestoreResponseType<[SettingsResponseModel]>
}

final class SettingsRepository: BaseRepository, ISettingsRepository {

    func getBuyingList() -> FirestoreResponseType<[SettingsResponseModel]> {
        return getDocuments(SettingsService.list)
    }
}
