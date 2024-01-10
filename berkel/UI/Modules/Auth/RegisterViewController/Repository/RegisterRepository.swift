//
//  RegisterRepository.swift
//  berkel
//
//  Created by Onur Yilmaz on 12.09.2023.
//

import FirebaseFirestore

protocol IRegisterRepository: AnyObject {

    func saveNewUser(userModel: UserModel) -> FirestoreResponseType<UserModel>
}

final class RegisterRepository: BaseRepository, IRegisterRepository {

    func saveNewUser(userModel: UserModel) -> FirestoreResponseType<UserModel> {
        let db: DocumentReference = UserService.tempSave(userId: userModel.id).documentReference
        return self.setData(db, data: userModel)
    }
}
