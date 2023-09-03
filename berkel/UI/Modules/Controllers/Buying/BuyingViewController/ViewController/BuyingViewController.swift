//
//  BuyingViewController.swift
//  berkel
//
//  Created by Onur Yilmaz on 2.09.2023.
//  Copyright (c) 2023 Emlakjet IOS Development Team. All rights reserved.[EC-2021]
//

import UIKit
import Combine
import FirebaseFirestore

struct City: Codable {
    var name: String? = nil
    var state: String? = nil

    // local variable
    var id: String? = nil
}

final class BuyingViewController: MainBaseViewController {

    var cancelBag = Set<AnyCancellable>()
    let db = Firestore.firestore()

    func setSanFranciscoData(city: City) {
        let onErrorCompletion: (Subscribers.Completion<Error>) -> Void = { completion in
            switch completion {
            case .finished: print("🏁 finished")
            case .failure(let error): print("❗️ failure: \(error)")
            }
        }

        let onValue: () -> Void = {
            print("✅ value")
        }

        // Add a new document in collection "cities"
        (db.collection("cities")
            .document("SF")
            .setData(from: city) as AnyPublisher<Void, Error>) // Note: you can use (as Void) for simple setData({})
        .sink(receiveCompletion: onErrorCompletion, receiveValue: onValue)
            .store(in: &cancelBag)
    }

    // Add a new document with a generated id.
    func addSanFranciscoDocument(city: City) {
        (db.collection("cities")
            .addDocument(data: [
                "name": city.name ?? "nil",
                "state": city.state ?? "nil"
            ]) as AnyPublisher<DocumentReference, Error>).sink(receiveCompletion: { completion in
                
                switch completion {
                case .finished:
                    print("🏁 finished")
                case .failure(let error):
                    print("❗️ failure: \(error)")
                }
                
            }, receiveValue: { value in
                print("** \(value.documentID)")
            }).store(in: &cancelBag)
        
        
        /*(db.collection("cities")
            .addDocument(data: [
                "name": city.name ?? "nil",
                "state": city.state ?? "nil"
        ]) as AnyPublisher<DocumentReference, Error>)
            .sink(receiveCompletion: { completion in
            switch completion {
            case .finished: print("🏁 finished")
            case .failure(let error): print("❗️ failure: \(error)")
            }) { ref in
            print("Document added with ID: \(ref.documentID)")
        }.store(in: &cancelBag)*/
        
    }


    // MARK: Constants

    // MARK: Inject
    private let viewModel: IBuyingViewModel

    // MARK: IBOutlets

    // MARK: Constraints Outlets

    // MARK: Initializer
    init(viewModel: IBuyingViewModel) {
        self.viewModel = viewModel
        super.init(nibName: "BuyingViewController", bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        return nil
    }

    override func initialComponents() {
        self.observeReactiveDatas()

        //setSanFranciscoData(city: City(name: "Onur", state: "Aktif"))
                //addSanFranciscoDocument(city: City(name: "Onur", state: "Aktif"))
    }

    override func registerEvents() {

    }

    private func observeReactiveDatas() {
        observeViewState()
        observeActionState()
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
        // observeErrorState(errorState: viewModel._errorState)
    }

    // MARK: Define Components (if you have or delete this line)
}

// MARK: Props
private extension BuyingViewController {

}
