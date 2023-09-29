//
//  BuyingTableViewCell.swift
//  berkel
//
//  Created by Onur Yilmaz on 29.09.2023.
//

import UIKit

protocol BuyingTableViewCellOutputDelegate: AnyObject {
    func cellTapped(uiModel: IBuyingTableViewCellUIModel)
    func addCollectionTapped(uiModel: IBuyingTableViewCellUIModel)
    func addPaymentTapped(uiModel: IBuyingTableViewCellUIModel)
    
}

class BuyingTableViewCell: BaseTableViewCell {
    
    weak var outputDelegate: BuyingTableViewCellOutputDelegate? = nil
    
    @IBOutlet private weak var mContentView: ShadowView!
    @IBOutlet private weak var btnAddCollection: UIButton!
    @IBOutlet private weak var btnAddPayment: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        mContentView.roundCornersEachCorner(.allCorners, radius: 8)
    }
    
    func registerEvents(uiModel: IBuyingTableViewCellUIModel) {

        // Events
        mContentView.onTap { [unowned self] _ in
            self.outputDelegate?.cellTapped(uiModel: uiModel)
        }

        btnAddCollection.onTap { [unowned self] _ in
            self.outputDelegate?.addCollectionTapped(uiModel: uiModel)
        }
        
        btnAddPayment.onTap { [unowned self] _ in
            self.outputDelegate?.addPaymentTapped(uiModel: uiModel)
        }
    }

    func configureCellWith(uiModel: IBuyingTableViewCellUIModel) {
        //self.registerEvents(uiModel: uiModel)

    }
    
}
