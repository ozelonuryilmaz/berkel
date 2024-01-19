//
//  NewOtherSellerViewController.swift
//  berkel
//
//  Created by Onur Yilmaz on 19.01.2024.
//

import UIKit
import Combine

protocol NewOtherSellerViewControllerOutputDelegate: AnyObject {
    func otherSellerData(_ data: OtherSellerModel)
}

final class NewOtherSellerViewController: BerkelBaseViewController {

    override var navigationTitle: String? {
        return "Diğer Satıcı Ekle"
    }

    // MARK: Constants

    // MARK: Inject
    private let viewModel: INewOtherSellerViewModel
    private var outputDelegate: NewOtherSellerViewControllerOutputDelegate? = nil

    // MARK: IBOutlets

    // MARK: Constraints Outlets

    // MARK: Initializer
    init(viewModel: INewOtherSellerViewModel,
         outputDelegate: NewOtherSellerViewControllerOutputDelegate?) {
        self.viewModel = viewModel
        self.outputDelegate = outputDelegate
        super.init(nibName: "NewOtherSellerViewController", bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        return nil
    }

    override func initialComponents() {
        self.navigationItem.leftBarButtonItems = [closeBarButtonItem]
        self.observeReactiveDatas()
    }

    override func registerEvents() {

    }

    private func observeReactiveDatas() {
        observeViewState()
        listenErrorState()
    }

    private func observeViewState() {
        viewModel.viewState.sink(receiveValue: { [weak self] states in
            guard let self = self, let states = states else { return }

            switch states {
            case .showNativeProgress(let isProgress):
                self.playNativeLoading(isLoading: isProgress)

            }

        }).store(in: &cancelBag)
    }

    private func listenErrorState() {
        let errorHandle = FirestoreErrorHandle(viewController: self)
        observeErrorState(errorState: viewModel.errorState,
                          errorHandle: errorHandle)
    }

    // MARK: Define Components
    private lazy var closeBarButtonItem: UIBarButtonItem = {
        return UIBarButtonItem(image: .closeNav) { [unowned self] _ in
            self.viewModel.dismiss()
        }
    }()
}

// MARK: Props
private extension NewOtherSellerViewController {

}
