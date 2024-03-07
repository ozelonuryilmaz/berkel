//
//  NewCavusRepository.swift
//  berkel
//
//  Created by Onur Yilmaz on 31.10.2023.
//

import FirebaseFirestore

protocol INewCavusRepository: AnyObject {

    func saveNewCavus(data: CavusModel) -> FirestoreResponseType<CavusModel>
    func updateCavus(data: CavusModel) -> FirestoreResponseType<Bool>
}

final class NewCavusRepository: BaseRepository, INewCavusRepository {

    func saveNewCavus(data: CavusModel) -> FirestoreResponseType<CavusModel> {
        let db: DocumentReference = CavusService.save.collectionReference.document()
        let key = db.documentID
        
        var tempData = data
        tempData.id = key
        
        return self.setData(db, data: tempData)
    }
    
    func updateCavus(data: CavusModel) -> FirestoreResponseType<Bool> {
        let db = CavusService.update(id: data.id ?? "").documentReference
        return updateData(db, data: ["name": data.name,
                                     "phoneNumber": data.phoneNumber,
                                     "description": data.description ?? "",
                                     "date": data.date ?? ""])
    }
}
