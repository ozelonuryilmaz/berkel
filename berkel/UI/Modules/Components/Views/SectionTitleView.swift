//
//  SectionTitleView.swift
//  berkel
//
//  Created by Onur Yilmaz on 11.12.2023.
//


import UIKit

@IBDesignable
class SectionTitleView: BaseReusableView {

    static let defaultHeight: CGFloat = 50

    // MARK: Private Props

    @IBInspectable
    var text: String? {
        get { return labelTitle.text }
        set { labelTitle.text = newValue }
    }

    @IBInspectable
    var mBackgroundColor: UIColor = .primaryVeryLightGray {
        didSet {
            self.backgroundColor = mBackgroundColor
        }
    }

    override func initializeSelf() {
        self.backgroundColor = mBackgroundColor
        setupAllConstraints()
    }

    // MARK: Definitions

    private lazy var labelTitle: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = .blackColor

        self.addSubview(label)
        return label
    }()
}

private extension SectionTitleView {

    func setupAllConstraints() {
        setupLabelTitleCons()
    }

    func setupLabelTitleCons() {
        labelTitle.snp.makeConstraints { maker in
            maker.top.equalToSuperview().offset(24)
            maker.bottom.equalToSuperview().inset(8)
            maker.leading.trailing.equalToSuperview().offset(32)
        }
    }
}
