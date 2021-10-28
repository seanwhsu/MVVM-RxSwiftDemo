//: [Previous](@previous) Installation
/*:
 RxSwift 能夠幫助我們做些什麼：
 * Target Action - 不需要使用 Target Action，這樣使得代碼邏輯清晰可見。
 * 代理 - 不需要書寫代理的配置代碼，就能獲得想要的結果。
 * 閉包回調
 * 通知 - 不需要去管理觀察者的生命週期，這樣你就有更多精力去關注業務邏輯。
 * 多個任務之間有依賴關係 - 可以避免回調地獄，從而使得代碼易讀，易維護。
 * 等待多個並發任務完成後處理結果
 
 - important:閱讀下面程式碼，搭配註解使用。
 
 那麼為什麼要使用 RxSwift ？

 * 複合 - Rx 就是複合的代名詞
 * 復用 - 因為它易複合
 * 清晰 - 因為聲明都是不可變更的
 * 易用 - 因為它抽象的了異步編程，使我們統一了代碼風格
 * 穩定 - 因為 Rx 是完全通過單元測試的
 
 */

import UIKit
import PlaygroundSupport
import RxSwift
import RxCocoa

/// 多個任務之間有依賴關係
enum MyError: Error {
    case PasswordError
    case TokenError
}

struct UserInfo {}

enum API {
    /// 傳統方式:
//    static func token(username: String, password: String,
//        success: (String) -> Void,
//        failure: (Error) -> Void) {
//        if password == "987654321" {
//            success("123")
//        } else {
//            failure(MyError.PasswordError)
//        }
//    }
//    static func userInfo(token: String,
//        success: (UserInfo) -> Void,
//        failure: (Error) -> Void) {
//        if token == "1234" {
//            success(UserInfo())
//        } else {
//            failure(MyError.TokenError)
//        }
//    }
    /// RxSwift:
    static func token(username: String, password: String) -> Observable<String> {
        return Observable.create { observer in
            if password == "987654321" {
                observer.onNext("123")
                observer.onCompleted()
            } else {
                observer.onError(MyError.PasswordError)
            }
            return Disposables.create()
        }
    }

    static func userInfo(token: String) -> Observable<UserInfo> {
        return Observable.create { observer in
            if token == "1234" {
                observer.onNext(UserInfo())
                observer.onCompleted()
            } else {
                observer.onError(MyError.TokenError)
            }
            return Disposables.create()
        }
    }
}
///
/// 等待多個並發任務完成後處理結果

enum MyError2: Error {
    case TeacherError
    case CommentError
}
struct Teacher {}
struct Comment {}

enum API2 {

    static func teacher(teacherId: Int) -> Observable<Teacher> {
        return Observable.create { observer in
            if teacherId == 1 {
                observer.onNext(Teacher())
                observer.onCompleted()
            } else {
                observer.onError(MyError2.TeacherError)
            }
            return Disposables.create()
        }.delay(.seconds(5), scheduler: MainScheduler.instance)
        .debug("teacher")
    }

    static func teacherComments(teacherId: Int) -> Observable<[Comment]> {
        return Observable.create { observer in
            if teacherId == 1 {
                observer.onNext([Comment()])
                observer.onCompleted()
            } else {
                observer.onError(MyError2.CommentError)
            }
            return Disposables.create()
        }.delay(.seconds(1), scheduler: MainScheduler.instance)
        .debug("teacherComments")
    }
}
///

class MyViewController : UIViewController {
    
    let disposeBag = DisposeBag()
    
