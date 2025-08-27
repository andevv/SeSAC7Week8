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
        let detail: PublishRelay<String>
    }
    
    func transform(input: Input) -> Output {
        
        let detail = PublishRelay<String>()
        
        input.buttonTap
            .bind(with: self) { owner, _ in
                detail.accept("고래밥")
            }
            .disposed(by: disposeBag)
        
        return Output(detail: detail)
    }
    
}
