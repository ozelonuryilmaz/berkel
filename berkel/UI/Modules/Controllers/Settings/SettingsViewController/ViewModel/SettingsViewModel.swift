//
//  SettingsViewModel.swift
//  berkel
//
//  Created by Onur Yilmaz on 2.09.2023.
//

import Foundation
import Combine
import FirebaseAuth

protocol ISettingsViewModel: SettingsItemCellOutputDelegate,
    AddBuyingItemViewControllerOutputDelegate,
    NewWorkerViewControllerOutputDelegate,
    NewSellerViewControllerOutputDelegate {

    var viewState: ScreenStateSubject<SettingsViewState> { get }
    var errorState: ErrorStateSubject { get }

    var season: String { get }

    init(repository: ISettingsRepository,
         coordinator: ISettingsCoordinator,
         uiModel: ISettingsUIModel)

    func getNumberOfItemsInSection() -> Int
    func getNumberOfItemsInRow(section: Int) -> Int

    func getSectionUIModel(section: Int) -> SettingsSectionUIModel
    func getItemCellUIModel(indexPath: IndexPath) -> ISettingsRowModel
    func isVisibleSeperatorRow(indexPath: IndexPath) -> Bool
    func isLastSection(section: Int) -> Bool
}

final class SettingsViewModel: BaseViewModel, ISettingsViewModel {

    // MARK: Definitions
    private let repository: ISettingsRepository
    private let coordinator: ISettingsCoordinator
    private var uiModel: ISettingsUIModel

    var viewState = ScreenStateSubject<SettingsViewState>(nil)
    var errorState = ErrorStateSubject(nil)

    // MARK: Initiliazer
    required init(repository: ISettingsRepository,
                  coordinator: ISettingsCoordinator,
                  uiModel: ISettingsUIModel) {
        self.repository = repository
        self.coordinator = coordinator
        self.uiModel = uiModel
    }

    var season: String {
        return uiModel.season
    }
}


// MARK: Service
internal extension SettingsViewModel {

    func logOut() {
        do {
            try Auth.auth().signOut()
            self.viewStateStartFlowSplash()
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
}

// MARK: States
internal extension SettingsViewModel {

    // MARK: View State
    func viewStateShowNativeProgress(isProgress: Bool) {
        viewState.value = .showNativeProgress(isProgress: isProgress)
    }

    func viewStateStartFlowSplash() {
        viewState.value = .startFlowSplash
    }

    // MARK: Action State

}

// MARK: TableView
internal extension SettingsViewModel {

    func getNumberOfItemsInSection() -> Int {
        return self.uiModel.getNumberOfItemsInSection()
    }

    func getNumberOfItemsInRow(section: Int) -> Int {
        self.uiModel.getNumberOfItemsInRow(section: section)
    }

    func getSectionUIModel(section: Int) -> SettingsSectionUIModel {
        return self.uiModel.getSectionUIModel(section: section)
    }

    func getItemCellUIModel(indexPath: IndexPath) -> ISettingsRowModel {
        return self.uiModel.getItemCellUIModel(indexPath: indexPath)
    }

    func isVisibleSeperatorRow(indexPath: IndexPath) -> Bool {
        return self.uiModel.isVisibleSeperatorRow(indexPath: indexPath)
    }

    func isLastSection(section: Int) -> Bool {
        return self.uiModel.isLastSection(section: section)
    }
}

// MARK: SettingsItemCellOutputDelegate
extension SettingsViewModel {

    func settingsCellTap(uiModel: SettingsItemCellUIModel) {

        let cellType = uiModel.cellType
        switch cellType {
        case .saticiList:
            self.pushAddBuyinItemViewController()
        case .cavusList:
            self.pushCavusListViewController()
        case .musteriList:
            self.pushCustomerListViewController()
        case .alisGelirGiderCizergesi:
            break
        case .isciGelirGiderCizergesi:
            break
        case .satisGelirGiderCizergesi:
            self.pushSellerChartsViewController()
        case .sezonlar:
            self.presentSeasonsViewController(seasonDismissCallback: { [unowned self] isSelected in
                if isSelected {
                    self.viewStateStartFlowSplash()
                }
            })
        case .cikisYap:
            self.logOut()
        }
    }
}

// MARK: Coordinate
internal extension SettingsViewModel {

    func pushAddBuyinItemViewController() {
        self.coordinator.pushAddBuyinItemViewController(passData: AddBuyingItemPassData(isCancellableCellTabbed: true),
                                                        outputDelegate: self)
    }

    func pushCavusListViewController() {
        self.coordinator.pushCavusListViewController(passData: CavusListPassData(isCancellableCellTabbed: true),
                                                     outputDelegate: self)
    }

    func pushCustomerListViewController() {
        self.coordinator.pushCustomerListViewController(passData: CustomerListPassData(isCancellableCellTabbed: true),
                                                        outputDelegate: self)
    }

    func presentSeasonsViewController(seasonDismissCallback: ((_ isSelected: Bool) -> Void)?) {
        self.coordinator.presentSeasonsViewController(seasonDismissCallback: seasonDismissCallback)
    }

    func pushSellerChartsViewController() {
        self.coordinator.pushSellerChartsViewController(passData: SellerChartsPassData())
    }
}

// MARK: AddBuyingItemViewControllerOutputDelegate, NewWorkerViewControllerOutputDelegate, NewSellerViewControllerOutputDelegate
internal extension SettingsViewModel {
    func newAddBuyingData(_ data: NewBuyingModel) { }
    func newWorkerData(_ data: WorkerModel) { }
    func newSellerData(_ data: SellerModel) { }
}

enum SettingsViewState {
    case showNativeProgress(isProgress: Bool)
    case startFlowSplash
}
