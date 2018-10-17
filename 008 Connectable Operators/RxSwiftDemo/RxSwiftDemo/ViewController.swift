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

public func delay(_ delay: Double, closure: @escaping () -> Void) {
    
    DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
        closure()
    }
}

public func printExampleHeader(_ description: String) {
    print("\n--- \(description) example ---")
}



class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        _ = ConnectableOperators()
    }
}

