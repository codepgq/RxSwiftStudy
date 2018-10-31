//
//  NumbersViewController.swift
//  RxSwiftDemo
//
//  Created by 盘国权 on 2018/10/19.
//  Copyright © 2018年 pgq. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class NumbersViewController: UIViewController {

    var bag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let textFields  = [textField1.rx.text.orEmpty,
        textField2.rx.text.orEmpty,
        textField3.rx.text.orEmpty]
        Observable
            .combineLatest(textFields)
            .map { $0.reduce(0, { $0 + (Int($1) ?? 0) }) }
            .map { $0.description }
            .bind(to: resultLabel.rx.text)
            .disposed(by: bag)
        
    }
    
    @IBOutlet weak var textField1: UITextField!
    @IBOutlet weak var textField2: UITextField!
    @IBOutlet weak var textField3: UITextField!
    @IBOutlet weak var resultLabel: UILabel!

}
