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
    
    private let viewModel: HomeworkViewModel
    
    init(viewModel: HomeworkViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let tableView = UITableView()
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout())
    let searchBar = UISearchBar()
    
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        bind()
    }
     
    private func bind() {
        
        let input = HomeworkViewModel.Input(searchTap: searchBar.rx.searchButtonClicked, searchText: searchBar.rx.text.orEmpty, cellSelected: tableView.rx.modelSelected(Int.self))
        let output = viewModel.transform(input: input)
        
            output.list
            .bind(to: tableView.rx.items(cellIdentifier: PersonTableViewCell.identifier,
                                         cellType: PersonTableViewCell.self)) { (row, element, cell) in
                let text = "\(element.drwNoDate)일, \(element.firstAccumamnt.formatted())원"
                cell.usernameLabel.text = text
            }
             .disposed(by: disposeBag)
        
        output.items
            .bind(to: collectionView.rx.items(
                cellIdentifier: UserCollectionViewCell.identifier,
                cellType: UserCollectionViewCell.self)) { (row, element, cell) in
                    cell.label.text = element
                }
                .disposed(by: disposeBag)
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
 
