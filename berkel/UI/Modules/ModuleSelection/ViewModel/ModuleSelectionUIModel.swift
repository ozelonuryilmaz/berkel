//
//  ModuleSelectionUIModel.swift
//  berkel
//
//  Created by Onur Yilmaz on 7.03.2024.
//

import UIKit

protocol IModuleSelectionUIModel {
    
    var seasonTitle: String { get }

	 init(data: ModuleSelectionPassData)

} 

struct ModuleSelectionUIModel: IModuleSelectionUIModel {

	// MARK: Definitions

	// MARK: Initialize
    init(data: ModuleSelectionPassData) {

    }
    
    var seasonTitle: String {
        return season.isEmpty ? "" : "\(season) Sezonu"
    }
    
    var season: String {
        return UserDefaultsManager.shared.getStringValue(key: .season) ?? ""
    }

    // MARK: Computed Props
}

// MARK: Props
extension ModuleSelectionUIModel {

}
