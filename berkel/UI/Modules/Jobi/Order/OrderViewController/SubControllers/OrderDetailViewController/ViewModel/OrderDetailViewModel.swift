//
//  OrderDetailViewModel.swift
//  berkel
//
//  Created by Onur Yilmaz on 16.04.2024.
//  Copyright (c) 2024 Berkel IOS Development Team. All rights reserved.[OY-2024]
//

import Foundation
import Combine

protocol IOrderDetailViewModel: OrderDetailCollectionDataSourceFactoryOutputDelegate {

    var viewState: ScreenStateSubject<OrderDetailViewState> { get }
    var errorState: ErrorStateSubject { get }

    init(repository: IOrderDetailRepository,
         jobiStockRepository: IJobiStockRepository,
         coordinator: IOrderDetailCoordinator,
         uiModel: IOrderDetailUIModel)

    var orderId: String { get }

    func initComponents()

    // Coordinate
    func presentNewSellerImageViewController(imagePathType: ImagePathType)

    // View State
    func viewStateSetNavigationTitle()
    
    func getInvoicePDFModel() -> [InvoicePDFModel]

    // Service
    func updateCalcForCollection(collectionId: String, isCalc: Bool)
    func updateFaturaNo(collectionId: String, faturaNo: String)
    func updateFaturaNo(paymentId: String, faturaNo: String)
    func updateSellerActive(completion: @escaping () -> Void)
    func deletePayment(uiModel: OrderPaymentModel)
    func deleteCollection(data: OrderCollectionModel)

    // for Table View
    func getNumberOfItemsInSection() -> Int
    func getCellUIModel(at index: Int) -> OrderDetailPaymentTableViewCellUIModel
}

final class OrderDetailViewModel: BaseViewModel, IOrderDetailViewModel {

    // MARK: Definitions
    private let repository: IOrderDetailRepository
    private let jobiStockRepository: IJobiStockRepository
    private let coordinator: IOrderDetailCoordinator
    private var uiModel: IOrderDetailUIModel

    // MARK: Private Props
    var viewState = ScreenStateSubject<OrderDetailViewState>(nil)
    var errorState = ErrorStateSubject(nil)
    var emptyErrorState = ErrorStateSubject(nil)
    let responsePayment = CurrentValueSubject<[OrderPaymentModel]?, Never>(nil)
    let responseCollection = CurrentValueSubject<[OrderCollectionModel]?, Never>(nil)
    let responseUpdateCalc = CurrentValueSubject<Bool?, Never>(nil)
    let responseUpdateFaturaNo = CurrentValueSubject<Bool?, Never>(nil)
    let responseUpdatePaymentFaturaNo = CurrentValueSubject<Bool?, Never>(nil)
    let responseUpdateActive = CurrentValueSubject<Bool?, Never>(nil)
    let responseDeletePayment = CurrentValueSubject<Bool?, Never>(nil)
    let responseDeleteCollection = CurrentValueSubject<Bool?, Never>(nil)
    let saveStockResponse = CurrentValueSubject<UpdateStockModel?, Never>(nil)
    let updateStockResponse = CurrentValueSubject<Bool?, Never>(false)

    var orderId: String {
        return self.uiModel.orderId
    }

    // MARK: Initiliazer
    required init(repository: IOrderDetailRepository,
                  jobiStockRepository: IJobiStockRepository,
                  coordinator: IOrderDetailCoordinator,
                  uiModel: IOrderDetailUIModel) {
        self.repository = repository
        self.jobiStockRepository = jobiStockRepository
        self.coordinator = coordinator
        self.uiModel = uiModel
    }

    func initComponents() {
        if self.uiModel.isActive { self.viewStateShowOrderActiveButton() }
        self.getDatas()
    }
    
    func getInvoicePDFModel() -> [InvoicePDFModel] {
        return uiModel.getInvoicePDFModel()
    }

    func reloadPage() {
        self.viewStateSetNavigationTitle()
        DispatchQueue.delay(250) { [weak self] in
            guard let self = self else { return }
            self.viewStateBuildCollectionSnapshot()
            self.viewStateReloadPaymentTableView()
            self.viewStateOldDoubt()
            self.viewStateNowDoubt()
        }
    }
}


// MARK: Service
internal extension OrderDetailViewModel {

    func getDatas() {
        self.getSellerCollection(completion: { [weak self] in
            guard let self = self else { return }
            DispatchQueue.delay(100) { [weak self] in
                guard let self = self else { return }
                self.getSellerPayment()
            }
        })
    }

