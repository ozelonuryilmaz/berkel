//
//  BuyingDetailViewModel.swift
//  berkel
//
//  Created by Onur Yilmaz on 15.10.2023.
//  Copyright (c) 2023 Emlakjet IOS Development Team. All rights reserved.[EC-2021]
//

import Foundation
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

    func viewStateSetNavigationTitle()
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
    let responseWarehouse = CurrentValueSubject<[WarehouseModel]?, Never>(nil)

    // MARK: Initiliazer
    required init(repository: IBuyingDetailRepository,
                  coordinator: IBuyingDetailCoordinator,
                  uiModel: IBuyingDetailUIModel) {
        self.repository = repository
        self.coordinator = coordinator
        self.uiModel = uiModel
    }

    func initComponents() {

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

                // Her Cell için ayrı ayrı depo çıktısı bilgisi toplanıyor.
                self.getWarehouses()

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

    // Depo çıkması bilgileri Toplama(collections) altında collection olarak saklanıyor
    // Her toplama(collections) için warehouses(depo çıktısı) çağırılıp UIModel'deki collection güncellenmeli
    private func getWarehouses(index: Int = 0) {
        let collections = self.uiModel.collections
        guard collections.count > index else { return }
        guard let collectionId = collections[index].id else { return }

        handleResourceFirestore(
            request: self.repository.getWarehouseList(season: self.uiModel.season,
                                                      buyingId: self.uiModel.buyingId,
                                                      collectionId: collectionId),
            response: self.responseWarehouse,
            errorState: self.errorState,
            callbackLoading: { [weak self] isProgress in
                guard let self = self else { return }
                self.viewStateShowNativeProgress(isProgress: (collections.count == index + 1) ? false : true)
            }, callbackSuccess: { [weak self] in
                guard let self = self,
                    let data = self.responseWarehouse.value else { return }
                self.uiModel.appendWarehouseInsideCollection(collectionId: collectionId, warehouses: data)

                if collections.count == index + 1 {
                    self.viewStateBuildCollectionSnapshot()
                }
            }, callbackComplete: { [weak self] in
                guard let self = self else { return }
                let limit = collections.count
                let count = index + 1
                if limit > count {
                    DispatchQueue.delay(25) {[weak self] in
                        guard let self = self else { return }
                        self.getWarehouses(index: count)
                    }
                }
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

    func presentWarehouseListViewController(uiModel: IBuyingCollectionTableViewCellUIModel) {
        let warehouses = self.uiModel.getWarehouses(collectionId: uiModel.collectionId)

        self.coordinator.presentWarehouseListViewController(
            passData: WarehouseListPassData(buyingId: uiModel.buyingId,
                                            collectionId: uiModel.collectionId,
                                            date: uiModel.date,
                                            sellerName: self.uiModel.sellerName,
                                            productName: self.uiModel.productName,
                                            warehouses: warehouses
        ), successDismissCallBack: { data in
            // TODO: yeni depo çıkması eklendiğinde cell ve üstteki toplam label'ları güncelle
            
        })
    }
}

// MARK: BuyingCollectionDataSourceFactoryOutputDelegate
internal extension BuyingDetailViewModel {

    func cellTapped(uiModel: IBuyingCollectionTableViewCellUIModel) {

    }

    func warehouseTapped(uiModel: IBuyingCollectionTableViewCellUIModel) {
        self.presentWarehouseListViewController(uiModel: uiModel)
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

