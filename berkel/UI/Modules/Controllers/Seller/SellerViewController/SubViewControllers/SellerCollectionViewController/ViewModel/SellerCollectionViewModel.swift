//
//  SellerCollectionViewModel.swift
//  berkel
//
//  Created by Onur Yilmaz on 24.11.2023.
//

import Combine

protocol ISellerCollectionViewModel: AnyObject {

    var viewState: ScreenStateSubject<SellerCollectionViewState> { get }
    var errorState: ErrorStateSubject { get }

    init(repository: ISellerCollectionRepository,
         coordinator: ISellerCollectionCoordinator,
         uiModel: ISellerCollectionUIModel)

    func initComponents()
    func updateResults()

    // Coordiante
    func dismiss()

    // Setter
    func setDate(date: String?)
    func setDaraliKG(_ text: String)
    func setDara(_ text: String)
    func setPrice(_ text: String)
    func setKDV(_ text: String)
    func setFaturaNo(_ text: String)
    func setPalet(_ text: String)
    func setKasa(_ text: String)
    func setDesc(_ text: String)

    // Service
    func saveCollection()
}

final class SellerCollectionViewModel: BaseViewModel, ISellerCollectionViewModel {

    // MARK: Definitions
    private let repository: ISellerCollectionRepository
    private let coordinator: ISellerCollectionCoordinator
    private var uiModel: ISellerCollectionUIModel

    // MARK: Public Props
    var viewState = ScreenStateSubject<SellerCollectionViewState>(nil)
    var errorState = ErrorStateSubject(nil)
    let response = CurrentValueSubject<SellerCollectionModel?, Never>(nil)

    // MARK: Initiliazer
    required init(repository: ISellerCollectionRepository,
                  coordinator: ISellerCollectionCoordinator,
                  uiModel: ISellerCollectionUIModel) {
        self.repository = repository
        self.coordinator = coordinator
        self.uiModel = uiModel
    }

    func initComponents() {
        self.viewStateSetCustomerName()
        self.viewStateSetProductName()
        self.viewStateSetPrice()
        self.viewStateSetKDV()

        self.viewStateViewedData()
        self.viewStateInitCount()

        if !self.uiModel.viewedData {
            self.updateResults()
        }
    }

    func updateResults() {
        self.viewStateSetTotalKg()
        self.viewStateSetTotalPrice()
    }
}


// MARK: Service
internal extension SellerCollectionViewModel {


    func saveCollection() {
        if let errorMessage = self.uiModel.errorMessage {
            errorState.value = .ERROR_MESSAGE(title: "Uyarı", msg: errorMessage)
            return
        }

        handleResourceFirestore(
            request: self.repository.saveNewCollection(season: self.uiModel.season,
                                                       sellerId: self.uiModel.sellerId ?? "",
                                                       data: self.uiModel.data),
            response: self.response,
            errorState: self.errorState,
            callbackLoading: { [weak self] isProgress in
                guard let self = self else { return }
                self.viewStateShowNativeProgress(isProgress: isProgress)
            }, callbackSuccess: { [weak self] in
                guard let self = self else { return }
                self.dismiss()
            })
    }
}

// MARK: States
internal extension SellerCollectionViewModel {

    // MARK: View State
    func viewStateShowNativeProgress(isProgress: Bool) {
        viewState.value = .showNativeProgress(isProgress: isProgress)
    }

    func viewStateSetCustomerName() {
        self.viewState.value = .setCustomerName(name: self.uiModel.customerName)
    }

    func viewStateSetProductName() {
        self.viewState.value = .setProductName(name: self.uiModel.productName)
    }

    func viewStateSetPrice() {
        self.viewState.value = .setPrice(name: self.uiModel.price.format())
    }

    func viewStateSetKDV() {
        self.viewState.value = .setKDV(name: self.uiModel.kdv.format())
    }

    func viewStateSetTotalKg() {
        self.viewState.value = .setTotalKg(kg: self.uiModel.getTotalKg())
    }

    func viewStateSetTotalPrice() {
        self.viewState.value = .setTotalPrice(price: self.uiModel.getTotalPrice())
    }
    
    func viewStateInitCount() {
        guard let data = self.uiModel.sellerCollectionModel else { return }
        self.viewState.value = .initCounts(daraliKG: data.daraliKg,
                                           dara: data.dara,
                                           faturaNo: data.faturaNo,
                                           palet: data.palet,
                                           kasa: data.kasa,
                                           desc: data.desc)
    }

    func viewStateViewedData() {
        self.viewState.value = .viewedData(isVisible: self.uiModel.viewedData)
    }
}

// MARK: Coordinate
internal extension SellerCollectionViewModel {

    func dismiss() {
        self.coordinator.dismiss(completion: nil)
    }
}

// MARK: Setter
internal extension SellerCollectionViewModel {

    func setDate(date: String?) {
        self.uiModel.setDate(date: date)
    }

    func setDaraliKG(_ text: String) {
        self.uiModel.setDaraliKG(text)
    }

    func setDara(_ text: String) {
        self.uiModel.setDara(text)
    }

    func setPrice(_ text: String) {
        self.uiModel.setPrice(text)
    }

    func setKDV(_ text: String) {
        self.uiModel.setKDV(text)
    }

    func setFaturaNo(_ text: String) {
        self.uiModel.setFaturaNo(text)
    }

    func setPalet(_ text: String) {
        self.uiModel.setPalet(text)
    }

    func setKasa(_ text: String) {
        self.uiModel.setKasa(text)
    }

    func setDesc(_ text: String) {
        self.uiModel.setDesc(text)
    }

}

enum SellerCollectionViewState {
    case showNativeProgress(isProgress: Bool)
    case setCustomerName(name: String)
    case setProductName(name: String)
    case setPrice(name: String)
    case setKDV(name: String)
    case setTotalKg(kg: String)
    case setTotalPrice(price: String)
    case initCounts(daraliKG: Int, dara: Int, faturaNo: String, palet: Int, kasa: Int, desc: String)
    case viewedData(isVisible: Bool)
}
