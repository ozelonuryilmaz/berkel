//
//  WorkerUIModel.swift
//  berkel
//
//  Created by Onur Yilmaz on 2.09.2023.
//

import UIKit

protocol IWorkerUIModel {

    var season: String { get }

    init()
}

struct WorkerUIModel: IWorkerUIModel {

    // MARK: Definitions

    // MARK: Initialize
    init() {

    }

    var season: String {
        return UserDefaultsManager.shared.getStringValue(key: .season) ?? "unknown"
    }

    // MARK: Computed Props
}

// MARK: Props
extension WorkerUIModel {

}
