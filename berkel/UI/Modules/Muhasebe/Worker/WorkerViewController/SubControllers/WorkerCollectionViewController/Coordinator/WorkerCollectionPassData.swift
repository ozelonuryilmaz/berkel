//
//  WorkerCollectionPassData.swift
//  berkel
//
//  Created by Onur Yilmaz on 4.11.2023.
//

import Foundation

struct WorkerCollectionPassData: ICoordinatorPassData {
    
    var viewedData: Bool = true
    var kesiciCount: Int = 0
    var ayakciCount: Int = 0
    var otherPrice: Double = 0.0
    
    let workerModel: WorkerModel
}
