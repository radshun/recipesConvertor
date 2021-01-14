//
//  GeneralService.swift
//  RecipesConvertor
//
//  Created by Daniel Radshun on 13/01/2021.
//

import Foundation

typealias GeneralDataCompletion = (CustomCompletionResponse<GeneralDetails?,String?>) -> ()

class GeneralService: BaseService {
    
    func fetchGeneralData(completion: @escaping GeneralDataCompletion) {
        self.request(GeneralApi.generalData, type: GeneralDetails.self) { response in
            switch response {
            case .success(let generalDetails):
                completion(.success(generalDetails))
            case .failure(let error):
                completion(.failure(error.localizedDescription))
            }
        }
    }
}
