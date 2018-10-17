//
//  TransformOperators.swift
//  RxSwiftDemo
//
//  Created by 盘国权 on 2018/9/22.
//  Copyright © 2018年 pgq. All rights reserved.
//

import Foundation
import RxSwift


class TransformOperators {
    init() {
        
        example("map") {
            let bag = DisposeBag()
            Observable.of(1, 2, 3)
                .map { $0 * $0 }
                .subscribe(onNext: { print($0) })
                .disposed(by: bag)
        }
        
        
        example("flatMap and flatMapLatest") {
            let bag = DisposeBag()
            
            struct Player {
                var score: Variable<Int>
            }
            
            let 👦🏻 = Player(score: Variable(80))
            let 👧🏼 = Player(score: Variable(90))
            
            let player = Variable(👦🏻)
            
            player.asObservable()
                .flatMap { $0.score.asObservable() }
                //.flatMapLatest { $0.score.asObservable() }
                .subscribe(onNext: { print($0) })
                .disposed(by: bag)
            
            👦🏻.score.value = 85
            
            player.value = 👧🏼
            
            // 如果之前使用了flatMapLatest进行形变，那么这个值讲不会打印
            👦🏻.score.value = 95
            
            👧🏼.score.value = 100
        }
        
        example("scan") {
            let bag = DisposeBag()
            
            Observable.of(10, 100, 1000)
                .scan(1) { aggregateValue, newValue in
                    aggregateValue + newValue
                }
                .subscribe(onNext: { print($0) })
                .disposed(by: bag)
            
            Observable.of("10", "100", "1000")
                .scan("1") { aggregateValue, newValue in
                    aggregateValue + newValue
                }
                .subscribe(onNext: { print($0) })
                .disposed(by: bag)
        }
        
        example("buffer") {
            let bag = DisposeBag()
            let subject = PublishSubject<String>()
            
            subject.asObserver()
                .buffer(timeSpan: 2, count: 5, scheduler: MainScheduler.instance)
                .subscribe(onNext: { print($0) })
                .disposed(by: bag)
            
            subject.onNext("1")
            subject.onNext("2")
            subject.onNext("3")
            subject.onNext("4")
            subject.onNext("5")
            
            subject.onNext("6")
            subject.onNext("7")
            
//            dispatchMain()
        }
        
        example("window") {
            let bag = DisposeBag()
            let subject = PublishSubject<String>()
            
            subject.asObserver()
                .debug()
                .window(timeSpan: 2, count: 5, scheduler: MainScheduler.instance)
                .flatMap { ob -> Observable<String> in
                    print(ob)
                    return ob.asObservable()
                }
                .subscribe(
                    onNext: { print($0) }
                ).disposed(by: bag)
            
            subject.onNext("a")
            subject.onNext("b")
            subject.onNext("c")
            subject.onNext("d")
            subject.onNext("e")

            subject.onNext("f")
            subject.onNext("g")
            subject.onNext("h")
            DispatchQueue.global()
                .asyncAfter(
                    deadline: DispatchTime.now() + 0.5,
                    execute: {
                    subject.onNext("i")
            })
            
            DispatchQueue.global()
                .asyncAfter(
                    deadline: DispatchTime.now() + 4,
                    execute: {
                    subject.onNext("j")
                    subject.onNext("k")
                    subject.onNext("l")
            })
            
            dispatchMain()
        }
        
    }
}
