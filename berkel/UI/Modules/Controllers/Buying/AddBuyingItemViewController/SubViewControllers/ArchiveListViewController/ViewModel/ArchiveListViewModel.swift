//
//  ArchiveListViewModel.swift
//  berkel
//
//  Created by Onur Yilmaz on 26.10.2023.
//  Copyright (c) 2023 Emlakjet IOS Development Team. All rights reserved.[EC-2021]
//

import Combine

protocol IArchiveListViewModel: AnyObject {

    var viewState: ScreenStateSubject<ArchiveListViewState> { get }
    var errorState: ErrorStateSubject { get }

    init(repository: IArchiveListRepository,
         coordinator: IArchiveListCoordinator,
         uiModel: IArchiveListUIModel)
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
    let responseKantarFisiImage = CurrentValueSubject<[SellerImageModel]?, Never>(nil)
    let responseDekontImage = CurrentValueSubject<[SellerImageModel]?, Never>(nil)
    let responseCekImage = CurrentValueSubject<[SellerImageModel]?, Never>(nil)
    let responseOtherImage = CurrentValueSubject<[SellerImageModel]?, Never>(nil)

    // MARK: Initiliazer
    required init(repository: IArchiveListRepository,
                  coordinator: IArchiveListCoordinator,
                  uiModel: IArchiveListUIModel) {
        self.repository = repository
        self.coordinator = coordinator
        self.uiModel = uiModel
    }

}


// MARK: Service
internal extension ArchiveListViewModel {

}

// MARK: States
internal extension ArchiveListViewModel {

    // MARK: View State
    func viewStateShowNativeProgress(isProgress: Bool) {
        viewState.value = .showNativeProgress(isProgress: isProgress)
    }

}

// MARK: Coordinate
internal extension ArchiveListViewModel {

    func presentArchiveDetailViewController(date: String, productName: String, imageUrl: String) {
        let data = ArchiveDetailPassData(date: date, productName: productName, imageUrl: imageUrl)
        self.coordinator.presentArchiveDetailViewController(passData: data)
    }
}


enum ArchiveListViewState {
    case showNativeProgress(isProgress: Bool)
}
