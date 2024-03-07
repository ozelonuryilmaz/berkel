//
//  WorkerViewModel.swift
//  berkel
//
//  Created by Onur Yilmaz on 2.09.2023.
//

import Combine

protocol IWorkerViewModel: NewWorkerViewControllerOutputDelegate,
                            WorkerDataSourceFactoryOutputDelegate,
                            WorkerDetailViewControllerOutputDelegate {

    var viewState: ScreenStateSubject<WorkerViewState> { get }
    var errorState: ErrorStateSubject { get }

    var season: String { get }

    init(repository: IWorkerRepository,
         coordinator: IWorkerCoordinator,
         uiModel: IWorkerUIModel)

    // Service
    func getWorker()

    // Coordinate
    func pushCavusListViewController()

    // DataSource
    func updateSnapshot(currentSnapshot: WorkerSnapshot,
                        newDatas: [WorkerModel]) -> WorkerSnapshot
}

final class WorkerViewModel: BaseViewModel, IWorkerViewModel {

    // MARK: Definitions
    private let repository: IWorkerRepository
    private let coordinator: IWorkerCoordinator
    private var uiModel: IWorkerUIModel

    var viewState = ScreenStateSubject<WorkerViewState>(nil)
    var errorState = ErrorStateSubject(nil)
    let response = CurrentValueSubject<[WorkerModel]?, Never>(nil)

    private var isLastPage: Bool = false
    private var isAvailablePagination: Bool = false

    var season: String {
        return uiModel.season
    }

    // MARK: Initiliazer
    required init(repository: IWorkerRepository,
                  coordinator: IWorkerCoordinator,
                  uiModel: IWorkerUIModel) {
        self.repository = repository
        self.coordinator = coordinator
        self.uiModel = uiModel
    }

    func updateSnapshot(currentSnapshot: WorkerSnapshot,
                        newDatas: [WorkerModel]) -> WorkerSnapshot {
        return self.uiModel.updateSnapshot(currentSnapshot: currentSnapshot, newDatas: newDatas)
    }
}


// MARK: Service
internal extension WorkerViewModel {

    func getWorker() {

        handleResourceFirestore(
            request: self.repository.getWorkerList(season: self.uiModel.season,
                                                   cursor: self.uiModel.getLastCursor(),
                                                   limit: self.uiModel.limit),
            response: self.response,
            errorState: self.errorState,
            callbackLoading: { isProgress in
                self.viewStateShowNativeProgress(isProgress: isProgress)
                self.isAvailablePagination = !isProgress
            },
            callbackSuccess: { [weak self] in
                guard let self = self else { return }
                self.uiModel.setResponse(self.response.value ?? [])

                if !self.uiModel.isHaveBuildData {
                    self.viewStateBuildSnapshot()
                } else {
                    self.viewStateUpdateSnapshot(data: self.response.value ?? [])
                }

                if true == self.response.value?.isEmpty {
                    self.isLastPage = true
                }
            }
        )
    }
}

// MARK: States
internal extension WorkerViewModel {

    // MARK: View State
    func viewStateShowNativeProgress(isProgress: Bool) {
        viewState.value = .showNativeProgress(isProgress: isProgress)
    }

    func viewStateBuildSnapshot() {
        viewState.value = .buildSnapshot(snapshot: self.uiModel.buildSnapshot())
    }

    func viewStateUpdateSnapshot(data: [WorkerModel]) {
        viewState.value = .updateSnapshot(data: data)
    }
}

// MARK: Coordinate
internal extension WorkerViewModel {

    func pushCavusListViewController() {
        self.coordinator.pushCavusListViewController(passData: CavusListPassData(),
                                                     outputDelegate: self)
    }

    func pushWorkerDetailViewController(passData: WorkerDetailPassData) {
        self.coordinator.pushWorkerDetailViewController(passData: passData,
                                                        outputDelegate: self)
    }

    func presentWorkerCollectionViewController(passData: WorkerCollectionPassData) {
        self.coordinator.presentWorkerCollectionViewController(passData: passData)
    }

    func presentWorkerPaymentViewController(passData: WorkerPaymentPassData) {
        self.coordinator.presentWorkerPaymentViewController(passData: passData)
    }
}

// MARK: NewWorkerViewControllerOutputDelegate
internal extension WorkerViewModel {

    func newWorkerData(_ data: WorkerModel) {
        self.uiModel.appendFirstItem(data: data)
        self.viewStateBuildSnapshot()
    }
}

// MARK: WorkerDataSourceFactoryOutputDelegate
extension WorkerViewModel {

    func cellTapped(uiModel: IWorkerTableViewCellUIModel) {
        let data = WorkerDetailPassData(workerId: uiModel.workerId,
                                        cavusName: uiModel.cavusName,
                                        cavusId: uiModel.cavusId,
                                        isActive: uiModel.isActive)
        self.pushWorkerDetailViewController(passData: data)
    }

    func addCollectionTapped(uiModel: IWorkerTableViewCellUIModel) {
        let passData = WorkerCollectionPassData(workerModel: uiModel.workerModel)
        self.presentWorkerCollectionViewController(passData: passData)
    }

    func addPaymentTapped(uiModel: IWorkerTableViewCellUIModel) {
        let passData = WorkerPaymentPassData(workerId: uiModel.workerId,
                                             cavusName: uiModel.cavusName,
                                             cavusId: uiModel.cavusId)
        self.presentWorkerPaymentViewController(passData: passData)
    }

    func scrollDidScroll(isAvailablePagination: Bool) {
        if self.isAvailablePagination && isAvailablePagination && !isLastPage {
            self.getWorker()
        }
    }
}

// MARK: WorkerDetailViewControllerOutputDelegate
internal extension WorkerViewModel {

    func closeButtonTapped(workerId: String, isActive: Bool) {
        self.uiModel.updateIsActive(workerId: workerId, isActive: isActive)
        self.viewStateBuildSnapshot()
    }
}

enum WorkerViewState {
    case showNativeProgress(isProgress: Bool)
    case buildSnapshot(snapshot: WorkerSnapshot)
    case updateSnapshot(data: [WorkerModel])
}
