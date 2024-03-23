//
//  DocumentServiceType.swift
//  berkel
//
//  Created by Onur Yilmaz on 6.09.2023.
//

import Foundation
import FirebaseFirestore

public protocol DocumentServiceType {

    var documentReference: DocumentReference { get }
}
