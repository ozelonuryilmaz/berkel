//
//  NewSellerImageViewModel.swift
//  berkel
//
//  Created by Onur Yilmaz on 23.10.2023.
//  Copyright (c) 2023 Emlakjet IOS Development Team. All rights reserved.[EC-2021]
//

import Foundation
import Combine

protocol INewSellerImageViewModel: AnyObject {

    var viewState: ScreenStateSubject<NewSellerImageViewState> { get }
    var errorState: ErrorStateSubject { get }

    init(repository: INewSellerImageRepository,
         coordinator: INewSellerImageCoordinator,
         uiModel: INewSellerImageUIModel)

    // View State
    func viewStateSetNavigationTitle()
    
    // Coordinate
    func dismiss()

}

final class NewSellerImageViewModel: BaseViewModel, INewSellerImageViewModel {

    // MARK: Definitions
    private let repository: INewSellerImageRepository
    private let coordinator: INewSellerImageCoordinator
    private var uiModel: INewSellerImageUIModel

    // MARK: Public Props
    var viewState = ScreenStateSubject<NewSellerImageViewState>(nil)
    var errorState = ErrorStateSubject(nil)
    let responseImageUrl = CurrentValueSubject<String?, Never>(nil)
    let responseSellerImage = CurrentValueSubject<SellerImageModel?, Never>(nil)

    // MARK: Initiliazer
    required init(repository: INewSellerImageRepository,
                  coordinator: INewSellerImageCoordinator,
                  uiModel: INewSellerImageUIModel) {
        self.repository = repository
        self.coordinator = coordinator
        self.uiModel = uiModel
    }

    func initComponents() {
        self.viewStateSetNavigationTitle()
    }

}


// MARK: Service
internal extension NewSellerImageViewModel {

    // TODO: UIIMage'i Data'yı çevir jpg formatında boyutu düşür.
    // TODO: Firestore'a kaydetme akışını ayarla.

    func saveImage(imagePathType: ImagePathType, imageData: Data, date: String) {
        handleResourceFirestore(
            request: self.repository.saveImage(sellerId: self.uiModel.sellerId,
                                               season: self.uiModel.season,
                                               imagePathType: imagePathType,
                                               imageData: imageData),
            response: self.responseImageUrl,
            errorState: self.errorState,
            callbackLoading: { [weak self] isProgress in
                guard let self = self else { return }
                self.viewStateShowNativeProgress(isProgress: isProgress)
            }, callbackSuccess: { [weak self] in
                guard let self = self,
                    let imageUrl = self.responseImageUrl.value else { return }

                let data = SellerImageModel(sellerId: self.uiModel.sellerId,
                                            userId: self.uiModel.userId,
                                            buyingId: self.uiModel.buyingId,
                                            buyingProductName: self.uiModel.buyingProductName,
                                            date: date,
                                            imageUrl: imageUrl)

                self.saveSellerImageData(imagePathType: imagePathType, data: data)
            })
    }

    private func saveSellerImageData(imagePathType: ImagePathType, data: SellerImageModel) {
        handleResourceFirestore(
            request: self.repository.saveSellerImage(sellerId: self.uiModel.sellerId,
                                                     season: self.uiModel.season,
                                                     imagePathType: imagePathType,
                                                     data: data),
            response: self.responseSellerImage,
            errorState: self.errorState,
            callbackLoading: { [weak self] isProgress in
                guard let self = self else { return }
                self.viewStateShowNativeProgress(isProgress: isProgress)
            }, callbackSuccess: { [weak self] in
                guard let self = self else { return }

            })
    }
}

// MARK: States
internal extension NewSellerImageViewModel {

    // MARK: View State
    func viewStateShowNativeProgress(isProgress: Bool) {
        viewState.value = .showNativeProgress(isProgress: isProgress)
    }

    func viewStateSetNavigationTitle() {
        self.viewState.value = .setNavigationTitle(title: self.uiModel.navTitle)
    }

    // MARK: Action State

}

// MARK: Coordinate
internal extension NewSellerImageViewModel {

    func dismiss() {
        self.coordinator.dismiss(completion: nil)
    }
}


enum NewSellerImageViewState {
    case showNativeProgress(isProgress: Bool)
    case setNavigationTitle(title: String)
}
