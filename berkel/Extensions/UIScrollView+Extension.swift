//
//  UIScrollView+Extension.swift
//  berkel
//
//  Created by Onur Yilmaz on 19.09.2023.
//

import UIKit

extension UIScrollView {
    
    var isScrollToTop: Bool {
        let topEdge = 0 - contentInset.top
        return contentOffset.y <= topEdge
    }

    var isScrollToBottom: Bool {
        let bottomEdge = contentSize.height + contentInset.bottom - bounds.height
        return contentOffset.y >= bottomEdge
    }
    
    var isAvailablePagination: Bool {
        if contentSize.height == 0 { return false }
        let height = frame.size.height
        let contentYoffset = contentOffset.y
        let distanceFromBottom = contentSize.height - contentYoffset
        return distanceFromBottom < height
    }

    func scrollToTop(animated: Bool = false) {
        let desiredOffset = CGPoint(x: -contentInset.left, y: -contentInset.top)
        setContentOffset(desiredOffset, animated: animated)
    }

    // scroll view'in kaydırılması durdurulur
    func scrollStopDragging(animated: Bool = false) {
        let contentOffset = self.contentOffset
        self.setContentOffset(contentOffset, animated: animated)
    }
}
