//
//  AnimationViewController.swift
//  SeSACRxThreads
//
//  Created by andev on 8/28/25.
//

import UIKit
import SnapKit

class AnimationViewController: UIViewController {
    
    private let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "star.circle.fill")
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .systemYellow
        return imageView
    }()
    
    private let emailTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "이메일"
        textField.keyboardType = .emailAddress
        textField.autocapitalizationType = .none
        return textField
    }()
    
    private let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "비밀번호"
        textField.isSecureTextEntry = true
        return textField
    }()
    
    private let loginButton: UIButton = {
        let button = UIButton()
        button.setTitle("로그인 버튼", for: .normal)
        button.backgroundColor = .green
        return button
    }()
    
    private let signUpLabel: UILabel = {
        let label = UILabel()
        label.text = "계정이 없으신가요? 회원가입"
        label.textColor = .systemBlue
        label.backgroundColor = .white
        label.textAlignment = .center
        label.font = UIFont(name: "S-CoreDream-9Black", size: 30)
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setAnimations()
        animationEmailTextField()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let vc = FirstViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func setAnimations() {
        logoImageView.alpha = 0
        logoImageView.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        
        emailTextField.alpha = 0
        passwordTextField.alpha = 0
        loginButton.alpha = 0
        signUpLabel.alpha = 0
        
        UIView.animate(withDuration: 5, delay: 0, options: [.repeat, .autoreverse]
                       //usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5
        ) {
            self.logoImageView.alpha = 1
            self.logoImageView.transform = CGAffineTransform(rotationAngle: 480)
        }
    }
    
    private func animationEmailTextField() {
        UIView.animate(withDuration: 1, delay: 0.5) {
            self.emailTextField.alpha = 1
        } completion: { _ in
            self.animationPasswordTextField()
        }

    }
    
    private func animationPasswordTextField() {
        UIView.animate(withDuration: 1) {
            self.passwordTextField.alpha = 1
        } completion: { _ in
            self.animationLoginButton()
        }
    }
    
    private func animationLoginButton() {
        UIView.animate(withDuration: 1) {
            self.loginButton.alpha = 1
        } completion: { _ in
            self.animationSignUpLabel()
        }

    }
    
    private func animationSignUpLabel() {
        UIView.animate(withDuration: 1) {
            self.signUpLabel.alpha = 1
        } completion: { _ in
            print("애니메이션 끝")
            self.emailTextField.becomeFirstResponder()
        }

    }
    
    private func setupViews() {
        view.backgroundColor = .white
        
        [logoImageView, emailTextField, passwordTextField, loginButton, signUpLabel]
            .forEach { view.addSubview($0) }
        
        logoImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(50)
            make.width.height.equalTo(100)
        }
        
        emailTextField.snp.makeConstraints { make in
            make.top.equalTo(logoImageView.snp.bottom).offset(50)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(44)
        }
        
        passwordTextField.snp.makeConstraints { make in
            make.top.equalTo(emailTextField.snp.bottom).offset(20)
            make.left.right.height.equalTo(emailTextField)
        }
        
        loginButton.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField.snp.bottom).offset(30)
            make.left.right.equalTo(emailTextField)
            make.height.equalTo(44)
        }
        
        signUpLabel.snp.makeConstraints { make in
            make.top.equalTo(loginButton.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        }
        
        //            view.addSubview(animationImageView)
        //
        //            animationImageView.snp.makeConstraints { make in
        //                make.size.equalTo(100)
        //                make.bottom.centerX.equalTo(view.safeAreaLayoutGuide)
        //            }
        //
        
    }
    
    
}
