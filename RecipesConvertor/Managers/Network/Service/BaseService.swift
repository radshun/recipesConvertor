//
//  BaseService.swift
//  RecipesConvertor
//
//  Created by Daniel Radshun on 13/01/2021.
//

import Foundation

enum CompletionResponse<T> {
    case success(T)
    case failure(Error)
}

enum CustomCompletionResponse<T,S> {
    case success(T)
    case failure(S)
}

class BaseService {
    
    lazy var baseApi = BaseApiReference().reference
    
    func request<T: Decodable>(_ target: TargetType, type: T.Type, completion: @escaping (CompletionResponse<T>) -> ()) {
        baseApi?.child(target.path).observeSingleEvent(of: .value, with: { (snapshot) in
            do {
                let json = snapshot.value as? NSDictionary ?? [:]
                let data = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
                let decodedResponse = try JSONDecoder().decode(T.self, from: data)
                completion(.success(decodedResponse))
            } catch {
                completion(.failure(error))
            }
        }) { (error) in
            completion(.failure(error))
        }
    }
}
