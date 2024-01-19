//
//  OtherUIModel.swift
//  berkel
//
//  Created by Onur Yilmaz on 19.01.2024.
//

import UIKit

protocol IOtherUIModel {
    
    var season: String { get }
    
	 init()

} 

struct OtherUIModel: IOtherUIModel {

	// MARK: Definitions

	// MARK: Initialize
    init() { }

    // MARK: Computed Props
    
    var season: String {
        return UserDefaultsManager.shared.getStringValue(key: .season) ?? "unknown"
    }
}

// MARK: Props
extension OtherUIModel {

}
