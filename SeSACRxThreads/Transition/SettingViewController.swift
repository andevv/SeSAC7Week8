//
//  SettingViewController.swift
//  SeSACRxThreads
//
//  Created by andev on 8/28/25.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import RxDataSources

struct JackSection {
    let header: String
    var items: [String]
}

extension JackSection: SectionModelType {
    init(original: JackSection, items: [String]) {
        self = original
        self.items = items
    }
}

class SettingViewController: UIViewController {
    
    let disposeBag = DisposeBag()
    
    private let tableView: UITableView = {
        let view = UITableView()
        view.register(SearchTableViewCell.self, forCellReuseIdentifier: SearchTableViewCell.identifier)
        view.backgroundColor = .lightGray
        view.rowHeight = 180
        view.separatorStyle = .none
        return view
    }()
    
    let items = Observable.just(["a", "b", "c"])
    
    let list = Observable.just([
        JackSection(header: "전체 설정", items: ["공지사항", "실험실"]),
        JackSection(header: "개인 설정", items: ["알림", "채팅", "프로필"]),
        JackSection(header: "기타", items: ["고객센터", "도움말"])
    ])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureLayout()
        bind()
    }
    
    private func configureLayout() {
        view.backgroundColor = .white
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func bind() {
        
        let dataSource = RxTableViewSectionedReloadDataSource<JackSection>(configureCell: { (dataSource, tableView, indexPath, item) in
            let cell = tableView.dequeueReusableCell(withIdentifier: SearchTableViewCell.identifier) as! SearchTableViewCell
            cell.appNameLabel.text = item
            return cell
        })
        
        dataSource.titleForHeaderInSection = { dataSource, index in
            return dataSource.sectionModels[index].header
        }
        
        list
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
    
}
