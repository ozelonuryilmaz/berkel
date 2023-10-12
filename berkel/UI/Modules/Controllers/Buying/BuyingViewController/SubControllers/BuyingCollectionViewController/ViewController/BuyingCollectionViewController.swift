//
//  BuyingCollectionViewController.swift
//  berkel
//
//  Created by Onur Yilmaz on 10.10.2023.
//  Copyright (c) 2023 Emlakjet IOS Development Team. All rights reserved.[EC-2021]
//

import UIKit

final class BuyingCollectionViewController: BerkelBaseViewController {

    override var navigationTitle: String? {
        return "Toplama"
    }

    // MARK: Constants

    // MARK: Inject
    private let viewModel: IBuyingCollectionViewModel

    // MARK: IBOutlets
    @IBOutlet private weak var lblSellerName: UILabel!
    @IBOutlet private weak var lblProductName: UILabel!
    @IBOutlet private weak var datePicker: UIDatePicker!

    @IBOutlet private weak var lblTotalKG: UILabel!
    @IBOutlet private weak var lblTotalPrice: UILabel!

    @IBOutlet private weak var btnSave: UIButton!

    @IBOutlet private weak var tfKantarFisi: PrimaryTextField!
    @IBOutlet private weak var tfPalet: PrimaryTextField!
    @IBOutlet private weak var tfRedCase: PrimaryTextField!
    @IBOutlet private weak var tfGreenCase: PrimaryTextField!
    @IBOutlet private weak var tf22BlackFoodCase: PrimaryTextField!
    @IBOutlet private weak var tfBigBlackCase: PrimaryTextField!
    @IBOutlet private weak var tfPercentFire: PrimaryTextField!
    @IBOutlet private weak var tfKgPrice: PrimaryTextField!
    @IBOutlet private weak var tfPaletDari: PrimaryTextField!
    @IBOutlet private weak var tfRedDari: PrimaryTextField!
    @IBOutlet private weak var tfGreenDari: PrimaryTextField!
    @IBOutlet private weak var tf22BlackDari: PrimaryTextField!
    @IBOutlet private weak var tfBigBlackDari: PrimaryTextField!


    // MARK: Constraints Outlets

    // MARK: Initializer
    init(viewModel: IBuyingCollectionViewModel) {
        self.viewModel = viewModel
        super.init(nibName: "BuyingCollectionViewController", bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        return nil
    }

    override func initialComponents() {
        self.navigationItem.leftBarButtonItems = [closeBarButtonItem]
        self.observeReactiveDatas()
    }

    override func setupView() {
        self.viewModel.initComponents()
        initDatePickerView()
    }

    override func registerEvents() {

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
            case .setSellerAndProductNameAndKg(let seller, let product, let kgPrice):
                self.lblSellerName.text = seller
                self.lblProductName.text = "(\(product))"
                self.tfKgPrice.placeholder = String(kgPrice)
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
private extension BuyingCollectionViewController {

    func initDatePickerView() {
        datePicker.addTarget(self, action: #selector(dueDateChanged(sender:)), for: UIControl.Event.valueChanged)
    }

    @objc func dueDateChanged(sender: UIDatePicker) {
        let date = sender.date.dateFormatterApiResponseType()
        self.viewModel.setDate(date: date)
    }
}

// MARK: TextField
private extension BuyingCollectionViewController {

    func listenTextFieldsDidChange() {
        tfKantarFisi.addListenDidChange { [unowned self] text in
            self.viewModel.setKantarFisi(text)
        }

        tfPalet.addListenDidChange { [unowned self] text in
            self.viewModel.setPalet(text)
        }

        tfRedCase.addListenDidChange { [unowned self] text in
            self.viewModel.setRedCase(text)
        }

        tfGreenCase.addListenDidChange { [unowned self] text in
            self.viewModel.setGreenCase(text)
        }

        tf22BlackFoodCase.addListenDidChange { [unowned self] text in
            self.viewModel.set22BlackFoodCase(text)
        }

        tfBigBlackCase.addListenDidChange { [unowned self] text in
            self.viewModel.setBigBlackCase(text)
        }

        tfPercentFire.addListenDidChange { [unowned self] text in
            self.viewModel.setPercentFire(text)
        }

        tfKgPrice.addListenDidChange { [unowned self] text in
            self.viewModel.setKgPrice(text)
        }

        tfPaletDari.addListenDidChange { [unowned self] text in
            self.viewModel.setPaletDari(text)
        }

        tfRedDari.addListenDidChange { [unowned self] text in
            self.viewModel.setRedDari(text)
        }

        tfGreenDari.addListenDidChange { [unowned self] text in
            self.viewModel.setGreenDari(text)
        }

        tf22BlackDari.addListenDidChange { [unowned self] text in
            self.viewModel.set22BlackDari(text)
        }

        tfBigBlackDari.addListenDidChange { [unowned self] text in
            self.viewModel.setBigBlackDari(text)
        }
    }
}
