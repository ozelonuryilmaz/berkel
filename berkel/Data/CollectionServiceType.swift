//
//  ServiceType.swift
//  berkel
//
//  Created by Onur Yilmaz on 5.09.2023.
//

import Foundation
import FirebaseFirestore

public protocol CollectionServiceType {

    var collectionReference: CollectionReference { get }
}
