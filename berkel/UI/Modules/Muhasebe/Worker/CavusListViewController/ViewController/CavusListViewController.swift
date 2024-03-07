//
//  CavusListViewController.swift
//  berkel
//
//  Created by Onur Yilmaz on 31.10.2023.
//

import UIKit
import Combine

final class CavusListViewController: MainBaseViewController {

    override var navigationTitle: String? {
        return "Çavuş Listesi"
    }

    // MARK: Constants

    // MARK: Inject
    private let viewModel: ICavusListViewModel
    private weak var outputDelegate: NewWorkerViewControllerOutputDelegate? = nil

    // MARK: IBOutlets
    @IBOutlet private weak var tableView: CavusListDiffableTableView!

    // MARK: Constraints Outlets

    // MARK: Initializer
    init(viewModel: ICavusListViewModel,
         outputDelegate: NewWorkerViewControllerOutputDelegate?) {
        self.viewModel = viewModel
        self.outputDelegate = outputDelegate
        super.init(nibName: "CavusListViewController", bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        return nil
    }

    override func initialComponents() {
        self.navigationItem.rightBarButtonItems = [addBarButtonItem]
        self.observeReactiveDatas()

        self.viewModel.getCavusList()
    }

    override func setupView() {
        initTableView()
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

            case .buildSnapshot(let snapshot):
                self.tableView.applySnapshot(snapshot)

            case .updateSnapshot(let data):
                let snapsoht = self.viewModel.updateSnapshot(currentSnapshot: self.tableView.getSnapshot(),
                                                             newDatas: data)
                self.tableView.applySnapshot(snapsoht)
                
            case .outputDelegate(let workerModel):
                self.outputDelegate?.newWorkerData(workerModel)
            }

        }).store(in: &cancelBag)
    }

    private func listenErrorState() {
        let errorHandle = FirestoreErrorHandle(
            viewController: self,
            callbackOverrideAlert: nil,
            callbackAlertButtonAction: { [unowned self] in
                self.viewModel.getCavusList()
            }
        )
        observeErrorState(errorState: viewModel.errorState,
                          errorHandle: errorHandle)
    }

    // MARK: Define Components
    private lazy var addBarButtonItem: UIBarButtonItem = {
        return UIBarButtonItem(image: .addPersonNav) { [unowned self] _ in
            self.viewModel.presentNewCavusViewController(passData: NewCavusPassData(cavusInformation: nil))
        }
    }()
}

// MARK: Props
private extension CavusListViewController {

    func initTableView() {
        self.tableView.configureView(delegateManager: self.viewModel)
    }
}
