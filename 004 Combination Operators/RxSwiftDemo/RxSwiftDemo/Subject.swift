//
//  Subject.swift
//  RxSwiftDemo
//
//  Created by 盘国权 on 2018/9/18.
//  Copyright © 2018年 pgq. All rights reserved.
//

import Foundation
import RxSwift


class Subject {
    init() {
        
        example("PublishSubject") {
            // 创建一个DisposeBag对象
            let bag = DisposeBag()
            // 创建一个subject对象，发送的事件值类型为String
            let subject = PublishSubject<String>()
            
            // 发送值
            subject.onNext("🐶")
            subject.onNext("🐱")
            
            // 订阅
            subject.subscribe(
                onNext: { print($0) },
                onError: { print($0) },
                onCompleted: { print("Completed") },
                onDisposed: { print("Disposed") })
                .disposed(by: bag)
            
            // 发送
            subject.onNext("🅰️")
            subject.onNext("🅱️")
        }
        
        
        
        example("ReplaySubject") {
            // 创建一个DisposeBag对象
            let bag = DisposeBag()
            // 创建一个ReplaySubject 并设置其缓冲区大小为1，表示缓存上一次的事件值，当有新的订阅者订阅，会把上一次缓存的值发送出去，如果上一次缓存的是空，则不会发送
            let subject = ReplaySubject<String>.create(bufferSize: 1)
            
            // 订阅
            subject.subscribe(
                onNext: { print("订阅者1 - ", $0) },
                onError: { print("订阅者1 - ", $0) },
                onCompleted: { print("订阅者1 - ", "Completed") },
                onDisposed: { print("订阅者1 - ", "Disposed") })
                .disposed(by: bag)
            
            subject.onNext("🐶")
            subject.onNext("🐱")
            
            
            // 订阅
            subject.subscribe(
                onNext: { print("订阅者2 - ", $0) },
                onError: { print("订阅者2 - ", $0) },
                onCompleted: { print("订阅者2 - ", "Completed") },
                onDisposed: { print("订阅者2 - ", "Disposed") })
                .disposed(by: bag)
            
            subject.onNext("🅰️")
            subject.onNext("🅱️")
        }
        
        example("BehaviorSubject") {
            // 新建一个DisposeBag 对象
            let bag = DisposeBag()
            // 新建一个BehaviorSubject，BehaviorSubject创建时会要求我们输入一个初始值，当我们订阅之后，就会把初始化的值发送给订阅者，当有多个订阅者的时候，新的订阅者会收到subject最后一次缓存的值
            let subject = BehaviorSubject(value: "🔴")
            subject.subscribe(
                onNext: { print("订阅者1 - ", $0) },
                onError: { print("订阅者2 - ", $0) },
                onCompleted: { print("订阅者1 - ", "Completed") },
                onDisposed: { print("订阅者1 - ", "Disposed") })
                .disposed(by: bag)
            
            subject.onNext("🐶")
            subject.onNext("🐱")
            
            subject.subscribe(
                onNext: { print("订阅者2 - ", $0) },
                onError: { print("订阅者2 - ", $0) },
                onCompleted: { print("订阅者2 - ", "Completed") },
                onDisposed: { print("订阅者2 - ", "Disposed") })
                .disposed(by: bag)
            
            subject.onNext("🅰️")
            subject.onNext("🅱️")
            
            enum TestError: Error {
                case test
            }
            
            subject.onError(TestError.test)
            
            subject.onNext("测试数据")
            
            subject.subscribe(
                onNext: { print("订阅者3 - ", $0) },
                onError: { print("订阅者3 - ", $0) },
                onCompleted: { print("订阅者3 - ", "Completed") },
                onDisposed: { print("订阅者3 - ", "Disposed") })
                .disposed(by: bag)
            
            subject.onNext("🍐")
            subject.onNext("🍊")
        }
        
        example("Variable") {
            // 新建一个DisposeBag 对象
            let bag = DisposeBag()
            // 新建一个Variable 对象, Variable 携带一个初始值，与前面三种Subject不同的是，Vaiable可以用来监听任意值，比如监听数组新增、删除、修改之类的操作，emmm……但是这个类已经被RxSwift打入冷宫了，将来的把其废用，官方给出的替换方案是BehaviorRelay
            let variable = Variable("🔴")
            
            variable.asObservable().subscribe(
                onNext: { print("订阅者1 - ", $0) },
                onError: { print("订阅者2 - ", $0) },
                onCompleted: { print("订阅者1 - ", "Completed") },
                onDisposed: { print("订阅者1 - ", "Disposed") })
                .disposed(by: bag)
            
            variable.value = "🐶"
            variable.value = "🐱"
            
            variable.asObservable().subscribe(
                onNext: { print("订阅者2 - ", $0) },
                onError: { print("订阅者2 - ", $0) },
                onCompleted: { print("订阅者2 - ", "Completed") },
                onDisposed: { print("订阅者2 - ", "Disposed") })
                .disposed(by: bag)
            
            variable.value = "🅰️"
            variable.value = "🅱️"
        }
        
    }
}
