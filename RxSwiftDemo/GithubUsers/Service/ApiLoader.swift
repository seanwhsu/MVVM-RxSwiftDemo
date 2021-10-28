//
//  ApiLoader.swift
//  RxSwiftDemo
//
//  Created by Sean on 2021/7/7.
//

import Foundation
import RxAlamofire
import Alamofire
import RxSwift
import RxCocoa

class ApiLoader {
    let usersApi = "https://api.github.com/users"
    func loadUsers<T: Codable>() -> Observable<T> {
        return RxAlamofire.data(.get, usersApi, encoding: JSONEncoding.default)
            .flatMapLatest ({ data -> Observable<T> in
                let objects = try JSONDecoder().decode(T.self, from: data)
                return Observable.just(objects)
            })
    }
    
}
