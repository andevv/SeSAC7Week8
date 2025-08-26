//
//  BirthdayViewModel.swift
//  SeSACRxThreads
//
//  Created by andev on 8/22/25.
//

import Foundation
import RxSwift
import RxCocoa

final class BirthdayViewModel: BaseViewModel {
    
    let disposeBag = DisposeBag()
    
    struct Input {
        //let datePicker: BehaviorSubject<Date>
    }
    
    let date: BehaviorSubject<Date> = BehaviorSubject(value: .now)
    
    struct Output {
        let year: BehaviorSubject<String>
        let month: BehaviorSubject<String>
        let day: BehaviorSubject<String>
    }
    
    init() { }
    
    func transform(input: Input) -> Output {
        
        let year = BehaviorSubject(value: "2025")
        let month = BehaviorSubject(value: "8")
        let day = BehaviorSubject(value: "22")
        
        //input.datePicker
        date
            .bind(with: self) { owner, date in
                
                let component = Calendar.current.dateComponents([.year, .month, .day], from: date)
                year.onNext("\(component.year!)")
                month.onNext("\(component.month!)")
                day.onNext("\(component.day!)")
            }
            .disposed(by: disposeBag)
        
        return Output(year: year, month: month, day: day)
    }
}
