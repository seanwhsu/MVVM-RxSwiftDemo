//
//  UserCellViewModel.swift
//  RxSwiftDemo
//
//  Created by Sean on 2021/7/8.
//

import Foundation
import RxSwift
import RxCocoa

class UserCellViewModel {
    private let userData: Observable<User>
    var userImage: Driver<UIImage>?
    var userName: Driver<String>?
    
    init(user: Observable<User>) {
        self.userData = user
        userImage = self.userData.asDriver(onErrorJustReturn: User())
            .flatMapLatest({ user in
                if let url = URL(string: user.avatar_url ?? ""),
                   let data = try? Data.init(contentsOf: url) {
                    return Driver.just(UIImage(data: data)!)
                } else {
                    return Driver.just(UIImage())
                }
            })
        userName = self.userData.asDriver(onErrorJustReturn: User())
            .flatMapLatest({ user in
                return Driver.just(user.login ?? "")
            })
    }
}
