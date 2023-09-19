//
//  HighlightCollectionViewCell.swift
//  EmlakjetIndividual
//
//  Created by Yunus Emre Celebi on 11.10.2021.
//

import UIKit

class HighlightCollectionViewCell: BaseCollectionViewCell {

    // for highlight
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        animatedAlpha(from: 1.0, to: 0.6)
    }

    // for highlight
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        animatedAlpha(from: 0.6, to: 1.0)
    }

    // for highlight
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        animatedAlpha(from: 0.6, to: 1.0)
    }
}

