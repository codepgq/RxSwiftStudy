//
//  Create.swift
//  RxSwiftDemo
//
//  Created by 盘国权 on 2018/9/17.
//  Copyright © 2018年 pgq. All rights reserved.
//

import Foundation
import RxSwift

class Create {
    
    
    init() {
        
        example("上一节内容") {
            Observable.of(1,2,3,4,5,6,7,8)
                .filter { $0 % 2 == 0 }
                .subscribe(
                    onNext: { num in
                        print(num)
                }).dispose()
        }
        
        example("of") {
            let bag = DisposeBag()
            print("of 1")
            Observable.of(1,2,3,4,5,6,7,8)
                .subscribe(
                    onNext:{
                    print("\t",$0)
                }).disposed(by: bag)
            
            print("of 2")
            Observable.of([1,2,3,4,5,6,7,8], scheduler: MainScheduler.instance)
                .subscribe(
                    onNext:{
                        print("\t", $0)
                }).disposed(by: bag)
            
        }
        
        example("from") {
            let bag = DisposeBag()
            Observable.from([1,2,3,4,5,6,7,8])
                .subscribe(
                    onNext:{
                        print("\t",$0)
                }).disposed(by: bag)
            
            
        }
        
        example("never") {
            let bag = DisposeBag()
            
            Observable<String>
                .never()
                .subscribe(
                    onNext: { _ in
                         print("永远都不会打印")
                    }
                ).disposed(by: bag)
        }
        
        example("empty") {
            let bag = DisposeBag()
            
            Observable<Int>.empty()
                .subscribe(
                    onNext: { print("next \($0)") },
                    onError: { print("error \($0)") },
                    onCompleted: { print("completed") },
                    onDisposed: { print("disposed") })
                .disposed(by: bag)
        }
        
        
        example("just") {
            let bag = DisposeBag()
            
            Observable.just("🔴")
                .subscribe(
                    onNext: { print($0) },
                    onError: { print("error \($0)") },
                    onCompleted: { print("completed") },
                    onDisposed: { print("disposed") })
                .disposed(by: bag)
        }
        
        
        example("create") {
            let bag = DisposeBag()
            let observable = Observable<String>.create({ (observar) -> Disposable in
                observar.onNext("on next")
                observar.onCompleted()
                return Disposables.create()
            })
            
            observable.subscribe(
                onNext: { print($0) },
                onError: { print("error \($0)") },
                onCompleted: { print("completed") },
                onDisposed: { print("disposed") }
                ).disposed(by: bag)
        }
        
        example("range") {
            let bag = DisposeBag()
            
            Observable.range(start: 1, count: 10)
                .subscribe(
                    onNext: { print($0) },
                    onError: { print("error \($0)") },
                    onCompleted: { print("completed") },
                    onDisposed: { print("disposed") }
                ).disposed(by: bag)
        }
        
        example("repeatElement") {
            let bag = DisposeBag()
            
            Observable.repeatElement("🔴")
                .take(3)
                .subscribe(
                    onNext: { print($0) },
                    onError: { print("error \($0)") },
                    onCompleted: { print("completed") },
                    onDisposed: { print("disposed") }
                )
                .disposed(by: bag)
        }
        
        example("generate") {
            let bag = DisposeBag()
            
            Observable.generate(
                initialState: 0,
                condition: { $0 < 3 },
                iterate: { $0 + 1 }
                )
                .subscribe(
                    onNext: { print($0) },
                    onError: { print("error \($0)") },
                    onCompleted: { print("completed") },
                    onDisposed: { print("disposed") }
                )
                .disposed(by: bag)
        }
        
        
        example("deferred") {
            let bag = DisposeBag()
            var count = 1
            
            let deferredSequence = Observable<String>.deferred {
                print("Creating \(count)")
                count += 1
                
                return Observable.create { observer in
                    print("Emitting...")
                    observer.onNext("🐶")
                    observer.onNext("🐱")
                    observer.onNext("🐵")
                    return Disposables.create()
                }
            }
            
            deferredSequence
                .subscribe(onNext: { print($0) })
                .disposed(by: bag)
            
            deferredSequence
                .subscribe(onNext: { print($0) })
                .disposed(by: bag)
        }
        
        example("error") {
            enum TestError: Error {
                case test
            }
            
            let bag = DisposeBag()
            
            Observable<Int>.error(TestError.test)
                .subscribe { print($0) }
                .disposed(by: bag)
        }
        
        example("doOn") {
            let bag = DisposeBag()
            
            Observable.of("🍎", "🍐", "🍊", "🍋")
                .do(onNext: { print("do:", $0) },
                    onError: { print("do error:", $0) },
                    onCompleted: { print("do Completed")  },
                    onDispose: { print("do dispose") })
                .subscribe(
                    onNext: { print($0) },
                    onError: { print("error \($0)") },
                    onCompleted: { print("completed") },
                    onDisposed: { print("disposed") }
                )
                .disposed(by: bag)
        }
        
        example("debug") {
            let bag = DisposeBag()
            Observable.of("🍎", "🍐", "🍊", "🍋")
                .debug()
                .subscribe(
                    onNext: { print($0) },
                    onError: { print("error \($0)") },
                    onCompleted: { print("completed") },
                    onDisposed: { print("disposed") }
                )
                .disposed(by: bag)
        }
    }
}
