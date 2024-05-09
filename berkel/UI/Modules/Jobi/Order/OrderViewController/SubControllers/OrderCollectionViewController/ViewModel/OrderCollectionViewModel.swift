//
//  OrderCollectionViewModel.swift
//  berkel
//
//  Created by Onur Yilmaz on 16.04.2024.
//  Copyright (c) 2024 Berkel IOS Development Team. All rights reserved.[OY-2024]
//

import Foundation
import Combine

protocol IOrderCollectionViewModel: JBCustomerPriceViewControllerOutputDelegate {

    var viewState: ScreenStateSubject<OrderCollectionViewState> { get }
    var errorState: ErrorStateSubject { get }

    init(repository: IOrderCollectionRepository,
         jobiStockRepository: IJobiStockRepository,
         coordinator: IOrderCollectionCoordinator,
         uiModel: IOrderCollectionUIModel)

    // Init
    func initComponents()
    
    // Service
    func saveOrder()

    // Coordinate
    func presentJBCustomerPriceViewController()
    func dismiss()

    // Setter
    func setCount(_ count: String)
    func setKDV(_ kdv: String)
    func setDesc(_ desc: String)
}

final class OrderCollectionViewModel: BaseViewModel, IOrderCollectionViewModel {

    // MARK: Definitions
    private let repository: IOrderCollectionRepository
    private let jobiStockRepository: IJobiStockRepository
    private let coordinator: IOrderCollectionCoordinator
    private var uiModel: IOrderCollectionUIModel

    // MARK: Private Props
    var viewState = ScreenStateSubject<OrderCollectionViewState>(nil)
    var errorState = ErrorStateSubject(nil)
    var emptyErrorState = ErrorStateSubject(nil)
    let responseOrderCollection = CurrentValueSubject<OrderCollectionModel?, Never>(nil)
    let updateStockResponse = CurrentValueSubject<Bool?, Never>(false)
    let saveStockResponse = CurrentValueSubject<UpdateStockModel?, Never>(nil)

    // MARK: Initiliazer
    required init(repository: IOrderCollectionRepository,
                  jobiStockRepository: IJobiStockRepository,
                  coordinator: IOrderCollectionCoordinator,
                  uiModel: IOrderCollectionUIModel) {
        self.repository = repository
        self.jobiStockRepository = jobiStockRepository
        self.coordinator = coordinator
        self.uiModel = uiModel
    }

    func initComponents() {
        self.viewStateSetCustomerName()
    }

    func setCount(_ count: String) {
        self.uiModel.setCount(count)
    }

    func setKDV(_ kdv: String) {
        self.uiModel.setKDV(kdv)
    }

    func setDesc(_ desc: String) {
        self.uiModel.setDesc(desc)
    }
}


// MARK: Service
internal extension OrderCollectionViewModel {

    func saveOrder() {
        if let errorMessage = self.uiModel.errorMessage {
            errorState.value = .ERROR_MESSAGE(title: "Uyarı", msg: errorMessage)
            return
        }

        handleResourceFirestore(
            request: self.repository.saveOrder(data: self.uiModel.data,
                                            season: self.uiModel.season),
            response: self.responseOrderCollection,
            errorState: self.errorState,
            callbackLoading: { [weak self] isProgress in
                guard let self = self else { return }
                self.viewStateShowNativeProgress(isProgress: isProgress)
            }, callbackSuccess: { [weak self] in
                guard let self = self  else { return }
                self.viewStateDisableButton() // üst üste butona tıklanılmasın
                DispatchQueue.delay(100) { [weak self] in
                    self?.saveStock()
                }
            })
    }
    
