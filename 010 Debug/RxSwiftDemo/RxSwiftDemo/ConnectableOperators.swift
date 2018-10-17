//
//  ConnectableOperators.swift
//  RxSwiftDemo
//
//  Created by 盘国权 on 2018/9/28.
//  Copyright © 2018年 pgq. All rights reserved.
//

import Foundation
import RxSwift

class ConnectableOperators {
    init() {
        
        example("interval") {
            return
            var bag: DisposeBag? = DisposeBag()
            let interval = Observable<Int>.interval(1, scheduler: MainScheduler.instance)
            
            interval
                .subscribe(
                    onNext:{
                        print(Date.time," Subscription: 1, Event: \($0)") }
                ).disposed(by: bag!)
            
            delay(5) {
                interval
                    .subscribe(onNext: { print(Date.time," Subscription: 2, Event: \($0)") })
                    .disposed(by: bag!)
            }
            
            delay(10, closure: {
                bag = nil
            })
        }
        
        example("publish") {
            return
            
            let intSequence = Observable<Int>.interval(1, scheduler: MainScheduler.instance)
                .publish()
            
            _ = intSequence
                .subscribe(onNext: { print(Date.time, " Subscription 1:, Event: \($0)") })
            
            delay(2) { _ = intSequence.connect() }
            
            delay(4) {
                _ = intSequence
                    .subscribe(onNext: { print(Date.time, " Subscription 2:, Event: \($0)") })
            }
            
            delay(6) {
                _ = intSequence
                    .subscribe(onNext: { print(Date.time, " Subscription 3:, Event: \($0)") })
            }
        }
        
        example("replay") {
            return
            let intSequence = Observable<Int>.interval(1, scheduler: MainScheduler.instance)
                .replay(5)
            
            _ = intSequence
                .subscribe(onNext: { print(Date.time, " Subscription 1:, Event: \($0)") })
            
            delay(2) { _ = intSequence.connect() }
            
            delay(4) {
                _ = intSequence
                    .subscribe(onNext: { print(Date.time, " Subscription 2:, Event: \($0)") })
            }
            
            delay(8) {
                _ = intSequence
                    .subscribe(onNext: { print(Date.time, " Subscription 3:, Event: \($0)") })
            }
        }
        
        example("multicast") {
            
            let subject = PublishSubject<Int>()
            
            print(Date.time)
            _ = subject
                .subscribe(onNext: { print(Date.time, " Subject: \($0)") })
            
            let intSequence = Observable<Int>.interval(1, scheduler: MainScheduler.instance)
                .multicast(subject)
            
            _ = intSequence
                .subscribe(onNext: { print("\t\(Date.time) Subscription 1:, Event: \($0)") })
            
            delay(2) { _ = intSequence.connect() }
            
            delay(4) {
                _ = intSequence
                    .subscribe(onNext: { print("\t\(Date.time) Subscription 2:, Event: \($0)") })
            }
            
            delay(6) {
                _ = intSequence
                    .subscribe(onNext: { print("\t\(Date.time) Subscription 3:, Event: \($0)") })
            }
        }
    }
}
