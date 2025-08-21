//
//  SecondPhoneViewModel.swift
//  SeSACRxThreads
//
//  Created by andev on 8/21/25.
//

import Foundation
import RxSwift
import RxCocoa

final class SecondPhoneViewModel {
    
    private let disposeBag = DisposeBag()
    
    struct Input {
        let buttonTap: ControlEvent<Void>
        let text: ControlProperty<String>
    }
    
    struct Output {
        let text: BehaviorSubject<String>
    }
    
    init() {
        
    }
    
    func transform(input: Input) -> Output {
        
        let labelText = BehaviorSubject(value: "")
        //버튼 클릭 -> 레이블 내용
        input.buttonTap
            .withLatestFrom(input.text)
            .map { text in
                text.count >= 8 ? "통과" : "8자 이상 입력해주세요"
            }
            .bind(with: self, onNext: { owner, value in
                labelText.onNext(value)
            })
            .disposed(by: disposeBag)
        return Output(text: labelText)
    }
}