    func saveStock() {
        var reRequest: Bool = true
        
        handleResourceFirestore(
            request: self.jobiStockRepository.saveSubStockInfo(season: uiModel.season,
                                                               stockId: uiModel.stockId ?? "",
                                                               subStockId: uiModel.subStockId ?? "",
                                                               data: uiModel.stockData),
            response: self.saveStockResponse,
            errorState: self.emptyErrorState,
            callbackLoading: { [weak self] isProgress in
                guard let self = self else { return }
                self.viewStateShowNativeProgress(isProgress: isProgress)
            }, callbackSuccess: { [weak self] in
                guard let self = self else { return }
                DispatchQueue.delay(300) { [weak self] in
                    self?.updateStockCount()
                }
            },
            callbackComplete: { [weak self] in
                DispatchQueue.delay(300) { [weak self] in
                    guard let self = self else { return }
                    if self.saveStockResponse.value == nil && reRequest {
                        self.saveStock()
                        reRequest = false
                    } else if self.saveStockResponse.value == nil {
                        self.viewStateShowSystemAlert(title: "!!! UYARI * DİKKAT !!!",
                                                      message: "Stoktan çıkarılamadı. Stoktan çıkarma işlemi yapınız.")
                    }
                }
            })
    }
    
    func updateStockCount() {
        var reRequest: Bool = true
        
        handleResourceFirestore(
            request: self.jobiStockRepository.updateSubStockCountWithTransaction(count: uiModel.getCount(),
                                                                                 season: uiModel.season,
                                                                                 stockId: uiModel.stockId ?? "",
                                                                                 subStockId: uiModel.subStockId ?? ""),
            response: self.updateStockResponse,
            errorState: self.emptyErrorState,
            callbackLoading: { [weak self] isProgress in
                guard let self = self else { return }
                self.viewStateShowNativeProgress(isProgress: isProgress)
            },
            callbackSuccess: { [weak self] in
                DispatchQueue.delay(300) { [weak self] in
                    guard let self = self, let isSuccess = self.updateStockResponse.value else { return }

                    if isSuccess {
                        self.dismiss()
                    }
                }
            },
            callbackComplete: { [weak self] in
                DispatchQueue.delay(300) { [weak self] in
                    guard let self = self else { return }
                    let isSuccess = self.updateStockResponse.value ?? false
                    if !isSuccess && reRequest {
                        self.updateStockCount()
                        reRequest = false
                    } else if !isSuccess {
                        self.viewStateShowSystemAlert(title: "!!! UYARI * DİKKAT !!!",
                                                      message: "Stok kaydedildi fakat Stok Sayısı güncellenemedi. Ana sayfadan güncelleme yapınız.")
                    }
                }
            })

    }

}

// MARK: States
internal extension OrderCollectionViewModel {

    // MARK: View State
    func viewStateShowNativeProgress(isProgress: Bool) {
        viewState.value = .showNativeProgress(isProgress: isProgress)
    }

    func viewStateSetCustomerName() {
        viewState.value = .setCustomerName(name: uiModel.customerName)
    }

    func viewStateSetProductName() {
        viewState.value = .setProductName(name: uiModel.productName)
    }

    func viewStateSetPrice() {
        viewState.value = .setPrice(price: uiModel.productPrice)
    }
    
    func viewStateDisableButton() {
        viewState.value = .disableButton
    }
    
    func viewStateShowSystemAlert(title: String, message: String) {
        viewState.value = .showSystemAlert(title: title, message: message)
    }
}

// MARK: Coordinate
internal extension OrderCollectionViewModel {
    
    func presentJBCustomerPriceViewController() {
        let passData = JBCustomerPricePassData(isPriceSelectable: true,
                                               customerModel: JBCustomerModel(id: uiModel.customerId,
                                                                              name: uiModel.customerName,
                                                                              phoneNumber: "",
                                                                              description: nil,
                                                                              date: nil))

        self.coordinator.presentJBCustomerPriceViewController(passData: passData,
                                                              outputDelegate: self)
    }

    func dismiss() {
        self.coordinator.dismiss(completion: nil)
    }
}

// MARK: JBCustomerPriceViewControllerOutputDelegate
internal extension OrderCollectionViewModel {

    func getJBCProductAndPrice(stockModel: StockModel, subStockModel: SubStockModel, price: Double) {
        self.uiModel.setStockModel(stockModel)
        self.uiModel.setSubStockModel(subStockModel)
        self.uiModel.setPrice(price)

        self.viewStateSetProductName()
        self.viewStateSetPrice()
    }
}

enum OrderCollectionViewState {
    case showNativeProgress(isProgress: Bool)
    case setCustomerName(name: String)
    case setProductName(name: String)
    case setPrice(price: String)
    case disableButton
    case showSystemAlert(title: String, message: String)
}
