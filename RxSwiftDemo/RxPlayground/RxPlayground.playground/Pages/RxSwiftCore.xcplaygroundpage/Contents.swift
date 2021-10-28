//: [Previous](@previous) Reactive
/*:
 
 # RxSwift 核心

 這一章主要介紹 **RxSwift** 的核心內容：

 ![](RxSwiftCore.png)

 * Observable - 產生事件
 * Observer - 響應事件
 * Operator - 創建變化組合事件
 * Disposable - 管理綁定（訂閱）的生命週期
 * Schedulers - 線程隊列調配

 ```swift
 // Observable<String>
 let text = usernameOutlet.rx.text.orEmpty.asObservable()

 // Observable<Bool>
 let passwordValid = text
     // Operator
     .map { $0.characters.count >= minimalUsernameLength }

 // Observer<Bool>
 let observer = passwordValidOutlet.rx.isHidden

 // Disposable
 let disposable = passwordValid
     // Scheduler 用於控制任務在那個線程隊列運行
     .subscribeOn(MainScheduler.instance)
     .observeOn(MainScheduler.instance)
     .bind(to: observer)


 ...

 // 取消綁定，你可以在退出頁面時取消綁定
 disposable.dispose()
 ```
 
 */

import UIKit
import PlaygroundSupport
import RxSwift
import RxCocoa


class MyViewController : UIViewController {
    
    let disposeBag = DisposeBag()
    
    override func loadView() {
        
        let view = UIView()
        view.backgroundColor = .white
        let usernameOutlet = UITextField(frame: CGRect(x: 20, y: 20, width: 100, height: 40))
        usernameOutlet.layer.borderWidth = 1.0
        usernameOutlet.layer.borderColor = UIColor.darkGray.cgColor
        view.addSubview(usernameOutlet)
        
        let minimalUsernameLength = 7
        let usernameValidOutlet = UILabel(frame: CGRect(x: 20, y: 80, width: 300, height: 30))
        usernameValidOutlet.text = "Username has to be at least \(minimalUsernameLength) characters"
        view.addSubview(usernameValidOutlet)
        
        
        
        
        
        let text = usernameOutlet.rx.text.orEmpty.asObservable()

        // Observable<Bool>
        let usernameValid = text
            // Operator
            .map { $0.count >= minimalUsernameLength }

        // Disposable
        usernameValid
            // Scheduler 用於控制任務在那個線程隊列運行
            .subscribe(on: MainScheduler.instance)
            .observe(on: MainScheduler.instance)
            .bind(to: usernameValidOutlet.rx.isHidden)
            .disposed(by: disposeBag)
//        disposable.dispose()
        self.view = view
    }
}

// Present the view controller in the Live View window
PlaygroundPage.current.liveView = MyViewController()

 
