//
//  ArchiveDetailViewController.swift
//  berkel
//
//  Created by Onur Yilmaz on 26.10.2023.
//

import UIKit
import Combine

final class ArchiveDetailViewController: BerkelBaseViewController {

    // MARK: Constants

    // MARK: Inject
    private let viewModel: IArchiveDetailViewModel

    // MARK: IBOutlets
    @IBOutlet private weak var imageView: DGZoomableImageView!

    // MARK: Constraints Outlets

    // MARK: Initializer
    init(viewModel: IArchiveDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: "ArchiveDetailViewController", bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        return nil
    }

    override func initialComponents() {
        self.navigationItem.leftBarButtonItems = [closeBarButtonItem]
        self.observeReactiveDatas()
        self.imageView.configureUI()

        self.viewModel.initComponents()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.viewModel.viewStateSetNavigationTitle()
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

            case .setNavigationTitle(let title, let subtitle):
                self.navigationItem.setCustomTitle(title, subtitle: subtitle)

            case .setImage(let imageUrl):
                self.imageView.urlString = imageUrl

            }

        }).store(in: &cancelBag)
    }

    private func listenErrorState() {
        let errorHandle = FirestoreErrorHandle(viewController: self)

        observeErrorState(errorState: viewModel.errorState,
                          errorHandle: errorHandle)
    }

    // MARK: Define Components
    private lazy var closeBarButtonItem: UIBarButtonItem = {
        return UIBarButtonItem(image: .closeNav) { [unowned self] _ in
            self.viewModel.dismiss()
        }
    }()
}

// MARK: Props
private extension ArchiveDetailViewController {

}
