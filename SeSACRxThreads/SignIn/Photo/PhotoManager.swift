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
        .validate(statusCode: 200..<300)
        .responseDecodable(of: Photo.self) { response in
            switch response.result {
            case .success(let value):
                dump(value)
                success(value)
            case .failure(let error):
                print("fail", error)
                
                let code = response.response?.statusCode ?? 500
                
                let errorType = NetworkError(rawValue: code) ?? .unknown
                print(errorType.userResponse)
            }
        }
    }
    
    func getRandomPhotoDecodable(api: PhotoRouter, success: @escaping (Photo) -> Void) {
        
        AF.request(api.endPoint,
                   method: api.method,
                   parameters: api.parameters,
                   encoding: URLEncoding(destination: .queryString))
        .validate(statusCode: 200..<300)
        .responseDecodable(of: Photo.self) { response in
            switch response.result {
            case .success(let value):
                dump(value)
                
                success(value)
                
            case .failure(let error):
                print("fail", error)
                
                guard let code = response.response?.statusCode,
                      let data = response.data else {
                    return
                }
                do {
                    let result = try JSONDecoder().decode(PhotoError.self, from: data)
                    dump(result)
                } catch {
                    print("에러 구조체에 담기 실패. 200-299번 디코딩 실패도 이쪽으로 옴")
                }
            }
            
        }
    }
    
    
    func getRandomPhotoString(api: PhotoRouter, success: @escaping (Photo) -> Void) {
        
        AF.request(api.endPoint,
                   method: api.method,
                   parameters: api.parameters,
                   encoding: URLEncoding(destination: .queryString))
        .validate(statusCode: 200..<500)
        .responseString { response in
            let code = response.response?.statusCode ?? 500
            guard let data = response.data else {
                return
            }
            
            switch code {
            case 200..<300:
                do {
                    let result = try JSONDecoder().decode(Photo.self, from: data)
                    dump(result)
                } catch {
                    print("Photo 구조체에 담기 실패")
                }
            default:
                do {
                    let result = try JSONDecoder().decode(PhotoError.self, from: data)
                    dump(result)
                } catch {
                    print("PhotoError 구조체에 담기 실패")
                }
            }
        }
    }
    
}


