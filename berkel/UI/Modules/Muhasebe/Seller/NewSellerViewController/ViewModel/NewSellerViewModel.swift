//
//  NewSellerViewModel.swift
//  berkel
//
//  Created by Onur Yilmaz on 22.11.2023.
//

import Combine

protocol INewSellerViewModel: ProductListViewControllerOutputDelegate {

    var viewState: ScreenStateSubject<NewSellerViewState> { get }
    var errorState: ErrorStateSubject { get }

    init(repository: INewSellerRepository,
         coordinator: INewSellerCoordinator,
         uiModel: INewSellerUIModel)
    
    
    func initComponents()

    // Service
    func saveNewSeller()

    // Coordinate
    func dismiss(completion: (() -> Void)?)
    func presentProductListViewController()

    // Setter
    func setKGPrice(_ value: String)
    func setKDV(_ value: String)
    func setDesc(_ value: String)
}

final class NewSellerViewModel: BaseViewModel, INewSellerViewModel {

    // MARK: Definitions
    private let repository: INewSellerRepository
    private let coordinator: INewSellerCoordinator
    private var uiModel: INewSellerUIModel

    // MARK: Public Props
    var viewState = ScreenStateSubject<NewSellerViewState>(nil)
    var errorState = ErrorStateSubject(nil)
    let responseSeller = CurrentValueSubject<SellerModel?, Never>(nil)

    // MARK: Initiliazer
    required init(repository: INewSellerRepository,
                  coordinator: INewSellerCoordinator,
                  uiModel: INewSellerUIModel) {
        self.repository = repository
        self.coordinator = coordinator
        self.uiModel = uiModel
    }

    func initComponents() {
        self.viewStateCustomerName()
    }
}


// MARK: Service
internal extension NewSellerViewModel {

    func saveNewSeller() {
        if let errorMessage = self.uiModel.errorMessage {
            errorState.value = .ERROR_MESSAGE(title: "Uyarı", msg: errorMessage)
            return
        }

        handleResourceFirestore(
            request: self.repository.saveNewSeller(data: self.uiModel.newSellerData,
                                                   season: self.uiModel.season),
            response: self.responseSeller,
            errorState: self.errorState,
            callbackLoading: { [weak self] isProgress in
                guard let self = self else { return }
                self.viewStateShowNativeProgress(isProgress: isProgress)
            }, callbackSuccess: { [weak self] in
                guard let self = self,
                    let response = self.responseSeller.value else { return }
                self.dismiss(completion: {
                    self.viewStateOutputDelegate(sellerModel: response)
                })
                
            })
    }
}

// MARK: States
internal extension NewSellerViewModel {

    // MARK: View State
    func viewStateShowNativeProgress(isProgress: Bool) {
        viewState.value = .showNativeProgress(isProgress: isProgress)
    }

    func viewStateCustomerName() {
        self.viewState.value = .setCustomerName(name: self.uiModel.customerName)
    }

    func viewStateOutputDelegate(sellerModel: SellerModel) {
        self.viewState.value = .outputDelegate(sellerModel: sellerModel)
    }
    
    func viewStateProductName(name: String) {
        self.viewState.value = .setProductName(name: name)
    }
}

// MARK: Coordinate
internal extension NewSellerViewModel {

    func dismiss(completion: (() -> Void)?) {
        self.coordinator.dismiss(completion: completion)
    }
    
    func presentProductListViewController() {
        self.coordinator.presentProductListViewController(outputDelegate: self)
    }
}


// MARK: Setter
internal extension NewSellerViewModel {
    
    func setProduct(id: String, name: String) {
        self.uiModel.setProduct(id: id, name: name)
    }

    func setKGPrice(_ value: String) {
        self.uiModel.setKGPrice(value)
    }

    func setKDV(_ value: String) {
        self.uiModel.setKDV(value)
    }

    func setDesc(_ value: String) {
        self.uiModel.setDesc(value)
    }
}

// MARK: ProductListViewControllerOutputDelegate
internal extension NewSellerViewModel {

    func getSelectionProduct(id: String, name: String) {
        self.setProduct(id: id, name: name)
        self.viewStateProductName(name: name)
    }
}


enum NewSellerViewState {
    case showNativeProgress(isProgress: Bool)
    case setCustomerName(name: String)
    case outputDelegate(sellerModel: SellerModel)
    case setProductName(name: String)
}
