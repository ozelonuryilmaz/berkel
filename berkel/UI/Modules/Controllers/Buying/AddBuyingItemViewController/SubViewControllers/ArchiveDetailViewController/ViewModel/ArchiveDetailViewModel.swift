//
//  ArchiveDetailViewModel.swift
//  berkel
//
//  Created by Onur Yilmaz on 26.10.2023.
//  Copyright (c) 2023 Emlakjet IOS Development Team. All rights reserved.[EC-2021]
//

import Combine

protocol IArchiveDetailViewModel: AnyObject {

    var viewState: ScreenStateSubject<ArchiveDetailViewState> { get }
    var errorState: ErrorStateSubject { get }

    init(repository: IArchiveDetailRepository,
         coordinator: IArchiveDetailCoordinator,
         uiModel: IArchiveDetailUIModel)

    func initComponents()
}

final class ArchiveDetailViewModel: BaseViewModel, IArchiveDetailViewModel {

    // MARK: Definitions
    private let repository: IArchiveDetailRepository
    private let coordinator: IArchiveDetailCoordinator
    private var uiModel: IArchiveDetailUIModel

    // MARK: Public Props
    var viewState = ScreenStateSubject<ArchiveDetailViewState>(nil)
    var errorState = ErrorStateSubject(nil)

    // MARK: Initiliazer
    required init(repository: IArchiveDetailRepository,
                  coordinator: IArchiveDetailCoordinator,
                  uiModel: IArchiveDetailUIModel) {
        self.repository = repository
        self.coordinator = coordinator
        self.uiModel = uiModel
    }

    func initComponents() {
        self.viewStateSetNavigationTitle()
    }
}


// MARK: Service
internal extension ArchiveDetailViewModel {

}

// MARK: States
internal extension ArchiveDetailViewModel {

    // MARK: View State
    func viewStateShowNativeProgress(isProgress: Bool) {
        viewState.value = .showNativeProgress(isProgress: isProgress)
    }

    func viewStateSetNavigationTitle() {
        self.viewState.value = .setNavigationTitle(title: self.uiModel.date,
                                                   subtitle: self.uiModel.productName)
    }
}

// MARK: Coordinate
internal extension ArchiveDetailViewModel {

}


enum ArchiveDetailViewState {
    case showNativeProgress(isProgress: Bool)
    case setNavigationTitle(title: String, subtitle: String)
}
