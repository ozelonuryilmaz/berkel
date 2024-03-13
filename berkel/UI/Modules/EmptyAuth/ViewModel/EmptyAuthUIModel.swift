//
//  EmptyAuthUIModel.swift
//  berkel
//
//  Created by Onur Yilmaz on 13.03.2024.
//

import UIKit

protocol IEmptyAuthUIModel {

	 init(data: EmptyAuthPassData)

} 

struct EmptyAuthUIModel: IEmptyAuthUIModel {

	// MARK: Definitions

	// MARK: Initialize
    init(data: EmptyAuthPassData) {

    }

    // MARK: Computed Props
}

// MARK: Props
extension EmptyAuthUIModel {

}
