//
//  ThirdViewController.swift
//  SeSACRxThreads
//
//  Created by andev on 8/28/25.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class ThirdViewController: UIViewController {
    
    let button = PointButton(title: "다음")
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        view.addSubview(button)
        button.snp.makeConstraints { make in
            make.size.equalTo(100)
            make.center.equalTo(view)
        }
        changeRootVC()
        button.rx.tap
            .bind(with: self) { owner, _ in
//                let vc = SettingViewController()
//                vc.modalPresentationStyle = .fullScreen
//                owner.present(vc, animated: true)
                owner.changeRootVC()
            }
            .disposed(by: disposeBag)

    }
    
    private func changeRootVC() {
        guard let windowScence = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let sceneDelegate = windowScence.delegate as? SceneDelegate else {
            return
        }
        sceneDelegate.window?.rootViewController = SettingViewController()
        
        UIView.transition(with: sceneDelegate.window!, duration: 0.5, options: .curveEaseIn) {
            
        }
    }
    
    deinit {
        print("Third Deinit")
    }
}
