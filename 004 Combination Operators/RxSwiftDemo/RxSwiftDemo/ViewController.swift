//
//  ViewController.swift
//  RxSwiftDemo
//
//  Created by 盘国权 on 2018/9/17.
//  Copyright © 2018年 pgq. All rights reserved.
//

import UIKit

func example(_ title: String, _ closure: () -> ()) {
    print("---------- \(title) ----------")
    closure()
}


class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        _ = CombinationOperators()
    }
}

