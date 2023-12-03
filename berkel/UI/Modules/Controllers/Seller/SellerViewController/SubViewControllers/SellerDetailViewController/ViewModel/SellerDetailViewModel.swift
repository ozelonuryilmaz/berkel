//
//  SellerDetailViewModel.swift
//  berkel
//
//  Created by Onur Yilmaz on 24.11.2023.
//

import Combine
import Foundation

protocol ISellerDetailViewModel: SellerDetailCollectionDataSourceFactoryOutputDelegate {

    var viewState: ScreenStateSubject<SellerDetailViewState> { get }
    var errorState: ErrorStateSubject { get }

    init(repository: ISellerDetailRepository,
         coordinator: ISellerDetailCoordinator,
         uiModel: ISellerDetailUIModel)
    
    var sellerId: String { get }

    func initComponents()

    // View State
    func viewStateSetNavigationTitle()

    // Service
    func updateCalcForCollection(collectionId: String, isCalc: Bool)
    func updateSellerActive(completion: @escaping () -> Void)

    // for Table View
    func getNumberOfItemsInSection() -> Int
    func getCellUIModel(at index: Int) -> SellerDetailPaymentTableViewCellUIModel
}

final class SellerDetailViewModel: BaseViewModel, ISellerDetailViewModel {

    // MARK: Definitions
    private let repository: ISellerDetailRepository
    private let coordinator: ISellerDetailCoordinator
    private var uiModel: ISellerDetailUIModel

    // MARK: Public Props
    var viewState = ScreenStateSubject<SellerDetailViewState>(nil)
    var errorState = ErrorStateSubject(nil)
    let responsePayment = CurrentValueSubject<[SellerPaymentModel]?, Never>(nil)
    let responseCollection = CurrentValueSubject<[SellerCollectionModel]?, Never>(nil)
    let responseUpdateCalc = CurrentValueSubject<Bool?, Never>(nil)
    let responseUpdateActive = CurrentValueSubject<Bool?, Never>(nil)
    
    var sellerId: String {
        return self.uiModel.sellerId
    }

    // MARK: Initiliazer
    required init(repository: ISellerDetailRepository,
                  coordinator: ISellerDetailCoordinator,
                  uiModel: ISellerDetailUIModel) {
        self.repository = repository
        self.coordinator = coordinator
        self.uiModel = uiModel
    }

    func initComponents() {
        if self.uiModel.isActive {
            self.viewStateShowSellerActiveButton()
        }

        getSellerCollection(completion: { [weak self] in
            guard let self = self else { return }
            self.getSellerPayment()
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
internal extension SellerDetailViewModel {

    private func getSellerCollection(completion: @escaping () -> Void) {

        handleResourceFirestore(
            request: self.repository.getCollection(season: self.uiModel.season,
                                                   sellerId: self.uiModel.sellerId),
            response: self.responseCollection,
            errorState: self.errorState,
            callbackLoading: { [weak self] isProgress in
                guard let self = self else { return }
                self.viewStateShowNativeProgress(isProgress: isProgress)
            }, callbackSuccess: { [weak self] in
                guard let self = self,
                    let data = self.responseCollection.value else { return }
                self.uiModel.setCollectionResponse(data: data)
                self.reloadPage()
            }, callbackComplete: {
                completion()
            })
    }

    private func getSellerPayment() {
        handleResourceFirestore(
            request: self.repository.getPayment(season: self.uiModel.season,
                                                sellerId: self.uiModel.sellerId),
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
            })
    }

    func updateCalcForCollection(collectionId: String, isCalc: Bool) {
        handleResourceFirestore(
            request: self.repository.updateCollectionCalc(season: self.uiModel.season,
                                                          sellerId: self.uiModel.sellerId,
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
                                                        sellerId: self.uiModel.sellerId,
                                                        isActive: false),
            response: self.responseUpdateActive,
            errorState: self.errorState,
            callbackLoading: { [weak self] isProgress in
                guard let self = self else { return }
                self.viewStateShowNativeProgress(isProgress: isProgress)
            }, callbackSuccess: { [weak self] in
                guard let self = self else { return }
                self.uiModel.setActive(isActive: false)


                // TODO: outputDelegate eklenecek
                //self.successDismissCallBack?(false)

                completion()
                self.reloadPage()
            })
    }
}

// MARK: States
internal extension SellerDetailViewModel {

    // MARK: View State
    func viewStateShowNativeProgress(isProgress: Bool) {
        viewState.value = .showNativeProgress(isProgress: isProgress)
    }

    func viewStateSetNavigationTitle() {
        self.viewState.value = .setNavigationTitle(title: self.uiModel.customerName)
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

    func viewStateUpdateCollectionSnapshot(data: [SellerCollectionModel]) {
        viewState.value = .updateCollectionSnapshot(data: data)
    }

    func viewStateReloadPaymentTableView() {
        viewState.value = .reloadPaymentTableView
    }

    func viewStateShowUpdateCalcAlertMessage(collectionId: String, date: String, isCalc: Bool) {
        viewState.value = .showUpdateCalcAlertMessage(collectionId: collectionId, date: date, isCalc: isCalc)
    }

    func viewStateShowSellerActiveButton() {
        viewState.value = .showSellerActiveButton
    }

}

// MARK: Coordinate
internal extension SellerDetailViewModel {

    func presentSellerCollectionViewController(passData: SellerCollectionPassData) {
        
    }
}

// MARK: TableView
internal extension SellerDetailViewModel {

    func getNumberOfItemsInSection() -> Int {
        return self.uiModel.getNumberOfItemsInSection()
    }

    func getCellUIModel(at index: Int) -> SellerDetailPaymentTableViewCellUIModel {
        return self.uiModel.getCellUIModel(at: index)
    }
}

// MARK: SellerDetailCollectionDataSourceFactoryOutputDelegate
internal extension SellerDetailViewModel {

    func cellTapped(uiModel: ISellerDetailCollectionTableViewCellUIModel) {
        //self.presentSellerCollectionViewController(passData: SellerCollectionPassData(sellerModel: uiModel.))
    }

    func calcActivateTapped(id: String, date: String, isCalc: Bool) {
        self.viewStateShowUpdateCalcAlertMessage(collectionId: id, date: date, isCalc: isCalc)
    }
}

enum SellerDetailViewState {
    case showNativeProgress(isProgress: Bool)
    case setNavigationTitle(title: String)
    case oldDoubt(text: String)
    case nowDoubt(text: String)
    case buildCollectionSnapshot(snapshot: SellerDetailCollectionSnapshot)
    case updateCollectionSnapshot(data: [SellerCollectionModel])
    case reloadPaymentTableView
    case showUpdateCalcAlertMessage(collectionId: String, date: String, isCalc: Bool)
    case showSellerActiveButton
}
