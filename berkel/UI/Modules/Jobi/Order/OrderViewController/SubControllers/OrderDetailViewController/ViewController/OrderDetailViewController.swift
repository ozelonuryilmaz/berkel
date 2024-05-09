//
//  OrderDetailViewController.swift
//  berkel
//
//  Created by Onur Yilmaz on 16.04.2024.
//  Copyright (c) 2024 Berkel IOS Development Team. All rights reserved.[OY-2024]
//

import UIKit
import Combine

protocol OrderDetailViewControllerOutputDelegate: AnyObject {
    func closeButtonTapped(orderId: String, isActive: Bool)
}

final class OrderDetailViewController: JobiBaseViewController {

    // MARK: Constants

    // MARK: Inject
    private let viewModel: IOrderDetailViewModel
    private weak var outputDelegate: OrderDetailViewControllerOutputDelegate? = nil

    // MARK: IBOutlets
    @IBOutlet private weak var lblOldDoubt: UILabel!
    @IBOutlet private weak var lblNowDoubt: UILabel!
    @IBOutlet private weak var segmentedController: UISegmentedControl!
    @IBOutlet private weak var tableViewOrderDetail: OrderDetailCollectionDiffableTableView!
    @IBOutlet private weak var tableViewPayment: UITableView!
    @IBOutlet private weak var viewImage: UIView!

    @IBOutlet private weak var btnKantarFisi: UIButton!
    @IBOutlet private weak var btnCek: UIButton!
    @IBOutlet private weak var btnDekont: UIButton!
    @IBOutlet private weak var btnDiger: UIButton!

    // MARK: Constraints Outlets

    // MARK: Initializer
    init(viewModel: IOrderDetailViewModel,
         outputDelegate: OrderDetailViewControllerOutputDelegate?) {
        self.viewModel = viewModel
        self.outputDelegate = outputDelegate
        super.init(nibName: "OrderDetailViewController", bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        return nil
    }

    override func initialComponents() {
        self.observeReactiveDatas()
        self.viewModel.initComponents()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.viewModel.viewStateSetNavigationTitle()
    }

    override func setupView() {
        initTableViewPayment()
        initTableViewOrderDetail()
    }

    override func registerEvents() {
        segmentedController.addTarget(self, action: #selector(segmentedControlValueChanged(_:)), for: .valueChanged)

        btnKantarFisi.onTap { [unowned self] _ in
            self.viewModel.presentNewSellerImageViewController(imagePathType: .kantarFisi)
        }

        btnCek.onTap { [unowned self] _ in
            self.viewModel.presentNewSellerImageViewController(imagePathType: .cek)
        }

        btnDekont.onTap { [unowned self] _ in
            self.viewModel.presentNewSellerImageViewController(imagePathType: .dekont)
        }

        btnDiger.onTap { [unowned self] _ in
            self.viewModel.presentNewSellerImageViewController(imagePathType: .diger)
        }
    }

    @objc private func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        self.tableViewOrderDetail.isHidden = sender.selectedSegmentIndex == 1
        self.tableViewPayment.isHidden = sender.selectedSegmentIndex == 0
        self.viewImage.isHidden = sender.selectedSegmentIndex == 1 || sender.selectedSegmentIndex == 0
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

            case .showOrderActiveButton:
                self.navigationItem.rightBarButtonItems = [self.discardBarButtonItem]
                self.btnKantarFisi.isHidden = false
                self.btnCek.isHidden = false
                self.btnDekont.isHidden = false
                self.btnDiger.isHidden = false

            case .setNavigationTitle(let title, let subTitle):
                self.navigationItem.setCustomTitle(title, subtitle: subTitle)

            case .oldDoubt(let text):
                self.lblOldDoubt.text = text
            case .nowDoubt(let text):
                self.lblNowDoubt.text = text

            case .buildCollectionSnapshot(let snapshot):
                self.tableViewOrderDetail.applySnapshot(snapshot)

            case .updateCollectionSnapshot(_):
                break

            case .reloadPaymentTableView:
                self.tableViewPayment.reloadData()

            case .showUpdateCalcAlertMessage(let collectionId, let date, let isCalc):
                let message = isCalc ? "Aktifleştirilsin mi?\nHesaplamaya Dahil Edilecek" : "Pasifleştirilsin mi?\nHesaplamadan Çıkarılacak"
                self.showSystemAlert(
                    title: message,
                    message: "* \(date) *",
                    positiveButtonText: "Evet",
                    positiveButtonClickListener: {
                        self.viewModel.updateCalcForCollection(collectionId: collectionId, isCalc: isCalc)
                    },
                    negativeButtonText: "İptal"
                )

            case .closeButtonTapped:
                self.outputDelegate?.closeButtonTapped(orderId: self.viewModel.orderId, isActive: false)

            case .showSystemAlert(let title, let message):
                self.showSystemAlert(title: title, message: message)

            case .deleteCollection(let data):
                self.showSystemAlert(
                    title: "Siparişi iptal etmek istiyor musunuz?",
                    message: "\(data.count) Adet \(data.stockName)-\(data.subStockName)",
                    positiveButtonText: "Evet",
                    positiveButtonClickListener: {
                        self.viewModel.deleteCollection(data: data)
                    },
                    negativeButtonText: "İptal"
                )

            case .updateFaturaNo(let collectionId):
                self.faturaAlertWithTextField(collectionId: collectionId)
            }

        }).store(in: &cancelBag)
    }

    private func listenErrorState() {
        let errorHandle = FirestoreErrorHandle(viewController: self)
        observeErrorState(errorState: viewModel.errorState,
                          errorHandle: errorHandle)
    }

    // MARK: Define Components
    private lazy var discardBarButtonItem: UIBarButtonItem = {
        return UIBarButtonItem(title: "KAPAT", style: .plain, handler: { [unowned self] _ in
            self.showSystemAlert(
                title: "Tüm Tahsilat tamamlandı mı?",
                message: "Müşteri kartı kapatılacak",
                positiveButtonText: "Evet",
                positiveButtonClickListener: {
                    self.viewModel.updateSellerActive(completion: { [weak self] in
                        guard let self = self else { return }
                        self.outputDelegate?.closeButtonTapped(orderId: self.viewModel.orderId, isActive: false)
                        self.navigationItem.rightBarButtonItems = []
                        self.btnKantarFisi.isHidden = true
                        self.btnCek.isHidden = true
                        self.btnDekont.isHidden = true
                        self.btnDiger.isHidden = true
                        self.tableViewPayment.reloadData()
                    })
                },
                negativeButtonText: "Hayır"
            )
        })
    }()
}

