//
//  CavusListViewModel.swift
//  berkel
//
//  Created by Onur Yilmaz on 31.10.2023.
//

import Combine

protocol ICavusListViewModel: NewCavusViewControllerOutputDelegate, CavusListDataSourceFactoryOutputDelegate {

    var viewState: ScreenStateSubject<CavusListViewState> { get }
    var errorState: ErrorStateSubject { get }

    init(repository: ICavusListRepository,
         coordinator: ICavusListCoordinator,
         uiModel: ICavusListUIModel)

    // Service
    func getCavusList()

    // Coordinate
    func presentNewCavusViewController()

    func updateSnapshot(currentSnapshot: CavusListSnapshot,
                        newDatas: [CavusModel]) -> CavusListSnapshot
}

final class CavusListViewModel: BaseViewModel, ICavusListViewModel {

    // MARK: Definitions
    private let repository: ICavusListRepository
    private let coordinator: ICavusListCoordinator
    private var uiModel: ICavusListUIModel

    // MARK: Private Props
    private var isLastPage: Bool = false
    private var isAvailablePagination: Bool = false

    // MARK: Public Props
    var viewState = ScreenStateSubject<CavusListViewState>(nil)
    var errorState = ErrorStateSubject(nil)
    let response = CurrentValueSubject<[CavusModel]?, Never>(nil)

    // MARK: Initiliazer
    required init(repository: ICavusListRepository,
                  coordinator: ICavusListCoordinator,
                  uiModel: ICavusListUIModel) {
        self.repository = repository
        self.coordinator = coordinator
        self.uiModel = uiModel
    }

    func updateSnapshot(currentSnapshot: CavusListSnapshot,
                        newDatas: [CavusModel]) -> CavusListSnapshot {
        self.uiModel.updateSnapshot(currentSnapshot: currentSnapshot, newDatas: newDatas)
    }
}


// MARK: Service
internal extension CavusListViewModel {

    func getCavusList() {

        handleResourceFirestore(
            request: self.repository.getCavusList(cursor: self.uiModel.getLastCursor(),
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
internal extension CavusListViewModel {

    // MARK: View State
    func viewStateShowNativeProgress(isProgress: Bool) {
        viewState.value = .showNativeProgress(isProgress: isProgress)
    }

    func viewStateBuildSnapshot() {
        viewState.value = .buildSnapshot(snapshot: self.uiModel.buildSnapshot())
    }

    func viewStateUpdateSnapshot(data: [CavusModel]) {
        viewState.value = .updateSnapshot(data: data)
    }
}

// MARK: Coordinate
internal extension CavusListViewModel {

    func presentNewCavusViewController() {
        self.coordinator.presentNewCavusViewController(passData: NewCavusPassData(),
                                                       outputDelegate: self)
    }

    func presentNewWorkerViewController() {
        self.coordinator.presentNewWorkerViewController(passData: NewWorkerPassData())
    }
}

// MARK: NewCavusViewControllerOutputDelegate
internal extension CavusListViewModel {

    func newCavusData(_ data: CavusModel) {
        self.uiModel.appendFirstItem(data: data)
        self.viewStateBuildSnapshot()
    }
}

// MARK: CavusListDataSourceFactoryOutputDelegate
extension CavusListViewModel {

    func phoneNumberTapped(phoneNumber: String) {
        PhoneCallHelper.shared.makeACall(phoneNumber: phoneNumber)
    }

    func cellTapped(uiModel: ICavusListTableViewCellUIModel) {
        self.presentNewWorkerViewController()
    }

    func scrollDidScroll(isAvailablePagination: Bool) {
        if self.isAvailablePagination && isAvailablePagination && !isLastPage {
            self.getCavusList()
        }
    }
}


enum CavusListViewState {
    case showNativeProgress(isProgress: Bool)
    case buildSnapshot(snapshot: CavusListSnapshot)
    case updateSnapshot(data: [CavusModel])
}
