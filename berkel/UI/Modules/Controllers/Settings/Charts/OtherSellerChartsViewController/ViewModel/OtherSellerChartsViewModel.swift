//
//  OtherSellerChartsViewModel.swift
//  berkel
//
//  Created by Onur Yilmaz on 7.02.2024.
//

import Foundation
import Combine

protocol IOtherSellerChartsViewModel: OtherDetailCollectionDataSourceFactoryOutputDelegate {

    var viewState: ScreenStateSubject<OtherSellerChartsViewState> { get }
    var errorState: ErrorStateSubject { get }
    
    var season: String { get }

    init(repository: IOtherSellerChartsRepository,
         coordinator: IOtherSellerChartsCoordinator,
         uiModel: IOtherSellerChartsUIModel)
    
    // Service
    func getList()
}

final class OtherSellerChartsViewModel: BaseViewModel, IOtherSellerChartsViewModel {

    // MARK: Definitions
    private let repository: IOtherSellerChartsRepository
    private let coordinator: IOtherSellerChartsCoordinator
    private var uiModel: IOtherSellerChartsUIModel

    // MARK: Public Props
    var viewState = ScreenStateSubject<OtherSellerChartsViewState>(nil)
    var errorState = ErrorStateSubject(nil)
    let responseList = CurrentValueSubject<[OtherModel]?, Never>(nil)
    let responsePayment = CurrentValueSubject<[OtherPaymentModel]?, Never>(nil)
    let responseCollection = CurrentValueSubject<[OtherCollectionModel]?, Never>(nil)

    var season: String {
        return uiModel.season
    }

    // MARK: Initiliazer
    required init(repository: IOtherSellerChartsRepository,
                  coordinator: IOtherSellerChartsCoordinator,
                  uiModel: IOtherSellerChartsUIModel) {
        self.repository = repository
        self.coordinator = coordinator
        self.uiModel = uiModel
    }

    func updateView() {
        DispatchQueue.delay(250) { [weak self] in
            guard let self = self else { return }
            self.viewStateOldDoubt()
            self.viewStateNowDoubt()
            self.viewStateBuildCollectionSnapshot()
        }

        DispatchQueue.delay(300) { [weak self] in
            self?.viewStateShowNativeProgress(isProgress: false)
        }
    }
}


// MARK: Service
internal extension OtherSellerChartsViewModel {

    func getList() {
        viewStateShowNativeProgress(isProgress: true)

        handleResourceFirestore(
            request: self.repository.getList(season: self.uiModel.season),
            response: self.responseList,
            errorState: self.errorState,
            callbackSuccess: { [weak self] in
                guard let self = self else { return }
                self.uiModel.setResponseList(self.responseList.value ?? [])
                self.getSellerCollection()
            },
            callbackComplete: { [weak self] in
                guard let self = self else { return }
                if true == self.responseList.value?.isEmpty {
                    self.viewStateShowNativeProgress(isProgress: false)
                }
            })
    }

    private func getSellerCollection(index: Int = 0) {
        let sellerResponse = self.uiModel.sellerResponse
        guard sellerResponse.count > index else { return }

        handleResourceFirestore(
            request: self.repository.getCollection(season: self.uiModel.season,
                                                   otherId: sellerResponse[index].id ?? "-1"),
            response: self.responseCollection,
            errorState: self.errorState,
            callbackSuccess: { [weak self] in
                guard let self = self,
                    let data = self.responseCollection.value else { return }
                self.uiModel.setCollectionResponse(data)
            }, callbackComplete: { [weak self] in
                guard let self = self else { return }
                if sellerResponse.count <= (index + 1) {
                    self.getSellerPayment()
                } else {
                    DispatchQueue.delay(10) { [weak self] in
                        self?.getSellerCollection(index: index + 1)
                    }
                }
            })
    }

    private func getSellerPayment(index: Int = 0) {
        let sellerResponse = self.uiModel.sellerResponse
        guard sellerResponse.count > index else { return }

        handleResourceFirestore(
            request: self.repository.getPayment(season: self.uiModel.season,
                                                otherId: sellerResponse[index].id ?? "-1"),
            response: self.responsePayment,
            errorState: self.errorState,
            callbackSuccess: { [weak self] in
                guard let self = self,
                    let data = self.responsePayment.value else { return }
                self.uiModel.setPaymentResponse(data)
            }, callbackComplete: { [weak self] in
                guard let self = self else { return }
                if sellerResponse.count <= (index + 1) {
                    self.updateView()
                } else {
                    DispatchQueue.delay(10) { [weak self] in
                        self?.getSellerPayment(index: index + 1)
                    }
                }
            })
    }
}

// MARK: States
internal extension OtherSellerChartsViewModel {

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
internal extension OtherSellerChartsViewModel {

}

// MARK: OtherDetailCollectionDataSourceFactoryOutputDelegate
internal extension OtherSellerChartsViewModel {

    func cellTapped(uiModel: IOtherDetailCollectionTableViewCellUIModel) { }
    func calcActivateTapped(id: String, date: String, isCalc: Bool) { }
}

enum OtherSellerChartsViewState {
    case showNativeProgress(isProgress: Bool)
    case oldDoubt(text: String)
    case nowDoubt(text: String)
    case buildCollectionSnapshot(snapshot: OtherDetailCollectionSnapshot)
}
