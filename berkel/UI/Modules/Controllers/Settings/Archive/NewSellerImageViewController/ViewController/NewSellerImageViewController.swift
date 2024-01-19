//
//  NewSellerImageViewController.swift
//  berkel
//
//  Created by Onur Yilmaz on 23.10.2023.
//

import UIKit
import Combine

final class NewSellerImageViewController: BerkelBaseViewController {

    // MARK: Constants

    // MARK: Inject
    private let viewModel: INewSellerImageViewModel
    private let imagePicker = UIImagePickerController()

    // MARK: IBOutlets
    @IBOutlet private weak var datePicker: UIDatePicker!
    @IBOutlet private weak var tfDesc: PrimaryTextField!
    @IBOutlet private weak var btnAddImage: UIButton!
    @IBOutlet private weak var imageView: DGZoomableImageView!

    @IBOutlet private weak var btnSave: UIButton!

    // MARK: Constraints Outlets

    // MARK: Initializer
    init(viewModel: INewSellerImageViewModel) {
        self.viewModel = viewModel
        super.init(nibName: "NewSellerImageViewController", bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        return nil
    }

    override func initialComponents() {
        self.navigationItem.leftBarButtonItems = [closeBarButtonItem]
        self.observeReactiveDatas()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.viewModel.viewStateSetNavigationTitle()
    }

    override func setupView() {
        self.viewModel.initComponents()
        self.initDatePickerView()
        self.initImageView()
    }

    override func registerEvents() {

        btnAddImage.onTap { [unowned self] _ in
            self.tfDesc.textField.resignFirstResponder()
            self.present(self.imagePicker, animated: true, completion: nil)
        }

        btnSave.onTap { [unowned self] _ in
            self.viewModel.saveImage()
        }
    }

    private func observeReactiveDatas() {
        observeViewState()
        listenErrorState()
        listenTextFieldsDidChange()
    }

    private func observeViewState() {
        viewModel.viewState.sink(receiveValue: { [weak self] states in
            guard let self = self, let states = states else { return }

            switch states {
            case .showNativeProgress(let isProgress):
                self.playNativeLoading(isLoading: isProgress)

            case .setNavigationTitle(let title):
                self.navigationItem.title = title

            case .showSuccessAlertMessage:
                self.showSystemAlert(
                    title: "Resim Başarıyla Kaydedildi",
                    message: "",
                    positiveButtonText: "Tamam",
                    positiveButtonClickListener: {
                        self.viewModel.dismiss()
                    }
                )

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
private extension NewSellerImageViewController {

    func initDatePickerView() {
        datePicker.addTarget(self, action: #selector(dueDateChanged(sender:)), for: UIControl.Event.valueChanged)
    }

    @objc func dueDateChanged(sender: UIDatePicker) {
        let date = sender.date.dateFormatterApiResponseType()
        self.viewModel.setDate(date: date)
    }

    func initImageView() {
        imageView.configureUI() // init DGZoomableImageView

        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
    }
}


// MARK: TextField
private extension NewSellerImageViewController {

    func listenTextFieldsDidChange() {

        tfDesc.addListenDidChange { [unowned self] text in
            self.viewModel.setDesc(text)
        }
    }
}


extension NewSellerImageViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    // Kullanıcı resim seçtikten sonra çağrılacak olan metod
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage,
            let imageData = image.jpegData(compressionQuality: 0.8) {
            self.imageView.image = UIImage(data: imageData)
            self.viewModel.setImageData(imageData)
        }
        picker.dismiss(animated: true, completion: nil)
    }
}
