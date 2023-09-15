//
//  AddSellerRepository.swift
//  berkel
//
//  Created by Onur Yilmaz on 15.09.2023.
//  Copyright (c) 2023 Emlakjet IOS Development Team. All rights reserved.[EC-2021]
//

import FirebaseFirestore

protocol IAddSellerRepository: AnyObject {

    func saveNewSeller(data: AddSellerModel) -> FirestoreResponseType<AddSellerModel>
}

final class AddSellerRepository: BaseRepository, IAddSellerRepository {

    func saveNewSeller(data: AddSellerModel) -> FirestoreResponseType<AddSellerModel> {
        return self.setData(SellerService.save, data: data)
    }
}
