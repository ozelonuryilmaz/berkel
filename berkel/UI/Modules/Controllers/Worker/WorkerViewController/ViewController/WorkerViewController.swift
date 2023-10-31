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
    }

    override func registerEvents() {

    }

    private func observeReactiveDatas() {
        observeViewState()
        listenErrorState()
    }

    private func observeViewState() {

    }

    private func listenErrorState() {

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

}
