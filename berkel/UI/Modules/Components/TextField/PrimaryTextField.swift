//
//  PrimaryTextField.swift
//  berkel
//
//  Created by Onur Yilmaz on 11.09.2023.
//

import UIKit
import SnapKit

typealias PrimaryTextFieldListener = ((String) -> (Void))

@IBDesignable
class PrimaryTextField: BaseReusableView {

    private let defaultBorderColor: CGColor = UIColor.grayColor.cgColor
    private let focusedBorderColor: CGColor = UIColor.primaryBlue.cgColor

    private var clickListener: PrimaryTextFieldListener? = nil
    private var arrayListenDidChange: [PrimaryTextFieldListener]? = nil

    @IBInspectable
    var title: String = "" {
        didSet {
            lblTitle.text = title
        }
    }
    
    var text: String = "" {
        didSet {
            textField.text = text
        }
    }

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
    var isPhoneNumber: Bool = false

    @IBInspectable
    var maxCharacterLenght: Int = Int.max

    override func initializeSelf() {
        self.arrayListenDidChange = [PrimaryTextFieldListener]()
        self.textField.delegate = self
        setupAllConstraints()
        initialDefaultUI()
    }

    // MARK: Actions

    func setOnTextFieldClickListener(callback: @escaping PrimaryTextFieldListener) {
        self.clickListener = callback
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

    private lazy var lblTitle: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(cgColor: defaultBorderColor)
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 20)

        addSubview(label)
        return label
    }()

    private lazy var tfBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.layer.borderWidth = 1
        view.layer.borderColor = defaultBorderColor
        view.layer.cornerRadius = 10
        view.clipsToBounds = true

        addSubview(view)
        return view
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

        tfBackgroundView.addSubview(textfield)
        return textfield
    }()

    private lazy var btnClear: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "crossLightGray")?.resizedImage(Size: .init(width: 10, height: 10))?.withRenderingMode(.alwaysTemplate), for: [])
        button.tintColor = .black

        button.addTarget(self, action: #selector(self.ActionClearButton), for: .touchUpInside)

        tfBackgroundView.addSubview(button)
        return button
    }()
}


// MARK: Props
private extension PrimaryTextField {

    func initialDefaultUI() {

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
        setuplblTitle()
        setupTFBackgroundViewCons()
        setupClearButtonCons()
        setupTextFieldCons()
    }

    func setuplblTitle() {
        lblTitle.snp.makeConstraints { maker in
            maker.top.equalToSuperview()
            maker.bottom.equalTo(tfBackgroundView.snp.top).inset(-4)
            maker.height.equalTo(28)
        }
    }

    func setupTFBackgroundViewCons() {
        tfBackgroundView.snp.makeConstraints { maker in
            maker.leading.trailing.bottom.equalToSuperview()
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
            maker.leading.equalToSuperview().inset(12)
            maker.trailing.equalTo(btnClear.snp.leading)
        }
    }

    func handleVisibilityClearButton() {
        btnClear.isHidden = true
        btnClear.snp.updateConstraints { maker in
            maker.width.equalTo(0)
        }
        /*if textField.text?.isEmpty == true {
            btnClear.isHidden = true
            btnClear.snp.updateConstraints { maker in
                maker.width.equalTo(0)
            }
        } else {
            btnClear.isHidden = false
            btnClear.snp.updateConstraints { maker in
                maker.width.equalTo(32)
            }
        }*/
    }
}

// MARK: UITextFieldDelegate && Target
extension PrimaryTextField: UITextFieldDelegate {

    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.tfBackgroundView.layer.borderColor = focusedBorderColor
        self.lblTitle.textColor = UIColor(cgColor: focusedBorderColor)
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        self.tfBackgroundView.layer.borderColor = defaultBorderColor
        self.lblTitle.textColor = UIColor(cgColor: defaultBorderColor)
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return textField.setMaxLengthShouldChangeCharactersIn(range: range, string: string, maxLength: self.maxCharacterLenght)
    }

    @objc func textFieldDidChange(_ textField: UITextField) {
        textField.text = textField.text?.replacingOccurrences(of: ",", with: ".")

        handleVisibilityClearButton()

        if isPhoneNumber {
            textField.text = textField.text?.applyPatternOnNumbers(pattern: "# (###) ### ## ##", replacementCharacter: "#")
        }

        if let arrayListener = self.arrayListenDidChange {
            for listener in arrayListener {
                listener(textField.text ?? "")
            }
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let text = textField.text, !text.isEmpty {
            self.clickListener?(text)
            textField.resignFirstResponder()
            return true
        }
        return false
    }
}

// MARK: Delegate wrapper completion listener
extension PrimaryTextField {

    func addListenDidChange(listener: @escaping PrimaryTextFieldListener) {
        self.arrayListenDidChange?.append(listener)
    }
}
