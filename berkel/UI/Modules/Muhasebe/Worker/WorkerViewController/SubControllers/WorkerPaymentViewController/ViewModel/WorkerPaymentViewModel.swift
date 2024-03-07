//
//  WorkerPaymentViewModel.swift
//  berkel
//
//  Created by Onur Yilmaz on 4.11.2023.
//

import Combine

protocol IWorkerPaymentViewModel: AnyObject {

    var viewState: ScreenStateSubject<WorkerPaymentViewState> { get }
    var errorState: ErrorStateSubject { get }

    init(repository: IWorkerPaymentRepository,
         coordinator: IWorkerPaymentCoordinator,
         uiModel: IWorkerPaymentUIModel)

    func initComponents()
    func dismiss()

    // Setter
    func setDate(date: String?)
    func setPayment(_ text: String)
    func setDesc(_ text: String)

    // Service
    func savePayment()
}

final class WorkerPaymentViewModel: BaseViewModel, IWorkerPaymentViewModel {

    // MARK: Definitions
    private let repository: IWorkerPaymentRepository
    private let coordinator: IWorkerPaymentCoordinator
    private var uiModel: IWorkerPaymentUIModel

    // MARK: Public Props
    var viewState = ScreenStateSubject<WorkerPaymentViewState>(nil)
    var errorState = ErrorStateSubject(nil)
    let response = CurrentValueSubject<WorkerPaymentModel?, Never>(nil)

    // MARK: Initiliazer
    required init(repository: IWorkerPaymentRepository,
                  coordinator: IWorkerPaymentCoordinator,
                  uiModel: IWorkerPaymentUIModel) {
        self.repository = repository
        self.coordinator = coordinator
        self.uiModel = uiModel
    }

    func initComponents() {
        self.viewStateCavusName()
    }
}


// MARK: Service
internal extension WorkerPaymentViewModel {

    func savePayment() {
        guard self.uiModel.payment > 0 else { return }

        handleResourceFirestore(
            request: self.repository.saveNewPayment(season: self.uiModel.season,
                                                    workerId: self.uiModel.workerId,
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
internal extension WorkerPaymentViewModel {

    // MARK: View State
    func viewStateShowNativeProgress(isProgress: Bool) {
        viewState.value = .showNativeProgress(isProgress: isProgress)
    }

    func viewStateCavusName() {
        self.viewState.value = .setCavusName(name: self.uiModel.cavusName)
    }

}

// MARK: Coordinate
internal extension WorkerPaymentViewModel {

    func dismiss() {
        self.coordinator.dismiss(completion: nil)
    }
}

// MARK: Setter
internal extension WorkerPaymentViewModel {

    func setDate(date: String?) {
        self.uiModel.setDate(date: date)
    }

    func setPayment(_ text: String) {
        self.uiModel.setPayment(text)
    }

    func setDesc(_ text: String) {
        self.uiModel.setDesc(text)
    }
}

enum WorkerPaymentViewState {
    case showNativeProgress(isProgress: Bool)
    case setCavusName(name: String)
}
