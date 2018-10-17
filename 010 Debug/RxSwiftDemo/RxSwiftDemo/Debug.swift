//
//  Debug.swift
//  RxSwiftDemo
//
//  Created by 盘国权 on 2018/10/9.
//  Copyright © 2018年 pgq. All rights reserved.
//

import Foundation
import RxSwift

class Debug: NSObject {
    override init() {
        example("debug") {
            let bag = DisposeBag()
            var count = 1
            
            let sequenceThatErrors = Observable<String>.create { observer in
                observer.onNext("🍎")
                observer.onNext("🍐")
                observer.onNext("🍊")
                
                if count < 5 {
                    observer.onError(TestError.test)
                    print("Error encountered")
                    count += 1
                }
                
                observer.onNext("🐶")
                observer.onNext("🐱")
                observer.onNext("🐭")
                observer.onCompleted()
                
                return Disposables.create()
            }
            
            sequenceThatErrors
                .retry(3)
                .debug()
                .subscribe(onNext: { print($0) })
                .disposed(by: bag)
        }
        
        example("RxSwift.Resources.total") {
            print(RxSwift.Resources.total)
            
            let variable = Variable("🍎")
            
            let subscription1 = variable.asObservable().subscribe(onNext: { print($0) })
            
            print(RxSwift.Resources.total)
            
            let subscription2 = variable.asObservable().subscribe(onNext: { print($0) })
            
            print(RxSwift.Resources.total)
            
            subscription1.dispose()
            
            print(RxSwift.Resources.total)
            
            subscription2.dispose()
            
            print(RxSwift.Resources.total)
        }
        
        print(RxSwift.Resources.total)
    }
}
