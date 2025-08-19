//
//  SignInViewController.swift
//  SeSACRxThreads
//
//  Created by jack on 2023/10/30.
//

import UIKit
import SnapKit
import Kingfisher
import RxSwift
import RxCocoa

class SignInViewController: UIViewController {

    let emailTextField = SignTextField(placeholderText: "이메일을 입력해주세요")
    let passwordTextField = SignTextField(placeholderText: "비밀번호를 입력해주세요")
    let signInButton = PointButton(title: "로그인")
    let signUpButton = UIButton()
    let photoImageView = UIImageView()
    
    let disposBag = DisposeBag()
    
    let color = Observable.just(UIColor.yellow)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //4자리 이상 이메일 작성 시, 로그인 버튼 회색 -> 검정색
        
//        emailTextField.rx.text
//            .bind(with: self) { owner, value in
//                print("bind: \(value)")
//                guard let value = value else { return }
//                
//                if value.count >= 4 {
//                    owner.signInButton.backgroundColor = .black
//                } else {
//                    owner.signInButton.backgroundColor = .lightGray
//                }
//            }
//            .disposed(by: disposBag)
        
//        emailTextField.rx.text.orEmpty //옵셔널 해제
//            .bind(with: self) { owner, value in
//                if value.count >= 4 {
//                    owner.signInButton.backgroundColor = .black
//                } else {
//                    owner.signInButton.backgroundColor = .lightGray
//                }
//            }
//            .disposed(by: disposBag)
        
//        emailTextField.rx.text.orEmpty
//            .map{ $0.count >= 4 }
//            .bind(with: self) { owner, value in
//                owner.signInButton.backgroundColor = value ? .black : .lightGray
//            }
//            .disposed(by: disposBag)
        
        emailTextField.rx.text.orEmpty
            .map { $0.count >= 4 }
            .bind(to: signInButton.rx.isHidden)
            .disposed(by: disposBag)
        
        color.bind(to: view.rx.backgroundColor, emailTextField.rx.textColor)
            .disposed(by: disposBag)

//        color.bind(with: self) { owner, color in
//            // rx적인 코드는 아님
//            owner.view.backgroundColor = color
//            owner.emailTextField.textColor = color
//        }
//        .disposed(by: disposBag)
        
        configureLayout()
        configure()
        
        signUpButton.addTarget(self, action: #selector(signUpButtonClicked), for: .touchUpInside)
        signInButton.addTarget(self, action: #selector(signInButtonClicked), for: .touchUpInside)
    }
    
    @objc func signInButtonClicked() {
        PhotoManager.shared.getRandomPhoto(api: .random) { photo in
//            print("random", photo)
//            self.photoImageView.kf.setImage(with: URL(string: photo.urls.regular))
        }
    }
    
    @objc func signUpButtonClicked() {
        navigationController?.pushViewController(SignUpViewController(), animated: true)
    }
    
    
    func configure() {
        signUpButton.setTitle("회원이 아니십니까?", for: .normal)
        signUpButton.setTitleColor(Color.black, for: .normal)
        photoImageView.backgroundColor = .blue
    }
    
    func configureLayout() {
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(signInButton)
        view.addSubview(signUpButton)
        view.addSubview(photoImageView)
        
        emailTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(200)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        passwordTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(emailTextField.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        signInButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(passwordTextField.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        signUpButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(signInButton.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        photoImageView.snp.makeConstraints { make in
            make.size.equalTo(100)
            make.centerX.equalTo(view.safeAreaLayoutGuide)
            make.top.equalTo(signUpButton.snp.bottom).offset(10)
        }
    }
    

}
