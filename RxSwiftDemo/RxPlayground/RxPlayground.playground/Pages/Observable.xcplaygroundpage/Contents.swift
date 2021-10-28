//: [Previous](@previous) RxSwift Core
/*:
 
 ## Observable - 可監聽序列

 ![1](Obervable.png)

 ### 所有的事物都是序列

 之前我們提到，`Observable` 可以用於描述元素異步產生的序列。這樣我們生活中許多事物都可以通過它來表示，例如：

 * **`Observable<Double>` 溫度**

   你可以將溫度看作是一個序列，然後監測這個溫度值，最後對這個值做出響應。例如：當室溫高於 33 度時，打開空調降溫。

   ![1](Temperature.png)

 * **`Observable<OnePieceEpisode>` 《海賊王》動漫**

   你也可以把《海賊王》的動漫看作是一個序列。然後當《海賊王》更新一集時，我們就立即觀看這一集。

   ![1](OnePiece.png)

 * **`Observable<JSON>` JSON**

   你可以把網絡請求的返回的 JSON 看作是一個序列。然後當取到 JSON 時，將它打印出來。

   ![1](JSON.png)

 * **`Observable<Void>` 任務回調**

   你可以把任務回調看作是一個序列。當任務結束後，提示用戶任務已完成。

   ![1](Callback.png)

 ### 如何創建序列

 現在我們已經可以把生活中的許多事物看作是一個序列了。那麼我們要怎麼創建這些序列呢？

 實際上，框架已經幫我們創建好了許多常用的序列。例如：`button`的點擊，`textField`的當前文本，`switch`的開關狀態，`slider`的當前數值等等。

 另外，有一些自定義的序列是需要我們自己創建的。這裡介紹一下創建序列最基本的方法，例如，我們創建一個 `[0, 1, ... 8, 9]` 的序列：

 ![1](Obervable.png)
*/
import RxSwift

let disposeBag = DisposeBag()


let numbers: Observable<Int> = Observable.create { observer -> Disposable in

 observer.onNext(0)
 observer.onNext(1)
 observer.onNext(2)
 observer.onNext(3)
 observer.onNext(4)
 observer.onNext(5)
 observer.onNext(6)
 observer.onNext(7)
 observer.onNext(8)
 observer.onNext(9)
 observer.onCompleted()
 return Disposables.create()
}

numbers.subscribe(onNext: { num in
    print(num)
}, onError: { error in
    print(error)
}, onCompleted: {
    print("onCompleted")
}, onDisposed: {
    print("onDisposed")
})
.disposed(by: disposeBag)
 
/*:
 創建序列最直接的方法就是調用 `Observable.create`，然後在構建函數里面描述元素的產生過程。
 `observer.onNext(0)` 就代表產生了一個元素，他的值是 `0`。後面又產生了 9 個元素分別是 `1, 2, ... 8, 9` 。最後，用 `observer.onCompleted()` 表示元素已經全部產生，沒有更多元素了。

 你可以用這種方式來封裝功能組件，例如，閉包回調：

 ![1](JSON.png)
*/
import Foundation

enum DataError: Error {
    case cantParseJSON
}

typealias JSON = Any

let json: Observable<JSON> = Observable.create { (observer) -> Disposable in

    let task = URLSession.shared.dataTask(with: URL(string: "https://api.github.com/users")!) { data, _, error in

     guard error == nil else {
         observer.onError(error!)
         return
     }

     guard let data = data,
         let jsonObject = try? JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
         else {
         observer.onError(DataError.cantParseJSON)
         return
     }

     observer.onNext(jsonObject)
     observer.onCompleted()
 }

 task.resume()

 return Disposables.create { task.cancel() }
}

/*:
 在閉包回調中，如果任務失敗，就調用 `observer.onError(error!)`。如果獲取到目標元素，就調用 `observer.onNext(jsonObject)`。由於我們的這個序列只有一個元素，所以在成功獲取到元素後，就直接調用 `observer.onCompleted()` 來表示任務結束。最後 `Disposables.create { task.cancel() }` 說明如果數據綁定被清除（訂閱被取消）的話，就取消網絡請求。

 這樣一來我們就將傳統的閉包回調轉換成序列了。然後可以用 `subscribe` 方法來響應這個請求的結果：
*/
json
 .subscribe(onNext: { json in
     print("取得 json 成功: \(json)")
 }, onError: { error in
     print("取得 json 失敗 Error: \(error.localizedDescription)")
 }, onCompleted: {
     print("取得 json 任務成功完成")
 })
 .disposed(by: disposeBag)

/*:
 這裡`subscribe`後面的`onNext`,`onError`, `onCompleted` 分別響應我們創建 json 時，構建函數里面的`onNext`,`onError`, `onCompleted` 事件。我們稱這些事件為 **Event**:

 ### Event - 事件

 ```swift
 public enum Event<Element> {
     case next(Element)
     case error(Swift.Error)
     case completed
 }
 ```

 * next - 序列產生了一個新的元素
 * error - 創建序列時產生了一個錯誤，導致序列終止
 * completed - 序列的所有元素都已經成功產生，整個序列已經完成

 你可以合理的利用這些 `Event` 來實現業務邏輯。

 ### 決策樹

 現在我們知道如何用最基本的方法創建序列。你還可參考 **決策樹** 來選擇其他的方式創建序列。

 ### 特徵序列

 我們都知道 **Swift** 是一個強類型語言，而強類型語言相對於弱類型語言的一個優點是更加嚴謹。我們可以通過類型來判斷出，實例有哪些特徵。同樣的在 **RxSwift** 裡面 `Observable` 也存在一些特徵序列，這些特徵序列可以幫助我們更準確的描述序列。並且它們還可以給我們提供語法糖，讓我們能夠用更加優雅的方式書寫代碼，他們分別是：

 * Single
 * Completable
 * Maybe
 * Driver
 * Signal
 * ControlEvent

 _ℹ️ 提示：由於**可被觀察的序列（Observable）**名字過長，很多時候會增加閱讀難度，所以筆者在必要時會將它簡寫為：**序列**。 _
 
 */
//: [Next](@next) Observer 
