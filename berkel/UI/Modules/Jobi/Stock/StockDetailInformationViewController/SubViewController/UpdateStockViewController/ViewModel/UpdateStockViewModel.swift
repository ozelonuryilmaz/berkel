//
//  UpdateStockViewModel.swift
//  berkel
//
//  Created by Onur Yilmaz on 7.04.2024.
//  Copyright (c) 2024 Berkel IOS Development Team. All rights reserved.[OY-2024]
//

import Foundation
import Combine

protocol IUpdateStockViewModel: AnyObject {

    var viewState: ScreenStateSubject<UpdateStockViewState> { get }
    var errorState: ErrorStateSubject { get }

    var navigationTitle: String { get }
    var navigationSubTitle: String { get }

    init(repository: IUpdateStockRepository,
         jobiStockRepository: IJobiStockRepository,
         coordinator: IUpdateStockCoordinator,
         uiModel: IUpdateStockUIModel)

    func initComponents()
    func dismiss()

    // Setter
    func setDate(date: String?)
    func setCount(_ text: String)
    func setDesc(_ text: String)

    // Service
    func saveStock()
}

final class UpdateStockViewModel: BaseViewModel, IUpdateStockViewModel {

    // MARK: Definitions
    private let repository: IUpdateStockRepository
    private let jobiStockRepository: IJobiStockRepository
    private let coordinator: IUpdateStockCoordinator
    private var uiModel: IUpdateStockUIModel

    // MARK: Private Props
    var viewState = ScreenStateSubject<UpdateStockViewState>(nil)
    var errorState = ErrorStateSubject(nil)
    let response = CurrentValueSubject<UpdateStockModel?, Never>(nil)
    let updateStockResponse = CurrentValueSubject<Bool?, Never>(nil)

    // MARK: Initiliazer
    required init(repository: IUpdateStockRepository,
                  jobiStockRepository: IJobiStockRepository,
                  coordinator: IUpdateStockCoordinator,
                  uiModel: IUpdateStockUIModel) {
        self.repository = repository
        self.jobiStockRepository = jobiStockRepository
        self.coordinator = coordinator
        self.uiModel = uiModel
    }

    func initComponents() {
        self.viewStateSetButtonTitle()
    }

    var navigationTitle: String {
        return uiModel.navigationTitle
    }

    var navigationSubTitle: String {
        return uiModel.navigationSubTitle
    }
}


// MARK: Service
internal extension UpdateStockViewModel {

    func saveStock() {
        guard self.uiModel.getCount() != 0 else { return }

        handleResourceFirestore(
            request: self.jobiStockRepository.saveStockInfo(season: uiModel.season,
                                                            stockId: uiModel.stockId,
                                                            subStockId: uiModel.subStockId,
                                                            data: uiModel.data),
            response: self.response,
            errorState: self.errorState,
            callbackLoading: { [weak self] isProgress in
                guard let self = self else { return }
                self.viewStateShowNativeProgress(isProgress: isProgress)
            }, callbackSuccess: { [weak self] in
                guard let self = self else { return }
                self.viewStateDisableButton() // üst üste butona tıklanılmasın
                DispatchQueue.delay(300) { [weak self] in
                    self?.updateStockCount()
                }
            })
    }

    // Delay kaldırıldığıda hata veriyor
    private func updateStockCount() {
        var reRequest: Bool = true

        handleResourceFirestore(
            request: self.jobiStockRepository.updateStockCount(count: uiModel.getCount(),
                                                               season: uiModel.season,
                                                               stockId: uiModel.stockId,
                                                               subStockId: uiModel.subStockId),
            response: self.updateStockResponse,
            errorState: self.errorState,
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
                    guard let self = self, let isSuccess = self.updateStockResponse.value else { return }
                    if !isSuccess && reRequest {
                        self.updateStockCount()
                        reRequest = false
                    } else if !isSuccess {
                        self.viewStateShowSystemAlert(title: "UYARI!",
                                                      message: "Stok kaydedildi fakat Stok Sayısı güncellenemedi. Ana sayfadan güncelleme yapınız.")
                    }
                }
            })
    }
}

// MARK: States
internal extension UpdateStockViewModel {

    // MARK: View State
    func viewStateShowNativeProgress(isProgress: Bool) {
        viewState.value = .showNativeProgress(isProgress: isProgress)
    }

    func viewStateSetButtonTitle() {
        viewState.value = .setButtonTitle(title: uiModel.buttonTitle)
    }

    func viewStateDisableButton() {
        viewState.value = .disableButton
    }

    func viewStateShowSystemAlert(title: String, message: String) {
        viewState.value = .showSystemAlert(title: title, message: message)
    }
}

// MARK: Coordinate
internal extension UpdateStockViewModel {

    func dismiss() {
        self.coordinator.dismiss(completion: nil)
    }
}

// MARK: Setter
internal extension UpdateStockViewModel {

    func setDate(date: String?) {
        self.uiModel.setDate(date: date)
    }

    func setCount(_ text: String) {
        self.uiModel.setCount(text)
    }

    func setDesc(_ text: String) {
        self.uiModel.setDesc(text)
    }
}

enum UpdateStockViewState {
    case showNativeProgress(isProgress: Bool)
    case setButtonTitle(title: String)
    case disableButton
    case showSystemAlert(title: String, message: String)
}
