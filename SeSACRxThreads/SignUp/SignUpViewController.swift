//
//  SignUpViewController.swift
//  SeSACRxThreads
//
//  Created by jack on 2023/10/30.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class SignUpViewController: UIViewController {
    
    let emailTextField = SignTextField(placeholderText: "이메일을 입력해주세요")
    let validationButton = UIButton()
    let nextButton = PointButton(title: "다음")
    
    // 중복확인 글자만 전달 -> 유한한 이벤트
    let buttonTitle = Observable.just("중복확인")
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Color.white
        
        configureLayout()
        configure()
        
        basicObservableTest()
        
        buttonTitle
            .subscribe(with: self) { owner, value in
                print("buttonTitle: onNext - \(value)")
                owner.validationButton.setTitle(value, for: .normal)
            }
            .disposed(by: disposeBag)
        
        
        //        buttonTitle.subscribe { value in //next
        //            print("buttonTitle: onNext - \(value)")
        //            self.validationButton.setTitle(value, for: .normal)
        //        } onError: { error in
        //            print("buttonTitle: onError")
        //        } onCompleted: {
        //            print("buttonTitle: onCompleted")
        //        } onDisposed: {
        //            print("buttonTitle: onDisposed")
        //        }
        //        .disposed(by: disposeBag) // 리소스 정리
        
        // 무한한 이벤트, UI라서 에러는 X, complete도 발생 X
        //        nextButton.rx.tap
        //            .subscribe { _ in // next, error, complete 이벤트 다 처리할 수 있지만, 발생하지 않으니까 생략을 한 구조
        //                print("nextButton: onNext")
        //            } onError: { error in
        //                print("nextButton: onError")
        //            } onCompleted: {
        //                print("nextButton: onCompleted")
        //            } onDisposed: {
        //                print("nextButton: onDisposed")
        //            }
        //            .disposed(by: disposeBag)
        
        //MARK: - 메모리 누수 해결
        //        nextButton.rx.tap
        //            .bind { [weak self] _ in
        //                guard let self = self else { return }
        //                print("nextButton: .bind - onNext")
        //                let vc = PasswordViewController()
        //                self.navigationController?.pushViewController(vc, animated: true)
        //            }
        //            .disposed(by: disposeBag)
        
        //        nextButton.rx.tap
        //            .withUnretained(self)
        //            .bind { _ in // 애초에 next 이벤트밖에 처리를 못하는 구조
        //                print("nextButton: .bind - onNext")
        //                let vc = PasswordViewController()
        //                self.navigationController?.pushViewController(vc, animated: true)
        //            }
        //            .disposed(by: disposeBag)
        
        nextButton.rx.tap
            .bind(with: self, onNext: { owner, _ in
                print("nextButton: .bind - onNext")
                let vc = PasswordViewController()
                owner.navigationController?.pushViewController(vc, animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    func basicObservableTest() {
        
        let list = ["고래밥", "칙촉", "카스타드", "갈배"]
        Observable.just(list)
            .subscribe { value in
                print("just \(value)")
            } onError: { error in
                print("just: \(error)")
            } onCompleted: {
                print("just: onComplete")
            } onDisposed: {
                print("just: onDisposed")
            }
            .disposed(by: disposeBag)
        
        Observable.from(list)
            .subscribe { value in
                print("from \(value)")
            } onError: { error in
                print("from: \(error)")
            } onCompleted: {
                print("from: onComplete")
            } onDisposed: {
                print("from: onDisposed")
            }
            .disposed(by: disposeBag)
        
        Observable.repeatElement(list) //무한 방출
            .take(10) //개수 제한
            .subscribe { value in
                print("repeatElement \(value)")
            } onError: { error in
                print("repeatElement: \(error)")
            } onCompleted: {
                print("repeatElement: onComplete")
            } onDisposed: {
                print("repeatElement: onDisposed")
            }
            .disposed(by: disposeBag)
        
    }
    
    func configure() {
        validationButton.setTitle("중복확인", for: .normal)
        validationButton.setTitleColor(Color.black, for: .normal)
        validationButton.layer.borderWidth = 1
        validationButton.layer.borderColor = Color.black.cgColor
        validationButton.layer.cornerRadius = 10
    }
    
    func configureLayout() {
        view.addSubview(emailTextField)
        view.addSubview(validationButton)
        view.addSubview(nextButton)
        
        validationButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(200)
            make.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.width.equalTo(100)
        }
        
        emailTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(200)
            make.leading.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.trailing.equalTo(validationButton.snp.leading).offset(-8)
        }
        
        nextButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(emailTextField.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }
    
    
}
