//
//  PasswordViewController.swift
//  SeSACRxThreads
//
//  Created by jack on 2023/10/30.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class PasswordViewController: UIViewController {
   
    let passwordTextField = SignTextField(placeholderText: "비밀번호를 입력해주세요")
    let nextButton = PointButton(title: "다음")
    
    private let disposeBag = DisposeBag()
    
    private let passwordPlaceholder = Observable.just("비밀번호를 입력해주세요")
    private let nextButtonTitle = Observable.just("다음")
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Color.white
        
        configureLayout()
        bind()
        aboutDispose()
         
//        nextButton.addTarget(self, action: #selector(nextButtonClicked), for: .touchUpInside)
    }
    
    func bind() {
//        passwordPlaceholder
//            .bind(with: self) { owner, value in
//                owner.passwordTextField.placeholder = value
//            }
//            .disposed(by: disposeBag)
        
        passwordPlaceholder
            .bind(to: passwordTextField.rx.placeholder)
            .disposed(by: disposeBag)
        
        nextButtonTitle
            .bind(to: nextButton.rx.title())
            .disposed(by: disposeBag)
        
        nextButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.navigationController?.pushViewController(PhoneViewController(), animated: true)
            }
            .disposed(by: disposeBag)


    }
    
    func aboutDispose() { // 리소스 정리
        
        //finite
        //Observable Lifecycle: next 이벤트 방출이 끝나면, complete 이벤트 실행 -> dispose를 통해서 Sequence를 종료시킴.
        let array = Observable.from([1, 2, 3, 4, 5])
        array
            .subscribe(with: self) { owner, value in
                print("array: onNext", value)
            } onError: { owner, error in
                print("array: onError", error)
            } onCompleted: { owner in
                print("array: onCompleted")
            } onDisposed: { owner in
                print("array: onDisposed")
            }
            .disposed(by: disposeBag)
        
        //infinite
        //next 이벤트가 무한해서 dispose 되지 않음.
        //화면전환이 되더라도 리소스 정리가 안되면 무한대로 실행
        let test = Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance)
        let result = test
            .subscribe(with: self) { owner, value in
                print("onNext", value)
            } onError: { owner, error in
                print("onError", error)
            } onCompleted: { owner in
                print("onCompleted")
            } onDisposed: { owner in
                print("onDisposed")
            }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            result.dispose() //리소스 정리
        }
        
        let test2 = Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance)
        let result2 = test2
            .subscribe(with: self) { owner, value in
                print("result2: onNext", value)
            } onError: { owner, error in
                print("result2: onError", error)
            } onCompleted: { owner in
                print("result2: onCompleted")
            } onDisposed: { owner in
                print("result2: onDisposed")
            }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
            result.dispose()
        }

    }
    
//    @objc func nextButtonClicked() {
//        navigationController?.pushViewController(PhoneViewController(), animated: true)
//    }
    
    func configureLayout() {
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
