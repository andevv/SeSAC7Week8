//
//  PhoneViewModel.swift
//  SeSACRxThreads
//
//  Created by andev on 8/21/25.
//

import Foundation
import RxSwift
import RxCocoa

class PhoneViewModel {
    
    private let disposeBag = DisposeBag()
    
    struct Input {
        let buttonTap: ControlEvent<Void>
    }
    
    struct Output {
        let text: BehaviorSubject<String>
    }
    
    init() {

    }
    
    func transform(input: Input) -> Output {
        
        let text = BehaviorSubject(value: "")
        
        // 버튼 클릭 시 subject
        input.buttonTap
            .bind(with: self) { owner, _ in
                text.onNext("칙촉 \(Int.random(in: 1...100))")
            }
            .disposed(by: disposeBag)
        
        return Output(text: text)
    }
}
