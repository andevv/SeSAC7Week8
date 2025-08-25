//
//  HomeworkViewController.swift
//  RxSwift
//
//  Created by Jack on 1/30/25.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import Alamofire

class HomeworkViewController: UIViewController {
    
    let tableView = UITableView()
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout())
    let searchBar = UISearchBar()
    
    let disposeBag = DisposeBag()
    
    let list: BehaviorRelay<[Lotto]> = BehaviorRelay(value: [])
    let items = BehaviorRelay(value: ["a", "b", "c"])
     
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        bind()
    }
     
    private func bind() {
        list
            .bind(to: tableView.rx.items(cellIdentifier: PersonTableViewCell.identifier,
                                         cellType: PersonTableViewCell.self)) { (row, element, cell) in
                let text = "\(element.drwNoDate)일, \(element.firstAccumamnt)원"
                cell.usernameLabel.text = text
            }
                                         .disposed(by: disposeBag)
        
        items
            .bind(to: collectionView.rx.items(
                cellIdentifier: UserCollectionViewCell.identifier,
                cellType: UserCollectionViewCell.self)) { (row, element, cell) in
                    cell.label.text = element
                }
                .disposed(by: disposeBag)
        
        tableView.rx.modelSelected(Int.self)
            .map { "셀 \($0)" }
            .bind(with: self) { owner, number in
                var original = owner.items.value
                original.insert(number, at: 0)
                
                owner.items.accept(original)
            }
            .disposed(by: disposeBag)
        
        searchBar.rx.searchButtonClicked
            .withLatestFrom(searchBar.rx.text.orEmpty)
            .distinctUntilChanged()
            .flatMap { text in
                CustomObservable.getLotto(query: text)
                    .debug("로또 옵저버블")
            }
            .debug("서치바 옵저버블")
            .subscribe(with: self) { owner, lotto in
                print("onNext", lotto)
                var data = owner.list.value
                data.insert(lotto, at: 0)
                owner.list.accept(data)
            } onError: { owner, error in
                print("onError", error)
            } onCompleted: { owner in
                print("onCompleted")
            } onDisposed: { owner in
                print("onDisposed")
            }
            .disposed(by: disposeBag)

        
//        //커스텀 옵저버블 활용, 서치 탭 시 랜덤으로 숫자를 추가
//        searchBar.rx.searchButtonClicked
//            .flatMap { CustomObservable.randomNumber()
//                    .debug("랜덤넘버 옵저버블")
//            }
//            .debug("서치바 옵저버블")
//            .bind(with: self) { owner, number in
//                var data = owner.list.value
//                data.insert(number, at: 0)
//                owner.list.accept(data)
//            }
//            .disposed(by: disposeBag)
        
//        searchBar.rx.searchButtonClicked
//            .map { return CustomObservable.randomNumber() }
//            .bind(with: self, onNext: { owner, value in
//                value
//                    .bind(with: self) { owner, number in
//                        var data = owner.list.value
//                        data.insert(number, at: 0)
//                        owner.list.accept(data)
//                    }
//                    .disposed(by: owner.disposeBag)
//            })
//            .disposed(by: disposeBag)
        
//        searchBar.rx.searchButtonClicked
//            .withLatestFrom(searchBar.rx.text.orEmpty)
//            .map { Int($0) ?? 0 }
//            .bind(with: self) { owner, text in
//                print(text)
//                var data = owner.list.value
//                data.insert(text, at: 0)
//                owner.list.accept(data)
//            }
//            .disposed(by: disposeBag)
        
//        CustomObservable.randomNumber()
//            .bind(with: self) { owner, number in
//                print("number", number)
//                owner.list.accept([number])
//            }
//            .disposed(by: disposeBag)
//        
//        CustomObservable.recommandNickname()
//            .subscribe(with: self) { owner, value in
//                owner.items.accept([value])
//            } onError: { owner, error in
//                print("onError", error)
//            } onCompleted: { owner in
//                print("onCompleted")
//            } onDisposed: { owner in
//                print("onDisposed")
//            }
//            .disposed(by: disposeBag)
    }
    
    private func configure() {
        view.backgroundColor = .white
        view.addSubview(tableView)
        view.addSubview(collectionView)
        view.addSubview(searchBar)
        
        navigationItem.titleView = searchBar
         
        collectionView.register(UserCollectionViewCell.self, forCellWithReuseIdentifier: UserCollectionViewCell.identifier)
        collectionView.backgroundColor = .lightGray
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(50)
        }
        
        tableView.register(PersonTableViewCell.self, forCellReuseIdentifier: PersonTableViewCell.identifier)
        tableView.backgroundColor = .systemGreen
        tableView.rowHeight = 100
        tableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(50)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    private func layout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 80, height: 40)
        layout.scrollDirection = .horizontal
        return layout
    }

}
 
