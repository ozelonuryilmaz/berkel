//
//  NativeProgressView.swift
//  berkel
//
//  Created by Onur Yilmaz on 13.09.2023.
//

import UIKit

class NativeProgressView: BaseReusableView {

    private lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.color = .whiteColor
        activityIndicator.hidesWhenStopped = true

        addSubview(activityIndicator)
        return activityIndicator
    }()

    override func initializeSelf() {
        alpha = 0
        backgroundColor = UIColor.black.withAlphaComponent(0.4)
        setupViews()
    }

    func playAnimation(isPlay: Bool) {
        if isPlay {
            playAnimation()
        } else {
            stopAnimation()
        }
    }

    func playAnimation(isPlay: Bool, parentView: UIView?) {
        if isPlay {
            playAnimation(parentView: parentView)
        } else {
            stopAnimation()
        }
    }

    func playAnimation() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            if !self.activityIndicator.isAnimating,
                let window = WindowHelper.getWindow() {
                window.addSubview(self)
                self.snp.makeConstraints { maker in
                    maker.edges.equalToSuperview()
                }
                window.bringSubviewToFront(self)
                UIView.animate(withDuration: 0.3) { [weak self] in
                    guard let self = self else { return }
                    self.alpha = 1.0
                }
                self.activityIndicator.startAnimating()
            }
        }
    }

    func playAnimation(parentView: UIView?) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            if !self.activityIndicator.isAnimating,
                let parentView = parentView {
                parentView.addSubview(self)
                self.snp.makeConstraints { maker in
                    maker.edges.equalToSuperview()
                }
                parentView.bringSubviewToFront(self)
                UIView.animate(withDuration: 0.3) { [weak self] in
                    guard let self = self else { return }
                    self.alpha = 1.0
                }
                self.activityIndicator.startAnimating()
            }
        }
    }

    func stopAnimation() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            if self.activityIndicator.isAnimating {
                UIView.animate(withDuration: 0.1) { [weak self] in
                    guard let self = self else { return }
                    self.alpha = 0
                } completion: { [weak self] completed in
                    guard let self = self else { return }
                    self.removeFromSuperview()
                    self.activityIndicator.stopAnimating()
                }
            }
        }
    }
}

private extension NativeProgressView {

    func setupViews() {
        addSubview(activityIndicator)
        activityIndicator.snp.makeConstraints { maker in
            maker.center.equalToSuperview()
        }
    }
}


