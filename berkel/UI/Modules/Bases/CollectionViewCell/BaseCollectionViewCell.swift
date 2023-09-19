//
//  BaseCollectionViewCell.swift
//  EmlakjetIndividual
//
//  Created by Yunus Emre Celebi on 11.10.2021.
//

import UIKit

class BaseCollectionViewCell: UICollectionViewCell {

    class var reuseIdentifier: String {
        return "\(self)"
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        initializeCell()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initializeCell()
    }

    open override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        initializeCell()
    }

    internal func initializeCell() { }
    
    func calculateBaseDynamicWidth(height: CGFloat) -> CGSize {
        setNeedsLayout()
        layoutIfNeeded()
        let size: CGSize = contentView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        return CGSize(width: size.width, height: height)
    }

}

class BaseCollectionReusableView: UICollectionReusableView {

    class var reuseIdentifier: String {
        return "\(self)"
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        initializeView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    internal func initializeView() { }

}
