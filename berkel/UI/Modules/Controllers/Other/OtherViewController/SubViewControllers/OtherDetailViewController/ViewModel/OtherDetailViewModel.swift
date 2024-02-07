//
//  OtherDetailViewModel.swift
//  berkel
//
//  Created by Onur Yilmaz on 30.01.2024.
//

import Foundation
import Combine

protocol IOtherDetailViewModel: OtherDetailCollectionDataSourceFactoryOutputDelegate {

    var viewState: ScreenStateSubject<OtherDetailViewState> { get }
    var errorState: ErrorStateSubject { get }

    init(repository: IOtherDetailRepository,
         coordinator: IOtherDetailCoordinator,
         uiModel: IOtherDetailUIModel)
    
    var otherId: String { get }

    func initComponents()

    // Coordinate
    func presentNewSellerImageViewController(imagePathType: ImagePathType)

    // View State
    func viewStateSetNavigationTitle()

    // Service
    func updateCalcForCollection(collectionId: String, isCalc: Bool)
    func updateSellerActive(completion: @escaping () -> Void)
    func deletePayment(uiModel: OtherPaymentModel)

    // for Table View
    func getNumberOfItemsInSection() -> Int
    func getCellUIModel(at index: Int) -> OtherDetailPaymentTableViewCellUIModel
}

final class OtherDetailViewModel: BaseViewModel, IOtherDetailViewModel {

    // MARK: Definitions
    private let repository: IOtherDetailRepository
    private let coordinator: IOtherDetailCoordinator
    private var uiModel: IOtherDetailUIModel

    // MARK: Public Props
    var viewState = ScreenStateSubject<OtherDetailViewState>(nil)
    var errorState = ErrorStateSubject(nil)
    let responsePayment = CurrentValueSubject<[OtherPaymentModel]?, Never>(nil)
    let responseCollection = CurrentValueSubject<[OtherCollectionModel]?, Never>(nil)
    let responseUpdateCalc = CurrentValueSubject<Bool?, Never>(nil)
    let responseUpdateActive = CurrentValueSubject<Bool?, Never>(nil)
    let responseDeletePayment = CurrentValueSubject<Bool?, Never>(nil)

    var otherId: String {
        return self.uiModel.otherId
    }

    // MARK: Initiliazer
    required init(repository: IOtherDetailRepository,
                  coordinator: IOtherDetailCoordinator,
                  uiModel: IOtherDetailUIModel) {
        self.repository = repository
        self.coordinator = coordinator
        self.uiModel = uiModel
    }

    func initComponents() {
        if self.uiModel.isActive {
            self.viewStateShowOtherActiveButton()
        }

        getSellerCollection(completion: { [weak self] in
            guard let self = self else { return }
            DispatchQueue.delay(100) { [weak self] in
                guard let self = self else { return }
                self.getSellerPayment()
            }
        })
    }

    func reloadPage() {
        self.viewStateSetNavigationTitle()
        DispatchQueue.delay(250) { [weak self] in
            guard let self = self else { return }
            self.viewStateBuildCollectionSnapshot()
            self.viewStateOldDoubt()
            self.viewStateNowDoubt()
        }
    }
}


// MARK: Service
internal extension OtherDetailViewModel {

    private func getSellerCollection(completion: @escaping () -> Void) {

        handleResourceFirestore(
            request: self.repository.getCollection(season: self.uiModel.season,
                                                   otherId: self.uiModel.otherId),
            response: self.responseCollection,
            errorState: self.errorState,
            callbackLoading: { [weak self] isProgress in
                guard let self = self else { return }
                self.viewStateShowNativeProgress(isProgress: isProgress)
            }, callbackSuccess: { [weak self] in
                guard let self = self,
                    let data = self.responseCollection.value else { return }
                self.uiModel.setCollectionResponse(data: data)
            }, callbackComplete: {
                completion()
            })
    }

    private func getSellerPayment() {
        handleResourceFirestore(
            request: self.repository.getPayment(season: self.uiModel.season,
                                                otherId: self.uiModel.otherId),
            response: self.responsePayment,
            errorState: self.errorState,
            callbackLoading: { [weak self] isProgress in
                guard let self = self else { return }
                self.viewStateShowNativeProgress(isProgress: isProgress)
            }, callbackSuccess: { [weak self] in
                guard let self = self,
                    let data = self.responsePayment.value else { return }
                self.uiModel.setPaymentResponse(data: data)
                self.viewStateReloadPaymentTableView()
            }, callbackComplete: { [weak self] in
                guard let self = self else { return }
                self.reloadPage()
            })
    }

    func updateCalcForCollection(collectionId: String, isCalc: Bool) {
        handleResourceFirestore(
            request: self.repository.updateCollectionCalc(season: self.uiModel.season,
                                                          otherId: self.uiModel.otherId,
                                                          collectionId: collectionId,
                                                          isCalc: isCalc),
            response: self.responseUpdateCalc,
            errorState: self.errorState,
            callbackLoading: { [weak self] isProgress in
                guard let self = self else { return }
                self.viewStateShowNativeProgress(isProgress: isProgress)
            }, callbackSuccess: { [weak self] in
                guard let self = self else { return }
                self.uiModel.updateCalcForCollection(collectionId: collectionId, isCalc: isCalc)
                self.reloadPage()
            })
    }

