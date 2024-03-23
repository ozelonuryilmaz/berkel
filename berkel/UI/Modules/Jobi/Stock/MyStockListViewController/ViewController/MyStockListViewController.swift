//
//  MyStockListViewController.swift
//  berkel
//
//  Created by Onur Yilmaz on 20.03.2024.
//

import UIKit
import Combine

protocol MyStockListViewControllerOutputDelegate: AnyObject {
    func stockData(_ data: StockModel)
}

final class MyStockListViewController: JobiBaseViewController {

    override var navigationTitle: String? {
        return "Stok Listesi"
    }

    // MARK: Constants

    // MARK: Inject
    private let viewModel: IMyStockListViewModel
    private var outputDelegate: MyStockListViewControllerOutputDelegate? = nil

    // MARK: IBOutlets

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
            self.viewModel.pushNewStockViewController()
        }
    }()
}

// MARK: Props
private extension MyStockListViewController {

    func newStockCategoryWithTextField() {
        let alertController = UIAlertController(title: "Yeni Stok Kategorisi Ekleyin", message: nil, preferredStyle: .alert)

        alertController.addTextField { (textField) in
            textField.placeholder = "Ana Stok Kategorisi Girin"
        }

        let cancelAction = UIAlertAction(title: "İptal", style: .cancel, handler: nil)
        let saveAction = UIAlertAction(title: "Ekle", style: .default) { _ in

            let inputName = alertController.textFields![0].text
            if (inputName?.count ?? 0) < 50 {
                //self.viewModel.saveSeason(season: SeasonResponseModel(season: inputName!, date: Date().dateFormatterApiResponseType()))
            } else {
                self.showSystemAlert(title: "Lütfen stok isminin 50 karakterden fazla girmeyin", message: "")
            }
        }

        alertController.addAction(cancelAction)
        alertController.addAction(saveAction)

        present(alertController, animated: true, completion: nil)
    }
}
