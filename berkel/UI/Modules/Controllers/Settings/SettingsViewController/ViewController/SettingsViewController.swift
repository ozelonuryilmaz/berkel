//
//  SettingsViewController.swift
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

final class SettingsViewController: MainBaseViewController {

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
        ]) as AnyPublisher<DocumentReference, Error>)

            .sink(receiveCompletion: { completion in
            switch completion {
            case .finished:
                print("🏁 finished")
            case .failure(let error):
                print("❗️ failure: \(error)")
            }
        }, receiveValue: { value in
            print("** \(value.documentID)")
        })
            .store(in: &cancelBag)

    }

    func getDocument() {
        db.collection("seaons")
            .document("SF")
            .getDocument()
            .sink(receiveCompletion: { (completion) in
            switch completion {
            case .finished: print("🏁 finished")
            case .failure(let error): print("❗️ failure: \(error)")
            }
        }) { document in
            print("Document data: \(document.data())")
        }.store(in: &cancelBag)
    }

    func getCollection() {
        db.collection("seasons")
            .document("2022-2023")
            .collection("buying")
            .getDocuments()
            .sink(receiveCompletion: { (completion) in
            switch completion {
            case .finished: print("🏁 finished")
            case .failure(let error): print("❗️ failure: \(error)")
            }
        }, receiveValue: { value in
            value.documents.forEach { ss in
                print("***\(ss.documentID), \(ss.data())")
            }
        }).store(in: &cancelBag)
    }

    // MARK: Constants

    // MARK: Inject
    private let viewModel: ISettingsViewModel

    // MARK: IBOutlets

    // MARK: Constraints Outlets

    // MARK: Initializer
    init(viewModel: ISettingsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: "SettingsViewController", bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        return nil
    }

    override func initialComponents() {
        self.observeReactiveDatas()
        //setSanFranciscoData(city: City(name: "Onur", state: "Aktif"))
        //addSanFranciscoDocument(city: City(name: "Onur", state: "Aktif"))
        self.setSanFranciscoData(city: City(name: "Onur", state: UUID().uuidString))
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.getCollection()
    }

    override func registerEvents() {

    }

    private func observeReactiveDatas() {
        observeViewState()
        observeActionState()
        // listenErrorState()
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
private extension SettingsViewController {

}
