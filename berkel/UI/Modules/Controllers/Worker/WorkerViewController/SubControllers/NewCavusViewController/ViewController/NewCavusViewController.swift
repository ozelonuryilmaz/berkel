//
//  NewCavusViewController.swift
//  berkel
//
//  Created by Onur Yilmaz on 31.10.2023.
//

import UIKit
import Combine

protocol NewCavusViewControllerOutputDelegate: AnyObject {
    func newCavusData(_ data: CavusModel)
}

final class NewCavusViewController: BerkelBaseViewController {
    
    override var navigationTitle: String? {
        return "Yeni Çavuş Ekle"
    }

    // MARK: Constants

    // MARK: Inject
    private let viewModel: INewCavusViewModel
    private weak var outputDelegate: NewCavusViewControllerOutputDelegate? = nil

    // MARK: IBOutlets
    @IBOutlet private weak var tfName: PrimaryTextField!
    @IBOutlet private weak var tfPhone: PrimaryTextField!
    @IBOutlet private weak var tfDesc: PrimaryTextField!
    @IBOutlet private weak var btnSave: UIButton!

    // MARK: Constraints Outlets

    // MARK: Initializer
    init(viewModel: INewCavusViewModel,
         outputDelegate: NewCavusViewControllerOutputDelegate?) {
        self.viewModel = viewModel
        self.outputDelegate = outputDelegate
        super.init(nibName: "NewCavusViewController", bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        return nil
    }

    override func initialComponents() {
        self.navigationItem.leftBarButtonItems = [closeBarButtonItem]
        self.observeReactiveDatas()
    }

    override func registerEvents() {

        btnSave.onTap { [unowned self] _ in
            self.viewModel.saveNewCavus()
        }
    }

    private func observeReactiveDatas() {
        observeViewState()
        listenErrorState()
        listenTextFieldsDidChange()
    }

    private func observeViewState() {
        viewModel.viewState.sink(receiveValue: { [weak self] states in
            guard let self = self, let states = states else { return }

            switch states {
            case .showNativeProgress(let isProgress):
                self.playNativeLoading(isLoading: isProgress)
                
            case .showSavedCavus(let data):
                self.outputDelegate?.newCavusData(data)
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
private extension NewCavusViewController {

}

// MARK: TextField
private extension NewCavusViewController {

    func listenTextFieldsDidChange() {
        tfName.addListenDidChange { [unowned self] text in
            self.viewModel.setName(text)
        }
        
        tfPhone.addListenDidChange { [unowned self] text in
            self.viewModel.setPhone(text)
        }
        
        tfDesc.addListenDidChange { [unowned self] text in
            self.viewModel.setDesc(text)
        }
    }
}
