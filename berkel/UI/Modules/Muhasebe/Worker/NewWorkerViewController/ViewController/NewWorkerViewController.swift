//
//  NewWorkerViewController.swift
//  berkel
//
//  Created by Onur Yilmaz on 31.10.2023.
//

import UIKit
import Combine

protocol NewWorkerViewControllerOutputDelegate: AnyObject {
    func newWorkerData(_ data: WorkerModel)
}

final class NewWorkerViewController: BerkelBaseViewController {
    
    override var navigationTitle: String? {
        return "Yeni İşçi Oluştur"
    }

    // MARK: Constants

    // MARK: Inject
    private let viewModel: INewWorkerViewModel
    private weak var outputDelegate: NewWorkerViewControllerOutputDelegate? = nil

    // MARK: IBOutlets
    @IBOutlet private weak var lblCavusName: UILabel!
    @IBOutlet private weak var tfCavusPrice: PrimaryTextField!
    @IBOutlet private weak var tfKesiciPrice: PrimaryTextField!
    @IBOutlet private weak var tfAyakciPrice: PrimaryTextField!
    @IBOutlet private weak var tfServisPrice: PrimaryTextField!
    @IBOutlet private weak var tfGarden: PrimaryTextField!
    @IBOutlet private weak var tfDesc: PrimaryTextField!
    @IBOutlet private weak var btnSave: UIButton!

    // MARK: Constraints Outlets

    // MARK: Initializer
    init(viewModel: INewWorkerViewModel,
         outputDelegate: NewWorkerViewControllerOutputDelegate?) {
        self.viewModel = viewModel
        self.outputDelegate = outputDelegate
        super.init(nibName: "NewWorkerViewController", bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        return nil
    }

    override func initialComponents() {
        self.navigationItem.leftBarButtonItems = [closeBarButtonItem]
        self.observeReactiveDatas()
        
        self.viewModel.initComponents()
    }

    override func registerEvents() {
        
        btnSave.onTap { [unowned self] _ in
            self.viewModel.saveNewWorker()
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

            case .setCavusName(let name):
                self.lblCavusName.text = name
                
            case .outputDelegate(let workerModel):
                self.outputDelegate?.newWorkerData(workerModel)
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
            self.viewModel.dismiss(completion: nil)
        }
    }()
}

// MARK: Props
private extension NewWorkerViewController {

    func listenTextFieldsDidChange() {
        tfCavusPrice.addListenDidChange { [unowned self] text in
            self.viewModel.setCavusPrice(text)
        }
        
        tfKesiciPrice.addListenDidChange { [unowned self] text in
            self.viewModel.setKesiciPrice(text)
        }
        
        tfAyakciPrice.addListenDidChange { [unowned self] text in
            self.viewModel.setAyakciPrice(text)
        }
        
        tfServisPrice.addListenDidChange { [unowned self] text in
            self.viewModel.setServisPrice(text)
        }
        
        tfGarden.addListenDidChange { [unowned self] text in
            self.viewModel.setGarden(text)
        }
        
        tfDesc.addListenDidChange { [unowned self] text in
            self.viewModel.setDesc(text)
        }
    }
    
}
