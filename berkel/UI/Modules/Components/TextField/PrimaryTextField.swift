//
//  PrimaryTextField.swift
//  berkel
//
//  Created by Onur Yilmaz on 11.09.2023.
//

import UIKit
import SnapKit

typealias PrimarySearchTextFieldListener = ((String) -> (Void))

@IBDesignable
class PrimaryTextField: BaseReusableView {

    private let defaultBorderColor: CGColor = UIColor.primaryLightGray.cgColor
    private let focusedBorderColor: CGColor = UIColor.primaryBlue.cgColor

    private var searchClickListener: PrimarySearchTextFieldListener? = nil
    private var arrayListenDidChange: [PrimarySearchTextFieldListener]? = nil

    @IBInspectable
    var placeholder: String = "" {
        didSet {
            textField.placeholder = placeholder
        }
    }

    @IBInspectable
    var keyboard: Int = 0 {
        didSet {
            self.textField.keyboardType = UIKeyboardType.init(rawValue: keyboard) ?? .default
        }
    }

    @IBInspectable
    var isSecureTextEntry: Bool = false {
        didSet {
            textField.isSecureTextEntry = isSecureTextEntry
        }
    }

    @IBInspectable
    var maxCharacterLenght: Int = Int.max

    override func initializeSelf() {
        self.arrayListenDidChange = [PrimarySearchTextFieldListener]()
        self.textField.delegate = self
        setupAllConstraints()
        initialDefaultUI()
    }

    // MARK: Actions

    func setOnSearchClickListener(callback: @escaping PrimarySearchTextFieldListener) {
        self.searchClickListener = callback
    }

    func convertToJustClickable(handler: @escaping () -> Void) {
        self.onTap { _ in handler() }
        self.textField.convertToJustClickable(handler: handler)
    }

    @objc func ActionClearButton() {
        self.textField.text = ""
        self.textField.sendActions(for: .editingChanged)
    }

    func activateTextFieldFocus() {
        textField.becomeFirstResponder()
    }

    func clearTextFieldFocus() {
        textField.resignFirstResponder()
    }

    func visibilityClearButton() {
        self.handleVisibilityClearButton()
    }

    // MARK: Definitions

    private lazy var imgSearchIcon: UIImageView = {
        let imageView = UIImageView()
        //imageView.image = #imageLiteral(resourceName: "magnifinderGreen")

        addSubview(imageView)
        return imageView
    }()

    lazy var textField: UITextField = {
        let textfield = UITextField()
        textfield.backgroundColor = .clear
        textfield.borderStyle = .none
        textfield.autocorrectionType = .no
        textfield.font = .systemFont(ofSize: 20)
        textfield.textColor = .black
        textfield.setPlaceHolderProps(color: .primaryDarkGray, font: .systemFont(ofSize: 20))

        textfield.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)

        addSubview(textfield)
        return textfield
    }()

    private lazy var btnClear: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "crossLightGray")?.resizedImage(Size: .init(width: 10, height: 10))?.withRenderingMode(.alwaysTemplate), for: [])
        button.tintColor = .black

        button.addTarget(self, action: #selector(self.ActionClearButton), for: .touchUpInside)

        addSubview(button)
        return button
    }()
}


// MARK: Props
private extension PrimaryTextField {

    func initialDefaultUI() {
        self.backgroundColor = .clear
        self.layer.borderWidth = 1
        self.layer.borderColor = defaultBorderColor
        self.layer.cornerRadius = 10
        self.clipsToBounds = true

        self.handleVisibilityClearButton()
    }

    func enabled() {
        alpha = 1
        textField.isEnabled = true
    }

    func disabled() {
        alpha = 0.7
        textField.isEnabled = false
    }
}

// MARK: Constraints
private extension PrimaryTextField {

    func setupAllConstraints() {
        setupImageViewSearchIconCons()
        setupClearButtonCons()
        setupTextFieldCons()
    }

    func setupImageViewSearchIconCons() {
        imgSearchIcon.snp.makeConstraints { maker in
            maker.centerY.equalToSuperview()
            maker.leading.equalToSuperview().offset(10)
            maker.width.height.equalTo(12)
        }
    }

    func setupClearButtonCons() {
        btnClear.snp.makeConstraints { maker in
            maker.top.bottom.trailing.equalToSuperview()
            maker.width.equalTo(32)
        }
    }

    func setupTextFieldCons() {
        textField.snp.makeConstraints { maker in
            maker.top.bottom.equalToSuperview()
            maker.leading.equalTo(imgSearchIcon.snp.trailing).offset(5)
            maker.trailing.equalTo(btnClear.snp.leading)
        }
    }

    func handleVisibilityClearButton() {
        if textField.text?.isEmpty == true {
            btnClear.isHidden = true
            btnClear.snp.updateConstraints { maker in
                maker.width.equalTo(0)
            }
        } else {
            btnClear.isHidden = false
            btnClear.snp.updateConstraints { maker in
                maker.width.equalTo(32)
            }
        }
    }
}

// MARK: UITextFieldDelegate && Target
extension PrimaryTextField: UITextFieldDelegate {

    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.layer.borderColor = focusedBorderColor
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        self.layer.borderColor = defaultBorderColor
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return textField.setMaxLengthShouldChangeCharactersIn(range: range, string: string, maxLength: self.maxCharacterLenght)
    }

    @objc func textFieldDidChange(_ textField: UITextField) {
        handleVisibilityClearButton()

        if let arrayListener = self.arrayListenDidChange {
            for listener in arrayListener {
                listener(textField.text ?? "")
            }
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let text = textField.text, !text.isEmpty {
            self.searchClickListener?(text)
            textField.resignFirstResponder()
            return true
        }
        return false
    }
}

// MARK: Delegate wrapper completion listener
extension PrimaryTextField {

    func addListenDidChange(listener: @escaping PrimarySearchTextFieldListener) {
        self.arrayListenDidChange?.append(listener)
    }
}
