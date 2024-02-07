//
//  OtherCollectionViewController.swift
//  berkel
//
//  Created by Onur Yilmaz on 28.01.2024.
//

import UIKit
import Combine

final class OtherCollectionViewController: BerkelBaseViewController {

    override var navigationTitle: String? {
        return "Hizmet Ekle"
    }

    // MARK: Constants

    // MARK: Inject
    private let viewModel: IOtherCollectionViewModel

    // MARK: IBOutlets
    @IBOutlet private weak var lblOtherSellerName: UILabel!
    @IBOutlet private weak var lblCategoryName: UILabel!
    @IBOutlet private weak var datePicker: UIDatePicker!

    @IBOutlet private weak var btnSave: UIButton!

    @IBOutlet private weak var tfPrice: PrimaryTextField!
    @IBOutlet private weak var tfDesc: PrimaryTextField!

    // MARK: Constraints Outlets

    // MARK: Initializer
    init(viewModel: IOtherCollectionViewModel) {
        self.viewModel = viewModel
        super.init(nibName: "OtherCollectionViewController", bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        return nil
    }

    override func initialComponents() {
        self.navigationItem.leftBarButtonItems = [closeBarButtonItem]
        self.observeReactiveDatas()

        self.initDatePickerView()
        self.viewModel.initComponents()
    }

    override func registerEvents() {

        btnSave.onTap { [unowned self] _ in
            self.viewModel.saveCollection()
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

            case .setOtherSellerName(let name):
                self.lblOtherSellerName.text = name

            case .setCategoryName(let name):
                self.lblCategoryName.text = name

            case .initCounts(let price, let desc):
                self.tfPrice.textField.text = price + " TL"
                self.tfDesc.textField.text = desc

            case .viewedData(let isVisible):
                self.btnSave.isHidden = !isVisible
                self.datePicker.isEnabled = isVisible
                self.tfPrice.textField.isEnabled = isVisible
                self.tfDesc.textField.isEnabled = isVisible
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
private extension OtherCollectionViewController {

    func initDatePickerView() {
        datePicker.addTarget(self, action: #selector(dueDateChanged(sender:)), for: UIControl.Event.valueChanged)
    }

    @objc func dueDateChanged(sender: UIDatePicker) {
        let date = sender.date.dateFormatterApiResponseType()
        self.viewModel.setDate(date: date)
    }
}


// MARK: TextField
private extension OtherCollectionViewController {

    func listenTextFieldsDidChange() {
        tfPrice.addListenDidChange { [unowned self] text in
            self.viewModel.setPrice(text)
        }

        tfDesc.addListenDidChange { [unowned self] text in
            self.viewModel.setDesc(text)
        }
    }
}
