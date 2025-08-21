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
    
    var data = ["김새싹", "고래", "고래밥", "새싹", "김김김", "AAA" ,"ABB", "BBB"]
    lazy var items = BehaviorSubject(value: data)
   
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
        
        //서치바에 입력 후 엔터치면 배열에 데이터 추가
//        searchBar.rx.searchButtonClicked
//            .withLatestFrom(searchBar.rx.text.orEmpty)
//            .bind(with: self) { owner, value in
//                print(value)
//                owner.data.insert(value, at: 0)
//                owner.items.onNext(owner.data)
//                
//            }
//            .disposed(by: disposeBag)
        
        //실시간 검색
        searchBar.rx.text.orEmpty
            .debounce(.seconds(1), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .bind(with: self) { owner, value in
                print(value)
                
                let filter = value.isEmpty ? owner.data : owner.data.filter { $0.contains(value) }
                owner.items.onNext(filter)
            }
            .disposed(by: disposeBag)
        
        items //observable
        .bind(to: tableView.rx.items) { (tableView, row, element) in
            let cell = tableView.dequeueReusableCell(withIdentifier: SearchTableViewCell.identifier) as! SearchTableViewCell
            cell.appNameLabel.text = "\(element) @ row \(row)"
            
            cell.downloadButton.rx.tap
                .bind(with: self) { owner, _ in
                    print("클릭되었습니다")
                    let vc = DetailViewController()
                    owner.navigationController?.pushViewController(vc, animated: true)
                }
                .disposed(by: cell.disposeBag)
            return cell
        }
        .disposed(by: disposeBag)
        
        
        Observable.zip(
            tableView.rx.modelSelected(String.self),
            tableView.rx.itemSelected
        )
        .bind(with: self) { owner, value in
            print(value)
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
