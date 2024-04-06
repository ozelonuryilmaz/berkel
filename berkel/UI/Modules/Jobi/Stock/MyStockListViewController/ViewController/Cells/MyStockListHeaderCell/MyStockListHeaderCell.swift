//
//  MyStockListHeaderCell.swift
//  berkel
//
//  Created by Onur Yilmaz on 25.03.2024.
//

import UIKit
import SnapKit

protocol MyStockListHeaderCellOutputDelegate: AnyObject {
    func appendSubStockButtonTap(uiModel: MyStockListHeaderCellUIModel)
}

class MyStockListHeaderCell: BaseTableViewHeaderFooterView {
    
    static let defaultHeight: CGFloat = SectionTitleView.defaultHeight
    
    weak var outputDelegate: MyStockListHeaderCellOutputDelegate? = nil

    override func initializeView() {
        setupAllConstraints()
    }

    func configureCell(with uiModel: MyStockListHeaderCellUIModel) {
        registerEvents(uiModel: uiModel)

        headerTitleView.text = uiModel.stockName
    }
    
    private func registerEvents(uiModel: MyStockListHeaderCellUIModel) {
        
        btnSubStock.onTap { [unowned self] _ in
            self.outputDelegate?.appendSubStockButtonTap(uiModel: uiModel)
        }
    }

    // MARK: Component Definitions
    private lazy var headerTitleView: SectionTitleView = {
        let titleView = SectionTitleView()

        addSubview(titleView)
        return titleView
    }()
    
    private lazy var btnSubStock: UIButton = {
        let btn = UIButton()
        btn.setTitle("+", for: .normal)
        btn.setTitleColor(.blackColor, for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 24, weight: .medium)
        
        addSubview(btn)
        return btn
    }()
}

// MARK: UI
extension MyStockListHeaderCell {

    func setupAllConstraints() {
        headerTitleView.snp.makeConstraints { maker in
            maker.leading.top.bottom.equalToSuperview()
            maker.height.equalTo(SectionTitleView.defaultHeight)
        }
        
        btnSubStock.snp.makeConstraints { maker in
            maker.leading.equalTo(headerTitleView.snp.trailing)
            maker.trailing.equalToSuperview().offset(-32)
            maker.centerY.equalTo(headerTitleView).offset(8)
            maker.width.equalTo(44)
            maker.height.equalTo(44)
        }
    }
}

