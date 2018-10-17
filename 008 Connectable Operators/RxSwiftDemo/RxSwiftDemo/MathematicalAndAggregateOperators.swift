//
//  MathematicalAndAggregateOperators.swift
//  RxSwiftDemo
//
//  Created by 盘国权 on 2018/9/25.
//  Copyright © 2018年 pgq. All rights reserved.
//

import Foundation
import RxSwift

class MathematicalAndAggregateOperators {
    init() {
        
        example("toArray") {
            let disposeBag = DisposeBag()
            
            Observable.range(start: 1, count: 10)
                .toArray()
                .subscribe { print($0) }
                .disposed(by: disposeBag)
        }
        
        example("reduce") {
            let disposeBag = DisposeBag()
            
            Observable.of(1, 2, 2, 3, 1, 4, 2)
                .reduce(1, accumulator: +)
                .subscribe(onNext: { print($0) })
                .disposed(by: disposeBag)
        }
        
        example("concat") {
            let disposeBag = DisposeBag()
            
            let subject1 = BehaviorSubject(value: "1")
            let subject2 = BehaviorSubject(value: "a")
            
            let subject = PublishSubject<Observable<String>>()
            
            
            subject.concat()
                .subscribe(
                    onNext:  { print("next ", $0) },
                    onError:  { print("error ",$0) },
                    onCompleted:  { print("onCompleted") },
                    onDisposed:  { print("onDisposed") }
                )
                .disposed(by: disposeBag)
            
            subject.onNext(subject1)
            subject.onNext(subject2)
            
            
            subject1.onNext("2")
            subject1.onNext("3")
            
//            subject2.onError(TestError.test)
//            subject1.onNext("🍊")
            
            subject2.onNext("I would be ignored")
            subject2.onNext("b")
            
            subject1.onCompleted()
//            subject1.dispose()
//            subject1.onError(TestError.test)
            
            subject2.onNext("c")
            subject2.onError(TestError.test)
            subject2.onNext("d")
            
            
            
        }
    }
}
