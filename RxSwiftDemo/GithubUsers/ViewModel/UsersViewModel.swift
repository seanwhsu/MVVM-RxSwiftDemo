//
//  UsersViewModel.swift
//  RxSwiftDemo
//
//  Created by Sean on 2021/7/7.
//

import UIKit
import RxSwift

class UsersViewModel: NSObject {
    
    private let disposeBag = DisposeBag()
    private let apiLoader = ApiLoader()
    private var usersData: Observable<[User]>?
    
    var userCellViewModels: PublishSubject<[UserCellViewModel]> = PublishSubject()
    
    override init() {
        
    }
    
    func loadUsers() {
        usersData = apiLoader.loadUsers()
        
        usersData?.subscribe(onNext: { [weak self] datas in
            self?.userCellViewModels.onNext(self?.prepareCellViewModel(datas: datas) ?? [])
        })
        .disposed(by: disposeBag)
    }
    
    func prepareCellViewModel(datas: [User]) -> [UserCellViewModel] {
        var models: [UserCellViewModel] = []
        
        for user in datas {
            let model = UserCellViewModel(user: Observable.just(user))
            models.append(model)
        }
        return models
    }
    
    
}
