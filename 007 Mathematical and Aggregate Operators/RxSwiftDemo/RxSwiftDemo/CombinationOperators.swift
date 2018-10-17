//
//  CombinationOperators.swift
//  RxSwiftDemo
//
//  Created by 盘国权 on 2018/9/19.
//  Copyright © 2018年 pgq. All rights reserved.
//

import Foundation
import RxSwift

enum TestError: Error {
    case test
}

class CombinationOperators {
    init() {
        
        example("startWith") {
            let bag = DisposeBag()
            
            Observable.of("🐶", "🐱", "🐭", "🐹")
                .startWith("1️⃣")
                .startWith("2️⃣")
                .subscribe(onNext: { print($0) })
                .disposed(by: bag)
        }
        
        example("merge") {
            let bag = DisposeBag()
            
            let subject1 = PublishSubject<String>()
            let subject2 = PublishSubject<String>()
            
            Observable.of(subject1, subject2)
                .merge()
                .subscribe(
                    onNext: { print($0) },
                    onError: { print($0) })
                .disposed(by: bag)
            
            subject1.onNext("🅰️")
            
            subject1.onNext("🅱️")
            
            subject2.onNext("①")
            
            subject2.onNext("②")
            
//            subject1.onError(TestError.test)
//            subject1.dispose()
            subject1.onCompleted()
            
            subject1.onNext("🆎")
            
            subject2.onNext("③")
        }
        
        example("zip") {
            let bag = DisposeBag()
            
            let stringSubject = PublishSubject<String>()
            let intSubject = PublishSubject<Int>()
            
            Observable.zip(stringSubject, intSubject) { stringElement, intElement in
                "\(stringElement) \(intElement)"
                }
                .subscribe(onNext: { print($0) })
                .disposed(by: bag)
            
            stringSubject.onNext("🅰️")
            stringSubject.onNext("🅱️")
            
            intSubject.onNext(1)
            
            intSubject.onNext(2)
            
//            stringSubject.onError(TestError.test)
//            stringSubject.onCompleted()
//            stringSubject.dispose()
            
            stringSubject.onNext("🆎")
            intSubject.onNext(3)
        }
        
        
        example("combineLatest") {
            let bag = DisposeBag()
            
            let stringSubject = PublishSubject<String>()
            let intSubject = PublishSubject<Int>()
            
            Observable.combineLatest(stringSubject, intSubject) { stringElement, intElement in
                "\(stringElement) \(intElement)"
                }
                .subscribe(onNext: { print($0) })
                .disposed(by: bag)
            
            stringSubject.onNext("🅰️")
            intSubject.onNext(1)
            
            stringSubject.onNext("🅱️")
            
            intSubject.onNext(2)
            
//                        stringSubject.onError(TestError.test)
//                        stringSubject.onCompleted()
//                        stringSubject.dispose()
            
            stringSubject.onNext("🆎")
            intSubject.onNext(3)
        }
        
        
        example("Array.combineLatest") {
            let bag = DisposeBag()

            let stringObservable = Observable.just("❤️")
            let fruitObservable = Observable.from(["🍎", "🍐", "🍊"])
            let animalObservable = Observable.of("🐶", "🐱", "🐭", "🐹")
            
            Observable.combineLatest([stringObservable, fruitObservable, animalObservable]) {
                "\($0[0]) \($0[1]) \($0[2])"
                }
                .subscribe(onNext: { print($0) })
                .disposed(by: bag)
        }
        
        
        example("switchLatest") {
            let bag = DisposeBag()
            
            let subject1 = BehaviorSubject(value: "⚽️")
            let subject2 = BehaviorSubject(value: "🍎")
            
            let variable = Variable(subject1)
            
            variable.asObservable()
                .switchLatest()
                .subscribe(onNext: { print($0) })
                .disposed(by: bag)
            
            subject1.onNext("🏈")
            subject1.onNext("🏀")
            
            variable.value = subject2
            
            subject1.onNext("⚾️")
            
            subject2.onNext("🍐")
        }
    }
}
