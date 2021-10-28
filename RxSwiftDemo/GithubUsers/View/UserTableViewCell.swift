//
//  UserTableViewCell.swift
//  RxSwiftDemo
//
//  Created by Sean on 2021/7/8.
//

import UIKit
import RxSwift
import RxCocoa

class UserTableViewCell: UITableViewCell {
    let disposeBag = DisposeBag()
    var viewModel: UserCellViewModel? {
        didSet {
            bindElement()
        }
    }
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func bindElement() {
        viewModel?.userImage?
            .drive(userImageView.rx.image)
            .disposed(by: disposeBag)
        viewModel?.userName?
            .drive(userNameLabel.rx.text)
            .disposed(by: disposeBag)
    }
}
