//: [Previous](@previous) Introduction
/*:
 安裝 **RxSwift** 不需要任何第三方依賴。

 以下是當前支持的安裝方法：

 ### 手動

 打開 Rx.xcworkspace, 選中 `RxExample` 並且點擊運行。此方法將構建所有內容並運行示例應用程序。

 ### [CocoaPods](https://guides.cocoapods.org/using/using-cocoapods.html)

 ** **`pod --version`**: **`1.3.1` 已通過測試

 ```ruby
 # Podfile
 use_frameworks!

 target 'YOUR_TARGET_NAME' do
     pod 'RxSwift', '~> 5.0'
     pod 'RxCocoa', '~> 5.0'
 end

 # RxTests 和 RxBlocking 將在單元/集成測試中起到重要作用
 target 'YOUR_TESTING_TARGET' do
     pod 'RxBlocking', '~> 5.0'
     pod 'RxTest', '~> 5.0'
 end
 ```

 替換 `YOUR_TARGET_NAME` 然後在 `Podfile` 目錄下, 終端輸入：

 ```bash
 $ pod install
 ```
 ### [Carthage](https://github.com/Carthage/Carthage)

 官方支持 0.33 及以上版本。

 添加到 `Cartfile`

 ```
 github "ReactiveX/RxSwift" ~> 5.0
 ```

 ```bash
 $ carthage update
 ```

 **[Carthage](https://github.com/Carthage/Carthage) 作為靜態庫。 **

 如果您希望使用 Carthage 將 [RxSwift] 構建為靜態庫，在使用 Carthage 構建之前，您可以使用以下腳本手動修改框架類型：

 ```bash
 carthage update RxSwift --platform iOS --no-build
 sed -i -e 's/MACH_O_TYPE = mh_dylib/MACH_O_TYPE = staticlib/g' Carthage/Checkouts/RxSwift/Rx.xcodeproj/project.pbxproj
 carthage build RxAlamofire --platform iOS
 ```

 ### [Swift Package Manager](https://github.com/apple/swift-package-manager)

 創建`Package.swift` 文件。

 ```swift
 // swift-tools-version:5.0

 import PackageDescription

 let package = Package(
   name: "RxTestProject",
   dependencies: [
     .package(url: "https://github.com/ReactiveX/RxSwift.git", from: "5.0.0")
   ],
   targets: [
     .target(name: "RxTestProject", dependencies: ["RxSwift", "RxCocoa"])
   ]
 )
 ```

 ```bash
 $ swift build
 ```

 如果構建或測試一個模塊對 RxTest 存在依賴， 設置 `TEST=1`.

 ```bash
 $ TEST=1 swift test
 ```

 ### 使用 git submodules 手動集成

 * 添加 RxSwift 作為子模塊

 ```bash
 $ git submodule add git@github.com:ReactiveX/RxSwift.git
 ```

 * 拖拽 `Rx.xcodeproj` 到項目中
 * 前往 `Project > Targets > Build Phases > Link Binary With Libraries`, 點擊 `+` 並且選中 `RxSwift-[Platform]` 和 `RxCocoa-[Platform]`
 */
//: [Next](@next) WhyRxSwift
