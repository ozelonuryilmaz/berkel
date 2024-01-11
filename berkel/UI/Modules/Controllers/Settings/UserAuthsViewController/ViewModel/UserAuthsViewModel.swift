//
//  UserAuthsViewModel.swift
//  berkel
//
//  Created by Onur Yilmaz on 11.01.2024.
//

import Foundation
import Combine

protocol IUserAuthsViewModel: UserAuthsItemCellOutputDelegate {

    var viewState: ScreenStateSubject<UserAuthsViewState> { get }
    var errorState: ErrorStateSubject { get }

    init(repository: IUserAuthsRepository,
         coordinator: IUserAuthsCoordinator,
         uiModel: IUserAuthsUIModel)

    // Service
    func getUsers()

    // TableView
    func getNumberOfItemsInRow() -> Int
    func getItemCellUIModel(indexPath: IndexPath) -> UserAuthsRowModel
}

final class UserAuthsViewModel: BaseViewModel, IUserAuthsViewModel {

    // MARK: Definitions
    private let repository: IUserAuthsRepository
    private let coordinator: IUserAuthsCoordinator
    private var uiModel: IUserAuthsUIModel

    // MARK: Public Props
    var viewState = ScreenStateSubject<UserAuthsViewState>(nil)
    var errorState = ErrorStateSubject(nil)
    var tempErrorState = ErrorStateSubject(nil)
    let userResponse = CurrentValueSubject<[UserModel]?, Never>(nil)
    let userTempResponse = CurrentValueSubject<[UserModel]?, Never>(nil)
    let deleteTempUserResponse = CurrentValueSubject<Bool?, Never>(nil)
    let updateUserResponse = CurrentValueSubject<Bool?, Never>(nil)
    let saveUserResponse = CurrentValueSubject<UserModel?, Never>(nil)

    // MARK: Initiliazer
    required init(repository: IUserAuthsRepository,
                  coordinator: IUserAuthsCoordinator,
                  uiModel: IUserAuthsUIModel) {
        self.repository = repository
        self.coordinator = coordinator
        self.uiModel = uiModel


    }

    func updateView() {
        self.uiModel.createTableViewDatas()
        DispatchQueue.delay(250) { [weak self] in
            self?.viewStateReloadData()
        }
    }

    private func updateUserRole(userModel: UserModel) {
        if self.uiModel.isExitTempUser(userId: userModel.id) {
            self.saveUser(userModel: userModel)
        } else {
            self.updateUser(userModel: userModel)
        }
    }
}


// MARK: Service
internal extension UserAuthsViewModel {

    func getUsers() {
        handleResourceFirestore(
            request: self.repository.getUsers(),
            response: self.userResponse,
            errorState: self.errorState,
            callbackLoading: { [weak self] isProgress in
                guard let self = self else { return }
                self.viewStateShowNativeProgress(isProgress: isProgress)
            },
            callbackSuccess: { [weak self] in
                guard let self = self else { return }
                self.uiModel.setUsers(users: self.userResponse.value ?? [])
                self.getTempUsers()
            })
    }

    private func getTempUsers() {
        handleResourceFirestore(
            request: self.repository.getTempUsers(),
            response: self.userTempResponse,
            errorState: self.errorState,
            callbackLoading: { [weak self] isProgress in
                guard let self = self else { return }
                self.viewStateShowNativeProgress(isProgress: isProgress)
            },
            callbackSuccess: { [weak self] in
                guard let self = self else { return }
                self.uiModel.setTempUsers(tempUsers: self.userTempResponse.value ?? [])
                self.updateView()
            })
    }

    private func saveUser(userModel: UserModel) {
        handleResourceFirestore(
            request: self.repository.saveUser(userModel: userModel),
            response: self.deleteTempUserResponse,
            errorState: self.tempErrorState,
            callbackLoading: { [weak self] isProgress in
                guard let self = self else { return }
                self.viewStateShowNativeProgress(isProgress: isProgress)
            },
            callbackComplete: { [weak self] in
                guard let self = self else { return }
                self.deleteTempUser(userModel: userModel)
            })
    }

    private func deleteTempUser(userModel: UserModel) {
        handleResourceFirestore(
            request: self.repository.deleteTempUser(userId: userModel.id),
            response: self.deleteTempUserResponse,
            errorState: self.tempErrorState,
            callbackLoading: { [weak self] isProgress in
                guard let self = self else { return }
                self.viewStateShowNativeProgress(isProgress: isProgress)
            },
            callbackComplete: { [weak self] in
                guard let self = self else { return }
                self.uiModel.addToUser(userModel: userModel)
                self.uiModel.deleteFromTempUser(userModel: userModel)
                self.updateView()
            })
    }

    func updateUser(userModel: UserModel) {
        handleResourceFirestore(
            request: self.repository.updateUser(userId: userModel.id, isAdmin: userModel.isAdmin),
            response: self.updateUserResponse,
            errorState: self.tempErrorState,
            callbackLoading: { [weak self] isProgress in
                guard let self = self else { return }
                self.viewStateShowNativeProgress(isProgress: isProgress)
            }, callbackComplete: { [weak self] in
                guard let self = self else { return }
                self.uiModel.updateUser(userModel: userModel)
                self.updateView()
            })
    }
}

// MARK: States
internal extension UserAuthsViewModel {

    // MARK: View State
    func viewStateShowNativeProgress(isProgress: Bool) {
        viewState.value = .showNativeProgress(isProgress: isProgress)
    }

    func viewStateReloadData() {
        viewState.value = .reloadData
    }
}

// MARK: TableView
internal extension UserAuthsViewModel {

    func getNumberOfItemsInRow() -> Int {
        return uiModel.getNumberOfItemsInRow()
    }

    func getItemCellUIModel(indexPath: IndexPath) -> UserAuthsRowModel {
        return uiModel.getItemCellUIModel(indexPath: indexPath)
    }
}

// MARK: UserAuthsItemCellOutputDelegate
internal extension UserAuthsViewModel {

    func switchButtonTap(userModel: UserModel) {
        self.updateUserRole(userModel: userModel)
    }
}

enum UserAuthsViewState {
    case showNativeProgress(isProgress: Bool)
    case reloadData
}
