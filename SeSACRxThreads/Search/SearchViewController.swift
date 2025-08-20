//
//  SearchViewController.swift
//  SeSACRxThreads
//
//  Created by jack on 8/1/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class SearchViewController: UIViewController {
    
    let disposeBag = DisposeBag()
    
    var items = BehaviorSubject(value: ["First Item", "Second Item", "Third Item"])
   
    private let tableView: UITableView = {
       let view = UITableView()
        view.register(SearchTableViewCell.self, forCellReuseIdentifier: SearchTableViewCell.identifier)
        view.backgroundColor = .lightGray
        view.rowHeight = 180
        view.separatorStyle = .none
       return view
     }()
    
    let searchBar = UISearchBar()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        configure()
        setSearchController()
        bind()
        operatorTest()
    }
    
    func operatorTest() {
        
        let mentor = Observable.of("Hue", "Jack", "Finn")
        let age = Observable.of(10, 20, 30)
        /*
         zip: 두 옵저버블이 모두 변화할 때 이벤트가 방출됨
         combineLatest: 두 옵저버블 중 하나만 바뀌어도 이벤트가 방출됨
         */
        
        Observable.combineLatest(
            mentor,
            age
        )
        .bind(with: self) { owner, value in
            print(value)
        }
        .disposed(by: disposeBag)
    }
    
    func bind() {
        print(#function)
        
        searchBar.rx.text.orEmpty
            .debounce(.seconds(1), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .subscribe(with: self) { owner, value in
                print("searchBar text", value)
                
                let all = try! owner.items.value()
                let filter = all.filter { $0.contains(value) }
                print(filter)
            }
            .disposed(by: disposeBag)
        
//        searchBar.rx.searchButtonClicked
//            .subscribe(with: self) { owner, _ in
//                print("클릭")
//                guard let text = owner.searchBar.text else { return }
//                var result = try! owner.items.value() // 기존 데이터 조회
//                result.append(text)
//                owner.items.onNext(result)
//            }
//            .disposed(by: disposeBag)

        
        items //observable
        .bind(to: tableView.rx.items) { (tableView, row, element) in
            let cell = tableView.dequeueReusableCell(withIdentifier: SearchTableViewCell.identifier) as! SearchTableViewCell
            cell.appNameLabel.text = "\(element) @ row \(row)"
            return cell
        }
        .disposed(by: disposeBag)
        
//        tableView.rx.itemSelected
//            .bind(with: self) { owner, indexPath in
//                print(indexPath)
//                print(owner.data[indexPath.row])
//            }
//            .disposed(by: disposeBag)
//        
//        tableView.rx.modelSelected(String.self)
//            .bind(with: self) { owner, value in
//                print(value)
//            }
//            .disposed(by: disposeBag)
        
        Observable.combineLatest(
            tableView.rx.modelSelected(String.self),
            tableView.rx.itemSelected
        )
        .bind(with: self) { owner, value in
            print(value.0)
            print(value.1)
        }
        .disposed(by: disposeBag)
    }
     
    private func setSearchController() {
        view.addSubview(searchBar)
        navigationItem.titleView = searchBar
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "추가", style: .plain, target: self, action: #selector(plusButtonClicked))
    }
    
    @objc func plusButtonClicked() {
        print("추가 버튼 클릭")
    }

    
    private func configure() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }

    }
}
