//
//  BuyingChartsViewModel.swift
//  berkel
//
//  Created by Onur Yilmaz on 9.01.2024.
//

import Foundation
import Combine

protocol IBuyingChartsViewModel: BuyingCollectionDataSourceFactoryOutputDelegate {

    var viewState: ScreenStateSubject<BuyingChartsViewState> { get }
    var errorState: ErrorStateSubject { get }

    var season: String { get }

    init(repository: IBuyingChartsRepository,
         coordinator: IBuyingChartsCoordinator,
         uiModel: IBuyingChartsUIModel)

    // Service
    func getList()
}

final class BuyingChartsViewModel: BaseViewModel, IBuyingChartsViewModel {

    // MARK: Definitions
    private let repository: IBuyingChartsRepository
    private let coordinator: IBuyingChartsCoordinator
    private var uiModel: IBuyingChartsUIModel

    // MARK: Public Props
    var viewState = ScreenStateSubject<BuyingChartsViewState>(nil)
    var errorState = ErrorStateSubject(nil)
    let responseList = CurrentValueSubject<[NewBuyingModel]?, Never>(nil)
    let responsePayment = CurrentValueSubject<[NewBuyingPaymentModel]?, Never>(nil)
    let responseCollection = CurrentValueSubject<[BuyingCollectionModel]?, Never>(nil)
    let responseWarehouse = CurrentValueSubject<[WarehouseModel]?, Never>(nil)

    var season: String {
        return uiModel.season
    }

    // MARK: Initiliazer
    required init(repository: IBuyingChartsRepository,
                  coordinator: IBuyingChartsCoordinator,
                  uiModel: IBuyingChartsUIModel) {
        self.repository = repository
        self.coordinator = coordinator
        self.uiModel = uiModel
    }

    func updateView() {
        DispatchQueue.delay(300) { [weak self] in
            guard let self = self else { return }
            self.viewStateOldDoubt()
            self.viewStateNowDoubt()
            self.viewStateBuildCollectionSnapshot()
        }

        DispatchQueue.delay(350) { [weak self] in
            self?.viewStateShowNativeProgress(isProgress: false)
        }
    }
}


// MARK: Service
internal extension BuyingChartsViewModel {

    func getList() {
        viewStateShowNativeProgress(isProgress: true)

        handleResourceFirestore(
            request: self.repository.getList(season: self.uiModel.season),
            response: self.responseList,
            errorState: self.errorState,
            callbackSuccess: { [weak self] in
                guard let self = self else { return }
                self.uiModel.setResponseList(self.responseList.value ?? [])
                self.getBuyingCollection()
            },
            callbackComplete: { [weak self] in
                guard let self = self else { return }
                if true == self.responseList.value?.isEmpty {
                    self.viewStateShowNativeProgress(isProgress: false)
                }
            })
    }

    private func getBuyingCollection(index: Int = 0) {
        let buyingResponse = self.uiModel.buyingResponse
        guard buyingResponse.count > index,
            let buyingId: String = buyingResponse[index].id else { return }

        handleResourceFirestore(
            request: self.repository.getCollection(season: self.uiModel.season,
                                                   buyingId: buyingId),
            response: self.responseCollection,
            errorState: self.errorState,
            callbackSuccess: { [weak self] in
                guard let self = self,
                    let data = self.responseCollection.value else { return }
                self.uiModel.setCollectionResponse(data)
            }, callbackComplete: { [weak self] in
                guard let self = self else { return }
                if buyingResponse.count <= (index + 1) {
                    self.getBuyingPayment()
                } else {
                    DispatchQueue.delay(30) { [weak self] in
                        self?.getBuyingCollection(index: index + 1)
                    }
                }
            })
    }

    private func getBuyingPayment(index: Int = 0) {
        let buyingResponse = self.uiModel.buyingResponse
        guard buyingResponse.count > index else { return }

        handleResourceFirestore(
            request: self.repository.getPayment(season: self.uiModel.season,
                                                buyingId: buyingResponse[index].id ?? "-1"),
            response: self.responsePayment,
            errorState: self.errorState,
            callbackSuccess: { [weak self] in
                guard let self = self,
                    let data = self.responsePayment.value else { return }
                self.uiModel.setPaymentResponse(data)
            }, callbackComplete: { [weak self] in
                guard let self = self else { return }
                if buyingResponse.count <= (index + 1) {
                    self.getWarehouses()
                } else {
                    DispatchQueue.delay(30) { [weak self] in
                        self?.getBuyingPayment(index: index + 1)
                    }
                }
            })
    }

    // Depo çıkması bilgileri Toplama(collections) altında collection olarak saklanıyor
    // Her toplama(collections) için warehouses(depo çıktısı) çağırılıp UIModel'deki collection güncellenmeli
    private func getWarehouses(index: Int = 0) {
        let collections = self.uiModel.buyingCollectionResponse
        guard collections.count > index else { return }
        guard let collectionId = collections[index].id,
            let buyingId = collections[index].buyingId else { return }

        handleResourceFirestore(
            request: self.repository.getWarehouseList(season: self.uiModel.season,
                                                      buyingId: buyingId,
                                                      collectionId: collectionId),
            response: self.responseWarehouse,
            errorState: self.errorState,
            callbackSuccess: { [weak self] in
                guard let self = self,
                    let data = self.responseWarehouse.value else { return }
                self.uiModel.appendWarehouseInsideCollection(collectionId: collectionId, warehouses: data)
    
            }, callbackComplete: { [weak self] in
                guard let self = self else { return }
                if collections.count <= (index + 1) {
                    // En son depo çıkmaları set edildikten sonra sonuçları güncelle
                    self.updateView()
                } else {
                    DispatchQueue.delay(30) { [weak self] in
                        self?.getWarehouses(index: index + 1)
                    }
                }
            })
    }
}

// MARK: States
internal extension BuyingChartsViewModel {

    // MARK: View State
    func viewStateShowNativeProgress(isProgress: Bool) {
        viewState.value = .showNativeProgress(isProgress: isProgress)
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
}

// MARK: Coordinate
internal extension BuyingChartsViewModel {

}

// MARK: BuyingCollectionDataSourceFactoryOutputDelegate
internal extension BuyingChartsViewModel {

    func cellTapped(uiModel: IBuyingCollectionTableViewCellUIModel) { }
    func warehouseTapped(uiModel: IBuyingCollectionTableViewCellUIModel) { }
    func calcActivateTapped(id: String, date: String, isCalc: Bool) { }
    func scrollDidScroll(isAvailablePagination: Bool) { }
}

enum BuyingChartsViewState {
    case showNativeProgress(isProgress: Bool)
    case oldDoubt(text: String)
    case nowDoubt(text: String)
    case buildCollectionSnapshot(snapshot: BuyingCollectionSnapshot)
}
