### RxSwift filterning and conditional operators

<br>

上一节了解了一下**[Transforming Operators](https://www.jianshu.com/p/eabc12be8a57)**,现在我们进行看看还有哪些常用的**过滤 Operators**



### filter

> 根据条件，过滤掉事件

```swift
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
```

![filter](/Users/panguoquan/Desktop/RxSwift/RxSwiftStudy/006 FilterningAndConditionalOperators/filter.png)





<br>

### distinctUntilChanged

> 当前的事件值不等于上一次的事件值的时候才会发送，可以用来过滤重复请求

```swift
example("distinctUntilChanged") {
    let bag = DisposeBag()
    
    Observable.of(1, 2, 2, 3, 1, 4, 2)
        .distinctUntilChanged()
        .subscribe(onNext: { print($0) })
        .disposed(by: bag)
}
```

![distinctUntilChanged](/Users/panguoquan/Desktop/RxSwift/RxSwiftStudy/006 FilterningAndConditionalOperators/distinctUntilChanged.png)



<br>

### elementAt

> 取指定下标的事件，下标从0开始

```swift
example("elementAt") {
    let bag = DisposeBag()
    
    Observable.of(1, 2, 2, 3, 1, 4, 2)
        .elementAt(3)
        .subscribe(onNext: { print($0) })
        .disposed(by: bag)
}
```

![elementAt](/Users/panguoquan/Desktop/RxSwift/RxSwiftStudy/006 FilterningAndConditionalOperators/elementAt.png)





<br>

### single 和 single { 条件 }

> 取第一次事件

```swift
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
```

![single](/Users/panguoquan/Desktop/RxSwift/RxSwiftStudy/006 FilterningAndConditionalOperators/single.png)







<br>

### take

> 取前N次的事件，N由用户输入

```swift
example("take") {
    let bag = DisposeBag()
    
    Observable.of(1, 2, 2, 3, 1, 4, 2)
        .take(3)
        .subscribe(onNext: { print($0) })
        .disposed(by: bag)
}
```

![take](/Users/panguoquan/Desktop/RxSwift/RxSwiftStudy/006 FilterningAndConditionalOperators/take.png)



<br>

### takeLast

> 取后N次的事件，N由用户输入

```swift
example("takeLast") {
            let bag = DisposeBag()
            
            Observable.of(1, 2, 2, 3, 1, 4, 2)
                .takeLast(3)
                .subscribe(onNext: { print($0) })
                .disposed(by: bag)
        }
```

![takeLast](/Users/panguoquan/Desktop/RxSwift/RxSwiftStudy/006 FilterningAndConditionalOperators/takeLast.png)



<br>

### takeWhile

> `closure`中编写条件，取满足掉件的值，当遇到不满足的时候，**Observable**会调用`completed`方法结束

```swift
example("takeWhile") {
    let bag = DisposeBag()
    
    Observable.of(1, 2, 2, 3, 1, 4, 2)
        .takeWhile { $0 < 3 }
        .subscribe(onNext: { print($0) },
                   onError: { print($0) },
                   onCompleted: { print("completed") })
        .disposed(by: bag)
}
```

![takeWhile](/Users/panguoquan/Desktop/RxSwift/RxSwiftStudy/006 FilterningAndConditionalOperators/takeWhile.png)



<br>

### takeUntil

> 参数是一个**Observable**，之后参数中的**Observable**发送了`onNext`事件才会监听到自己的`onNext`事件,如果参数中的**Observable**发生了`onError`事件，则会释放资源`disposed`

```swift
example("takeUntil") {
            let bag = DisposeBag()
            
            let sourceSequence = PublishSubject<String>()
            let referenceSequence = PublishSubject<String>()
            
            sourceSequence
                .takeUntil(referenceSequence)
                .subscribe { print($0) }
                .disposed(by: bag)
            
            sourceSequence.onNext("1")
            sourceSequence.onNext("2")
            sourceSequence.onNext("2")
            
            referenceSequence.onNext("3")
            
            sourceSequence.onNext("1")
            sourceSequence.onNext("4")
            sourceSequence.onNext("2")
        }
```

![takeUntil](/Users/panguoquan/Desktop/RxSwift/RxSwiftStudy/006 FilterningAndConditionalOperators/takeUntil.png)





<br>

### Skip

> 跳过N次事件，N由用户输入

```swift
example("skip") {
    let bag = DisposeBag()
    
    Observable.of(1, 2, 2, 3, 1, 4, 2)
        .skip(3)
        .subscribe(onNext: { print($0) })
        .disposed(by: bag)
}
```

![skip](/Users/panguoquan/Desktop/RxSwift/RxSwiftStudy/006 FilterningAndConditionalOperators/skip.png)

<br>

### skipWhile

> 跳过事件，通过`closure`的返回值(`bool`)决定忽略哪些事件

```swift
example("skipWhile") {
    let disposeBag = DisposeBag()
    
    Observable.of(1, 2, 2, 3, 1, 4, 2)
        .skipWhile { $0 < 3 }
        .subscribe(onNext: { print($0) })
        .disposed(by: disposeBag)
}
```

![skipWhile](/Users/panguoquan/Desktop/RxSwift/RxSwiftStudy/006 FilterningAndConditionalOperators/skipWhile.png)



<br>

### skipWhileWithIndex

> 和`skipWhile`类似，只是在closure中多了`index`，但是此方法被标记为过期

```swift
example("skipWhileWithIndex") {
    let bag = DisposeBag()
    
    Observable.of(1, 2, 2, 3, 1, 4, 2)
        .skipWhileWithIndex { element, index in
            index < 3
        }
        .subscribe(onNext: { print($0) })
        .disposed(by: bag)
}
```

![skipWhileWithIndex](/Users/panguoquan/Desktop/RxSwift/RxSwiftStudy/006 FilterningAndConditionalOperators/skipWhileWithIndex.png)



<br>

### skipUntil

> 和`takeUntil`类似，表示一直忽略，知道参数中的**Observable**发送了`onNext`事件

```swift
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
```

![takeUntil](/Users/panguoquan/Desktop/RxSwift/RxSwiftStudy/006 FilterningAndConditionalOperators/takeUntil.png)



### throttle 

>当发送很多事件时，每隔多少ms取一次事件值



**使用场景：滑动Slider的时候回产生很多值，当我们并不想处理每次的值，只想在值的变化过程中取一些值**

```swift
 progressSlider.rx
            .value.asObservable()
            .throttle(0.4, scheduler: MainScheduler.instance)
            .map(progress)
            .bind(to: progressLabel.rx.text)
            .disposed(by: bag)
```





### debounce 

> 当上一次的值和下一次的值超出时间间隔之后，就把事件的值发送出来



**使用场景：避免用户多次点击按钮导致多次请求等类似情况**

```swift
button.rx
    .tap.asObservable()
    .debounce(0.3, scheduler:MainScheduler.instance)
    .map(btnTapCount)
    .bind(to: btnLabel.rx.text)
    .disposed(by: bag)
```

![filter](/Users/panguoquan/Desktop/博客相关部分/Licecap/filter.gif)