//: [Previous](@previous) Why RxSwift
/*:
 
 # 函數響應式編程

  ![](FunctionalReactiveProgramming.png)

  **函數響應式編程**是種編程範式。它是通過構建函數操作數據序列，然後對這些序列做出響應的編程方式。它結合了**函數式編程**以及**響應式編程**
 
 ## 函數式編程

 ![](FunctionalProgrammingBanner.png)

 **函數式編程**是種編程範式，它需要我們將函數作為參數傳遞，或者作為返回值返還。我們可以通過組合不同的函數來得到想要的結果。

 我們來看一下這幾個例子：

 ```swift
 // 全校學生
 let allStudents: [Student] = getSchoolStudents()

 // 三年二班的學生
 let gradeThreeClassTwoStudents: [Student] = allStudents
     .filter { student in student.grade == 3 && student.class == 2 }
 ```

 由於我們想要得到三年二班的學生，所以我們把三年二班的判定函數作為參數傳遞給 `filter` 方法，這樣就能從全校學生中過濾出三年二班的學生。

 ```swift
 // 三年二班的每一個男同學唱一首《一剪梅》
 gradeThreeClassTwoStudents
     .filter { student in student.sex == .male }
     .forEach { boy in boy.singASong(name: "一剪梅") }
 ```

 同樣的我們將性別的判斷函數傳遞給 `filter` 方法，這樣就能從三年二班的學生中過濾出男同學，然後將唱歌作為函數傳遞給 `forEach` 方法。於是每一個男同學都要唱《一剪梅》😄。

 ```swift
 // 三年二班學生成績高於90分的家長上台領獎
 gradeThreeClassTwoStudents
     .filter { student in student.score > 90 }
     .map { student in student.parent }
     .forEach { parent in parent.receiveAPrize() }
 ```

 用分數判定來篩選出90分以上的同學，然後用`map`轉換為學生家長，最後用`forEach`讓每個家長上台領獎。

 ```swift
 // 由高到低打印三年二班的學生成績
 gradeThreeClassTwoStudents
     .sorted { student0, student1 in student0.score > student1.score }
     .forEach { student in print("score: \(student.score), name: \(student.name)") }
 ```

 將排序邏輯的函數傳遞給 `sorted`方法，這樣學生就按成績高低排序，最後用`forEach`將成績和學生名字打印出來。

 ### 整體結構

 ![](FunctionalProgramming.png)

 值得注意的是，我們先從三年二班篩選出男同學，後來又從三年二班篩選出分數高於90的學生。都是用的 `filter` 方法，只是傳遞了不同的判定函數，從而得出了不同的篩選結果。如果現在要實現這個需求：二年一班分數不足60的學生唱一首《我有罪》。

 相信大家要不了多久就可以找到對應的實現方法。

 這就是**函數式編程**，它使我們可以通過組合不同的方法，以及不同的函數來獲取目標結果。你可以想像如果我們用傳統的 for 循環來完成相同的邏輯，那將會是一件多麼繁瑣的事情。所以函數式編程的優點是顯而易見的：

 * 靈活
 * 高複用
 * 簡潔
 * 易維護
 * 適應各種需求變化


 如果想了解更多有關於**函數式編程**的知識。可以參考這本書籍 [《函數式 Swift》](https://www.objccn.io/products/functional-swift/)。
 
 
 ## 函數式編程 -> 函數響應式編程

 現在大家已經了解我們是如何運用**函數式編程**來操作序列的。其實我們可以把這種操作序列的方式再昇華一下。例如，你可以把一個按鈕的點擊事件看作是一個序列：

 ![](TapArray.png)

 ```swift
 // 假設用戶在進入頁面到離開頁面期間，總共點擊按鈕 3 次

 // 按鈕點擊序列
 let taps: Array<Void> = [(), (), ()]

 // 每次點擊後彈出提示框
 taps.forEach { showAlert() }
 ```

 這樣處理點擊事件是非常理想的，但是問題是這個序列裡面的元素（點擊事件）是異步產生的，傳統序列是無法描敘這種元素異步產生的情況。為了解決這個問題，於是就產生了**可監聽序列**`Observable<Element>`。它也是一個序列，只不過這個序列裡面的元素可以是同步產生的，也可以是異步產生的:

 ![](TapObservable.png)

 ```swift
 // 按鈕點擊序列
 let taps: Observable<Void> = button.rx.tap.asObservable()

 // 每次點擊後彈出提示框
 taps.subscribe(onNext: { showAlert() })
 ```

 這裡 `taps` 就是按鈕點擊事件的序列。然後我們通過彈出提示框，來對每一次點擊事件做出響應。這種編程方式叫做**響應式編程**。我們結合**函數式編程**以及**響應式編程**就得到了**函數響應式編程**：

 ![](PasswordValid.png)

 ```swift
 passwordOutlet.rx.text.orEmpty
     .map { $0.characters.count >= minimalPasswordLength }
     .bind(to: passwordValidOutlet.rx.isHidden)
     .disposed(by: disposeBag)
 ```

 我們通過不同的構建函數，來創建所需要的數據序列。最後通過適當的方式來響應這個序列。這就是**函數響應式編程**。
 
 ## 數據綁定（訂閱）

 ![](Binding.png)

 在 **RxSwift** 裡有一個比較重要的概念就是**數據綁定（訂閱）**。就是指將**可監聽序列**綁定到**觀察者**上：

 我們對比一下這兩段代碼：

 ```swift
 let image: UIImage = UIImage(named: ...)
 imageView.image = image
 ```

 ```swift
 let image: Observable<UIImage> = ...
 image.bind(to: imageView.rx.image)
 ```

 第一段代碼我們非常熟悉，它就是將一個單獨的圖片設置到`imageView`上。

 第二段代碼則是將一個圖片序列 **“同步”** 到`imageView`上。這個序列裡面的圖片可以是**異步**產生的。這裡定義的 `image` 就是上圖中藍色部分（**可監聽序列**），`imageView.rx.image`就是上圖中橙色部分（**觀察者**）。而這種 **“同步機制”** 就是**數據綁定（訂閱）**。
 
 */
//: [Next](@next) RxSwift Core
