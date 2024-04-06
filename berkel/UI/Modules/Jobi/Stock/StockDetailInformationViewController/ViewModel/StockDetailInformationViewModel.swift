//
//  StockDetailInformationViewModel.swift
//  berkel
//
//  Created by Onur Yilmaz on 20.03.2024.
//

import Combine

protocol IStockDetailInformationViewModel: AnyObject {

    var viewState: ScreenStateSubject<StockDetailInformationViewState> { get }
    var errorState: ErrorStateSubject { get }

    var navigationTitle: String { get }
    var navigationSubTitle: String { get }

    init(repository: IStockDetailInformationRepository,
         jobiStockRepository: IJobiStockRepository,
         coordinator: IStockDetailInformationCoordinator,
         uiModel: IStockDetailInformationUIModel)
    
    // Service
    func updateStockCount(_ count: Int)
}

final class StockDetailInformationViewModel: BaseViewModel, IStockDetailInformationViewModel {

    // MARK: Definitions
    private let repository: IStockDetailInformationRepository
    private let jobiStockRepository: IJobiStockRepository
    private let coordinator: IStockDetailInformationCoordinator
    private var uiModel: IStockDetailInformationUIModel

    // MARK: Public Props
    var viewState = ScreenStateSubject<StockDetailInformationViewState>(nil)
    var errorState = ErrorStateSubject(nil)
    let response = CurrentValueSubject<Bool?, Never>(nil)

    // MARK: Initiliazer
    required init(repository: IStockDetailInformationRepository,
                  jobiStockRepository: IJobiStockRepository,
                  coordinator: IStockDetailInformationCoordinator,
                  uiModel: IStockDetailInformationUIModel) {
        self.repository = repository
        self.jobiStockRepository = jobiStockRepository
        self.coordinator = coordinator
        self.uiModel = uiModel
    }

    var navigationTitle: String {
        return uiModel.navigationTitle
    }

    var navigationSubTitle: String {
        return uiModel.navigationSubTitle
    }
}


// MARK: Service
internal extension StockDetailInformationViewModel {

    // TODO: Count yüklenemediğinde kullanıcıya uyarı göster! Güncelleme işlemini başlat. Güncelleme işleminde stoğa yeni giriş yapılmamışsa güncelle.
    func updateStockCount(_ count: Int) {
        var reRequest: Bool = true
        
        handleResourceFirestore(
            request: self.jobiStockRepository.updateStockCount(count: count,
                                                               season: self.uiModel.season,
                                                               stockId: self.uiModel.stockId,
                                                               subStockId: self.uiModel.subStockId),
            response: self.response,
            errorState: self.errorState,
            callbackLoading: { [weak self] isProgress in
                self?.viewStateShowNativeProgress(isProgress: isProgress)
            }, callbackSuccess: { [weak self] in
                guard let self = self, let isSuccess = self.response.value else { return }
                if isSuccess {
                    reRequest = true
                }
            },
            callbackComplete: { [weak self] in
                guard let self = self, let isSuccess = self.response.value else { return }
                if !isSuccess && reRequest {
                    self.updateStockCount(count)
                    reRequest = false
                }
            })
    }
}

// MARK: States
internal extension StockDetailInformationViewModel {

    // MARK: View State
    func viewStateShowNativeProgress(isProgress: Bool) {
        viewState.value = .showNativeProgress(isProgress: isProgress)
    }

}

// MARK: Coordinate
internal extension StockDetailInformationViewModel {

}


enum StockDetailInformationViewState {
    case showNativeProgress(isProgress: Bool)
}
