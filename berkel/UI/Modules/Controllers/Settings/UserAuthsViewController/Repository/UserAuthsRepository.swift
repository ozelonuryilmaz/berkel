//
//  UserAuthsRepository.swift
//  berkel
//
//  Created by Onur Yilmaz on 11.01.2024.
//

import Foundation
import FirebaseFirestore

protocol IUserAuthsRepository: AnyObject {

    func getUsers() -> FirestoreResponseType<[UserModel]>
    func getTempUsers() -> FirestoreResponseType<[UserModel]>
    func saveUser(userModel: UserModel) -> FirestoreResponseType<UserModel>
    func deleteTempUser(userId: String) -> FirestoreResponseType<Bool>
    func updateUser(userId: String, isAdmin: Bool) -> FirestoreResponseType<Bool>
}

final class UserAuthsRepository: BaseRepository, IUserAuthsRepository {

    func getUsers() -> FirestoreResponseType<[UserModel]> {
        let db = UserListService.list
        return getDocuments(db, order: db.order)
    }

    func getTempUsers() -> FirestoreResponseType<[UserModel]> {
        let db = UserListService.tempList
        return getDocuments(db, order: db.order)
    }

    func saveUser(userModel: UserModel) -> FirestoreResponseType<UserModel> {
        let db: DocumentReference = UserService.save(userId: userModel.id).documentReference
        return setData(db, data: userModel)
    }

    func deleteTempUser(userId: String) -> FirestoreResponseType<Bool> {
        let db: DocumentReference = UserService.delete(userId: userId).documentReference
        return deleteData(db)
    }

    func updateUser(userId: String, isAdmin: Bool) -> FirestoreResponseType<Bool> {
        let db = UserService.save(userId: userId).documentReference
        return updateData(db, data: ["isAdmin": isAdmin])
    }
}
