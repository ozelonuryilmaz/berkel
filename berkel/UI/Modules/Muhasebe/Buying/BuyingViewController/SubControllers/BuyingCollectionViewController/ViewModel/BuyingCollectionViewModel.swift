//
//  BuyingCollectionViewModel.swift
//  berkel
//
//  Created by Onur Yilmaz on 10.10.2023.
//

import Foundation
import Combine

protocol IBuyingCollectionViewModel: AnyObject {

    var viewState: ScreenStateSubject<BuyingCollectionViewState> { get }
    var errorState: ErrorStateSubject { get }

    init(repository: IBuyingCollectionRepository,
         coordinator: IBuyingCollectionCoordinator,
         uiModel: IBuyingCollectionUIModel,
         successDismissCallBack: ((_ data: BuyingCollectionModel) -> Void)?)
    func initComponents()
    func dismiss()

    func updateResults()

    // Setter
    func setDate(date: String?)
    func setKantarFisi(_ text: String)
    func setPalet(_ text: String)
    func setRedCase(_ text: String)
    func setGreenCase(_ text: String)
    func set22BlackFoodCase(_ text: String)
    func setBigBlackCase(_ text: String)
    func setPercentFire(_ text: String)
    func setKgPrice(_ text: String)
    func setPaletDari(_ text: String)
    func setRedDari(_ text: String)
    func setGreenDari(_ text: String)
    func set22BlackDari(_ text: String)
    func setBigBlackDari(_ text: String)

    // Service
    func saveCollection()
}

final class BuyingCollectionViewModel: BaseViewModel, IBuyingCollectionViewModel {

    // MARK: Definitions
    private let repository: IBuyingCollectionRepository
    private let coordinator: IBuyingCollectionCoordinator
    private var uiModel: IBuyingCollectionUIModel
    var successDismissCallBack: ((_ data: BuyingCollectionModel) -> Void)? = nil

    // MARK: Private Props


    // MARK: Public Props
    var viewState = ScreenStateSubject<BuyingCollectionViewState>(nil)
    var errorState = ErrorStateSubject(nil)
    let response = CurrentValueSubject<BuyingCollectionModel?, Never>(nil)

    // MARK: Initiliazer
    required init(repository: IBuyingCollectionRepository,
                  coordinator: IBuyingCollectionCoordinator,
                  uiModel: IBuyingCollectionUIModel,
                  successDismissCallBack: ((_ data: BuyingCollectionModel) -> Void)?) {
        self.repository = repository
        self.coordinator = coordinator
        self.uiModel = uiModel
        self.successDismissCallBack = successDismissCallBack
    }

    func initComponents() {
        self.viewStateSellerName()

        // Sayfada veri görüntülenmesi yapılıyor. GÜncelleştir vs.
        if self.uiModel.isViewedPage {
            DispatchQueue.delay(150) { [weak self] in
                guard let self = self else { return }
                self.viewStateGetViewedPageData()
                self.updateResults()
            }
        }
    }

    func updateResults() {
        self.viewStateSetTotalKg()
        self.viewStateSetTotalPrice()
    }
}


// MARK: Service
internal extension BuyingCollectionViewModel {

    func saveCollection() {
        guard self.uiModel.getTotalPrice() != "0" else { return }

        handleResourceFirestore(
            request: self.repository.saveNewCollection(season: self.uiModel.season,
                                                       buyingId: self.uiModel.buyingId,
                                                       data: self.uiModel.data),
            response: self.response,
            errorState: self.errorState,
            callbackLoading: { [weak self] isProgress in
                guard let self = self else { return }
                self.viewStateShowNativeProgress(isProgress: isProgress)
            }, callbackSuccess: { [weak self] in
                guard let self = self,
                    let response = self.response.value else { return }
                self.successDismiss(data: response)
            })
    }

}

// MARK: States
internal extension BuyingCollectionViewModel {

    // MARK: View State
    func viewStateShowNativeProgress(isProgress: Bool) {
        viewState.value = .showNativeProgress(isProgress: isProgress)
    }

    func viewStateSellerName() {
        self.viewState.value = .setSellerAndProductNameAndKg(seller: self.uiModel.sellerName,
                                                             product: self.uiModel.productName,
                                                             kgPrice: self.uiModel.kgPrice)
    }

    func viewStateSetTotalKg() {
        self.viewState.value = .setTotalKg(kg: self.uiModel.getTotalKg())
    }

    func viewStateSetTotalPrice() {
        self.viewState.value = .setTotalPrice(price: self.uiModel.getTotalPrice())
    }

    func viewStateGetViewedPageData() {
        guard let data = self.uiModel.viewedData else { return }
        self.viewState.value = .getViewedPageData(data: data)
    }
}

// MARK: Coordinate
internal extension BuyingCollectionViewModel {

    func dismiss() {
        self.coordinator.dismiss(completion: nil)
    }

    func successDismiss(data: BuyingCollectionModel) {
        self.coordinator.dismiss(completion: { [weak self] in
            self?.successDismissCallBack?(data)
        })
    }
}


// MARK: Setter
internal extension BuyingCollectionViewModel {

    func setDate(date: String?) {
        self.uiModel.setDate(date: date)
    }

    func setKantarFisi(_ text: String) {
        self.uiModel.setKantarFisi(text)
    }

    func setPalet(_ text: String) {
        self.uiModel.setPalet(text)
    }

    func setRedCase(_ text: String) {
        self.uiModel.setRedCase(text)
    }

    func setGreenCase(_ text: String) {
        self.uiModel.setGreenCase(text)
    }

    func set22BlackFoodCase(_ text: String) {
        self.uiModel.set22BlackFoodCase(text)
    }

    func setBigBlackCase(_ text: String) {
        self.uiModel.setBigBlackCase(text)
    }

    func setPercentFire(_ text: String) {
        self.uiModel.setPercentFire(text)
    }

    func setKgPrice(_ text: String) {
        self.uiModel.setKgPrice(text)
    }

    func setPaletDari(_ text: String) {
        self.uiModel.setPaletDari(text)
    }

    func setRedDari(_ text: String) {
        self.uiModel.setRedDari(text)
    }

    func setGreenDari(_ text: String) {
        self.uiModel.setGreenDari(text)
    }

    func set22BlackDari(_ text: String) {
        self.uiModel.set22BlackDari(text)
    }

    func setBigBlackDari(_ text: String) {
        self.uiModel.setBigBlackDari(text)
    }

}


enum BuyingCollectionViewState {
    case showNativeProgress(isProgress: Bool)
    case setSellerAndProductNameAndKg(seller: String, product: String, kgPrice: Double)
    case setTotalKg(kg: String)
    case setTotalPrice(price: String)
    case getViewedPageData(data: BuyingCollectionModel)
}
