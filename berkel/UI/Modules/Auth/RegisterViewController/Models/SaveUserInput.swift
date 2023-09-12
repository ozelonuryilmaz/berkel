//
//  SaveUserInput.swift
//  berkel
//
//  Created by Onur Yilmaz on 13.09.2023.
//

import Foundation
import FirebaseFirestoreSwift


struct SaveUserInput: Codable {
    //@DocumentID var id: String?
    var name: String
    var email: String
}
