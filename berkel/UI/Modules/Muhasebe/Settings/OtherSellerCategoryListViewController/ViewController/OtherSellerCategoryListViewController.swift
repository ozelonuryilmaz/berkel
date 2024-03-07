//
//  OtherSellerCategoryListViewController.swift
//  berkel
//
//  Created by Onur Yilmaz on 21.01.2024.
//

import UIKit
import Combine

protocol OtherSellerCategoryListViewControllerOutputDelegate: AnyObject {
    func getSelectionOtherSellerCategory(id: String, name: String)
}

final class OtherSellerCategoryListViewController: BerkelBaseViewController {

    override var navigationTitle: String? {
        return "Satıcı Kategorisi Seçiniz"
    }
    
    // MARK: Constants

    // MARK: Inject
    private let viewModel: IOtherSellerCategoryListViewModel
    private weak var outputDelegate: OtherSellerCategoryListViewControllerOutputDelegate? = nil

    // MARK: IBOutlets
    @IBOutlet private weak var tableView: UITableView!

    // MARK: Constraints Outlets

    // MARK: Initializer
    init(viewModel: IOtherSellerCategoryListViewModel,
         outputDelegate: OtherSellerCategoryListViewControllerOutputDelegate?) {
        self.viewModel = viewModel
        self.outputDelegate = outputDelegate
        super.init(nibName: "OtherSellerCategoryListViewController", bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        return nil
    }

    override func initialComponents() {
        self.navigationItem.leftBarButtonItems = [closeBarButtonItem]
        self.navigationItem.rightBarButtonItems = [addBarButtonItem]
        self.observeReactiveDatas()
        self.initTableView()

        self.viewModel.getOtherSellerCategory()
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
        
        let errorHandleCategory = FirestoreErrorHandle(viewController: self)
        observeErrorState(errorState: viewModel.errorStateOtherSellerCategory,
                          errorHandle: errorHandleCategory)
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
private extension OtherSellerCategoryListViewController {

    func initTableView() {
        tableView.registerCell(OtherSellerCategoryListTableViewCell.self)
        tableView.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.removeTableHeaderView()
        tableView.removeTableFooterView()
    }

    func seasonAlertWithTextField() {
        let alertController = UIAlertController(title: "Yeni Kategori Ekleyin", message: nil, preferredStyle: .alert)

        alertController.addTextField { (textField) in
            textField.placeholder = "Kategori Adı"
            textField.delegate = self
            textField.keyboardType = .default
        }

        let cancelAction = UIAlertAction(title: "İptal", style: .cancel, handler: nil)
        let saveAction = UIAlertAction(title: "Ekle", style: .default) { _ in

            let inputName = alertController.textFields![0].text
            if (inputName?.count ?? 0) <= 50 {
                self.viewModel.saveOtherSellerCategory(otherSellerCategory: OtherSellerCategoryListModel(name: inputName!,
                                                                     date: Date().dateFormatterApiResponseType()))
            } else {
                self.showSystemAlert(title: "Lütfen kategori ismi 50 harfi geçmesin", message: "")
            }
        }

        alertController.addAction(cancelAction)
        alertController.addAction(saveAction)

        present(alertController, animated: true, completion: nil)
    }
}

// MARK: UITableViewDelegate, UITableViewDataSource
extension OtherSellerCategoryListViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getNumberOfRowsInSection()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.generateReusableCell(OtherSellerCategoryListTableViewCell.self, indexPath: indexPath)
        cell.configureCell(with: self.viewModel.getItemCellUIModel(index: indexPath.row))
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let otherSellerCategory = self.viewModel.getOtherSellerCategory(index: indexPath.row)

        DispatchQueue.delay(25) { [unowned self] in
            self.selfDismiss(completion: {
                self.outputDelegate?.getSelectionOtherSellerCategory(id: otherSellerCategory.id ?? "",
                                                                     name: otherSellerCategory.name)
            })
        }
    }
}


extension OtherSellerCategoryListViewController: UITextFieldDelegate {

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return textField.setMaxLengthShouldChangeCharactersIn(range: range, string: string, maxLength: 50)
    }
}
