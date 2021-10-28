//: [Previous](@previous)
import UIKit
import PlaygroundSupport
import RxSwift
import RxCocoa
import RxDataSources

class SimpleTableViewExampleSectionedViewController
    : UIViewController
    , UITableViewDelegate {
    var tableView: UITableView!
    let disposeBag = DisposeBag()
    
    let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, Double>>(
        configureCell: { (_, tv, indexPath, element) in
            let cell = tv.dequeueReusableCell(withIdentifier: "Cell")!
            cell.textLabel?.text = "\(element) @ row \(indexPath.row)"
            return cell
        },
        titleForHeaderInSection: { dataSource, sectionIndex in
            return dataSource[sectionIndex].model
        }
    )

    override func viewDidLoad() {
        super.viewDidLoad()
        let view = UIView()
        view.backgroundColor = .white
        tableView = UITableView(frame: self.view.bounds, style: .plain)
        view.addSubview(tableView)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        self.view = view
        let dataSource = self.dataSource

        let items = Observable.just([
            SectionModel(model: "First section", items: [
                    1.0,
                    2.0,
                    3.0
                ]),
            SectionModel(model: "Second section", items: [
                    1.0,
                    2.0,
                    3.0
                ]),
            SectionModel(model: "Third section", items: [
                    1.0,
                    2.0,
                    3.0
                ])
            ])


        items
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)

        tableView.rx
            .itemSelected
            .map { indexPath in
                return (indexPath, dataSource[indexPath])
            }
            .subscribe(onNext: { [weak self] pair in
                let alert = UIAlertController(title: "", message: "Tapped `\(pair.1)` @ \(pair.0)", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                self?.present(alert, animated: true, completion: nil)
            })
            .disposed(by: disposeBag)

        tableView.rx
            .setDelegate(self)
            .disposed(by: disposeBag)
    }

    // to prevent swipe to delete behavior
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
}

// Present the view controller in the Live View window
PlaygroundPage.current.liveView = SimpleTableViewExampleSectionedViewController()

/*:
 # TableViewSectionedViewController - 多層級的列表頁

 ![](TableViewSectionedViewController/TableViewSectionedViewControllerFull.png)

 演示如何使用 [RxDataSources] 來佈局列表頁，你可以在這裡下載[這個例子]。

 ---

 ### 簡介

 這是一個多層級列表頁，它主要需要完成這些需求：

 * 每個 `Section` 顯示對應的標題
 * 每個 `Cell` 顯示對應的元素以及行號
 * 根據 `Cell` 的 `indexPath` 控制行高
 * 當 `Cell` 被選中時，顯示一個彈框

 ### 整體結構

 ![](TableViewSectionedViewController/All.png)

 以上這些需求，只需要一頁代碼就能完成：

 我們首先創建一個 `dataSource: RxTableViewSectionedReloadDataSource<SectionModel<String, Double>>`:

 ```swift
 let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, Double>>(
     configureCell: { (_, tv, indexPath, element) in
         let cell = tv.dequeueReusableCell(withIdentifier: "Cell")!
         cell.textLabel?.text = "\(element) @ row \(indexPath.row)"
         return cell
     },
     titleForHeaderInSection: { dataSource, sectionIndex in
         return dataSource[sectionIndex].model
     }
 )
 ```

 通過使用這個輔助類型，我們就不用執行數據源代理方法，而只需要提供必要的配置函數就可以佈局列表頁了。

 第一個函數 `configureCell` 是用來配置 `Cell` 的顯示，而這裡的參數 `element` 就是 `SectionModel<String, Double>` 中的 `Double`。

 第二個函數 `titleForHeaderInSection` 是用來配置 `Section` 的標題，而 `dataSource[sectionIndex].model` 就是 `SectionModel<String, Double>` 中的 `String`。

 然後為列表頁訂製一個多層級的數據源 `items: Observable<[SectionModel<String, Double>]>`，用這個數據源來綁定列表頁。

 ![](bindings.png)

 這裡 `SectionModel<String, Double>` 中的 `String` 是用來顯示 `Section` 的標題。而 `Double` 是用來綁定對應的 `Cell`。假如我們的列表頁是用來顯示通訊錄的，並且通訊錄通過首字母來分組。那麼應該把數據定義為 `SectionModel<String, Person>`，然後用首字母 `String` 來顯示 `Section` 標題，用聯繫人 `Person` 來顯示對應的 `Cell`。

 由於 `SectionModel<Section, ItemType>` 是一個範型，所以我們可以用它來定義任意類型的 `Section` 以及 `Item`。

 最後:

 ```swift
 override func viewDidLoad() {
     super.viewDidLoad()

     ...

     tableView.rx
         .setDelegate(self)
         .disposed(by: disposeBag)
 }

 ...

 func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
     return 40
 }
 ```

 這個是用來控制行高的，`tableView.rx.setDelegate(self)...` 將自己設置成 `tableView` 的代理，通過 `heightForHeaderInSection` 方法提供行高。

 ### 參考

 * [RxDataSources]
 * just
 * map


 [RxDataSources]:https://github.com/RxSwiftCommunity/RxDataSources
 [這個例子]:https://github.com/ReactiveX/RxSwift/tree/master/RxExample/RxExample/Examples/SimpleTableViewExampleSectioned
 */
//: [Next](@next)
