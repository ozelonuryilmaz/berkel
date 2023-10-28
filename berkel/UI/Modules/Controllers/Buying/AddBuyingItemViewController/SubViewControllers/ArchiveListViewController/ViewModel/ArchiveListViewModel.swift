//
//  ArchiveListViewModel.swift
//  berkel
//
//  Created by Onur Yilmaz on 26.10.2023.
//

import Combine

protocol IArchiveListViewModel: ArchiveListTableViewCellOutputDelegate {

    var viewState: ScreenStateSubject<ArchiveListViewState> { get }
    var errorState: ErrorStateSubject { get }

    init(repository: IArchiveListRepository,
         coordinator: IArchiveListCoordinator,
         uiModel: IArchiveListUIModel)


    func setArchiveType(index: Int)
    func getArchive()
    
    // for Table View
    func getNumberOfItemsInSection() -> Int
    func getCellUIModel(at index: Int) -> ArchiveListTableViewCellUIModel
}

final class ArchiveListViewModel: BaseViewModel, IArchiveListViewModel {

    // MARK: Definitions
    private let repository: IArchiveListRepository
    private let coordinator: IArchiveListCoordinator
    private var uiModel: IArchiveListUIModel

    // MARK: Private Props

    // MARK: Public Props
    var viewState = ScreenStateSubject<ArchiveListViewState>(nil)
    var errorState = ErrorStateSubject(nil)
    let responseArchive = CurrentValueSubject<[SellerImageModel]?, Never>(nil)

    // MARK: Initiliazer
    required init(repository: IArchiveListRepository,
                  coordinator: IArchiveListCoordinator,
                  uiModel: IArchiveListUIModel) {
        self.repository = repository
        self.coordinator = coordinator
        self.uiModel = uiModel
    }

    func setArchiveType(index: Int) {
        self.uiModel.setArchiveType(index: index)
    }
}


// MARK: Service
internal extension ArchiveListViewModel {

    func getArchive() {
        switch self.uiModel.archiveSegmentType {
        case .kantarFisi:
            if !self.uiModel.isHaveAnyKantarFisi {
                self.getArchive(imagePathType: .kantarFisi)
            } else {
                self.viewStateReloadTableView()
            }

        case .cek:
            if !self.uiModel.isHaveAnyCek {
                self.getArchive(imagePathType: .cek)
            } else {
                self.viewStateReloadTableView()
            }
        case .dekont:
            if !self.uiModel.isHaveAnyDekont {
                self.getArchive(imagePathType: .dekont)
            } else {
                self.viewStateReloadTableView()
            }
        case .diger:
            if !self.uiModel.isHaveAnyDiger {
                self.getArchive(imagePathType: .diger)
            } else {
                self.viewStateReloadTableView()
            }
        }
    }

    private func getArchive(imagePathType: ImagePathType) {
        handleResourceFirestore(
            request: self.repository.getArchiveList(season: self.uiModel.season,
                                                    sellerId: self.uiModel.sellerId,
                                                    imagePathType: imagePathType),
            response: self.responseArchive,
            errorState: self.errorState,
            callbackLoading: { [weak self] isProgress in
                guard let self = self else { return }
                self.viewStateShowNativeProgress(isProgress: isProgress)
            }, callbackSuccess: { [weak self] in
                guard let self = self,
                    let data = self.responseArchive.value else { return }

                self.uiModel.setArchive(imagePathType: imagePathType, data: data)
                self.viewStateReloadTableView()
            })
    }

}

// MARK: States
internal extension ArchiveListViewModel {

    // MARK: View State
    func viewStateShowNativeProgress(isProgress: Bool) {
        viewState.value = .showNativeProgress(isProgress: isProgress)
    }

    func viewStateReloadTableView() {
        viewState.value = .reloadTableView
    }
}

// MARK: Coordinate
internal extension ArchiveListViewModel {

    func presentArchiveDetailViewController(date: String, productName: String, imageUrl: String) {
        let data = ArchiveDetailPassData(date: date, productName: productName, imageUrl: imageUrl)
        self.coordinator.presentArchiveDetailViewController(passData: data)
    }
}

// MARK: TableView
internal extension ArchiveListViewModel {

    func getNumberOfItemsInSection() -> Int {
        return self.uiModel.getNumberOfItemsInSection()
    }

    func getCellUIModel(at index: Int) -> ArchiveListTableViewCellUIModel {
        return self.uiModel.getCellUIModel(at: index)
    }
}


// MARK: ArchiveListTableViewCellOutputDelegate
internal extension ArchiveListViewModel {
    
    func cellTapped(uiModel: IArchiveListTableViewCellUIModel) {
        self.presentArchiveDetailViewController(date: uiModel.date,
                                                productName: uiModel.productName,
                                                imageUrl: uiModel.imageUrl)
    }
}

enum ArchiveListViewState {
    case showNativeProgress(isProgress: Bool)
    case reloadTableView
}
