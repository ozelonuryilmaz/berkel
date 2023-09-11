//
//  UITextField+Extensions.swift
//  berkel
//
//  Created by Onur Yilmaz on 11.09.2023.
//

import UIKit

extension UITextField {

    func convertToJustClickable(handler: @escaping () -> Void) {
        inputView = UIView()
        inputAccessoryView = UIView()
        onTap { _ in handler() }
        onLongPress { _ in /* nothing here */ }
    }

    func disablePasswordSuggestion() {
        self.textContentType = .newPassword
    }

    func setEmptyText() {
        self.text = ""
    }

    func enable() {
        isEnabled = true
    }

    func disable() {
        isEnabled = false
    }

    func addLeftImage(imageName: String) {
        self.leftViewMode = UITextField.ViewMode.always
        let mView = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 20))
        let mImage = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        mImage.image = UIImage(named: imageName)
        mView.addSubview(mImage)
        self.leftView = mView
    }

    func useUnderline() {
        self.layer.sublayers?.forEach {
            if($0.name == "underline") {
                $0.removeFromSuperlayer()
            }
        }

        let border = CALayer()
        let borderWidth = CGFloat(1.0)
        border.borderColor = UIColor.lightGray.cgColor
        border.frame = CGRect(origin: CGPoint(x: 0, y: self.frame.size.height - borderWidth), size: CGSize(width: self.frame.size.width, height: borderWidth))
        border.borderWidth = borderWidth
        border.name = "underline"
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true

    }

    func changeColorUnderline(color: CGColor) {
        self.layer.sublayers?.forEach {
            if($0.name == "underline") {
                $0.borderColor = color
            }
        }
    }

    func setPlaceHolderProps(color: UIColor? = .lightGray, font: UIFont? = UIFont.systemFont(ofSize: 16)) {
        self.attributedPlaceholder = NSAttributedString(string: self.placeholder != nil ? self.placeholder! : "", attributes: [
            NSAttributedString.Key.foregroundColor: color!,
            NSAttributedString.Key.font: font!
        ])
    }

    func limitationDigitForNumber(range: NSRange, string: String, maxLength: Int) -> Bool {
        let inverseSet = CharacterSet(charactersIn: "+0123456789()").inverted

        let components = string.components(separatedBy: inverseSet)
        let filtered = components.joined(separator: "")

        return string == filtered &&
            self.setMaxLengthShouldChangeCharactersIn(range: range, string: string, maxLength: maxLength)
    }

    func setMaxLengthShouldChangeCharactersIn(range: NSRange, string: String, maxLength: Int) -> Bool {
        guard let text = self.text,
            let rangeOfTextToReplace = Range(range, in: text) else {
            return false
        }
        let substringToReplace = text[rangeOfTextToReplace]
        let count = text.count - substringToReplace.count + string.count

        return count <= maxLength
    }

    func setCursorLocation(_ location: Int) {
        if let cursorLocation = position(from: beginningOfDocument, offset: location) {
            DispatchQueue.main.async { [weak self] in
                guard let strongSelf = self else { return }
                strongSelf.selectedTextRange = strongSelf.textRange(from: cursorLocation, to: cursorLocation)
            }
        }
    }

}