    private func getSellerCollection(completion: @escaping () -> Void) {
        handleResourceFirestore(
            request: self.repository.getCollection(season: self.uiModel.season,
                                                   customerId: self.uiModel.customerId,
                                                   orderId: self.uiModel.orderId),
            response: self.responseCollection,
            errorState: self.errorState,
            callbackLoading: { [weak self] isProgress in
                guard let self = self else { return }
                self.viewStateShowNativeProgress(isProgress: isProgress)
            }, callbackSuccess: { [weak self] in
                guard let self = self,
                    let data = self.responseCollection.value else { return }
                self.uiModel.setCollectionResponse(data: data)
            }, callbackComplete: {
                completion()
            })
    }

    private func getSellerPayment() {
        handleResourceFirestore(
            request: self.repository.getPayment(season: self.uiModel.season,
                                                customerId: self.uiModel.customerId,
                                                orderId: self.uiModel.orderId),
            response: self.responsePayment,
            errorState: self.errorState,
            callbackLoading: { [weak self] isProgress in
                guard let self = self else { return }
                self.viewStateShowNativeProgress(isProgress: isProgress)
            }, callbackSuccess: { [weak self] in
                guard let self = self,
                    let data = self.responsePayment.value else { return }
                self.uiModel.setPaymentResponse(data: data)
                self.viewStateReloadPaymentTableView()
            }, callbackComplete: { [weak self] in
                guard let self = self else { return }
                self.reloadPage()
            })
    }

    func updateCalcForCollection(collectionId: String, isCalc: Bool) {
        handleResourceFirestore(
            request: self.repository.updateCollectionCalc(season: self.uiModel.season,
                                                          customerId: self.uiModel.customerId,
                                                          orderId: self.uiModel.orderId,
                                                          collectionId: collectionId,
                                                          isCalc: isCalc),
            response: self.responseUpdateCalc,
            errorState: self.errorState,
            callbackLoading: { [weak self] isProgress in
                guard let self = self else { return }
                self.viewStateShowNativeProgress(isProgress: isProgress)
            }, callbackSuccess: { [weak self] in
                guard let self = self else { return }
                self.uiModel.updateCalcForCollection(collectionId: collectionId, isCalc: isCalc)
                self.reloadPage()
            })
    }

    func updateFaturaNo(collectionId: String, faturaNo: String) {
        handleResourceFirestore(
            request: self.repository.updateFaturaNo(season: self.uiModel.season,
                                                    customerId: self.uiModel.customerId,
                                                    orderId: self.uiModel.orderId,
                                                    collectionId: collectionId,
                                                    faturaNo: faturaNo),
            response: self.responseUpdateFaturaNo,
            errorState: self.errorState,
            callbackLoading: { [weak self] isProgress in
                guard let self = self else { return }
                self.viewStateShowNativeProgress(isProgress: isProgress)
            }, callbackSuccess: { [weak self] in
                guard let self = self else { return }
                self.uiModel.updateFaturaNo(collectionId: collectionId, faturaNo: faturaNo)
                self.reloadPage()
            })
    }

    func updateFaturaNo(paymentId: String, faturaNo: String) {
        handleResourceFirestore(
            request: self.repository.updateFaturaNo(season: self.uiModel.season,
                                                    customerId: self.uiModel.customerId,
                                                    orderId: self.uiModel.orderId,
                                                    paymentId: paymentId,
                                                    faturaNo: faturaNo),
            response: self.responseUpdatePaymentFaturaNo,
            errorState: self.errorState,
            callbackLoading: { [weak self] isProgress in
                guard let self = self else { return }
                self.viewStateShowNativeProgress(isProgress: isProgress)
            }, callbackSuccess: { [weak self] in
                guard let self = self else { return }
                self.uiModel.updateFaturaNo(paymentId: paymentId, faturaNo: faturaNo)
                self.reloadPage()
            })
    }

    func updateSellerActive(completion: @escaping () -> Void) {
        handleResourceFirestore(
            request: self.repository.updateBuyingActive(season: self.uiModel.season,
                                                        orderId: self.uiModel.orderId,
                                                        isActive: false),
            response: self.responseUpdateActive,
            errorState: self.errorState,
            callbackLoading: { [weak self] isProgress in
                guard let self = self else { return }
                self.viewStateShowNativeProgress(isProgress: isProgress)
            }, callbackSuccess: { [weak self] in
                guard let self = self else { return }
                self.uiModel.setActive(isActive: false)
                self.viewStateCloseButtonTapped()

                completion()
                self.reloadPage()
            })
    }

