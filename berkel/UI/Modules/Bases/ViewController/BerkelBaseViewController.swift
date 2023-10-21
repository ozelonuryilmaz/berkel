//
//  BerkelBaseViewController.swift
//  berkel
//
//  Created by Onur Yilmaz on 1.09.2023.
//

import UIKit
import Combine

class BerkelBaseViewController: UIViewController {
    
    public var navigationTitle: String? {
        return nil
    }
    
    public var navigationSubTitle: String? {
        return nil
    }
    
    var cancelBag = Set<AnyCancellable>()
    private var nativeProgressView: NativeProgressView?

    deinit {
        print("killed: \(type(of: self))")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        initDidLoad()

    }

    // just base sub class
    internal func initDidLoad() {
        self.nativeProgressView = NativeProgressView()
        self.initNavigationBarBackButton()
        self.initialComponents()
        self.setupView()
        self.registerEvents()
    }
    
    private func initNavigationBarBackButton() {
        self.setBackButtonTitle(title: "Geri")
        if #available(iOS 14.0, *) {
            // closed long press context menu
            navigationItem.backButtonDisplayMode = .minimal
        }
    }

    // Sayfa kapanmalarını alt sayfaya bildirmek için kullanılıyor
    public var willDismissCallback: DefaultDismissCallback? = nil
    public var didDismissCallback: DefaultDismissCallback? = nil

    // for all sub class
    func setupView() { }

    // for all sub class
    func initialComponents() { }

    // for all sub class
    func registerEvents() { }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationItem.titleView = nil
        if let navTitle = navigationTitle {
            if let subNavTitle = navigationSubTitle {
                self.navigationItem.setCustomTitle(navTitle, subtitle: subNavTitle)
            }else {
                self.navigationItem.title = navTitle
            }
        }

        hideAllToast()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        self.willDismissCallback?()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        self.didDismissCallback?()
    }
}

// MARK: Native Progress View
extension BerkelBaseViewController {

    func playNativeLoading(isLoading: Bool) {
        if isLoading {
            playNativeLoading()
        } else {
            stopNativeLoading()
        }
    }

    func playNativeLoading() {
        nativeProgressView?.playAnimation()
    }

    func stopNativeLoading() {
        nativeProgressView?.stopAnimation()
    }
}

extension BerkelBaseViewController {

    func observeErrorState(errorState: ErrorStateSubject,
                           errorHandle: FirestoreErrorHandle) {
        errorState.sink(receiveValue: { [weak self] errorType in
            self?.handleApiError(errorType: errorType,
                                errorHandler: errorHandle)
        }).store(in: &cancelBag)
    }

    private func handleApiError(errorType: NetworkingError?,
                                errorHandler: FirestoreErrorHandle) {

        switch errorType {
        case .COMMON_ERROR(_),
             .UNDEFINED_RESPONSE_TYPE:

            errorHandler.handleCommonError(title: nil,errorMessage: errorType?.description ?? "Beklenmedik bir hata oluştu")
        case .ERROR_MESSAGE(let title, let msg):
            errorHandler.handleCommonError(title: title, errorMessage: msg)
            
        case .none:
            break
        }
    }
}
