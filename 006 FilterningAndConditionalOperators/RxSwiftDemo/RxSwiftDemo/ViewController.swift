//
//  ViewController.swift
//  RxSwiftDemo
//
//  Created by 盘国权 on 2018/9/17.
//  Copyright © 2018年 pgq. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

func example(_ title: String, _ closure: () -> ()) {
    print("---------- \(title) ----------")
    closure()
}


class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        _ = FilterningAndConditionalOperators()
        
        setup()
    }
    
    @IBOutlet weak var progressLabel: UILabel!
    @IBOutlet weak var progressSlider: UISlider!
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var btnLabel: UILabel!
    
    private let bag = DisposeBag()
    
    private var count = 0
    private var lastTimeInterval = CFAbsoluteTimeGetCurrent()
}

extension ViewController {
    private func setup() {
        
        progressSlider.rx
            .value.asObservable()
            .throttle(0.4, scheduler: MainScheduler.instance)
            .map(progress)
            .bind(to: progressLabel.rx.text)
            .disposed(by: bag)
        
        button.rx
            .tap.asObservable()
            .debounce(0.3, scheduler: MainScheduler.instance)
            .map(btnTapCount)
            .bind(to: btnLabel.rx.text)
            .disposed(by: bag)
    }
    
    private func progress(_ progress: Float) -> String {
        let time = CFAbsoluteTimeGetCurrent() - lastTimeInterval
        lastTimeInterval = CFAbsoluteTimeGetCurrent()
        return  "time: \(time)" + "\n" + String(format: "%.2f", progress)
    }
    
    private func btnTapCount() -> String {
        count += 1
        return "响应点击次数: \(count)"
    }
}

