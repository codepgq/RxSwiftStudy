//
//  InvaildEnterInfoController.swift
//  RxSwiftDemo
//
//  Created by 盘国权 on 2018/10/19.
//  Copyright © 2018年 pgq. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

fileprivate let minimalUsernameLength = 5
fileprivate let minimalPasswordLength = 5

class InvaildEnterInfoController: UIViewController {

    
    var bag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        usernameLabel.text = "账号最少不能少于\(minimalUsernameLength)位"
        passwordLabel.text = "密码最少不能少于\(minimalUsernameLength)位"
        
        let usernameValid = usernameTF.rx.text.orEmpty
            .map { $0.count >= minimalUsernameLength }
            .share(replay: 1) // 如果不进行一次映射，默认Rx是没有状态的
        
        let passwordValid = passwordTF.rx.text.orEmpty
            .map { $0.count >= minimalPasswordLength }
            .share(replay: 1)
        
        /// 绑定到账号label是否显示
        usernameValid
            .bind(to: usernameLabel.rx.isHidden)
            .disposed(by: bag)
        
        /// 绑定到密码label是否显示
        passwordValid
            .bind(to: passwordLabel.rx.isHidden)
            .disposed(by: bag)
        
        /// 组合账号 密码,绑定到按钮的enable上
        Observable
            .combineLatest(usernameValid, passwordValid)
            .map { $0 && $1 }
            .bind(to: doSomethingBtn.rx.isEnabled)
            .disposed(by: bag)
        
        /// 监听按钮点击事件
        doSomethingBtn.rx
            .controlEvent(.touchUpInside)
            .subscribe(
                onNext: {[weak self] in
                  self?.showAlert()
                }
            ).disposed(by: bag)
        
    }
    
    @IBOutlet weak var usernameTF: UITextField!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var doSomethingBtn: UIButton!

}

extension InvaildEnterInfoController {
    func showAlert() {
        let alertView = UIAlertView(
            title: "RxCocoa Demo",
            message: "登录成功",
            delegate: nil,
            cancelButtonTitle: "确定"
        )
        
        alertView.show()
    }
}
