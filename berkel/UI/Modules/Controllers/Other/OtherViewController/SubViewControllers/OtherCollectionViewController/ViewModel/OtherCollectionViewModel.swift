//
//  OtherCollectionViewModel.swift
//  berkel
//
//  Created by Onur Yilmaz on 28.01.2024.
//

import Combine

protocol IOtherCollectionViewModel: AnyObject {

    var viewState: ScreenStateSubject<OtherCollectionViewState> { get }
    var errorState: ErrorStateSubject { get }

    init(repository: IOtherCollectionRepository,
         coordinator: IOtherCollectionCoordinator,
         uiModel: IOtherCollectionUIModel)

    func initComponents()

    // Coordiante
    func dismiss()

    // Setter
    func setDate(date: String?)
    func setPrice(_ text: String)
    func setDesc(_ text: String)

    // Service
    func saveCollection()
}

final class OtherCollectionViewModel: BaseViewModel, IOtherCollectionViewModel {

    // MARK: Definitions
    private let repository: IOtherCollectionRepository
    private let coordinator: IOtherCollectionCoordinator
    private var uiModel: IOtherCollectionUIModel

    // MARK: Public Props
    var viewState = ScreenStateSubject<OtherCollectionViewState>(nil)
    var errorState = ErrorStateSubject(nil)
    let response = CurrentValueSubject<OtherCollectionModel?, Never>(nil)

    // MARK: Initiliazer
    required init(repository: IOtherCollectionRepository,
                  coordinator: IOtherCollectionCoordinator,
                  uiModel: IOtherCollectionUIModel) {
        self.repository = repository
        self.coordinator = coordinator
        self.uiModel = uiModel
    }

    func initComponents() {
        self.viewStateSetOtherSellerName()
        self.viewStateSetCategoryName()

        self.viewStateViewedData()
        self.viewStateInitCount()
    }
}


// MARK: Service
internal extension OtherCollectionViewModel {

    func saveCollection() {
        if let errorMessage = self.uiModel.errorMessage {
            errorState.value = .ERROR_MESSAGE(title: "Uyarı", msg: errorMessage)
            return
        }

        handleResourceFirestore(
            request: self.repository.saveNewCollection(season: self.uiModel.season,
                                                       otherId: self.uiModel.otherId ?? "",
                                                       data: self.uiModel.data),
            response: self.response,
            errorState: self.errorState,
            callbackLoading: { [weak self] isProgress in
                guard let self = self else { return }
                self.viewStateShowNativeProgress(isProgress: isProgress)
            }, callbackSuccess: { [weak self] in
                guard let self = self else { return }
                self.dismiss()
            })
    }
}

// MARK: States
internal extension OtherCollectionViewModel {

    // MARK: View State
    func viewStateShowNativeProgress(isProgress: Bool) {
        viewState.value = .showNativeProgress(isProgress: isProgress)
    }

    func viewStateSetOtherSellerName() {
        self.viewState.value = .setOtherSellerName(name: self.uiModel.otherSellerName)
    }

    func viewStateSetCategoryName() {
        self.viewState.value = .setCategoryName(name: self.uiModel.categoryName)
    }

    func viewStateInitCount() {
        guard let data = self.uiModel.otherCollectionModel else { return }
        self.viewState.value = .initCounts(price: data.price.decimalString(),
                                           desc: data.desc)
    }

    func viewStateViewedData() {
        self.viewState.value = .viewedData(isVisible: self.uiModel.viewedData)
    }

}

// MARK: Coordinate
internal extension OtherCollectionViewModel {

    func dismiss() {
        self.coordinator.dismiss(completion: nil)
    }
}

// MARK: Setter
internal extension OtherCollectionViewModel {

    func setDate(date: String?) {
        self.uiModel.setDate(date: date)
    }

    func setPrice(_ text: String) {
        self.uiModel.setPrice(text)
    }

    func setDesc(_ text: String) {
        self.uiModel.setDesc(text)
    }
}


enum OtherCollectionViewState {
    case showNativeProgress(isProgress: Bool)
    case setOtherSellerName(name: String)
    case setCategoryName(name: String)
    case initCounts(price: String, desc: String)
    case viewedData(isVisible: Bool)
}
