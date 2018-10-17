### RxSwift filterning and conditional operators

<br>



### toArray

> 把生成包装成为一个数组，一次性发送出来

```swift
example("toArray") {
    let disposeBag = DisposeBag()
    
    Observable.range(start: 1, count: 10)
        .toArray()
        .subscribe { print($0) }
        .disposed(by: disposeBag)
}
```

![toArray](/Users/panguoquan/Desktop/RxSwift/RxSwiftStudy/007 Mathematical and Aggregate Operators/toArray.png)





<br>

### reduce

> 设置一个初始值，让后遍历事件序列中的每一个事件，根据closure计算值，把最终的结果发送出来

```swift
example("reduce") {
    let disposeBag = DisposeBag()
    
    Observable.of(1, 2, 2, 3, 1, 4, 2)
        .reduce(1, accumulator: +)
        .subscribe(onNext: { print($0) })
        .disposed(by: disposeBag)
}
```

![reduce](/Users/panguoquan/Desktop/RxSwift/RxSwiftStudy/007 Mathematical and Aggregate Operators/reduce.png)



<br>

### concat

> 把多个**Observable**串联在一起，只有前面的的**Observable**调用了`completed`事件，后面的Observable发送的事件才会被监听到，如果当前事件发生了`error`或者`dispose`事件，整个**Observable**都会销毁

```swift
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
   
    //subject2.onError(TestError.test)
    //subject1.onNext("🍊")
    
    subject2.onNext("I would be ignored")
    subject2.onNext("b")
    
    subject1.onCompleted()
    //subject1.dispose()
    //subject1.onError(TestError.test)
    
    subject2.onNext("c")
    //subject2.onError(TestError.test)
    subject2.onNext("d")
    
    
    
}
```

![concat](/Users/panguoquan/Desktop/RxSwift/RxSwiftStudy/007 Mathematical and Aggregate Operators/concat.png)





