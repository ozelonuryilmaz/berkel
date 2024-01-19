//
//  UserAuthsViewController.swift
//  berkel
//
//  Created by Onur Yilmaz on 11.01.2024.
//

import UIKit
import Combine

final class UserAuthsViewController: BerkelBaseViewController {

    override var navigationTitle: String? {
        return "Kullanıcı Yetkilendir"
    }

    // MARK: Inject
    private let viewModel: IUserAuthsViewModel

    // MARK: IBOutlets
    @IBOutlet private weak var tableView: UITableView!

    // MARK: Initializer
    init(viewModel: IUserAuthsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: "UserAuthsViewController", bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        return nil
    }

    override func initialComponents() {
        self.observeReactiveDatas()
        self.initTableView()
    }

    override func setupView() {
        DispatchQueue.delay(200) { [weak self] in
            self?.viewModel.getUsers()
        }
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

            case .reloadData:
                self.tableView.reloadData()
            }

        }).store(in: &cancelBag)
    }

    private func listenErrorState() {
        let errorHandle = FirestoreErrorHandle(viewController: self)
        observeErrorState(errorState: viewModel.errorState,
                          errorHandle: errorHandle)
    }
}

// MARK: Props
private extension UserAuthsViewController {

    func initTableView() {
        tableView.registerCell(UserAuthsItemCell.self)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.contentInset = .init(top: 16, left: 0, bottom: 16, right: 0)
        if #available(iOS 15.0, *) { tableView.sectionHeaderTopPadding = 0 }
    }
}

// MARK: UITableViewDelegate & UITableViewDataSource
extension UserAuthsViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getNumberOfItemsInRow()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.generateReusableCell(UserAuthsItemCell.self, indexPath: indexPath)
        cell.outputDelegate = self.viewModel
        cell.configureCell(with: self.viewModel.getItemCellUIModel(indexPath: indexPath))
        return cell
    }
}
