//
//  BaseViewModel.swift
//  SeSACRxThreads
//
//  Created by andev on 8/26/25.
//

import Foundation

protocol BaseViewModel {
    
    associatedtype Input //input
    associatedtype Output //output
    
    func transform(input: Input) -> Output
}