    func updateSellerActive(completion: @escaping () -> Void) {
        handleResourceFirestore(
            request: self.repository.updateBuyingActive(season: self.uiModel.season,
                                                        otherId: self.uiModel.otherId,
                                                        isActive: false),
            response: self.responseUpdateActive,
            errorState: self.errorState,
            callbackLoading: { [weak self] isProgress in
                guard let self = self else { return }
                self.viewStateShowNativeProgress(isProgress: isProgress)
            }, callbackSuccess: { [weak self] in
                guard let self = self else { return }
                self.uiModel.setActive(isActive: false)
                self.viewStateCloseButtonTapped()

                completion()
                self.reloadPage()
            })
    }

    func deletePayment(uiModel: OtherPaymentModel) {
        guard let paymentId = uiModel.id else { return }

        handleResourceFirestore(
            request: self.repository.deletePayment(season: self.uiModel.season,
                                                   otherId: self.uiModel.otherId,
                                                   paymentId: paymentId),
            response: self.responseDeletePayment,
            errorState: self.errorState,
            callbackLoading: { [weak self] isProgress in
                guard let self = self else { return }
                self.viewStateShowNativeProgress(isProgress: isProgress)
            }, callbackSuccess: { [weak self] in
                guard let self = self else { return }
                self.getSellerPayment()
            })
    }
}

// MARK: States
internal extension OtherDetailViewModel {

    // MARK: View State
    func viewStateShowNativeProgress(isProgress: Bool) {
        viewState.value = .showNativeProgress(isProgress: isProgress)
    }

    func viewStateSetNavigationTitle() {
        self.viewState.value = .setNavigationTitle(title: self.uiModel.otherSellerName,
                                                   subTitle: self.uiModel.categoryName)
    }

    func viewStateOldDoubt() {
        self.viewState.value = .oldDoubt(text: self.uiModel.oldDoubt())
    }

    func viewStateNowDoubt() {
        self.viewState.value = .nowDoubt(text: self.uiModel.nowDoubt())
    }

    func viewStateBuildCollectionSnapshot() {
        viewState.value = .buildCollectionSnapshot(snapshot: self.uiModel.buildCollectionSnapshot())
    }

    func viewStateUpdateCollectionSnapshot(data: [OtherCollectionModel]) {
        viewState.value = .updateCollectionSnapshot(data: data)
    }

    func viewStateReloadPaymentTableView() {
        viewState.value = .reloadPaymentTableView
    }

    func viewStateShowUpdateCalcAlertMessage(collectionId: String, date: String, isCalc: Bool) {
        viewState.value = .showUpdateCalcAlertMessage(collectionId: collectionId, date: date, isCalc: isCalc)
    }

    func viewStateShowOtherActiveButton() {
        viewState.value = .showOtherActiveButton
    }

    func viewStateCloseButtonTapped() {
        viewState.value = .closeButtonTapped
    }
}

// MARK: Coordinate
internal extension OtherDetailViewModel {

    func presentOtherCollectionViewController(passData: OtherCollectionPassData) {
        self.coordinator.presentOtherCollectionViewController(passData: passData)
    }

    func presentNewSellerImageViewController(imagePathType: ImagePathType) {
        let data = NewSellerImagePassData(imagePageType: .other(otherSellerId: self.uiModel.otherSellerId,
                                                                otherId: self.uiModel.otherId,
                                                                otherSellerProductName: self.uiModel.categoryName),
                                          imagePathType: imagePathType)

        self.coordinator.presentNewSellerImageViewController(passData: data)
    }
}

// MARK: TableView
internal extension OtherDetailViewModel {

    func getNumberOfItemsInSection() -> Int {
        return self.uiModel.getNumberOfItemsInSection()
    }

    func getCellUIModel(at index: Int) -> OtherDetailPaymentTableViewCellUIModel {
        return self.uiModel.getCellUIModel(at: index)
    }
}

// MARK: OtherDetailCollectionDataSourceFactoryOutputDelegate
internal extension OtherDetailViewModel {

    func cellTapped(uiModel: IOtherDetailCollectionTableViewCellUIModel) {
        guard let otherModel = uiModel.otherModel else { return }
        self.presentOtherCollectionViewController(passData:
            OtherCollectionPassData(otherModel: otherModel,
                                    otherCollectionModel: uiModel.otherCollectionModel)
        )
    }

    func calcActivateTapped(id: String, date: String, isCalc: Bool) {
        self.viewStateShowUpdateCalcAlertMessage(collectionId: id, date: date, isCalc: isCalc)
    }
}

enum OtherDetailViewState {
    case showNativeProgress(isProgress: Bool)
    case setNavigationTitle(title: String, subTitle: String)
    case oldDoubt(text: String)
    case nowDoubt(text: String)
    case buildCollectionSnapshot(snapshot: OtherDetailCollectionSnapshot)
    case updateCollectionSnapshot(data: [OtherCollectionModel])
    case reloadPaymentTableView
    case showUpdateCalcAlertMessage(collectionId: String, date: String, isCalc: Bool)
    case showOtherActiveButton
    case closeButtonTapped
}
