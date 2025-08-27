//
//  ProfileDetailViewController.swift
//  SeSACRxThreads
//
//  Created by andev on 8/27/25.
//

import UIKit
import RxSwift
import RxCocoa

class ProfileDetailViewController: UIViewController {
    
    private let viewModel: ProfileDetailViewModel
    private let disposeBag = DisposeBag()
    
    init(viewModel: ProfileDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .lightGray
        

        
        bind()

    }
    
    func bind() {
        
        let input = ProfileDetailViewModel.Input()
        let output = viewModel.transform(input: input)
        
        output.navTitle
            .bind(to: navigationItem.rx.title)
            .disposed(by: disposeBag)
    }



}
