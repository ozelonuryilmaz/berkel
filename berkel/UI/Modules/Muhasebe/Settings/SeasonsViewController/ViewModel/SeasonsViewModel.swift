//
//  SeasonsViewModel.swift
//  berkel
//
//  Created by Onur Yilmaz on 25.09.2023.
//

import Combine

protocol ISeasonsViewModel: AnyObject {

    var viewState: ScreenStateSubject<SeasonsViewState> { get }
    var errorState: ErrorStateSubject { get }
    var errorStateSeason: ErrorStateSubject { get }
    var isHiddenBackButton: Bool { get }
    var isAppSeasonSelection: Bool { get }

    init(repository: ISeasonsRepository,
         coordinator: ISeasonsCoordinator,
         uiModel: ISeasonsUIModel)

    // Service
    func getSeasons()
    func saveSeason(season: SeasonResponseModel)

    func saveSeason(index: Int)

    // TableView
    func getNumberOfRowsInSection() -> Int
    func getItemCellUIModel(index: Int) -> SeasonsTableViewCellUIModel
}

final class SeasonsViewModel: BaseViewModel, ISeasonsViewModel {

    // MARK: Definitions
    private let repository: ISeasonsRepository
    private let coordinator: ISeasonsCoordinator
    private var uiModel: ISeasonsUIModel

    // MARK: Private Props

    // MARK: Public Props
    var viewState = ScreenStateSubject<SeasonsViewState>(nil)
    let response = CurrentValueSubject<[SeasonResponseModel]?, Never>(nil)
    let responseSeason = CurrentValueSubject<SeasonResponseModel?, Never>(nil)
    var errorState = ErrorStateSubject(nil)
    var errorStateSeason = ErrorStateSubject(nil)

    var isHiddenBackButton: Bool {
        return self.uiModel.isHiddenBackButton
    }
    
    var isAppSeasonSelection: Bool {
        return self.uiModel.isAppSeasonSelection
    }

    // MARK: Initiliazer
    required init(repository: ISeasonsRepository,
                  coordinator: ISeasonsCoordinator,
                  uiModel: ISeasonsUIModel) {
        self.repository = repository
        self.coordinator = coordinator
        self.uiModel = uiModel
    }

    func saveSeason(index: Int) {
        self.uiModel.saveSeason(index: index)
    }
}


// MARK: Service
internal extension SeasonsViewModel {

    func getSeasons() {
        handleResourceFirestore(
            request: self.repository.getSeasonList(),
            response: self.response,
            errorState: self.errorState,
            callbackLoading: { isProgress in
                self.viewStateShowNativeProgress(isProgress: isProgress)
            },
            callbackSuccess: { [weak self] in
                guard let self = self else { return }
                self.uiModel.setResponse(self.response.value ?? [])
                self.viewStateReloadTableView()
            }
        )
    }

    func saveSeason(season: SeasonResponseModel) {
        guard !self.uiModel.isHaveSeason(season.season) else { return }

        handleResourceFirestore(
            request: self.repository.saveSeason(season: season),
            response: self.responseSeason,
            errorState: self.errorStateSeason,
            callbackLoading: { [weak self] isProgress in
                guard let self = self else { return }
                self.viewStateShowNativeProgress(isProgress: isProgress)
            }, callbackSuccess: { [weak self] in
                guard let self = self,
                    let season = self.responseSeason.value else { return }

                self.uiModel.addSeason(season)
                self.viewStateReloadTableView()
            })
    }
}

// MARK: States
internal extension SeasonsViewModel {

    // MARK: View State
    func viewStateShowNativeProgress(isProgress: Bool) {
        viewState.value = .showNativeProgress(isProgress: isProgress)
    }

    func viewStateReloadTableView() {
        viewState.value = .reloadTableView
    }


    // MARK: Action State

}

// MARK: Coordinate
internal extension SeasonsViewModel {

}

//MARK: TableView
internal extension SeasonsViewModel {

    func getNumberOfRowsInSection() -> Int {
        return uiModel.getNumberOfRowsInSection()
    }

    func getItemCellUIModel(index: Int) -> SeasonsTableViewCellUIModel {
        return uiModel.getItemCellUIModel(index: index)
    }
}

enum SeasonsViewState {
    case showNativeProgress(isProgress: Bool)
    case reloadTableView
}
