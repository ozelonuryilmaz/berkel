//
//  ProductListViewController.swift
//  berkel
//
//  Created by Onur Yilmaz on 18.11.2023.
//

import UIKit
import Combine

protocol ProductListViewControllerOutputDelegate: AnyObject {
    func getSelectionProduct(id: String, name: String)
}

final class ProductListViewController: BerkelBaseViewController {

    override var navigationTitle: String? {
        return "Ürün Seçiniz"
    }

    // MARK: Constants

    // MARK: Inject
    private let viewModel: IProductListViewModel
    private weak var outputDelegate: ProductListViewControllerOutputDelegate? = nil

    // MARK: IBOutlets
    @IBOutlet private weak var tableView: UITableView!

    // MARK: Constraints Outlets

    // MARK: Initializer
    init(viewModel: IProductListViewModel,
         outputDelegate: ProductListViewControllerOutputDelegate?) {
        self.viewModel = viewModel
        self.outputDelegate = outputDelegate
        super.init(nibName: "ProductListViewController", bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        return nil
    }

    override func initialComponents() {
        self.navigationItem.leftBarButtonItems = [closeBarButtonItem]
        self.navigationItem.rightBarButtonItems = [addBarButtonItem]

        self.observeReactiveDatas()
        self.initTableView()

        self.viewModel.getProducts()
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

            case .reloadTableView:
                self.tableView.reloadData()
            }

        }).store(in: &cancelBag)
    }

    private func listenErrorState() {
        let errorHandle = FirestoreErrorHandle(viewController: self)
        observeErrorState(errorState: viewModel.errorState,
                          errorHandle: errorHandle)
        
        let errorHandleProduct = FirestoreErrorHandle(viewController: self)
        observeErrorState(errorState: viewModel.errorStateProduct,
                          errorHandle: errorHandleProduct)
    }

    // MARK: Define Components
    private lazy var closeBarButtonItem: UIBarButtonItem = {
        return UIBarButtonItem(image: .closeNav) { [unowned self] _ in
            self.viewModel.dismiss()
        }
    }()

    private lazy var addBarButtonItem: UIBarButtonItem = {
        return UIBarButtonItem(image: .addNavLoupe) { [unowned self] _ in
            self.seasonAlertWithTextField()
        }
    }()
}

// MARK: Props
private extension ProductListViewController {

    func initTableView() {
        tableView.registerCell(ProductListTableViewCell.self)
        tableView.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.removeTableHeaderView()
        tableView.removeTableFooterView()
    }

    func seasonAlertWithTextField() {
        let alertController = UIAlertController(title: "Yeni Ürün Ekleyin", message: nil, preferredStyle: .alert)

        alertController.addTextField { (textField) in
            textField.placeholder = "Ürün Adı"
            textField.delegate = self
            textField.keyboardType = .default
        }

        let cancelAction = UIAlertAction(title: "İptal", style: .cancel, handler: nil)
        let saveAction = UIAlertAction(title: "Ekle", style: .default) { _ in

            let inputName = alertController.textFields![0].text
            if (inputName?.count ?? 0) <= 50 {
                self.viewModel.saveProduct(product: ProductListModel(name: inputName!,
                                                                     date: Date().dateFormatterApiResponseType()))
            } else {
                self.showSystemAlert(title: "Lütfen ürün ismi 50 harfi geçmesin", message: "")
            }
        }

        alertController.addAction(cancelAction)
        alertController.addAction(saveAction)

        present(alertController, animated: true, completion: nil)
    }
}

// MARK: UITableViewDelegate, UITableViewDataSource
extension ProductListViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getNumberOfRowsInSection()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.generateReusableCell(ProductListTableViewCell.self, indexPath: indexPath)
        cell.configureCell(with: self.viewModel.getItemCellUIModel(index: indexPath.row))
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let product = self.viewModel.getProduct(index: indexPath.row)

        DispatchQueue.delay(25) { [unowned self] in
            self.selfDismiss(completion: {
                self.outputDelegate?.getSelectionProduct(id: product.id ?? "", name: product.name)
            })
        }
    }
}


extension ProductListViewController: UITextFieldDelegate {

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return textField.setMaxLengthShouldChangeCharactersIn(range: range, string: string, maxLength: 50)
    }
}
