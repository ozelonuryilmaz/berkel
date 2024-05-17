//
//  SettingsViewController.swift
//  berkel
//
//  Created by Onur Yilmaz on 2.09.2023.
//

import UIKit

final class SettingsViewController: MainBaseViewController {

    override var navigationTitle: String? {
        switch otherModule {
        case .accouting:
            return "Muhasebe"
        case .jobi:
            return "Jobi"
        }
    }

    override var navigationSubTitle: String? {
        return self.viewModel.season
    }

    // MARK: Constants

    // MARK: Inject
    private let viewModel: ISettingsViewModel

    // MARK: IBOutlets
    @IBOutlet private weak var tableView: UITableView!

    // MARK: Constraints Outlets

    // MARK: Initializer
    init(viewModel: ISettingsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: "SettingsViewController", bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        return nil
    }

    override func initialComponents() {
        self.observeReactiveDatas()

        self.initTableView()
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

            case .startFlowSplash:
                // TODO: MainTabBar kapatıldığından emin olunmalı
                self.mainTabbarController?.selfDismiss()
                self.appDelegate.window?.rootViewController?.selfDismiss()
                self.appDelegate.startFlowSplash()
            }

        }).store(in: &cancelBag)
    }

    private func listenErrorState() {
        let errorHandle = FirestoreErrorHandle(viewController: self)
        observeErrorState(errorState: viewModel.errorState,
                          errorHandle: errorHandle)
    }

    // MARK: Define Components
}

// MARK: Props
private extension SettingsViewController {

    func initTableView() {
        tableView.registerHeaderFooterView(SettingsHeaderCell.self) // for section
        tableView.registerHeaderFooterView(SettingsFooterCell.self) // for footer
        tableView.registerCell(SettingsItemCell.self)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.contentInset = .init(top: 0, left: 0, bottom: 28, right: 0)

        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        }
    }

    func tableViewReload() {
        tableView.reloadData()
        tableView.animatedAlpha(from: 0, to: 1, withDuration: 1)
    }
}

// MARK: UITableViewDelegate & UITableViewDataSource
extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.getNumberOfItemsInSection()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getNumberOfItemsInRow(section: section)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let rowModel = viewModel.getItemCellUIModel(indexPath: indexPath)
        switch rowModel.rowType {
        case .SETTINGS_ITEM:
            if let castModel = rowModel as? SettingsItemCellDataRow {
                let cell = tableView.generateReusableCell(SettingsItemCell.self, indexPath: indexPath)
                cell.outputDelegate = self.viewModel
                cell.configureCell(with: castModel.uiModel)
                cell.visibleSeperator(isVisible: viewModel.isVisibleSeperatorRow(indexPath: indexPath))
                return cell
            }
            return UITableViewCell()
        }
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionView = self.tableView.generateReusableHeaderFooterView(SettingsHeaderCell.self)
        sectionView.configureCell(with: self.viewModel.getSectionUIModel(section: section))
        return sectionView
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return SettingsHeaderCell.defaultHeight
    }

    // Sayfasının sonuna Copyright eklendi.
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if self.viewModel.isLastSection(section: section) {
            let footerView = self.tableView.generateReusableHeaderFooterView(SettingsFooterCell.self)
            return footerView
        }
        return nil
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if self.viewModel.isLastSection(section: section) {
            return SettingsFooterCell.defaultHeight
        }
        return .zero
    }
}
