//
//  WorkerCollectionViewModel.swift
//  berkel
//
//  Created by Onur Yilmaz on 4.11.2023.
//

import Combine

protocol IWorkerCollectionViewModel: AnyObject {

    var viewState: ScreenStateSubject<WorkerCollectionViewState> { get }
    var errorState: ErrorStateSubject { get }

    init(repository: IWorkerCollectionRepository,
         coordinator: IWorkerCollectionCoordinator,
         uiModel: IWorkerCollectionUIModel)

    func initComponents()
    func dismiss()

    func updateResults()

    // Setter
    func setDate(date: String?)
    func setGardenOwner(_ text: String)
    func setKesiciCount(_ text: String)
    func setAyakciCount(_ text: String)
    func setCavusPrice(_ text: String)
    func setKesiciPrice(_ text: String)
    func setAyakciPrice(_ text: String)
    func setServicePrice(_ text: String)
    func setOtherPrice(_ text: String)

    // Service
    func saveCollection()
}

final class WorkerCollectionViewModel: BaseViewModel, IWorkerCollectionViewModel {

    // MARK: Definitions
    private let repository: IWorkerCollectionRepository
    private let coordinator: IWorkerCollectionCoordinator
    private var uiModel: IWorkerCollectionUIModel

    // MARK: Public Props
    var viewState = ScreenStateSubject<WorkerCollectionViewState>(nil)
    var errorState = ErrorStateSubject(nil)
    let response = CurrentValueSubject<WorkerCollectionModel?, Never>(nil)

    // MARK: Initiliazer
    required init(repository: IWorkerCollectionRepository,
                  coordinator: IWorkerCollectionCoordinator,
                  uiModel: IWorkerCollectionUIModel) {
        self.repository = repository
        self.coordinator = coordinator
        self.uiModel = uiModel
    }

    func initComponents() {
        self.viewStateCavusName()
        self.viewStateInitData()
        self.viewStateInitCount()
        self.viewStateViewedData()

        if !self.uiModel.viewedData {
            self.updateResults()
        }
    }

    func updateResults() {
        self.viewStateSetTotalPrice()
    }
}


// MARK: Service
internal extension WorkerCollectionViewModel {

    func saveCollection() {
        guard self.uiModel.kesiciCount != 0 else { return }

        handleResourceFirestore(
            request: self.repository.saveNewCollection(season: self.uiModel.season,
                                                       workerId: self.uiModel.workerModel.id ?? "",
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
internal extension WorkerCollectionViewModel {

    // MARK: View State
    func viewStateShowNativeProgress(isProgress: Bool) {
        viewState.value = .showNativeProgress(isProgress: isProgress)
    }

    func viewStateCavusName() {
        self.viewState.value = .setCavusName(name: self.uiModel.cavusName)
    }

    func viewStateSetTotalPrice() {
        self.viewState.value = .setTotalPrice(price: self.uiModel.getTotalPrice())
    }

    func viewStateInitData() {
        self.viewState.value = .initData(data: self.uiModel.workerModel)
    }

    func viewStateInitCount() {
        self.viewState.value = .initCounts(kesici: self.uiModel.kesiciCount,
                                           ayakci: self.uiModel.ayakciCount,
                                           other: self.uiModel.otherPrice)
    }

    func viewStateViewedData() {
        self.viewState.value = .viewedData(isVisible: self.uiModel.viewedData)
    }

}

// MARK: Coordinate
internal extension WorkerCollectionViewModel {

    func dismiss() {
        self.coordinator.dismiss(completion: nil)
    }
}

// MARK: Setter
internal extension WorkerCollectionViewModel {

    func setDate(date: String?) {
        self.uiModel.setDate(date: date)
    }

    func setGardenOwner(_ text: String) {
        self.uiModel.setGardenOwner(text)
    }

    func setKesiciCount(_ text: String) {
        self.uiModel.setKesiciCount(text)
    }

    func setAyakciCount(_ text: String) {
        self.uiModel.setAyakciCount(text)
    }

    func setCavusPrice(_ text: String) {
        self.uiModel.setCavusPrice(text)
    }

    func setKesiciPrice(_ text: String) {
        self.uiModel.setKesiciPrice(text)
    }

    func setAyakciPrice(_ text: String) {
        self.uiModel.setAyakciPrice(text)
    }

    func setServicePrice(_ text: String) {
        self.uiModel.setServicePrice(text)
    }

    func setOtherPrice(_ text: String) {
        self.uiModel.setOtherPrice(text)
    }
}

enum WorkerCollectionViewState {
    case showNativeProgress(isProgress: Bool)
    case setCavusName(name: String)
    case setTotalPrice(price: String)
    case initData(data: WorkerModel)
    case initCounts(kesici: Int, ayakci: Int, other: Double)
    case viewedData(isVisible: Bool)
}
