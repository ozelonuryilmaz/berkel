//
//  OtherDetailViewController.swift
//  berkel
//
//  Created by Onur Yilmaz on 30.01.2024.
//

import UIKit
import Combine

protocol OtherDetailViewControllerOutputDelegate: AnyObject {

    func closeButtonTapped(otherId: String, isActive: Bool)
}

final class OtherDetailViewController: MainBaseViewController {

    // MARK: Constants

    // MARK: Inject
    private let viewModel: IOtherDetailViewModel
    private weak var outputDelegate: OtherDetailViewControllerOutputDelegate? = nil

    // MARK: IBOutlets
    @IBOutlet private weak var lblOldDoubt: UILabel!
    @IBOutlet private weak var lblNowDoubt: UILabel!
    @IBOutlet private weak var segmentedController: UISegmentedControl!
    @IBOutlet private weak var tableViewOtherDetail: OtherDetailCollectionDiffableTableView!
    @IBOutlet private weak var tableViewPayment: UITableView!
    @IBOutlet private weak var viewImage: UIView!
    
    @IBOutlet private weak var btnKantarFisi: UIButton!
    @IBOutlet private weak var btnCek: UIButton!
    @IBOutlet private weak var btnDekont: UIButton!
    @IBOutlet private weak var btnDiger: UIButton!

    // MARK: Constraints Outlets

    // MARK: Initializer
    init(viewModel: IOtherDetailViewModel,
         outputDelegate: OtherDetailViewControllerOutputDelegate?) {
        self.viewModel = viewModel
        self.outputDelegate = outputDelegate
        super.init(nibName: "OtherDetailViewController", bundle: nil)
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
        initTableViewOtherDetail()
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
        self.tableViewSellerDetail.isHidden = sender.selectedSegmentIndex == 1
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

            case .showOtherActiveButton:
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
                self.tableViewSellerDetail.applySnapshot(snapshot)

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
                self.outputDelegate?.closeButtonTapped(otherId: self.viewModel.otherId, isActive: false)

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
                title: "Tüm Ödemeniz tamamlandı mı?",
                message: "Kişi/Kurum kartı kapatılacak",
                positiveButtonText: "Evet",
                positiveButtonClickListener: {
                    self.viewModel.updateSellerActive(completion: { [weak self] in
                        guard let self = self else { return }
                        self.outputDelegate?.closeButtonTapped(sellerId: self.viewModel.otherId, isActive: false)
                        self.navigationItem.rightBarButtonItems = []
                        self.btnKantarFisi.isHidden = true
                        self.btnCek.isHidden = true
                        self.btnDekont.isHidden = true
                        self.btnDiger.isHidden = true
                    })
                },
                negativeButtonText: "İptal"
            )
        })
    }()
}

// MARK: Props
private extension OtherDetailViewController {

    func initTableViewOtherDetail() {
        self.tableViewOtherDetail.configureView(delegateManager: self.viewModel)
    }

    func initTableViewPayment() {
        self.tableViewPayment.registerCell(OtherDetailPaymentTableViewCell.self)
        self.tableViewPayment.delegate = self
        self.tableViewPayment.dataSource = self
        self.tableViewPayment.contentInset = .init(top: 8, left: 0, bottom: 8, right: 0)
        self.tableViewPayment.removeTableHeaderView()
        self.tableViewPayment.removeTableFooterView()
    }
}

// MARK: UITableViewDelegate & UITableViewDataSource
extension OtherDetailViewController: UITableViewDelegate, UITableViewDataSource, OtherDetailPaymentTableViewCellOutputDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.getNumberOfItemsInSection()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.generateReusableCell(OtherDetailPaymentTableViewCell.self, indexPath: indexPath)
        cell.configureCell(with: self.viewModel.getCellUIModel(at: indexPath.row))
        cell.outputDelegate = self
        return cell
    }
    
    func deleteButtonTapped(uiModel: OtherPaymentModel) {
        self.showSystemAlert(
            title: "\(uiModel.payment.decimalString()) TL tutarı silmek istediğinize emin misin?",
            message: "",
            positiveButtonText: "Evet",
            positiveButtonClickListener: {
                self.viewModel.deletePayment(uiModel: uiModel)
            },
            negativeButtonText: "Hayır"
        )
    }
}
