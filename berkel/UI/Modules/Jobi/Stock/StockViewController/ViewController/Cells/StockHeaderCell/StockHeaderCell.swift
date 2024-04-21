//
//  StockHeaderCell.swift
//  berkel
//
//  Created by Onur Yilmaz on 6.04.2024.
//

import UIKit
import SnapKit

protocol StockHeaderCellOutputDelegate: AnyObject {

    func updateStockCounts(stockModel: StockModel)
}

class StockHeaderCell: BaseTableViewHeaderFooterView {
    
    static let defaultHeight: CGFloat = SectionTitleView.defaultHeight
    
    weak var outputDelegate: StockHeaderCellOutputDelegate? = nil

    override func initializeView() {
        setupAllConstraints()
    }

    func configureCell(with uiModel: StockHeaderCellUIModel) {
        registerEvents(uiModel: uiModel)

        headerTitleView.text = uiModel.stockName
        lblDate.text = uiModel.date
        btnUpdateStock.isHidden = uiModel.isUpdateButtonHideable
    }
    
    private func registerEvents(uiModel: StockHeaderCellUIModel) {
        
        btnUpdateStock.onTap { [unowned self] _ in
            self.outputDelegate?.updateStockCounts(stockModel: uiModel.stockModel)
        }
    }

    // MARK: Component Definitions
    private lazy var headerTitleView: SectionTitleView = {
        let titleView = SectionTitleView()

        addSubview(titleView)
        return titleView
    }()
    
    private lazy var lblDate: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: 12)
        lbl.textColor = .darkGray
        
        addSubview(lbl)
        lbl.bringSubviewToFront(self.contentView)
        return lbl
    }()
    
    private lazy var btnUpdateStock: UIButton = {
        let btn = UIButton()
        btn.setTitle("Güncelle", for: .normal)
        btn.setTitleColor(.primaryBlue, for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        
        addSubview(btn)
        return btn
    }()
}

// MARK: UI
extension StockHeaderCell {

    func setupAllConstraints() {
        headerTitleView.snp.makeConstraints { maker in
            maker.leading.top.bottom.equalToSuperview()
            maker.height.equalTo(SectionTitleView.defaultHeight)
        }
        
        lblDate.snp.makeConstraints { maker in
            maker.leading.equalToSuperview().offset(32)
            maker.trailing.equalToSuperview().offset(-76)
            maker.top.equalTo(headerTitleView.snp.bottom).offset(6)
            maker.bottom.equalToSuperview()
            maker.height.equalTo(26)
        }
        
        btnUpdateStock.snp.makeConstraints { maker in
            maker.leading.equalTo(headerTitleView.snp.trailing)
            maker.trailing.equalToSuperview().offset(-32)
            maker.centerY.equalTo(headerTitleView).offset(16)
            maker.width.equalTo(70)
            maker.height.equalTo(44)
        }
    }
}

