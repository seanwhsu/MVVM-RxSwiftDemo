//: [Previous](@previous) Observer
/*:
 
 ## Disposable - 可被清除的資源

 ![](Disposable.png)

 通常來說，一個序列如果發出了 `error` 或者 `completed` 事件，那麼所有內部資源都會被釋放。如果你需要提前釋放這些資源或取消訂閱的話，那麼你可以對返回的 **可被清除的資源（Disposable）** 調用 `dispose` 方法：

 ```swift
 var disposable: Disposable?

 override func viewWillAppear(_ animated: Bool) {
     super.viewWillAppear(animated)

     self.disposable = textField.rx.text.orEmpty
         .subscribe(onNext: { text in print(text) })
 }

 override func viewWillDisappear(_ animated: Bool) {
     super.viewWillDisappear(animated)

     self.disposable?.dispose()
 }
 ```

 調用 `dispose` 方法後，訂閱將被取消，並且內部資源都會被釋放。通常情況下，你是不需要手動調用 `dispose` 方法的，這裡只是做個演示而已。我們推薦使用 **清除包（DisposeBag）** 或者 **takeUntil 操作符** 來管理訂閱的生命週期。

 ## DisposeBag - 清除包

 ![](DisposeBag.png)

 因為我們用的是**Swift** ，所以我們更習慣於使用[ARC](https://developer.apple.com/library/content/documentation/Swift/Conceptual/Swift_Programming_Language/AutomaticReferenceCounting.html#//apple_ref /doc/uid/TP40014097-CH20-ID48) 來管理內存。那麼我們能不能用 **ARC** 來管理訂閱的生命週期了。答案是肯定了，你可以用 **清除包（DisposeBag）** 來實現這種訂閱管理機制：

 ```swift
 var disposeBag = DisposeBag()

 override func viewWillAppear(_ animated: Bool) {
     super.viewWillAppear(animated)

     textField.rx.text.orEmpty
         .subscribe(onNext: { text in print(text) })
         .disposed(by: self.disposeBag)
 }

 override func viewWillDisappear(_ animated: Bool) {
     super.viewWillDisappear(animated)

     self.disposeBag = DisposeBag()
 }
 ```

 當 **清除包** 被釋放的時候，**清除包** 內部所有 **可被清除的資源（Disposable）** 都將被清除。在輸入驗證範例中我們也多次看到 **清除包** 的身影：

 ```swift
 var disposeBag = DisposeBag() // 來自父類 ViewController

 override func viewDidLoad() {
     super.viewDidLoad()

     ...

     usernameValid
         .bind(to: passwordOutlet.rx.isEnabled)
         .disposed(by: disposeBag)

     usernameValid
         .bind(to: usernameValidOutlet.rx.isHidden)
         .disposed(by: disposeBag)

     passwordValid
         .bind(to: passwordValidOutlet.rx.isHidden)
         .disposed(by: disposeBag)

     everythingValid
         .bind(to: doSomethingOutlet.rx.isEnabled)
         .disposed(by: disposeBag)

     doSomethingOutlet.rx.tap
         .subscribe(onNext: { [weak self] in self?.showAlert() })
         .disposed(by: disposeBag)
 }
 ```

 這個例子中 `disposeBag` 和 `ViewController` 具有相同的生命週期。當退出頁面時， `ViewController` 就被釋放，`disposeBag` 也跟著被釋放了，那麼這裡的 5 次綁定（訂閱）也就被取消了。這正是我們所需要的。

 ## [takeUntil]

 ![](TakeUntil.png)

 另外一種實現自動取消訂閱的方法就是使用 takeUntil 操作符，上面那個輸入驗證的演示代碼也可以通過使用 takeUntil 來實現：

 ```swift
 override func viewDidLoad() {
     super.viewDidLoad()

     ...

     _ = usernameValid
         .takeUntil(self.rx.deallocated)
         .bind(to: passwordOutlet.rx.isEnabled)

     _ = usernameValid
         .takeUntil(self.rx.deallocated)
         .bind(to: usernameValidOutlet.rx.isHidden)

     _ = passwordValid
         .takeUntil(self.rx.deallocated)
         .bind(to: passwordValidOutlet.rx.isHidden)

     _ = everythingValid
         .takeUntil(self.rx.deallocated)
         .bind(to: doSomethingOutlet.rx.isEnabled)

     _ = doSomethingOutlet.rx.tap
         .takeUntil(self.rx.deallocated)
         .subscribe(onNext: { [weak self] in self?.showAlert() })
 }

 ```

 這將使得訂閱一直持續到控制器的 **dealloc** 事件產生為止。

 _注意⚠️：這裡配圖中所使用的 `Observable` 都是**“熱”** `Observable`，它可以幫助我們理解訂閱的生命週期。如果你想要了解 **“冷熱”** `Observable` 之間的區別，可以參考官方文檔 [Hot and Cold Observables]。 _

 takeUntil
 [Hot and Cold Observables]:https://github.com/ReactiveX/RxSwift/blob/master/Documentation/HotAndColdObservables.md
 
 */
//: [Next](@next) TableViewSectionedViewController
