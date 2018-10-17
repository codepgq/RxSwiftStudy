//
//  FilterningAndConditionalOperators.swift
//  RxSwiftDemo
//
//  Created by 盘国权 on 2018/9/22.
//  Copyright © 2018年 pgq. All rights reserved.
//

import Foundation
import RxSwift

class FilterningAndConditionalOperators {
    init() {
        example("filter") {
            let bag = DisposeBag()
            
            Observable.of(
                "🐱", "🐰", "🐶",
                "🐸", "🐱", "🐰",
                "🐹", "🐸", "🐱")
                .filter {
                    $0 == "🐱"
                }
                .subscribe(onNext: { print($0) })
                .disposed(by: bag)
        }
        
        example("distinctUntilChanged") {
            let bag = DisposeBag()
            
            Observable.of(1, 2, 2, 3, 1, 4, 2)
                .distinctUntilChanged()
                .subscribe(onNext: { print($0) })
                .disposed(by: bag)
        }
        
        example("elementAt") {
            let bag = DisposeBag()
            
            Observable.of(1, 2, 2, 3, 1, 4, 2)
                .elementAt(3)
                .subscribe(onNext: { print($0) })
                .disposed(by: bag)
        }
        
        example("single") {
            let bag = DisposeBag()
            
            Observable.of(1, 2, 2, 3, 1, 4, 2)
                .single()
                .subscribe(
                    onNext: { print($0) },
                    onError: { print($0) }
                ).disposed(by: bag)
        }
        
        example("single with conditions") {
            let bag = DisposeBag()
            
            Observable.of("🐱", "🐰", "🐶", "🐸", "🐷", "🐵")
                .single { $0 == "🐸" }
                .subscribe { print($0) }
                .disposed(by: bag)
            
            Observable.of("🐱", "🐰", "🐶", "🐱", "🐰", "🐶")
                .single { $0 == "🐰" }
                .subscribe { print($0) }
                .disposed(by: bag)
            
            Observable.of("🐱", "🐰", "🐶", "🐸", "🐷", "🐵")
                .single { $0 == "🔵" }
                .subscribe { print($0) }
                .disposed(by: bag)
        }

        
        example("take") {
            let bag = DisposeBag()
            
            Observable.of(1, 2, 2, 3, 1, 4, 2)
                .take(3)
                .subscribe(onNext: { print($0) })
                .disposed(by: bag)
        }
        
        example("takeLast") {
            let bag = DisposeBag()
            
            Observable.of(1, 2, 2, 3, 1, 4, 2)
                .takeLast(3)
                .subscribe(onNext: { print($0) })
                .disposed(by: bag)
        }
        
        example("takeWhile") {
            let bag = DisposeBag()
            
            Observable.of(1, 2, 2, 3, 1, 4, 2)
                .takeWhile { $0 < 3 }
                .subscribe(onNext: { print($0) },
                           onError: { print($0) },
                           onCompleted: { print("completed") })
                .disposed(by: bag)
        }
        
        example("takeUntil") {
            let bag = DisposeBag()
            
            let sourceSequence = PublishSubject<String>()
            let referenceSequence = PublishSubject<String>()
            
            sourceSequence
                .takeUntil(referenceSequence)
                .subscribe(
                    onNext: { print($0) },
                    onError: { print($0) },
                    onCompleted: { print("onCompleted") },
                    onDisposed: { print("disposed") }
                )
                .disposed(by: bag)
            
            sourceSequence.onNext("1")
            sourceSequence.onNext("2")
            sourceSequence.onNext("2")
            
            referenceSequence.onError(TestError.test)
//            referenceSequence.onNext("3")
            
            sourceSequence.onNext("1")
            sourceSequence.onNext("4")
            sourceSequence.onNext("2")
        }
        
        example("skip") {
            let bag = DisposeBag()
            
            Observable.of(1, 2, 2, 3, 1, 4, 2)
                .skip(3)
                .subscribe(onNext: { print($0) })
                .disposed(by: bag)
        }
        
        example("skipWhile") {
            let disposeBag = DisposeBag()
            
            Observable.of(1, 2, 2, 3, 1, 4, 2)
                .skipWhile { $0 < 3 }
                .subscribe(onNext: { print($0) })
                .disposed(by: disposeBag)
        }
        
        example("skipWhileWithIndex") {
            let bag = DisposeBag()
            
            Observable.of(1, 2, 2, 3, 1, 4, 2)
                .skipWhileWithIndex { element, index in
                    index < 3
                }
                .subscribe(onNext: { print($0) })
                .disposed(by: bag)
        }
        
        
        example("skipUntil") {
            let disposeBag = DisposeBag()
            
            let sourceSequence = PublishSubject<String>()
            let referenceSequence = PublishSubject<String>()
            
            sourceSequence
                .skipUntil(referenceSequence)
                .subscribe(onNext: { print($0) })
                .disposed(by: disposeBag)
            
            sourceSequence.onNext("1")
            sourceSequence.onNext("2")
            sourceSequence.onNext("2")
            
            referenceSequence.onNext("3")
            
            sourceSequence.onNext("1")
            sourceSequence.onNext("4")
            sourceSequence.onNext("2")
        }
    }
}
