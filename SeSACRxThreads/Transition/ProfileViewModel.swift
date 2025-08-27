//
//  ProfileViewModel.swift
//  SeSACRxThreads
//
//  Created by andev on 8/27/25.
//

import Foundation
import RxSwift //Rx
import RxCocoa //UIKit wrapping

final class ProfileViewModel: BaseViewModel {
    
    let disposeBag = DisposeBag()
    
    struct Input {
        let buttonTap: Observable<Void>
    }
    
    struct Output {
        let detail: Driver<String>
        let placeholder: Observable<String>
        let buttonTitle: Observable<String>
    }
    
    func transform(input: Input) -> Output {
        
        let detail = PublishRelay<String>()
        
        input.buttonTap
            .observe(on: ConcurrentDispatchQueueScheduler(qos: .default))
            .bind(with: self) { owner, _ in
                print("1", Thread.isMainThread)
                detail.accept("고래밥")
            }
            .disposed(by: disposeBag)
        
        return Output(detail: detail.asDriver(onErrorJustReturn: ""), placeholder: Observable.just("닉네임을 입력해주세요"), buttonTitle: Observable.just("다음"))
    }
    
}
