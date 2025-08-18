//
//  PhotoManager.swift
//  SeSACRxThreads
//
//  Created by Jack on 8/18/25.
//

import Foundation
import Alamofire

class PhotoManager {
    
    static let shared = PhotoManager()

    private init() { }
    
    func getRandomPhoto(api: PhotoRouter, success: @escaping (Photo) -> Void) {
        
        AF.request(api.endPoint,
                   method: api.method,
                   parameters: api.parameters,
                   encoding: URLEncoding(destination: .queryString))
        .responseDecodable(of: Photo.self) { response in
            switch response.result {
            case .success(let value):
                dump(value)
                
                success(value)
                
            case .failure(let error):
                print("fail", error)
            }
            
        }
    } 
    
}

