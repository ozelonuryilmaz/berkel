//
//  WorkerDetailPassData.swift
//  berkel
//
//  Created by Onur Yilmaz on 4.11.2023.
//

import Foundation

struct WorkerDetailPassData: ICoordinatorPassData {

    let workerId: String
    let cavusName: String
    let cavusId: String
    var isActive: Bool
}
