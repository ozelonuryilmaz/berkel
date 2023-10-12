//
//  BuyingCollectionViewModel.swift
//  berkel
//
//  Created by Onur Yilmaz on 10.10.2023.
//  Copyright (c) 2023 Emlakjet IOS Development Team. All rights reserved.[EC-2021]
//

protocol IBuyingCollectionViewModel: AnyObject {
    
    var viewState: ScreenStateSubject<BuyingCollectionViewState> { get }
    var errorState: ErrorStateSubject { get }

    init(repository: IBuyingCollectionRepository,
         coordinator: IBuyingCollectionCoordinator,
         uiModel: IBuyingCollectionUIModel,
         successDismissCallBack: ((_ data: BuyingCollectionModel) -> Void)?)
    func initComponents()
    func dismiss()
    
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
    }

}


// MARK: Service
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

// MARK: States
internal extension BuyingCollectionViewModel {

    // MARK: View State
    func viewStateSellerName() {
        self.viewState.value = .setSellerAndProductNameAndKg(seller: self.uiModel.sellerName,
                                                        product: self.uiModel.productName,
                                                        kgPrice: self.uiModel.kgPrice)
    }

}

// MARK: Coordinate
internal extension BuyingCollectionViewModel {

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
    case setSellerAndProductNameAndKg(seller: String, product: String, kgPrice: Double)
}
