//
//  BuyingViewModel.swift
//  berkel
//
//  Created by Onur Yilmaz on 2.09.2023.
//  Copyright (c) 2023 Emlakjet IOS Development Team. All rights reserved.[EC-2021]
//

import Combine

protocol IBuyingViewModel: AnyObject {

    init(repository: IBuyingRepository,
         coordinator: IBuyingCoordinator,
         uiModel: IBuyingUIModel)

    func getDocuments()
}

final class BuyingViewModel: BaseViewModel, IBuyingViewModel {

    // MARK: Definitions
    private let repository: IBuyingRepository
    private let coordinator: IBuyingCoordinator
    private var uiModel: IBuyingUIModel

    let response = CurrentValueSubject<[BuyingResponseModel]?, Never>(nil)

    // MARK: Initiliazer
    required init(repository: IBuyingRepository,
                  coordinator: IBuyingCoordinator,
                  uiModel: IBuyingUIModel) {
        self.repository = repository
        self.coordinator = coordinator
        self.uiModel = uiModel
    }

}


// MARK: Service
internal extension BuyingViewModel {

    func getDocuments() {

        handleResourceToFirestoreState(
            request: self.repository.getBuyingList(),
            response: self.response,
            callbackLoading: { isProgress in
                print("***isProgress: \(isProgress ? "Yükleniyor" : "Yüklendi")")
            },
            callbackSuccess: { [weak self] in
                guard let self = self else { return }

                self.response.value?.forEach { item in
                    print(item.test ?? "")
                }
            }, callbackComplete: {
                print("***data1: \(self.response.value)")
            }, callbackError: { msg in


            }
        )

    }
}

// MARK: States
internal extension BuyingViewModel {

    // MARK: View State

    // MARK: Action State

}

// MARK: Coordinate
internal extension BuyingViewModel {

}


enum BuyingViewState {
    case showLoadingProgress(isProgress: Bool)
}

enum BuyingActionState {

}