    func deletePayment(uiModel: OrderPaymentModel) {
        guard let paymentId = uiModel.id else { return }

        handleResourceFirestore(
            request: self.repository.deletePayment(season: self.uiModel.season,
                                                   customerId: self.uiModel.customerId,
                                                   orderId: self.uiModel.orderId,
                                                   paymentId: paymentId),
            response: self.responseDeletePayment,
            errorState: self.errorState,
            callbackLoading: { [weak self] isProgress in
                guard let self = self else { return }
                self.viewStateShowNativeProgress(isProgress: isProgress)
            }, callbackSuccess: { [weak self] in
                guard let self = self else { return }
                self.getSellerPayment()
            })
    }

    func deleteCollection(data: OrderCollectionModel) {
        guard let collectionId = data.id else { return }

        handleResourceFirestore(
            request: self.repository.deleteCollection(season: self.uiModel.season,
                                                      customerId: self.uiModel.customerId,
                                                      orderId: self.uiModel.orderId,
                                                      collectionId: collectionId),
            response: self.responseDeleteCollection,
            errorState: self.errorState,
            callbackLoading: { [weak self] isProgress in
                guard let self = self else { return }
                self.viewStateShowNativeProgress(isProgress: isProgress)
            }, callbackSuccess: { [weak self] in
                guard let self = self else { return }

                self.addStockDataAgain(data: data)
            })
    }

    func addStockDataAgain(data: OrderCollectionModel) {
        var reRequest: Bool = true
        let stockData = UpdateStockModel(stockId: data.stockId,
                                         subStockId: data.subStockId,
                                         userId: self.uiModel.userId,
                                         count: data.count,
                                         date: Date().dateFormatterApiResponseType(),
                                         desc: "\(data.customerName) siparişi iptal edildi",
                                         type: UpdateStockType.add.rawValue)

        handleResourceFirestore(
            request: self.jobiStockRepository.saveSubStockInfo(season: self.uiModel.season,
                                                               stockId: data.stockId ?? "",
                                                               subStockId: data.subStockId ?? "",
                                                               data: stockData),
            response: self.saveStockResponse,
            errorState: self.emptyErrorState,
            callbackLoading: { [weak self] isProgress in
                guard let self = self else { return }
                self.viewStateShowNativeProgress(isProgress: isProgress)
            }, callbackSuccess: { [weak self] in
                guard let self = self else { return }
                DispatchQueue.delay(300) { [weak self] in
                    self?.updateStockCount(data: data)
                }
            },
            callbackComplete: { [weak self] in
                DispatchQueue.delay(300) { [weak self] in
                    guard let self = self else { return }
                    if self.saveStockResponse.value == nil && reRequest {
                        self.addStockDataAgain(data: data)
                        reRequest = false
                    } else if self.saveStockResponse.value == nil {
                        self.viewStateShowSystemAlert(title: "!!! UYARI * DİKKAT !!!",
                                                      message: "Stoktan çıkarılamadı. Stoktan çıkarma işlemi yapınız.")
                    }
                }
            })
    }

    func updateStockCount(data: OrderCollectionModel) {
        var reRequest: Bool = true

        handleResourceFirestore(
            request: self.jobiStockRepository.updateSubStockCountWithTransaction(count: data.count,
                                                                                 season: self.uiModel.season,
                                                                                 stockId: data.stockId ?? "",
                                                                                 subStockId: data.subStockId ?? ""),
            response: self.updateStockResponse,
            errorState: self.emptyErrorState,
            callbackLoading: { [weak self] isProgress in
                guard let self = self else { return }
                self.viewStateShowNativeProgress(isProgress: isProgress)
            }, callbackSuccess: { [weak self] in
                guard let self = self else { return }
                let isSuccess = self.updateStockResponse.value ?? false
                if isSuccess {
                    DispatchQueue.delay(300) { [weak self] in
                        self?.uiModel.deleteCollection(collectionId: data.id ?? "")
                        self?.reloadPage()
                    }
                }
            },
            callbackComplete: { [weak self] in
                DispatchQueue.delay(300) { [weak self] in
                    guard let self = self else { return }
                    let isSuccess = self.updateStockResponse.value ?? false
                    if !isSuccess && reRequest {
                        self.updateStockCount(data: data)
                        reRequest = false
                    } else if !isSuccess {
                        self.viewStateShowSystemAlert(title: "!!! UYARI * DİKKAT !!!",
                                                      message: "Stok kaydedildi fakat Stok Sayısı güncellenemedi. Ana sayfadan güncelleme yapınız.")
                    } else {
                        self.viewStateShowSystemAlert(title: "Sipariş iptal edildi. Stok güncellendi",
                                                      message: "")
                    }
                }
            })
    }
}

