//
//  ProductListViewModel.swift
//  berkel
//
//  Created by Onur Yilmaz on 18.11.2023.
//

import Combine

protocol IProductListViewModel: AnyObject {

    var viewState: ScreenStateSubject<ProductListViewState> { get }
    var errorState: ErrorStateSubject { get }
    var errorStateProduct: ErrorStateSubject { get }

    init(repository: IProductListRepository,
         coordinator: IProductListCoordinator,
         uiModel: IProductListUIModel)
    
    func getProducts()
    func saveProduct(product: ProductListModel)
    func getProduct(index: Int) -> ProductListModel
    
    // Coordinate
    func dismiss()
    
    // TableView
    func getNumberOfRowsInSection() -> Int
    func getItemCellUIModel(index: Int) -> ProductListTableViewCellUIModel
}

final class ProductListViewModel: BaseViewModel, IProductListViewModel {

    // MARK: Definitions
    private let repository: IProductListRepository
    private let coordinator: IProductListCoordinator
    private var uiModel: IProductListUIModel

    // MARK: Public Props
    var viewState = ScreenStateSubject<ProductListViewState>(nil)
    let response = CurrentValueSubject<[ProductListModel]?, Never>(nil)
    let responseProduct = CurrentValueSubject<ProductListModel?, Never>(nil)
    var errorState = ErrorStateSubject(nil)
    var errorStateProduct = ErrorStateSubject(nil)

    // MARK: Initiliazer
    required init(repository: IProductListRepository,
                  coordinator: IProductListCoordinator,
                  uiModel: IProductListUIModel) {
        self.repository = repository
        self.coordinator = coordinator
        self.uiModel = uiModel
    }

    func getProduct(index: Int) -> ProductListModel {
        return self.uiModel.getProduct(index: index)
    }
}


// MARK: Service
internal extension ProductListViewModel {

    func getProducts() {
        handleResourceFirestore(
            request: self.repository.getProductList(),
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
    
    func saveProduct(product: ProductListModel) {
        handleResourceFirestore(
            request: self.repository.saveProduct(data: product),
            response: self.responseProduct,
            errorState: self.errorStateProduct,
            callbackLoading: { [weak self] isProgress in
                guard let self = self else { return }
                self.viewStateShowNativeProgress(isProgress: isProgress)
            }, callbackSuccess: { [weak self] in
                guard let self = self,
                    let product = self.responseProduct.value else { return }

                self.uiModel.addProduct(product)
                self.viewStateReloadTableView()
            })
    }
}

// MARK: States
internal extension ProductListViewModel {

    // MARK: View State
    func viewStateShowNativeProgress(isProgress: Bool) {
        viewState.value = .showNativeProgress(isProgress: isProgress)
    }

    func viewStateReloadTableView() {
        viewState.value = .reloadTableView
    }
}

// MARK: Coordinate
internal extension ProductListViewModel {

    func dismiss() {
        self.coordinator.dismiss(completion: nil)
    }
}


//MARK: TableView
internal extension ProductListViewModel {

    func getNumberOfRowsInSection() -> Int {
        return uiModel.getNumberOfRowsInSection()
    }

    func getItemCellUIModel(index: Int) -> ProductListTableViewCellUIModel {
        return uiModel.getItemCellUIModel(index: index)
    }
}

enum ProductListViewState {
    case showNativeProgress(isProgress: Bool)
    case reloadTableView
}
