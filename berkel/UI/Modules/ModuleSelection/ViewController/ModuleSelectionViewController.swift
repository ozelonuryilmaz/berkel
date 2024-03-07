//
//  ModuleSelectionViewController.swift
//  berkel
//
//  Created by Onur Yilmaz on 7.03.2024.
//

import UIKit
import Combine

final class ModuleSelectionViewController: BerkelBaseViewController {

    // MARK: Constants

    // MARK: Inject
    private let viewModel: IModuleSelectionViewModel

    // MARK: IBOutlets
    @IBOutlet private weak var btnAccouting: UIButton!
    @IBOutlet private weak var btnCost: UIButton!
    @IBOutlet private weak var lblSeasonTitle: UILabel!

    // MARK: Constraints Outlets

    // MARK: Initializer
    init(viewModel: IModuleSelectionViewModel) {
        self.viewModel = viewModel
        super.init(nibName: "ModuleSelectionViewController", bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        return nil
    }

    override func initialComponents() {
        self.observeReactiveDatas()
        self.visibleNavigationBar(isVisible: false)
        self.viewModel.viewStateSetSeasonTitle()
    }

    override func registerEvents() {

        btnAccouting.onTap { [unowned self] _ in
            self.selfDismiss(completion: {
                self.appDelegate.startFlowMain()
            })
        }
        
        btnCost.onTap { [unowned self] _ in
            self.selfDismiss(completion: {
                self.appDelegate.startFlowJobi()
            })
        }
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
            case .setSeasonTitle(let title):
                self.lblSeasonTitle.text = title
            }

        }).store(in: &cancelBag)
    }

    private func listenErrorState() {
        let errorHandle = FirestoreErrorHandle(viewController: self)
        observeErrorState(errorState: viewModel.errorState,
                          errorHandle: errorHandle)
    }

    // MARK: Define Components
}

// MARK: Props
private extension ModuleSelectionViewController {

}
