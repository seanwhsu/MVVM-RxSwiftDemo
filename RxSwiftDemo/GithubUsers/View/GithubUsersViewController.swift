//
//  GithubUsersViewController.swift
//  RxSwiftDemo
//
//  Created by Sean on 2021/7/6.
//

import UIKit
import RxSwift
import RxCocoa
//import RxDataSources

class GithubUsersViewController: UIViewController {
    
    let disposeBag = DisposeBag()
    let viewModel = UsersViewModel()
    
    
    @IBOutlet weak var tableview: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.loadUsers()
        
    
        viewModel.userCellViewModels.bind(to: tableview.rx.items) { [weak self] (tableView, row, element) in
            let cell = self?.tableview.dequeueReusableCell(withIdentifier: String(describing: UserTableViewCell.self))!
            if let cell = cell as? UserTableViewCell {
                cell.viewModel = element
            }
            return cell ?? UITableViewCell()
        }
        .disposed(by: disposeBag)
        
//        let items = Observable.just([
//                    SectionModel(model: "基本控件", items: [
//                        "UILable的用法",
//                        "UIText的用法",
//                        "UIButton的用法"
//                        ]),
//                    SectionModel(model: "高级控件", items: [
//                        "UITableView的用法",
//                        "UICollectionViews的用法"
//                        ])
//                    ])
//
//        let dataSource = RxTableViewSectionedReloadDataSource
//            <SectionModel<String, String>>(configureCell: {
//                (dataSource, tv, indexPath, element) in
//                let cell = tv.dequeueReusableCell(withIdentifier: "Cell")!
//                cell.textLabel?.text = "\(indexPath.row)：\(element)"
//                return cell
//            })
//
//        dataSource.titleForHeaderInSection = { ds, index in
//                    return ds.sectionModels[index].model
//                }
//
//        items
//            .bind(to: tableview.rx.items(dataSource: dataSource))
//            .disposed(by: disposeBag)
        
//        let items = Observable.just([
//                    "文本输入框的用法",
//                    "开关按钮的用法",
//                    "进度条的用法",
//                    "文本标签的用法",
//                    ])
//        items.bind(to: tableview.rx.items) { [weak self] (tableView, row, element) in
//            let cell = self?.tableview.dequeueReusableCell(withIdentifier: "Cell")!
//            cell?.textLabel?.text = "\(row)：\(element)"
//            return cell ?? UITableViewCell()
//        }
//        .disposed(by: disposeBag)
        
//        tableview.rx.itemSelected.subscribe(onNext: { indexPath in
//            print("选中项的indexPath为：\(indexPath)")
//        }).disposed(by: disposeBag)
//
//        tableview.rx.modelSelected(String.self).subscribe(onNext: { item in
//            print("选中项的标题为：\(item)")
//        }).disposed(by: disposeBag)
//        Observable.zip(tableview.rx.itemSelected, tableview.rx.modelSelected(String.self))
//            .bind { indexPath, item in
//                print("选中项的indexPath为：\(indexPath)")
//                print("选中项的标题为：\(item)")
//            }
//            .disposed(by: disposeBag)
//        tableview.rx.itemDeleted.subscribe(onNext: { indexPath in
//            print("删除项的indexPath为：\(indexPath)")
//        }).disposed(by: disposeBag)
//        tableview.rx.modelDeleted(String.self).subscribe(onNext: { item in
//            print("删除项的的标题为：\(item)")
//        }).disposed(by: disposeBag)
//
//        tableview.rx.itemMoved.subscribe(onNext: {
//            sourceIndexPath, destinationIndexPath in
//            print("移动项原来的indexPath为：\(sourceIndexPath)")
//            print("移动项现在的indexPath为：\(destinationIndexPath)")
//        }).disposed(by: disposeBag)
//
//        tableview.rx.itemInserted.subscribe(onNext: { indexPath in
//            print("插入项的indexPath为：\(indexPath)")
//        }).disposed(by: disposeBag)
//
//        tableview.rx.itemAccessoryButtonTapped.subscribe(onNext: { indexPath in
//            print("尾部项的indexPath为：\(indexPath)")
//        }).disposed(by: disposeBag)
    }

}
