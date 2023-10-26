//
//  WorkerViewController.swift
//  berkel
//
//  Created by Onur Yilmaz on 2.09.2023.
//  Copyright (c) 2023 Emlakjet IOS Development Team. All rights reserved.[EC-2021]
//

import UIKit

final class WorkerViewController: MainBaseViewController {

    // MARK: Constants

    // MARK: Inject
    private let viewModel: IWorkerViewModel

    // MARK: IBOutlets

    // MARK: Constraints Outlets
    
    // MARK: Initializer
    init(viewModel: IWorkerViewModel) {
        self.viewModel = viewModel
        super.init(nibName: "WorkerViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        return nil
    }

    override func initialComponents() {
        self.observeReactiveDatas()
    }

    override func registerEvents() {

    }

    private func observeReactiveDatas() {
        observeViewState()
        observeActionState()
        listenErrorState()
    }

    private func observeViewState() {
        
    }

    private func observeActionState() {
        /* viewModel._actionState.observeNext { [unowned self] state in
             switch state {
            
            } 
        }.dispose(in: disposeBag) */
    }

    private func listenErrorState() {
    }

    // MARK: Define Components
}

// MARK: Props
private extension WorkerViewController {
    
}