// MARK: States
internal extension OrderDetailViewModel {

    // MARK: View State
    func viewStateShowNativeProgress(isProgress: Bool) {
        viewState.value = .showNativeProgress(isProgress: isProgress)
    }

    func viewStateSetNavigationTitle() {
        self.viewState.value = .setNavigationTitle(title: self.uiModel.customerName, subTitle: "")
    }

    func viewStateOldDoubt() {
        self.viewState.value = .oldDoubt(text: self.uiModel.oldDoubt())
    }

    func viewStateNowDoubt() {
        self.viewState.value = .nowDoubt(text: self.uiModel.nowDoubt())
    }

    func viewStateBuildCollectionSnapshot() {
        viewState.value = .buildCollectionSnapshot(snapshot: self.uiModel.buildCollectionSnapshot())
    }

    func viewStateUpdateCollectionSnapshot(data: [OrderCollectionModel]) {
        viewState.value = .updateCollectionSnapshot(data: data)
    }

    func viewStateReloadPaymentTableView() {
        viewState.value = .reloadPaymentTableView
    }

    func viewStateShowUpdateCalcAlertMessage(collectionId: String, date: String, isCalc: Bool) {
        viewState.value = .showUpdateCalcAlertMessage(collectionId: collectionId, date: date, isCalc: isCalc)
    }

    func viewStateShowOrderActiveButton() {
        viewState.value = .showOrderActiveButton
    }

    func viewStateCloseButtonTapped() {
        viewState.value = .closeButtonTapped
    }

    func viewStateShowSystemAlert(title: String, message: String) {
        viewState.value = .showSystemAlert(title: title, message: message)
    }

    func viewStateDeleteCollection(data: OrderCollectionModel) {
        viewState.value = .deleteCollection(data: data)
    }

    func viewStateUpdateFaturaNo(collectionId: String) {
        viewState.value = .updateFaturaNo(collectionId: collectionId)
    }
}

// MARK: Coordinate
internal extension OrderDetailViewModel {

    func presentOrderCollectionViewController(passData: OrderCollectionPassData) {
        self.coordinator.presentOrderCollectionViewController(passData: passData)
    }

    func presentNewSellerImageViewController(imagePathType: ImagePathType) {
        let data = NewSellerImagePassData(imagePageType: .order(jbCustomerId: self.uiModel.customerId,
                                                                orderId: self.uiModel.orderId,
                                                                orderName: self.uiModel.customerName),
                                          imagePathType: imagePathType)

        self.coordinator.presentNewSellerImageViewController(passData: data)
    }
}

// MARK: TableView
internal extension OrderDetailViewModel {

    func getNumberOfItemsInSection() -> Int {
        return self.uiModel.getNumberOfItemsInSection()
    }

    func getCellUIModel(at index: Int) -> OrderDetailPaymentTableViewCellUIModel {
        return self.uiModel.getCellUIModel(at: index)
    }
}

// MARK: OrderDetailCollectionDataSourceFactoryOutputDelegate
internal extension OrderDetailViewModel {

    func cellTapped(uiModel: IOrderDetailCollectionTableViewCellUIModel) {
        // Tüm detay cell'de gösteriliyor
        /*guard let orderModel = uiModel.orderModel else { return }
        self.presentOrderCollectionViewController(
            passData: OrderCollectionPassData(orderModel: orderModel, orderCollectionModel: uiModel.orderCollectionModel)
        )*/
    }

    func appendFaturaTapped(uiModel: IOrderDetailCollectionTableViewCellUIModel) {
        guard let collectionId = uiModel.collectionId else { return }
        self.viewStateUpdateFaturaNo(collectionId: collectionId)
    }

    func cancelTapped(uiModel: IOrderDetailCollectionTableViewCellUIModel) {
        guard let data = uiModel.orderCollectionModel else { return }
        self.viewStateDeleteCollection(data: data)
    }
}

enum OrderDetailViewState {
    case showNativeProgress(isProgress: Bool)
    case setNavigationTitle(title: String, subTitle: String)
    case oldDoubt(text: String)
    case nowDoubt(text: String)
    case buildCollectionSnapshot(snapshot: OrderDetailCollectionSnapshot)
    case updateCollectionSnapshot(data: [OrderCollectionModel])
    case reloadPaymentTableView
    case showUpdateCalcAlertMessage(collectionId: String, date: String, isCalc: Bool)
    case showOrderActiveButton
    case closeButtonTapped
    case showSystemAlert(title: String, message: String)
    case deleteCollection(data: OrderCollectionModel)
    case updateFaturaNo(collectionId: String)
}
