//
//  SplashRepository.swift
//  berkel
//
//  Created by Onur Yilmaz on 1.09.2023.
//

import Foundation
import FirebaseFirestore

protocol ISplashRepository: AnyObject {

    func getUsers() -> FirestoreResponseType<[UserModel]>
}

final class SplashRepository: BaseRepository, ISplashRepository {

    func getUsers() -> FirestoreResponseType<[UserModel]> {
        let db = UserListService.list
        return getDocuments(db, order: db.order)
    }
}
