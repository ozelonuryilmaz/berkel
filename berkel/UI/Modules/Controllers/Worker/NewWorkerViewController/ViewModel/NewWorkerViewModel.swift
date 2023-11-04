//
//  NewWorkerViewModel.swift
//  berkel
//
//  Created by Onur Yilmaz on 31.10.2023.
//

import Combine

protocol INewWorkerViewModel: AnyObject {

    var viewState: ScreenStateSubject<NewWorkerViewState> { get }
    var errorState: ErrorStateSubject { get }

    init(repository: INewWorkerRepository,
         coordinator: INewWorkerCoordinator,
         uiModel: INewWorkerUIModel)

    func initComponents()

    // Service
    func saveNewWorker()

    // Coordinate
    func dismiss(completion: (() -> Void)?)

    func setCavusPrice(_ value: String)
    func setKesiciPrice(_ value: String)
    func setAyakciPrice(_ value: String)
    func setServisPrice(_ value: String)
    func setGarden(_ value: String)
    func setDesc(_ value: String)

}

final class NewWorkerViewModel: BaseViewModel, INewWorkerViewModel {

    // MARK: Definitions
    private let repository: INewWorkerRepository
    private let coordinator: INewWorkerCoordinator
    private var uiModel: INewWorkerUIModel

    // MARK: Public Props
    var viewState = ScreenStateSubject<NewWorkerViewState>(nil)
    var errorState = ErrorStateSubject(nil)
    let responseWorker = CurrentValueSubject<WorkerModel?, Never>(nil)

    // MARK: Initiliazer
    required init(repository: INewWorkerRepository,
                  coordinator: INewWorkerCoordinator,
                  uiModel: INewWorkerUIModel) {
        self.repository = repository
        self.coordinator = coordinator
        self.uiModel = uiModel
    }

    func initComponents() {
        self.viewStateCavusName()
    }
}


// MARK: Service
internal extension NewWorkerViewModel {

    func saveNewWorker() {
        if let errorMessage = self.uiModel.errorMessage {
            errorState.value = .ERROR_MESSAGE(title: "Uyarı", msg: errorMessage)
            return
        }

        handleResourceFirestore(
            request: self.repository.saveNewWorker(data: self.uiModel.newWorkerData,
                                                   season: self.uiModel.season),
            response: self.responseWorker,
            errorState: self.errorState,
            callbackLoading: { [weak self] isProgress in
                guard let self = self else { return }
                self.viewStateShowNativeProgress(isProgress: isProgress)
            }, callbackSuccess: { [weak self] in
                guard let self = self,
                    let response = self.responseWorker.value else { return }
                self.dismiss(completion: {
                    self.viewStateOutputDelegate(workerModel: response)
                })
                
            })
    }
}

// MARK: States
internal extension NewWorkerViewModel {

    // MARK: View State
    func viewStateShowNativeProgress(isProgress: Bool) {
        viewState.value = .showNativeProgress(isProgress: isProgress)
    }

    func viewStateCavusName() {
        self.viewState.value = .setCavusName(name: self.uiModel.cavusName)
    }

    func viewStateOutputDelegate(workerModel: WorkerModel) {
        self.viewState.value = .outputDelegate(workerModel: workerModel)
    }
}

// MARK: Coordinate
internal extension NewWorkerViewModel {

    func dismiss(completion: (() -> Void)? = nil) {
        self.coordinator.dismiss(completion: completion)
    }
}


extension NewWorkerViewModel {

    func setCavusPrice(_ value: String) {
        self.uiModel.setCavusPrice(value)
    }

    func setKesiciPrice(_ value: String) {
        self.uiModel.setKesiciPrice(value)
    }

    func setAyakciPrice(_ value: String) {
        self.uiModel.setAyakciPrice(value)
    }

    func setServisPrice(_ value: String) {
        self.uiModel.setServisPrice(value)
    }

    func setGarden(_ value: String) {
        self.uiModel.setGarden(value)
    }

    func setDesc(_ value: String) {
        self.uiModel.setDesc(value)
    }
}


enum NewWorkerViewState {
    case showNativeProgress(isProgress: Bool)
    case setCavusName(name: String)
    case outputDelegate(workerModel: WorkerModel)
}
