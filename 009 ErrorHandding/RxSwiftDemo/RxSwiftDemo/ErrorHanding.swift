//
//  ErrorHanding.swift
//  RxSwiftDemo
//
//  Created by 盘国权 on 2018/10/9.
//  Copyright © 2018年 pgq. All rights reserved.
//

import Foundation
import RxSwift

class ErrorHanding: NSObject {
    override init() {
        
        example("catchErrorJustReturn") {
            let bag = DisposeBag()
            
            let sequenceThatFails = PublishSubject<Int>()
            
            sequenceThatFails
                .catchErrorJustReturn(-1)
                .subscribe(
                    onNext: { print($0) },
                    onError: { print($0) },
                    onCompleted: { print("onCompleted") },
                    onDisposed: { print("onDisposed") }
                )
                .disposed(by: bag)
            
            sequenceThatFails.onNext(1)
            sequenceThatFails.onNext(2)
            sequenceThatFails.onNext(3)
            sequenceThatFails.onError(TestError.test)
        }
        
        
        example("catchError") {
            let bag = DisposeBag()
            
            let sequenceThatFails = PublishSubject<String>()
            let recoverySequence = PublishSubject<String>()
            
            sequenceThatFails
                .catchError {
                    print("Error:", $0)
                    return recoverySequence
                }
                .subscribe (
                    onNext: { print($0) },
                    onError: { print($0) },
                    onCompleted: { print("onCompleted") },
                    onDisposed: { print("onDisposed") }
                )
                .disposed(by: bag)
            
            sequenceThatFails.onNext("A")
            sequenceThatFails.onNext("B")
            sequenceThatFails.onNext("C")
            sequenceThatFails.onNext("D")
            sequenceThatFails.onError(TestError.test)
            
            recoverySequence.onNext("1")
        }
        
        example("retry") {
            let bag = DisposeBag()
            
            let sequenceThatErrors = Observable<String>.create { observer in
                observer.onNext("A")
                observer.onNext("B")
                observer.onNext("C")
                observer.onNext("D")
                
//                observer.onError(TestError.test)
                
                observer.onNext("1")
                observer.onNext("2")
                observer.onNext("3")
                observer.onCompleted()
                
                return Disposables.create()
            }
            
            sequenceThatErrors
                .retry()
                .subscribe(
                    onNext: { print($0) },
                    onError: { print($0) },
                    onCompleted: { print("onCompleted") },
                    onDisposed: { print("onDisposed") }
                )
                .disposed(by: bag)
        }
        
        example("retry maxAttemptCount") {
            let bag = DisposeBag()
            
            let sequenceThatErrors = Observable<String>.create { observer in
                observer.onNext("A")
                observer.onNext("B")
                observer.onNext("C")
                observer.onNext("D")
                
                observer.onError(TestError.test)
                
                observer.onNext("1")
                observer.onNext("2")
                observer.onNext("3")
                observer.onCompleted()
                
                return Disposables.create()
            }
            
            sequenceThatErrors
                .retry(2)
                .subscribe(
                    onNext: { print($0) },
                    onError: { print($0) },
                    onCompleted: { print("onCompleted") },
                    onDisposed: { print("onDisposed") }
                )
                .disposed(by: bag)
        }
        
    }
}
