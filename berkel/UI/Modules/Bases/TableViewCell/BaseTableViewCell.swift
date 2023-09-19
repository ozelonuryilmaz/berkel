//
//  BaseTableViewCell.swift
//  EmlakjetIndividual
//
//  Created by Yunus Emre Celebi on 11.10.2021.
//

import UIKit

class BaseTableViewCell: UITableViewCell {

    class var reuseIdentifier: String {
        return "\(self)"
    }

    class var nibInstance: UINib {
        return .init(nibName: "\(self)", bundle: nil)
    }

    class var defaultHeight: CGFloat {
        return UITableView.automaticDimension
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    } 
}

class BaseTableViewHeaderFooterView: UITableViewHeaderFooterView {

    class var reuseIdentifier: String {
        return "\(self)"
    }

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        initializeView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initializeView()
    }

    internal func initializeView() { }
}

