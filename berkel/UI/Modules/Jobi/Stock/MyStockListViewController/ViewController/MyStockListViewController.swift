//
//  MyStockListViewController.swift
//  berkel
//
//  Created by Onur Yilmaz on 20.03.2024.
//

import UIKit
import Combine

protocol MyStockListViewControllerOutputDelegate: AnyObject {
    func stockData(_ data: StockListModel)
}

final class MyStockListViewController: JobiBaseViewController {

    override var navigationTitle: String? {
        return "Stok K. Ekle"
    }

    // MARK: Constants

    // MARK: Inject
    private let viewModel: IMyStockListViewModel
    private var outputDelegate: MyStockListViewControllerOutputDelegate? = nil

    // MARK: IBOutlets
    @IBOutlet private weak var tableView: UITableView!

    // MARK: Constraints Outlets

    // MARK: Initializer
    init(viewModel: IMyStockListViewModel,
         outputDelegate: MyStockListViewControllerOutputDelegate?) {
        self.viewModel = viewModel
        self.outputDelegate = outputDelegate
        super.init(nibName: "MyStockListViewController", bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        return nil
    }

    override func initialComponents() {
        self.navigationItem.rightBarButtonItems = [addBarButtonItem]
        self.observeReactiveDatas()
        self.initTableView()
        self.viewModel.getStock()
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
                
            case .newSubStockCategoryWithTextField(let uiModel):
                self.newSubStockCategoryWithTextField(uiModel: uiModel)

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

    // MARK: Define Components
    private lazy var addBarButtonItem: UIBarButtonItem = {
        return UIBarButtonItem(image: .addNavLoupe) { [unowned self] _ in
            self.newStockCategoryWithTextField()
        }
    }()
}

// MARK: Props
private extension MyStockListViewController {
    
    func initTableView() {
        tableView.registerHeaderFooterView(MyStockListHeaderCell.self)
        tableView.registerCell(MyStockListItemCell.self)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.contentInset = .init(top: 16, left: 0, bottom: 16, right: 0)
        
        tableViewReload()
    }

    func tableViewReload() {
        tableView.reloadData()
        tableView.animatedAlpha(from: 0, to: 1, withDuration: 1)
    }
    
    func newSubStockCategoryWithTextField(uiModel: MyStockListHeaderCellUIModel) {
        let alertController = UIAlertController(title: "\(uiModel.stockName) Stoğuna Alt Kategori Ekleyin",
                                                message: nil, preferredStyle: .alert)

        alertController.addTextField { (textField) in
            textField.placeholder = "Alt Stok Kategorisi Girin"
        }

        let cancelAction = UIAlertAction(title: "İptal", style: .cancel, handler: nil)
        let saveAction = UIAlertAction(title: "Ekle", style: .default) { _ in

            let inputName = alertController.textFields![0].text
            if (inputName?.count ?? 0) > 2 && (inputName?.count ?? 0) < 50 {
                self.viewModel.saveSubStock(name: inputName?.capitalized(with: Locale(identifier: "tr")) ?? "",
                                            stockId: uiModel.stockId)
            } else {
                self.showSystemAlert(title: "Lütfen alt kategori isminin 50 karakterden fazla girmeyin", message: "")
            }
        }

        alertController.addAction(cancelAction)
        alertController.addAction(saveAction)

        present(alertController, animated: true, completion: nil)
    }

    func newStockCategoryWithTextField() {
        let alertController = UIAlertController(title: "Yeni Stok Kategorisi Ekleyin", message: nil, preferredStyle: .alert)

        alertController.addTextField { (textField) in
            textField.placeholder = "Stok Kategorisi Girin"
        }

        let cancelAction = UIAlertAction(title: "İptal", style: .cancel, handler: nil)
        let saveAction = UIAlertAction(title: "Ekle", style: .default) { _ in

            let inputName = alertController.textFields![0].text
            if (inputName?.count ?? 0) > 2 && (inputName?.count ?? 0) < 50 {
                self.viewModel.saveStock(name: inputName?.capitalized(with: Locale(identifier: "tr")) ?? "")
            } else {
                self.showSystemAlert(title: "Lütfen stok isminin 50 karakterden fazla girmeyin", message: "")
            }
        }

        alertController.addAction(cancelAction)
        alertController.addAction(saveAction)

        present(alertController, animated: true, completion: nil)
    }
}

// MARK: UITableViewDelegate & UITableViewDataSource
extension MyStockListViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.getNumberOfItemsInSection()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getNumberOfItemsInRow(section: section)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.generateReusableCell(MyStockListItemCell.self, indexPath: indexPath)
        cell.configureCell(with: viewModel.getItemCellUIModel(indexPath: indexPath))
        return cell
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionView = tableView.generateReusableHeaderFooterView(MyStockListHeaderCell.self)
        sectionView.configureCell(with: self.viewModel.getSectionUIModel(section: section))
        sectionView.outputDelegate = self.viewModel
        return sectionView
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return SettingsHeaderCell.defaultHeight
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return .zero
    }
}

