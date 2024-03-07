//
//  NewSellerImageViewModel.swift
//  berkel
//
//  Created by Onur Yilmaz on 23.10.2023.
//

import Foundation
import Combine

protocol INewSellerImageViewModel: AnyObject {

    var viewState: ScreenStateSubject<NewSellerImageViewState> { get }
    var errorState: ErrorStateSubject { get }

    init(repository: INewSellerImageRepository,
         coordinator: INewSellerImageCoordinator,
         uiModel: INewSellerImageUIModel)

    func initComponents()

    // Service
    func saveImage()

    // View State
    func viewStateSetNavigationTitle()

    // Coordinate
    func dismiss()

    // Setter
    func setDate(date: String?)
    func setDesc(_ text: String)
    func setImageData(_ data: Data?)
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
    let responseCustomerImage = CurrentValueSubject<CustomerImageModel?, Never>(nil)
    let responseWorkerImage = CurrentValueSubject<WorkerImageModel?, Never>(nil)
    let responseOtherSellerImage = CurrentValueSubject<OtherSellerImageModel?, Never>(nil)

    // MARK: Initiliazer
    required init(repository: INewSellerImageRepository,
                  coordinator: INewSellerImageCoordinator,
                  uiModel: INewSellerImageUIModel) {
        self.repository = repository
        self.coordinator = coordinator
        self.uiModel = uiModel
    }

    func initComponents() {

    }

}


// MARK: Service
internal extension NewSellerImageViewModel {

    func saveImage() {
        guard let imageData = self.uiModel.imageData else { return }

        handleResourceFirestore(
            request: self.repository.saveImage(season: self.uiModel.season,
                                               imagePageType: self.uiModel.imagePageType,
                                               imagePathType: self.uiModel.imagePathType,
                                               imageData: imageData),
            response: self.responseImageUrl,
            errorState: self.errorState,
            callbackLoading: { [weak self] isProgress in
                guard let self = self else { return }
                self.viewStateShowNativeProgress(isProgress: isProgress)
            }, callbackSuccess: { [weak self] in
                guard let self = self,
                    let imageUrl = self.responseImageUrl.value else { return }

                switch self.uiModel.imagePageType {
                case .buying(let sellerId, let buyingId, let buyingProductName):
                    let data = SellerImageModel(sellerId: sellerId,
                                                userId: self.uiModel.userId,
                                                buyingId: buyingId,
                                                buyingProductName: buyingProductName,
                                                date: self.uiModel.date,
                                                description: self.uiModel.desc,
                                                imageUrl: imageUrl)

                    self.saveSellerImageData(data: data)
                case .seller(let customerId, let sellerId, let sellerProductName):
                    let data = CustomerImageModel(customerId: customerId,
                                                  userId: self.uiModel.userId,
                                                  sellerId: sellerId,
                                                  sellerProductName: sellerProductName,
                                                  date: self.uiModel.date,
                                                  description: self.uiModel.desc,
                                                  imageUrl: imageUrl)

                    self.saveSellerImageData(data: data)

                case .worker(let cavusId, let workerId, let workerProductName):
                    let data = WorkerImageModel(cavusId: cavusId,
                                                userId: self.uiModel.userId,
                                                workerId: workerId,
                                                workerProductName: workerProductName,
                                                date: self.uiModel.date,
                                                description: self.uiModel.desc,
                                                imageUrl: imageUrl)

                    self.saveSellerImageData(data: data)

                case .other(let otherSellerId, let otherId, let otherSellerProductName):
                    let data = OtherSellerImageModel(otherSellerId: otherSellerId,
                                                     userId: self.uiModel.userId,
                                                     otherId: otherId,
                                                     otherProductName: otherSellerProductName,
                                                     date: self.uiModel.date,
                                                     description: self.uiModel.desc,
                                                     imageUrl: imageUrl)

                    self.saveSellerImageData(data: data)
                }

            })
    }

    private func saveSellerImageData(data: SellerImageModel) {
        handleResourceFirestore(
            request: self.repository.saveSellerImage(sellerId: data.sellerId,
                                                     season: self.uiModel.season,
                                                     imagePathType: self.uiModel.imagePathType,
                                                     data: data),
            response: self.responseSellerImage,
            errorState: self.errorState,
            callbackLoading: { [weak self] isProgress in
                guard let self = self else { return }
                self.viewStateShowNativeProgress(isProgress: isProgress)
            }, callbackSuccess: { [weak self] in
                guard let self = self else { return }
                self.viewStateShowSuccessAlertMessage()
            })
    }

    private func saveSellerImageData(data: CustomerImageModel) {
        handleResourceFirestore(
            request: self.repository.saveSellerImage(customerId: data.customerId,
                                                     season: self.uiModel.season,
                                                     imagePathType: self.uiModel.imagePathType,
                                                     data: data),
            response: self.responseCustomerImage,
            errorState: self.errorState,
            callbackLoading: { [weak self] isProgress in
                guard let self = self else { return }
                self.viewStateShowNativeProgress(isProgress: isProgress)
            }, callbackSuccess: { [weak self] in
                guard let self = self else { return }
                self.viewStateShowSuccessAlertMessage()
            })
    }

    private func saveSellerImageData(data: WorkerImageModel) {
        handleResourceFirestore(
            request: self.repository.saveSellerImage(cavusId: data.cavusId,
                                                     season: self.uiModel.season,
                                                     imagePathType: self.uiModel.imagePathType,
                                                     data: data),
            response: self.responseWorkerImage,
            errorState: self.errorState,
            callbackLoading: { [weak self] isProgress in
                guard let self = self else { return }
                self.viewStateShowNativeProgress(isProgress: isProgress)
            }, callbackSuccess: { [weak self] in
                guard let self = self else { return }
                self.viewStateShowSuccessAlertMessage()
            })
    }

    private func saveSellerImageData(data: OtherSellerImageModel) {
        handleResourceFirestore(
            request: self.repository.saveSellerImage(otherSellerId: data.otherSellerId,
                                                     season: self.uiModel.season,
                                                     imagePathType: self.uiModel.imagePathType,
                                                     data: data),
            response: self.responseOtherSellerImage,
            errorState: self.errorState,
            callbackLoading: { [weak self] isProgress in
                guard let self = self else { return }
                self.viewStateShowNativeProgress(isProgress: isProgress)
            }, callbackSuccess: { [weak self] in
                guard let self = self else { return }
                self.viewStateShowSuccessAlertMessage()
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

    func viewStateShowSuccessAlertMessage() {
        self.viewState.value = .showSuccessAlertMessage
    }

    // MARK: Action State

}

// MARK: Coordinate
internal extension NewSellerImageViewModel {

    func dismiss() {
        self.coordinator.dismiss(completion: nil)
    }
}

// MARK: Setter
internal extension NewSellerImageViewModel {

    func setDate(date: String?) {
        self.uiModel.setDate(date: date)
    }

    func setImageData(_ data: Data?) {
        self.uiModel.setImageData(data)
    }

    func setDesc(_ text: String) {
        self.uiModel.setDesc(text)
    }
}

enum NewSellerImageViewState {
    case showNativeProgress(isProgress: Bool)
    case setNavigationTitle(title: String)
    case showSuccessAlertMessage
}
