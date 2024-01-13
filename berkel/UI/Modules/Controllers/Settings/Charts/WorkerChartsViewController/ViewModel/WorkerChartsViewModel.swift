//
//  WorkerChartsViewModel.swift
//  berkel
//
//  Created by Onur Yilmaz on 8.01.2024.
//

import Foundation
import Combine

protocol IWorkerChartsViewModel: WorkerDetailCollectionDataSourceFactoryOutputDelegate {

    var viewState: ScreenStateSubject<WorkerChartsViewState> { get }
    var errorState: ErrorStateSubject { get }

    var season: String { get }

    init(repository: IWorkerChartsRepository,
         coordinator: IWorkerChartsCoordinator,
         uiModel: IWorkerChartsUIModel)

    // Service
    func getList()
}

final class WorkerChartsViewModel: BaseViewModel, IWorkerChartsViewModel {

    // MARK: Definitions
    private let repository: IWorkerChartsRepository
    private let coordinator: IWorkerChartsCoordinator
    private var uiModel: IWorkerChartsUIModel

    // MARK: Public Props
    var viewState = ScreenStateSubject<WorkerChartsViewState>(nil)
    var errorState = ErrorStateSubject(nil)
    let responseList = CurrentValueSubject<[WorkerModel]?, Never>(nil)
    let responsePayment = CurrentValueSubject<[WorkerPaymentModel]?, Never>(nil)
    let responseCollection = CurrentValueSubject<[WorkerCollectionModel]?, Never>(nil)

    var season: String {
        return uiModel.season
    }

    // MARK: Initiliazer
    required init(repository: IWorkerChartsRepository,
                  coordinator: IWorkerChartsCoordinator,
                  uiModel: IWorkerChartsUIModel) {
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
internal extension WorkerChartsViewModel {

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
        let workerResponse = self.uiModel.workerResponse
        guard workerResponse.count > index else { return }

        handleResourceFirestore(
            request: self.repository.getCollection(season: self.uiModel.season,
                                                   workerId: workerResponse[index].id ?? "-1"),
            response: self.responseCollection,
            errorState: self.errorState,
            callbackSuccess: { [weak self] in
                guard let self = self,
                    let data = self.responseCollection.value else { return }
                self.uiModel.setCollectionResponse(data)
            }, callbackComplete: { [weak self] in
                guard let self = self else { return }
                if workerResponse.count <= (index + 1) {
                    self.getSellerPayment()
                } else {
                    DispatchQueue.delay(30) { [weak self] in
                        self?.getSellerCollection(index: index + 1)
                    }
                }
            })
    }

    private func getSellerPayment(index: Int = 0) {
        let workerResponse = self.uiModel.workerResponse
        guard workerResponse.count > index else { return }

        handleResourceFirestore(
            request: self.repository.getPayment(season: self.uiModel.season,
                                                workerId: workerResponse[index].id ?? "-1"),
            response: self.responsePayment,
            errorState: self.errorState,
            callbackSuccess: { [weak self] in
                guard let self = self,
                    let data = self.responsePayment.value else { return }
                self.uiModel.setPaymentResponse(data)
            }, callbackComplete: { [weak self] in
                guard let self = self else { return }
                if workerResponse.count <= (index + 1) {
                    self.updateView()
                } else {
                    DispatchQueue.delay(30) { [weak self] in
                        self?.getSellerPayment(index: index + 1)
                    }
                }
            })
    }
}

// MARK: States
internal extension WorkerChartsViewModel {

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
internal extension WorkerChartsViewModel {

}

// MARK: WorkerDetailCollectionDataSourceFactoryOutputDelegate
internal extension WorkerChartsViewModel {
    func cellTapped(uiModel: IWorkerDetailCollectionTableViewCellUIModel) { }
    func calcActivateTapped(id: String, date: String, isCalc: Bool) { }
}

enum WorkerChartsViewState {
    case showNativeProgress(isProgress: Bool)
    case oldDoubt(text: String)
    case nowDoubt(text: String)
    case buildCollectionSnapshot(snapshot: WorkerDetailCollectionSnapshot)
}
