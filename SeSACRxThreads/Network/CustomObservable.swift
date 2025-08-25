//
//  CustomObservable.swift
//  SeSACRxThreads
//
//  Created by andev on 8/25/25.
//

import Foundation
import RxSwift

final class CustomObservable {
    
    static func randomNumber() -> Observable<Int>  {
        
        return Observable<Int>.create { observer in
            
            observer.onNext(Int.random(in: 1...100))
            observer.onCompleted() //메모리 누수 방지
            
            return Disposables.create()
        }
    }
    
    static func recommandNickname() -> Observable<String> {
        
        return Observable<String>.create { observer in
            
            let text: [String?] = ["고래밥", nil, "칙촉", "카스타드", "몽쉘", "오예스"]
            guard let random = text.randomElement(), let result = random else {
                observer.onError(JackError.invalid)
                return Disposables.create()
            }
            
            if result == "카스타드" {
                observer.onError(JackError.invalid)
            } else {
                observer.onNext(result)
                observer.onCompleted()
            }
            
            return Disposables.create()
        }
    }
    
}
