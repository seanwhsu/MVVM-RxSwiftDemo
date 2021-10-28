import UIKit
import Foundation
import RxSwift
import RxCocoa


/*
 # Single

 Single 是 Observable 的另外一个版本。不像 Observable 可以发出多个元素，它要么只能发出一个元素，要么产生一个 error 事件。

 发出一个元素，或一个 error 事件
 不会共享附加作用
 一个比较常见的例子就是执行 HTTP 请求，然后返回一个应答或错误。不过你也可以用 Single 来描述任何只有一个元素的序列。
 */

enum DataError: Error {
    case cantParseJSON
}

func getRepo(_ repo: String) -> Single<[String: Any]> {

    return Single<[String: Any]>.create { single in
        let url = URL(string: "https://api.github.com/repos/\(repo)")!
        let task = URLSession.shared.dataTask(with: url) {
            data, _, error in

            if let error = error {
                single(.failure(error))
                return
            }

            guard let data = data,
                  let json = try? JSONSerialization.jsonObject(with: data, options: .mutableLeaves),
                  let result = json as? [String: Any] else {
                single(.failure(DataError.cantParseJSON))
                return
            }

            single(.success(result))
        }

        task.resume()

        return Disposables.create { task.cancel() }
    }
}

let disposeBag = DisposeBag()


getRepo("ReactiveX/RxSwift")
    .subscribe(onSuccess: { json in
        print("JSON: ", json)
    }, onFailure: { error in
        print("Error: ", error)
    })
    .disposed(by: disposeBag)
