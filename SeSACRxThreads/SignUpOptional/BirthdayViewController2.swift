//
//  BirthdayViewController.swift
//  SeSACRxThreads
//
//  Created by jack on 2023/10/30.
//
 
import UIKit
import SnapKit
import RxSwift
import RxCocoa

enum JackError: Error {
    case invalid
}

class BirthdayViewController2: UIViewController {
        
    let birthDayPicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.preferredDatePickerStyle = .wheels
        picker.locale = Locale(identifier: "ko-KR")
        picker.maximumDate = Date()
        return picker
    }()
    
    let infoLabel: UILabel = {
       let label = UILabel()
        label.textColor = Color.black
        label.text = "만 17세 이상만 가입 가능합니다."
        return label
    }()
    
    let containerStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .equalSpacing
        stack.spacing = 10
        return stack
    }()
    
    let yearLabel: UILabel = {
       let label = UILabel()
        label.text = "2023년"
        label.textColor = Color.black
        label.snp.makeConstraints {
            $0.width.equalTo(100)
        }
        return label
    }()
    
    let monthLabel: UILabel = {
       let label = UILabel()
        label.text = "33월"
        label.textColor = Color.black
        label.snp.makeConstraints {
            $0.width.equalTo(100)
        }
        return label
    }()
    
    let dayLabel: UILabel = {
       let label = UILabel()
        label.text = "99일"
        label.textColor = Color.black
        label.snp.makeConstraints {
            $0.width.equalTo(100)
        }
        return label
    }()
  
    let nextButton = PointButton(title: "가입하기")
    
    let disposeBag = DisposeBag()
    
    let text = PublishSubject<String>()
    //BehaviorSubject(value: "")
    //빌드하자마자 ""가 왜 레이블에 들어가는 걸까? -> PublishSubject 사용
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Color.white
        
        configureLayout()
        bind()
        //aboutPublishSubject()
        //aboutBehaviorSubject()
        
    }
    
    func bind() {
        
        //스트림이 공유되고 있지 않다.
        //버튼이 세번 클릭되는 현상
        //네트워크 콜을 3번 시도하는 상황이 될 수 있음
        //.share() 사용
        
        let tap = nextButton.rx.tap
            .map { "랜덤 \(Int.random(in: 1...100))" }
            .share()
        
        tap
            .bind(to: yearLabel.rx.text)
            .disposed(by: disposeBag)
        
        tap
            .bind(to: monthLabel.rx.text)
            .disposed(by: disposeBag)
        
        tap
            .bind(to: dayLabel.rx.text)
            .disposed(by: disposeBag)
        
//        text
//            .asDriver(onErrorJustReturn: "unknown")
//            .drive(yearLabel.rx.text)
//            .disposed(by: disposeBag)
//
//        nextButton.rx.tap
//            .asDriver()
//            .drive(with: self) { owner, _ in
//                owner.infoLabel.text = "입력했어요"
//                owner.text.onError(JackError.invalid)
//            }
//            .disposed(by: disposeBag)
    }
    
    func aboutPublishSubject() {
        let text = PublishSubject<String>()
        text.onNext("칙촉")
        text.onNext("칫솔")
        
        text
            .subscribe(with: self) { owner, value in
                print("PublishSubject next", value)
            } onError: { owner, error in
                print("PublishSubject error", error)
            } onCompleted: { owner in
                print("PublishSubject completed")
            } onDisposed: { owner in
                print("PublishSubject disposed")
            }
            .disposed(by: disposeBag)
        
        text.onNext("치약")
        text.onError(JackError.invalid)
        text.onNext("음료수")
    }
    
    func aboutBehaviorSubject() {
        let text = BehaviorSubject(value: "고래밥")
        text.onNext("칙촉")
        text.onNext("칫솔")
        
        text
            .subscribe(with: self) { owner, value in
                print("next", value)
            } onError: { owner, error in
                print("error", error)
            } onCompleted: { owner in
                print("completed")
            } onDisposed: { owner in
                print("disposed")
            }
            .disposed(by: disposeBag)
        
        text.onNext("치약")
        text.onNext("음료수")

    }
    
    func configureLayout() {
        view.addSubview(infoLabel)
        view.addSubview(containerStackView)
        view.addSubview(birthDayPicker)
        view.addSubview(nextButton)
 
        infoLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(150)
            $0.centerX.equalToSuperview()
        }
        
        containerStackView.snp.makeConstraints {
            $0.top.equalTo(infoLabel.snp.bottom).offset(30)
            $0.centerX.equalToSuperview()
        }
        
        [yearLabel, monthLabel, dayLabel].forEach {
            containerStackView.addArrangedSubview($0)
        }
        
        birthDayPicker.snp.makeConstraints {
            $0.top.equalTo(containerStackView.snp.bottom)
            $0.centerX.equalToSuperview()
        }
   
        nextButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(birthDayPicker.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }

}
