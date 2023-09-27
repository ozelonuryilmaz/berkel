//
//  SeasonsViewController.swift
//  berkel
//
//  Created by Onur Yilmaz on 25.09.2023.
//  Copyright (c) 2023 Emlakjet IOS Development Team. All rights reserved.[EC-2021]
//

import UIKit

final class SeasonsViewController: BerkelBaseViewController {

    override var navigationTitle: String? {
        return "Sezon Seçiniz"
    }

    // MARK: Constants

    // MARK: Inject
    private let viewModel: ISeasonsViewModel

    // MARK: IBOutlets
    @IBOutlet private weak var tableView: UITableView!

    // MARK: Constraints Outlets

    var seasonDismissCallback: ((_ isSelected: Bool) -> Void)? = nil

    // MARK: Initializer
    init(viewModel: ISeasonsViewModel,
         seasonDismissCallback: ((_ isSelected: Bool) -> Void)?) {
        self.viewModel = viewModel
        super.init(nibName: "SeasonsViewController", bundle: nil)

        self.seasonDismissCallback = seasonDismissCallback
    }

    required init?(coder aDecoder: NSCoder) {
        return nil
    }

    override func initialComponents() {
        if !self.viewModel.isHiddenBackButton {
            self.navigationItem.leftBarButtonItems = [closeBarButtonItem]
        }

        self.navigationItem.rightBarButtonItems = [addBarButtonItem]

        self.observeReactiveDatas()
        self.initTableView()

        self.viewModel.getSeasons()
    }

    override func registerEvents() {

    }

    private func observeReactiveDatas() {
        observeViewState()
        // listenErrorState()
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
        let errorHandle = FirestoreErrorHandle(
            viewController: self,
            callbackOverrideAlert: nil,
            callbackAlertButtonAction: { [unowned self] in
                self.viewModel.getSeasons()
            }
        )
        observeErrorState(errorState: viewModel.errorState,
                          errorHandle: errorHandle)

        let errorHandleSeason = FirestoreErrorHandle(viewController: self)
        observeErrorState(errorState: viewModel.errorStateSeason,
                          errorHandle: errorHandleSeason)
    }

    // MARK: Define Components
    private lazy var closeBarButtonItem: UIBarButtonItem = {
        return UIBarButtonItem(image: .closeNav) { [unowned self] _ in
            self.selfDismiss()
        }
    }()

    private lazy var addBarButtonItem: UIBarButtonItem = {
        return UIBarButtonItem(image: .addNavLoupe) { [unowned self] _ in
            self.seasonAlertWithTextField()
        }
    }()
}

// MARK: Props
private extension SeasonsViewController {

    func initTableView() {
        tableView.registerCell(SeasonsTableViewCell.self)
        tableView.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.removeTableHeaderView()
        tableView.removeTableFooterView()
    }

    func seasonAlertWithTextField() {
        let alertController = UIAlertController(title: "Yeni Sezon Ekleyin", message: nil, preferredStyle: .alert)

        alertController.addTextField { (textField) in
            textField.placeholder = "xxxx/xxxx"
            textField.delegate = self
            textField.keyboardType = .numberPad
            textField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
        }

        let cancelAction = UIAlertAction(title: "İptal", style: .cancel, handler: nil)
        let saveAction = UIAlertAction(title: "Ekle", style: .default) { _ in

            let inputName = alertController.textFields![0].text
            if inputName?.count == 9 {
                self.viewModel.saveSeason(season: SeasonResponseModel(season: inputName!,
                                                                      date: Date().dateFormatterApiResponseType()))
            } else {
                self.showSystemAlert(title: "Lütfen sezon isminin tam olduğundan emin olunuz.", message: "")
            }
        }

        alertController.addAction(cancelAction)
        alertController.addAction(saveAction)

        present(alertController, animated: true, completion: nil)
    }
}

// MARK: UITableViewDelegate, UITableViewDataSource
extension SeasonsViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getNumberOfRowsInSection()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.generateReusableCell(SeasonsTableViewCell.self, indexPath: indexPath)
        cell.configureCell(with: self.viewModel.getItemCellUIModel(index: indexPath.row))
        cell.visibleSeperator(isVisible: false)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.viewModel.saveSeason(index: indexPath.row)

        DispatchQueue.delay(25) { [unowned self] in
            self.selfDismiss(completion: {
                self.seasonDismissCallback?(true)
            })
        }
    }
}


extension SeasonsViewController: UITextFieldDelegate {

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return textField.setMaxLengthShouldChangeCharactersIn(range: range, string: string, maxLength: 9)
    }

    @objc func textFieldDidChange(_ textField: UITextField) {
        textField.text = textField.text?.applyPatternOnNumbers(pattern: "####-####", replacementCharacter: "#")
    }
}
