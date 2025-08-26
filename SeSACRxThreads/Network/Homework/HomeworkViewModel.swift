//
//  HomeworkViewModel.swift
//  SeSACRxThreads
//
//  Created by andev on 8/26/25.
//

import Foundation
import RxSwift
import RxCocoa

final class HomeworkViewModel: BaseViewModel {
    
    let disposeBag = DisposeBag()
    
    struct Input {
        let searchTap: ControlEvent<Void>
        let searchText: ControlProperty<String>
        let cellSelected: ControlEvent<Int>
    }
    
    struct Output {
        let list: BehaviorRelay<[Lotto]>
        let items: BehaviorRelay<[String]>
    }
    
    func transform(input: Input) -> Output {
        
        let list = BehaviorRelay(
            value: [Lotto(drwNoDate: "테스트", firstAccumamnt: 10)]
        )
        
        let items = BehaviorRelay(value: ["1", "2", "3"])
        
        input.searchTap
            .withLatestFrom(input.searchText)
            .distinctUntilChanged()
            .flatMap { text in
                CustomObservable.getLotto(query: text)
                    .debug("로또 옵저버블")
            }
            .debug("서치바 옵저버블")
            .subscribe(with: self) { owner, lotto in
                print("onNext", lotto)
                var data = list.value
                data.insert(lotto, at: 0)
                list.accept(data)
            } onError: { owner, error in
                print("onError", error)
            } onCompleted: { owner in
                print("onCompleted")
            } onDisposed: { owner in
                print("onDisposed")
            }
            .disposed(by: disposeBag)
        
        input.cellSelected
            .map { "셀 \($0)" }
            .bind(with: self) { owner, number in
                var original = items.value
                original.insert(number, at: 0)
                
                items.accept(original)
            }
            .disposed(by: disposeBag)

        return Output(list: list, items: items)
    }
    
}
