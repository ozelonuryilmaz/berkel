//
//  OtherSellerCategoryListViewModel.swift
//  berkel
//
//  Created by Onur Yilmaz on 21.01.2024.
//

import Combine

protocol IOtherSellerCategoryListViewModel: AnyObject {

    var viewState: ScreenStateSubject<OtherSellerCategoryListViewState> { get }
    var errorState: ErrorStateSubject { get }
    var errorStateOtherSellerCategory: ErrorStateSubject { get }

    init(repository: IOtherSellerCategoryListRepository,
         coordinator: IOtherSellerCategoryListCoordinator,
         uiModel: IOtherSellerCategoryListUIModel)
    
    func getOtherSellerCategory()
    func saveOtherSellerCategory(otherSellerCategory: OtherSellerCategoryListModel)
    func getOtherSellerCategory(index: Int) -> OtherSellerCategoryListModel
    
    // Coordinate
    func dismiss()
    
    // TableView
    func getNumberOfRowsInSection() -> Int
    func getItemCellUIModel(index: Int) -> OtherSellerCategoryListTableViewCellUIModel
}

final class OtherSellerCategoryListViewModel: BaseViewModel, IOtherSellerCategoryListViewModel {

    // MARK: Definitions
    private let repository: IOtherSellerCategoryListRepository
    private let coordinator: IOtherSellerCategoryListCoordinator
    private var uiModel: IOtherSellerCategoryListUIModel

    // MARK: Public Props
    var viewState = ScreenStateSubject<OtherSellerCategoryListViewState>(nil)
    
    let response = CurrentValueSubject<[OtherSellerCategoryListModel]?, Never>(nil)
    let responseOtherSellerCategory = CurrentValueSubject<OtherSellerCategoryListModel?, Never>(nil)
    var errorState = ErrorStateSubject(nil)
    var errorStateOtherSellerCategory = ErrorStateSubject(nil)

    // MARK: Initiliazer
    required init(repository: IOtherSellerCategoryListRepository,
                  coordinator: IOtherSellerCategoryListCoordinator,
                  uiModel: IOtherSellerCategoryListUIModel) {
        self.repository = repository
        self.coordinator = coordinator
        self.uiModel = uiModel
    }

    func getOtherSellerCategory(index: Int) -> OtherSellerCategoryListModel {
        return self.uiModel.getOtherSellerCategory(index: index)
    }
}


// MARK: Service
internal extension OtherSellerCategoryListViewModel {

    func getOtherSellerCategory() {
        handleResourceFirestore(
            request: self.repository.getOtherSellerCategoryList(),
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
    
    func saveOtherSellerCategory(otherSellerCategory: OtherSellerCategoryListModel) {
        handleResourceFirestore(
            request: self.repository.saveOtherSellerCategory(data: otherSellerCategory),
            response: self.responseOtherSellerCategory,
            errorState: self.errorStateOtherSellerCategory,
            callbackLoading: { [weak self] isProgress in
                guard let self = self else { return }
                self.viewStateShowNativeProgress(isProgress: isProgress)
            }, callbackSuccess: { [weak self] in
                guard let self = self,
                    let otherSellerCategory = self.responseOtherSellerCategory.value else { return }

                self.uiModel.addOtherSellerCategory(otherSellerCategory)
                self.viewStateReloadTableView()
            })
    }
}

// MARK: States
internal extension OtherSellerCategoryListViewModel {

    // MARK: View State
    func viewStateShowNativeProgress(isProgress: Bool) {
        viewState.value = .showNativeProgress(isProgress: isProgress)
    }

    func viewStateReloadTableView() {
        viewState.value = .reloadTableView
    }
}

// MARK: Coordinate
internal extension OtherSellerCategoryListViewModel {

    func dismiss() {
        self.coordinator.dismiss(completion: nil)
    }
}

//MARK: TableView
internal extension OtherSellerCategoryListViewModel {

    func getNumberOfRowsInSection() -> Int {
        return uiModel.getNumberOfRowsInSection()
    }

    func getItemCellUIModel(index: Int) -> OtherSellerCategoryListTableViewCellUIModel {
        return uiModel.getItemCellUIModel(index: index)
    }
}

enum OtherSellerCategoryListViewState {
    case showNativeProgress(isProgress: Bool)
    case reloadTableView
}
