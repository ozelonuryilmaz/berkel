//
//  WorkerDetailViewController.swift
//  berkel
//
//  Created by Onur Yilmaz on 4.11.2023.
//

import UIKit
import Combine

protocol WorkerDetailViewControllerOutputDelegate: AnyObject {

    func closeButtonTapped(workerId: String, isActive: Bool)
}

final class WorkerDetailViewController: MainBaseViewController {

    override var isShowTabbar: Bool {
        return false
    }

    // MARK: Constants
    @IBOutlet private weak var lblOldDoubt: UILabel!
    @IBOutlet private weak var lblNowDoubt: UILabel!
    @IBOutlet private weak var segmentedController: UISegmentedControl!
    @IBOutlet private weak var tableViewWorkerDetail: WorkerDetailCollectionDiffableTableView!
    @IBOutlet private weak var tableViewPayment: UITableView!

    // MARK: Inject
    private let viewModel: IWorkerDetailViewModel

    private weak var outputDelegate: WorkerDetailViewControllerOutputDelegate? = nil

    // MARK: IBOutlets

    // MARK: Constraints Outlets

    // MARK: Initializer
    init(viewModel: IWorkerDetailViewModel,
         outputDelegate: WorkerDetailViewControllerOutputDelegate?) {
        self.viewModel = viewModel
        self.outputDelegate = outputDelegate
        super.init(nibName: "WorkerDetailViewController", bundle: nil)
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
        initTableViewWorkerDetail()
    }

    override func registerEvents() {
        segmentedController.addTarget(self, action: #selector(segmentedControlValueChanged(_:)), for: .valueChanged)
    }

    @objc private func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        self.tableViewWorkerDetail.isHidden = sender.selectedSegmentIndex == 1
        self.tableViewPayment.isHidden = sender.selectedSegmentIndex == 0
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

            case .showWorkerActiveButton:
                self.navigationItem.rightBarButtonItems = [self.discardBarButtonItem]

            case .setNavigationTitle(let title):
                self.navigationItem.title = title

            case .oldDoubt(let text):
                self.lblOldDoubt.text = text
            case .nowDoubt(let text):
                self.lblNowDoubt.text = text

            case .buildCollectionSnapshot(let snapshot):
                self.tableViewWorkerDetail.applySnapshot(snapshot)

            case .updateCollectionSnapshot(_):
                break

            case .reloadPaymentTableView:
                self.tableViewPayment.reloadData()

            case .showUpdateCalcAlertMessage(let collectionId, let date, let isCalc):
                self.showSystemAlert(
                    title: date,
                    message: "Aktifleştirilsin mi?\nHesaplamalara dahil edilecek.",
                    positiveButtonText: "Evet",
                    positiveButtonClickListener: {
                        self.viewModel.updateCalcForCollection(collectionId: collectionId, isCalc: isCalc)
                    },
                    negativeButtonText: "İptal"
                )

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
                title: "Çavuş ile anlaşmanız bitti mi?",
                message: "Devre dışı bırakılmasını istediğinize emin misiniz?",
                positiveButtonText: "Evet",
                positiveButtonClickListener: {
                    self.viewModel.updateWorkerActive(completion: { [weak self] in
                        guard let self = self else { return }
                        self.outputDelegate?.closeButtonTapped(workerId: self.viewModel.workerId, isActive: false)
                        self.navigationItem.rightBarButtonItems = []
                    })
                },
                negativeButtonText: "İptal"
            )
        })
    }()
}

// MARK: Props
private extension WorkerDetailViewController {

    func initTableViewWorkerDetail() {
        self.tableViewWorkerDetail.configureView(delegateManager: self.viewModel)
    }

    func initTableViewPayment() {
        self.tableViewPayment.registerCell(WorkerDetailPaymentTableViewCell.self)
        self.tableViewPayment.delegate = self
        self.tableViewPayment.dataSource = self
        self.tableViewPayment.contentInset = .init(top: 8, left: 0, bottom: 8, right: 0)
        self.tableViewPayment.removeTableHeaderView()
        self.tableViewPayment.removeTableFooterView()
    }
}

// MARK: UITableViewDelegate & UITableViewDataSource
extension WorkerDetailViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.getNumberOfItemsInSection()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.generateReusableCell(WorkerDetailPaymentTableViewCell.self, indexPath: indexPath)
        cell.configureCell(with: self.viewModel.getCellUIModel(at: indexPath.row))
        return cell
    }
}
