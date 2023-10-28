//
//  SeasonsRepository.swift
//  berkel
//
//  Created by Onur Yilmaz on 25.09.2023.
//

import FirebaseFirestore

protocol ISeasonsRepository: AnyObject {

    func getSeasonList() -> FirestoreResponseType<[SeasonResponseModel]>
    func saveSeason(season: SeasonResponseModel) -> FirestoreResponseType<SeasonResponseModel>
}

final class SeasonsRepository: BaseRepository, ISeasonsRepository {

    func getSeasonList() -> FirestoreResponseType<[SeasonResponseModel]> {
        return getDocuments(SeasonItemService.list,
                            order: SeasonItemService.list.order)
    }

    func saveSeason(season: SeasonResponseModel) -> FirestoreResponseType<SeasonResponseModel> {
        let db: DocumentReference = SeasonItemService.save.collectionReference.document()
        return self.setData(db, data: season)
    }
}
