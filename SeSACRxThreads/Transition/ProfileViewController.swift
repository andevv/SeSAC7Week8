//
//  ProfileViewController.swift
//  SeSACRxThreads
//
//  Created by andev on 8/27/25.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class ProfileViewController: UIViewController {
    
    let disposeBag = DisposeBag()
    let viewModel = ProfileViewModel()
    
    let passwordTextField = SignTextField(placeholderText: "")
    let nextButton = PointButton(title: "")

    override func viewDidLoad() {
        super.viewDidLoad()
        configureLayout()
        bind()
        
    }
    
    func bind() {
        let input = ProfileViewModel.Input(buttonTap: nextButton.rx.tap.asObservable())
        let output = viewModel.transform(input: input)
        
        output.placeholder
            .bind(to: passwordTextField.rx.placeholder)
            .disposed(by: disposeBag)
        
        output.buttonTitle
            .bind(to: nextButton.rx.title())
            .disposed(by: disposeBag)
        
        output.detail
            .drive(with: self) { owner, value in
                print(">>>>", value, Thread.isMainThread)
                let viewModel = ProfileDetailViewModel(text: value)
                let vc = ProfileDetailViewController(viewModel: viewModel)
                owner.navigationController?.pushViewController(vc, animated: true)
            }
            .disposed(by: disposeBag)
    }


}

extension ProfileViewController {
    
    func configureLayout() {
        view.backgroundColor = .white
        view.addSubview(passwordTextField)
        view.addSubview(nextButton)
         
        passwordTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(200)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        nextButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(passwordTextField.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }
}
