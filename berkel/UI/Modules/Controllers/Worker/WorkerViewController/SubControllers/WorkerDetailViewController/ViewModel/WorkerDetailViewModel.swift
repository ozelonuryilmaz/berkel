//
//  WorkerDetailViewModel.swift
//  berkel
//
//  Created by Onur Yilmaz on 4.11.2023.
//

import Foundation
import Combine

protocol IWorkerDetailViewModel: WorkerDetailCollectionDataSourceFactoryOutputDelegate {

    var viewState: ScreenStateSubject<WorkerDetailViewState> { get }
    var errorState: ErrorStateSubject { get }

    init(repository: IWorkerDetailRepository,
         coordinator: IWorkerDetailCoordinator,
         uiModel: IWorkerDetailUIModel)

    var workerId: String { get }

    func initComponents()

    // View State
    func viewStateSetNavigationTitle()

    // Service
    func updateCalcForCollection(collectionId: String, isCalc: Bool)
    func updateWorkerActive(completion: @escaping () -> Void)

    // for Table View
    func getNumberOfItemsInSection() -> Int
    func getCellUIModel(at index: Int) -> WorkerDetailPaymentTableViewCellUIModel
}

final class WorkerDetailViewModel: BaseViewModel, IWorkerDetailViewModel {

    // MARK: Definitions
    private let repository: IWorkerDetailRepository
    private let coordinator: IWorkerDetailCoordinator
    private var uiModel: IWorkerDetailUIModel

    // MARK: Public Props
    var viewState = ScreenStateSubject<WorkerDetailViewState>(nil)
    var errorState = ErrorStateSubject(nil)
    let responsePayment = CurrentValueSubject<[WorkerPaymentModel]?, Never>(nil)
    let responseCollection = CurrentValueSubject<[WorkerCollectionModel]?, Never>(nil)
    let responseUpdateCalc = CurrentValueSubject<Bool?, Never>(nil)
    let responseUpdateActive = CurrentValueSubject<Bool?, Never>(nil)

    var workerId: String {
        return self.uiModel.workerId
    }

    // MARK: Initiliazer
    required init(repository: IWorkerDetailRepository,
                  coordinator: IWorkerDetailCoordinator,
                  uiModel: IWorkerDetailUIModel) {
        self.repository = repository
        self.coordinator = coordinator
        self.uiModel = uiModel
    }

    func initComponents() {
        if self.uiModel.isActive {
            self.viewStateShowWorkerActiveButton()
        }

        getWorkerCollection(completion: { [weak self] in
            guard let self = self else { return }
            self.getWorkerPayment()
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
internal extension WorkerDetailViewModel {

    private func getWorkerCollection(completion: @escaping () -> Void) {

        handleResourceFirestore(
            request: self.repository.getCollection(season: self.uiModel.season,
                                                   workerId: self.uiModel.workerId),
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

    private func getWorkerPayment() {
        handleResourceFirestore(
            request: self.repository.getPayment(season: self.uiModel.season,
                                                workerId: self.uiModel.workerId),
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
                                                          workerId: self.uiModel.workerId,
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

    func updateWorkerActive(completion: @escaping () -> Void) {
        handleResourceFirestore(
            request: self.repository.updateBuyingActive(season: self.uiModel.season,
                                                        workerId: self.uiModel.workerId,
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
internal extension WorkerDetailViewModel {

    // MARK: View State
    func viewStateShowNativeProgress(isProgress: Bool) {
        viewState.value = .showNativeProgress(isProgress: isProgress)
    }

    func viewStateSetNavigationTitle() {
        self.viewState.value = .setNavigationTitle(title: self.uiModel.cavusName)
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

    func viewStateUpdateCollectionSnapshot(data: [WorkerCollectionModel]) {
        viewState.value = .updateCollectionSnapshot(data: data)
    }

    func viewStateReloadPaymentTableView() {
        viewState.value = .reloadPaymentTableView
    }

    func viewStateShowUpdateCalcAlertMessage(collectionId: String, date: String, isCalc: Bool) {
        viewState.value = .showUpdateCalcAlertMessage(collectionId: collectionId, date: date, isCalc: isCalc)
    }

    func viewStateShowWorkerActiveButton() {
        viewState.value = .showWorkerActiveButton
    }
}

// MARK: Coordinate
internal extension WorkerDetailViewModel {

    func presentWorkerCollectionViewController(passData: WorkerCollectionPassData) {
        self.coordinator.presentWorkerCollectionViewController(passData: passData)
    }
}

// MARK: TableView
internal extension WorkerDetailViewModel {

    func getNumberOfItemsInSection() -> Int {
        return self.uiModel.getNumberOfItemsInSection()
    }

    func getCellUIModel(at index: Int) -> WorkerDetailPaymentTableViewCellUIModel {
        return self.uiModel.getCellUIModel(at: index)
    }
}

// MARK: WorkerDetailCollectionDataSourceFactoryOutputDelegate
internal extension WorkerDetailViewModel {

    func cellTapped(uiModel: IWorkerDetailCollectionTableViewCellUIModel) {
        self.presentWorkerCollectionViewController(passData: WorkerCollectionPassData(viewedData: false,
                                                                                      kesiciCount: uiModel.kesiciCount,
                                                                                      ayakciCount: uiModel.ayakciCount,
                                                                                      otherPrice: uiModel.otherPrice,
                                                                                      workerModel: uiModel.workerModel))
    }

    func calcActivateTapped(id: String, date: String, isCalc: Bool) {
        self.viewStateShowUpdateCalcAlertMessage(collectionId: id, date: date, isCalc: isCalc)
    }
}

enum WorkerDetailViewState {
    case showNativeProgress(isProgress: Bool)
    case setNavigationTitle(title: String)
    case oldDoubt(text: String)
    case nowDoubt(text: String)
    case buildCollectionSnapshot(snapshot: WorkerDetailCollectionSnapshot)
    case updateCollectionSnapshot(data: [WorkerCollectionModel])
    case reloadPaymentTableView
    case showUpdateCalcAlertMessage(collectionId: String, date: String, isCalc: Bool)
    case showWorkerActiveButton
}