// MARK: Props
private extension OrderDetailViewController {

    func initTableViewOrderDetail() {
        self.tableViewOrderDetail.configureView(delegateManager: self.viewModel)
    }

    func initTableViewPayment() {
        self.tableViewPayment.registerCell(OrderDetailPaymentTableViewCell.self)
        self.tableViewPayment.delegate = self
        self.tableViewPayment.dataSource = self
        self.tableViewPayment.contentInset = .init(top: 8, left: 0, bottom: 8, right: 0)
        self.tableViewPayment.removeTableHeaderView()
        self.tableViewPayment.removeTableFooterView()
    }
}


// MARK: Alert Controller
private extension OrderDetailViewController {

    func faturaAlertWithTextField(collectionId: String) {
        let alertController = UIAlertController(title: "Güncel Fatura Numarası Ekleyin", message: nil, preferredStyle: .alert)

        alertController.addTextField { (textField) in
            textField.placeholder = "Fatura Numarası"
            textField.delegate = self
            textField.keyboardType = .default
        }

        let cancelAction = UIAlertAction(title: "İptal", style: .cancel, handler: nil)
        let saveAction = UIAlertAction(title: "Ekle", style: .default) { _ in

            let inputName = alertController.textFields![0].text
            if (inputName?.count ?? 0) <= 100 {
                self.viewModel.updateFaturaNo(collectionId: collectionId, faturaNo: inputName!)
            } else {
                self.showSystemAlert(title: "Lütfen fatura numarası 100 harfi geçmesin", message: "")
            }
        }

        alertController.addAction(cancelAction)
        alertController.addAction(saveAction)

        present(alertController, animated: true, completion: nil)
    }
}

extension OrderDetailViewController: UITextFieldDelegate {

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return textField.setMaxLengthShouldChangeCharactersIn(range: range, string: string, maxLength: 100)
    }
}


// MARK: UITableViewDelegate & UITableViewDataSource
extension OrderDetailViewController: UITableViewDelegate, UITableViewDataSource, OrderDetailPaymentTableViewCellOutputDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.getNumberOfItemsInSection()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.generateReusableCell(OrderDetailPaymentTableViewCell.self, indexPath: indexPath)
        cell.configureCell(with: self.viewModel.getCellUIModel(at: indexPath.row))
        cell.outputDelegate = self
        return cell
    }

    func deleteButtonTapped(uiModel: OrderPaymentModel) {
        self.showSystemAlert(
            title: "\(uiModel.payment.decimalString()) TL tahsilatı silmek istediğinize emin misin?",
            message: "",
            positiveButtonText: "Evet",
            positiveButtonClickListener: {
                self.viewModel.deletePayment(uiModel: uiModel)
            },
            negativeButtonText: "Hayır"
        )
    }
}
