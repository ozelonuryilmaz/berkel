//
//  WorkerViewController.swift
//  berkel
//
//  Created by Onur Yilmaz on 2.09.2023.
//

import UIKit
import Combine

final class WorkerViewController: MainBaseViewController {

    override var navigationTitle: String? {
        return "İşçi"
    }

    override var navigationSubTitle: String? {
        return self.viewModel.season
    }

    // MARK: Constants

    // MARK: Inject
    private let viewModel: IWorkerViewModel

    // MARK: IBOutlets
    @IBOutlet private weak var tableView: WorkerDiffableTableView!

    // MARK: Constraints Outlets

    // MARK: Initializer
    init(viewModel: IWorkerViewModel) {
        self.viewModel = viewModel
        super.init(nibName: "WorkerViewController", bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        return nil
    }

    override func initialComponents() {
        self.navigationItem.rightBarButtonItems = [addBarButtonItem]
        self.observeReactiveDatas()
        self.initTableView()

        self.viewModel.getWorker()
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

            }

        }).store(in: &cancelBag)
    }

    private func listenErrorState() {
        let errorHandle = FirestoreErrorHandle(
            viewController: self,
            callbackOverrideAlert: nil,
            callbackAlertButtonAction: { [unowned self] in
                self.viewModel.getWorker()
            }
        )
        observeErrorState(errorState: viewModel.errorState,
                          errorHandle: errorHandle)
    }

    // MARK: Define Components
    private lazy var addBarButtonItem: UIBarButtonItem = {
        return UIBarButtonItem(image: .addNavLoupe) { [unowned self] _ in
            self.viewModel.pushCavusListViewController()
        }
    }()
}

// MARK: Props
private extension WorkerViewController {

    func initTableView() {
        self.tableView.configureView(delegateManager: self.viewModel)
    }
}
