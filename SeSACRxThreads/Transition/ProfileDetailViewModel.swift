//
//  ProfileDetailViewModel.swift
//  SeSACRxThreads
//
//  Created by andev on 8/27/25.
//

import Foundation
import RxSwift
import RxCocoa

final class ProfileDetailViewModel: BaseViewModel {
    
    private let text: String
    
    init(text: String) {
        self.text = text
    }
    
    struct Input {
        
    }
    
    struct Output {
        let navTitle: Observable<String>
    }
    
    private let disposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        
        let title = Observable.just("Jack \(Int.random(in: 1...10)) \(text)")
        return Output(navTitle: title)
    }
    
}