    override func loadView() {
        
        let view = UIView()
        view.backgroundColor = .white
        
        /// Target Action
        let button = UIButton(type: .system)
        button.isEnabled = true
        button.frame = CGRect(x: 75, y: 200, width: 100, height: 40)
        button.backgroundColor = .blue
        view.addSubview(button)
//        /// 傳統方式:
////        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
//        /// RxSwift:
        button.rx.tap
            .subscribe(onNext: {
                print("button Tapped")
            })
            .disposed(by: disposeBag)
        ///
        
        /// 代理
//        let scrollView = UIScrollView()
//        scrollView.frame = CGRect(x: 75, y: 200, width: 200, height: 300)
//        scrollView.contentSize = CGSize(width: 300, height: 500)
//        scrollView.backgroundColor = .blue
//        view.addSubview(scrollView)
//        /// 傳統方式:
////        scrollView.delegate = self
//        /// RxSwift:
//        scrollView.rx.contentOffset
//                    .subscribe(onNext: { contentOffset in
//                        print("contentOffset: \(contentOffset)")
//                    })
//                    .disposed(by: disposeBag)
        ///
        
        /// 閉包回調
        /// 傳統方式:
//        URLSession.shared.dataTask(with: URLRequest(url: URL(string: "https://api.github.com/users")!)) {
//            (data, response, error) in
//            guard error == nil else {
//                print("Data Task Error: \(error!)")
//                return
//            }
//
//            guard let data = data else {
//                print("Data Task Error: unknown")
//                return
//            }
//
//            print("Data Task Success with count: \(data.count)")
//        }.resume()
        
        /// RxSwift:
//        URLSession.shared.rx.data(request: URLRequest(url: URL(string: "https://api.github.com/users")!))
//            .subscribe(onNext: { data in
//                print("Data Task Success with count: \(data.count)")
//            }, onError: { error in
//                print("Data Task Error: \(error)")
//            })
//            .disposed(by: disposeBag)
        ///
        /// 通知
        let textFeild = UITextField()
        textFeild.frame = CGRect(x: 75, y: 200, width: 200, height: 40)
        textFeild.layer.borderColor = UIColor.blue.cgColor
        textFeild.layer.borderWidth = 1.0
        view.addSubview(textFeild)
        /// 傳統方式:
//        NotificationCenter.default.addObserver(
//            forName: UIApplication.keyboardDidShowNotification,
//                  object: nil, queue: nil) { (notification) in
//                print("Keyboard Did Show Notification")
//            }
        /// RxSwift:
//        NotificationCenter.default.rx
//                .notification(UIApplication.keyboardDidShowNotification)
//                .subscribe(onNext: { (notification) in
//                    print("Keyboard Did Show Notification")
//                })
//                .disposed(by: disposeBag)
        ///
        
        /// 多個任務之間有依賴關係
        /// 傳統方式:
//        API.token(username: "beeth0ven", password: "987654321",
//            success: { token in
//                API.userInfo(token: token,
//                    success: { userInfo in
//                        print("獲取用戶信息成功: \(userInfo)")
//                    },
//                    failure: { error in
//                        print("獲取用户信息失敗: \(error)")
//                })
//            },
//            failure: { error in
//                print("獲取用户信息失敗: \(error)")
//        })
        // RxSwift:
//        API.token(username: "beeth0ven", password: "987654321")
//            .flatMapLatest(API.userInfo)
//            .subscribe(onNext: { userInfo in
//                print("獲取用戶信息成功: \(userInfo)")
//            }, onError: { error in
//                print("獲取用户信息失敗: \(error)")
//            })
//            .disposed(by: disposeBag)
        ///
        /// 等待多個並發任務完成後處理結果
        /// RxSwift:

//        Observable.zip(
//              API2.teacher(teacherId: 1),
//              API2.teacherComments(teacherId: 1)
//            )
//            .subscribe(onNext: { (teacher, comments) in
//                print("獲取老師信息成功: \(teacher)")
//                print("獲取老師評論成功: \(comments.count) 條")
//            }, onError: { error in
//                print("獲取老師信息或評論失敗: \(error)")
//            })
//            .disposed(by: disposeBag)
        ///
        
        self.view = view
    }
    /// Target Action
    @objc func buttonTapped() {
        print("button Tapped")
    }
    ///
}

/// 代理
extension MyViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print("contentOffset: \(scrollView.contentOffset)")
    }
}
///

// Present the view controller in the Live View window
PlaygroundPage.current.liveView = MyViewController()

//: [Next](@next) Reactive
