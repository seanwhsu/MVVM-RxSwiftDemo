//: [Previous](@previous) Observable
/*:
 ## Observer - 觀察者

 ![](Observer.png)

 **觀察者** 是用來監聽事件，然後它需要這個事件做出響應。例如：**彈出提示框**就是**觀察者**，它對**點擊按鈕**這個事件做出響應。

 ### 響應事件的都是觀察者

 在 Observable 章節，我們舉了個幾個例子來介紹什麼是**可監聽序列**。那麼我們還是用這幾個例子來解釋一下什麼是**觀察者**：

 * **當室溫高於 33 度時，打開空調降溫**

   ![1](Temperature.png)

   打開空調降溫就是**觀察者** `Observer<Double>`。

 * **當《海賊王》更新一集時，我們就立即觀看這一集**

   ![1](OnePiece.png)

   觀看這一集就是**觀察者** `Observer<OnePieceEpisode>`。

 * **當取到 JSON 時，將它打印出來**

   ![1](JSON.png)

   將它打印出來就是**觀察者** `Observer<JSON>`

 * **當任務結束後，提示用戶任務已完成**

   ![1](Callback.png)

   提示用戶任務已完成就是**觀察者** `Observer<Void>`

 ### 如何創建觀察者

 現在我們已經知道**觀察者**主要是做什麼的了。那麼我們要怎麼創建它們呢？

 和 Observable 一樣，框架已經幫我們創建好了許多常用的**觀察者**。例如：`view` 是否隱藏，`button` 是否可點擊， `label` 的當前文本，`imageView` 的當前圖片等等。

 另外，有一些自定義的**觀察者**是需要我們自己創建的。這裡介紹一下創建觀察者最基本的方法，例如，我們創建一個彈出提示框的的**觀察者**：

 ![](Observer.png)

 ```swift
 tap.subscribe(onNext: { [weak self] in
     self?.showAlert()
 }, onError: { error in
     print("發生錯誤： \(error.localizedDescription)")
 }, onCompleted: {
     print("任務完成")
 })
 ```

 創建**觀察者**最直接的方法就是在 `Observable` 的 `subscribe` 方法後面描述，事件發生時，需要如何做出響應。而**觀察者**就是由後面的 `onNext`，`onError`，`onCompleted`的這些閉包構建出來的。

 以上是創建觀察者最常見的方法。當然你還可以通過其他的方式來創建**觀察者**，可以參考一下 AnyObserver 和 Binder。

 ### 特徵觀察者

 和 Observable 一樣，觀察者也存特徵**觀察者**，例如：

 * Binder
 */
//: [Next](@next) Disposable
