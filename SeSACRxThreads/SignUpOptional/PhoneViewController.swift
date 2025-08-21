//
//  PhoneViewController.swift
//  SeSACRxThreads
//
//  Created by jack on 2023/10/30.
//
 
import UIKit
import SnapKit
import RxSwift
import RxCocoa

class PhoneViewController: UIViewController {
    
    private let disposeBag = DisposeBag()
    
    let limitNumber = 8
    
    let phoneTextField = SignTextField(placeholderText: "연락처를 입력해주세요")
    let nextButton = PointButton(title: "다음")
    let resultLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Color.white
        
        configureLayout()
        bind()
        
    }
    
    func bind() {
        //버튼 클릭 -> 레이블 내용
        nextButton.rx.tap
            .withLatestFrom(phoneTextField.rx.text.orEmpty)
            .map { text in
                text.count >= 8 ? "통과" : "8자 이상 입력해주세요"
            }
            .bind(to: resultLabel.rx.text)
            .disposed(by: disposeBag)

        //텍스트필드가 달라질 때마다 레이블에 내용 출력
//        phoneTextField.rx.text.orEmpty //String
//            .withUnretained(self) //self, value
//            .debug("orEmpty")
//            .map { owner, text in
//                text.count >= owner.limitNumber
//            }
//            .debug("map")
//            .bind(with: self) { owner, value in
//                owner.resultLabel.text = value ? "통과" : "8자 이상을 입력해주세요"
//            }
//            .disposed(by: disposeBag)
    }
    
    func configureLayout() {
        view.addSubview(phoneTextField)
        view.addSubview(nextButton)
        view.addSubview(resultLabel)
         
        phoneTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(200)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        nextButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(phoneTextField.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        resultLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.top.equalTo(nextButton.snp.bottom).offset(20)
        }
        
        resultLabel.text = "test"
    }

}
