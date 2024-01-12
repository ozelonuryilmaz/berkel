//
//  UserAuthsUIModel.swift
//  berkel
//
//  Created by Onur Yilmaz on 11.01.2024.
//

import UIKit

// Proje Sahibine kurulum yapıldığında açmış olduğu hesap id'si FB Rules'a tanımlanıyor. Tüm işlemleri yapabiliyor.
// Yeni birisi kayıt olduğunda TempUser'a kaydı düşüyor.
// Account Holder, tempUser'daki bir kişiye yetki verirse kaydı users'a düşüyor.
// Users altında yetkisi olanlar Account Holder gibi verilere erişmeye başlıyor.

protocol IUserAuthsUIModel {

    init(data: UserAuthsPassData)

    mutating func createTableViewDatas()

    // Props
    func isExitTempUser(userId: String) -> Bool
    //mutating func updateUser(userModel: UserModel)
    //mutating func addToUser(userModel: UserModel)
    //mutating func deleteFromTempUser(userModel: UserModel)

    // Setter
    mutating func setUsers(users: [UserModel])
    mutating func setTempUsers(tempUsers: [UserModel])

    // TableView
    func getNumberOfItemsInRow() -> Int
    func getItemCellUIModel(indexPath: IndexPath) -> UserAuthsRowModel
}

struct UserAuthsUIModel: IUserAuthsUIModel {

    // MARK: Definitions
    private var users: [UserModel] = []
    private var tempUsers: [UserModel] = []
    private var datas: [UserModel] = []

    // MARK: Initialize
    init(data: UserAuthsPassData) { }

}

// MARK: Setter
extension UserAuthsUIModel {

    mutating func setUsers(users: [UserModel]) {
        self.users = users
    }

    mutating func setTempUsers(tempUsers: [UserModel]) {
        self.tempUsers = tempUsers
    }
}

// MARK: Props
extension UserAuthsUIModel {

    // Güncel users ve tempUsers verilerini birleştirip TableView'de gösteriliyor.
    mutating func createTableViewDatas() {
        var datas: [UserModel] = []
        datas.append(contentsOf: tempUsers)
        datas.append(contentsOf: users)
        self.datas = datas.sorted(by: { $0.date > $1.date })
    }

    // TempUser'a yetki verildiğinde User'a aktarılması için kontrol sağlanıyor
    func isExitTempUser(userId: String) -> Bool {
        return tempUsers.contains(where: { $0.id == userId })
    }

    /*
    // Yetki verildiğinde Hücre yenilenmesi için User'ı güncelle
    mutating func updateUser(userModel: UserModel) {
        if let index = users.firstIndex(where: { $0.id == userModel.id }) {
            self.users[index] = userModel
        }
    }

    // TempUser'a yetki verildiğinde User'a aktar
    mutating func addToUser(userModel: UserModel) {
        self.users.append(userModel)
    }

    // TempUser'a yetki verildiğinde Sil. User'a aktarılıyor.
    mutating func deleteFromTempUser(userModel: UserModel) {
        if let index = tempUsers.firstIndex(where: { $0.id == userModel.id }) {
            self.tempUsers.remove(at: index)
        }
    }
    */
}

// MARK: Props
extension UserAuthsUIModel {

    func getNumberOfItemsInRow() -> Int {
        return datas.count
    }

    func getItemCellUIModel(indexPath: IndexPath) -> UserAuthsRowModel {
        return UserAuthsRowModel(userModel: datas[indexPath.row])
    }
}

