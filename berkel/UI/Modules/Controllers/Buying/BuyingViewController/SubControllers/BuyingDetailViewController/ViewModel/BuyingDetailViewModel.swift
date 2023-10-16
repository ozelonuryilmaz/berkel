//
//  BuyingDetailViewModel.swift
//  berkel
//
//  Created by Onur Yilmaz on 15.10.2023.
//  Copyright (c) 2023 Emlakjet IOS Development Team. All rights reserved.[EC-2021]
//

import Combine

protocol IBuyingDetailViewModel: BuyingCollectionDataSourceFactoryOutputDelegate {

    var viewState: ScreenStateSubject<BuyingDetailViewState> { get }
    var errorState: ErrorStateSubject { get }

    init(repository: IBuyingDetailRepository,
         coordinator: IBuyingDetailCoordinator,
         uiModel: IBuyingDetailUIModel)

    func updateCollectionSnapshot(currentSnapshot: BuyingCollectionSnapshot,
                                  newDatas: [BuyingCollectionModel]) -> BuyingCollectionSnapshot

    func initComponents()
}

final class BuyingDetailViewModel: BaseViewModel, IBuyingDetailViewModel {

    // MARK: Definitions
    private let repository: IBuyingDetailRepository
    private let coordinator: IBuyingDetailCoordinator
    private var uiModel: IBuyingDetailUIModel

    // MARK: Private Props

    // MARK: Public Props
    var viewState = ScreenStateSubject<BuyingDetailViewState>(nil)
    var errorState = ErrorStateSubject(nil)
    let responsePayment = CurrentValueSubject<[NewBuyingPaymentModel]?, Never>(nil)
    let responseCollection = CurrentValueSubject<[BuyingCollectionModel]?, Never>(nil)

    // MARK: Initiliazer
    required init(repository: IBuyingDetailRepository,
                  coordinator: IBuyingDetailCoordinator,
                  uiModel: IBuyingDetailUIModel) {
        self.repository = repository
        self.coordinator = coordinator
        self.uiModel = uiModel
    }

    func initComponents() {
        self.viewStateSetNavigationTitle()
        getBuyingCollection(completion: { [weak self] in
            guard let self = self else { return }
            self.getBuyingPayment()
        })
    }

    func updateCollectionSnapshot(currentSnapshot: BuyingCollectionSnapshot,
                                  newDatas: [BuyingCollectionModel]) -> BuyingCollectionSnapshot {
        self.uiModel.updateCollectionSnapshot(currentSnapshot: currentSnapshot, newDatas: newDatas)
    }
}


// MARK: Service
internal extension BuyingDetailViewModel {

    private func getBuyingCollection(completion: @escaping () -> Void) {
        handleResourceFirestore(
            request: self.repository.getCollection(season: self.uiModel.season,
                                                   buyingId: self.uiModel.buyingId),
            response: self.responseCollection,
            errorState: self.errorState,
            callbackLoading: { [weak self] isProgress in
                guard let self = self else { return }
                self.viewStateShowNativeProgress(isProgress: isProgress)
            }, callbackSuccess: { [weak self] in
                guard let self = self,
                    let data = self.responseCollection.value else { return }
                self.uiModel.setCollectionResponse(data: data)
                self.viewStateBuildCollectionSnapshot()
            }, callbackComplete: {
                completion()
            })
    }

    private func getBuyingPayment() {
        handleResourceFirestore(
            request: self.repository.getPayment(season: self.uiModel.season,
                                                buyingId: self.uiModel.buyingId),
            response: self.responsePayment,
            errorState: self.errorState,
            callbackLoading: { [weak self] isProgress in
                guard let self = self else { return }
                self.viewStateShowNativeProgress(isProgress: isProgress)
            }, callbackSuccess: { [weak self] in
                guard let self = self,
                    let data = self.responsePayment.value else { return }
                self.uiModel.setPaymentResponse(data: data)
                self.viewStateOldDoubt()
                self.viewStateNowDoubt()
            })
    }
}

// MARK: States
internal extension BuyingDetailViewModel {

    // MARK: View State
    func viewStateShowNativeProgress(isProgress: Bool) {
        viewState.value = .showNativeProgress(isProgress: isProgress)
    }

    func viewStateSetNavigationTitle() {
        self.viewState.value = .setNavigationTitle(title: self.uiModel.sellerName,
                                                   subTitle: self.uiModel.productName)
    }

    func viewStateOldDoubt() {
        self.viewState.value = .oldDoubt(text: self.uiModel.oldDoubt)
    }

    func viewStateNowDoubt() {
        self.viewState.value = .nowDoubt(text: self.uiModel.nowDoubt)
    }

    func viewStateBuildCollectionSnapshot() {
        viewState.value = .buildCollectionSnapshot(snapshot: self.uiModel.buildCollectionSnapshot())
    }

    func viewStateUpdateCollectionSnapshot(data: [BuyingCollectionModel]) {
        viewState.value = .updateCollectionSnapshot(data: data)
    }
}

// MARK: Coordinate
internal extension BuyingDetailViewModel {

}

// MARK: BuyingCollectionDataSourceFactoryOutputDelegate
internal extension BuyingDetailViewModel {

    func cellTapped(uiModel: IBuyingCollectionTableViewCellUIModel) {

    }

    func warehouseTapped(id: String?) {

    }

    func calcActivateTapped(id: String?) {

    }
    
    func scrollDidScroll(isAvailablePagination: Bool) {
        
    }
}

enum BuyingDetailViewState {
    case showNativeProgress(isProgress: Bool)
    case setNavigationTitle(title: String, subTitle: String)
    case oldDoubt(text: String)
    case nowDoubt(text: String)
    case buildCollectionSnapshot(snapshot: BuyingCollectionSnapshot)
    case updateCollectionSnapshot(data: [BuyingCollectionModel])
}

