# **Combination Operators**



在了解了**Observable**和**Subject**之后，我们来看看与之搭配使用的**Operators**有哪些，如果说之前是在游戏里面创建角色，那么**Operators**就是我们的神器了，一刀99级有木有。



### StartWith

**会在事件队列前插入固定数量的元素**

```swift
		example("startWith") {
            let bag = DisposeBag()
            
            Observable.of("🐶", "🐱", "🐭", "🐹")
                .startWith("1️⃣")
                .startWith("2️⃣")
                .subscribe(onNext: { print($0) })
                .disposed(by: bag)
        }
```

![StartWith](/Users/panguoquan/Desktop/RxSwift/RxSwiftStudy/004 Combination Operators/StartWith.png)





### Merge

**把多个Observable合并成为一个新的Observable,当任意一个被组合的Observable发生新事件都会发事件值发送出来，如果有任意一个Observable发生了`onError`事件，那么整个Observable都不会往下执行了**

```swift
        example("merge") {
            let bag = DisposeBag()
            
            let subject1 = PublishSubject<String>()
            let subject2 = PublishSubject<String>()
            
            Observable.of(subject1, subject2)
                .merge()
                .subscribe(onNext: { print($0) })
                .disposed(by: bag)
            
            subject1.onNext("🅰️")
            
            subject1.onNext("🅱️")
            
            subject2.onNext("①")
            
            subject2.onNext("②")
            
            subject1.onNext("🆎")
            
            subject2.onNext("③")
        }
```

![Merge](/Users/panguoquan/Desktop/RxSwift/RxSwiftStudy/004 Combination Operators/Merge.png)





### Zip

**把多个Observable组合成为一个新的Observable，只有当组合中的每一个Observable都发生了OnNext事件，才会发送事件出来，如果组合中有任意Observable发生了`onError`、`onCompleted`、`dispose`事件，Zip之后的Observable也会结束**

**Zip最多支持8个Observable**

```swift
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
```

![Zip](/Users/panguoquan/Desktop/RxSwift/RxSwiftStudy/004 Combination Operators/Zip.png)





### combineLatest

**combineLatest有两个初始化方法一个接收固定数量Observable，一个接收一个数组**。

**两者的区别就是数组的那个只能传同类型的的Observable，接收固定数量的Observable则可以处理不同类型的Observable**

**combineLatest和Zip类似，不同之处是不需要等待组合中的Observable都是最新的事件才会发送事件，而是当有一个Observable有新的事件之后就会进行发送事件，其中任意一个Observable调用了dispose或者completed事件都不会影响到新的Observable。**

```swift
        example("combineLatest") {
            let disposeBag = DisposeBag()
            
            let stringSubject = PublishSubject<String>()
            let intSubject = PublishSubject<Int>()
            
            Observable.combineLatest(stringSubject, intSubject) { stringElement, intElement in
                "\(stringElement) \(intElement)"
                }
                .subscribe(onNext: { print($0) })
                .disposed(by: disposeBag)
            
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
```

![combineLatest](/Users/panguoquan/Desktop/RxSwift/RxSwiftStudy/004 Combination Operators/combineLatest.png)





### switchLatest

**选择最后一个Observable**

```swift
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
```

![SwitchLatest](/Users/panguoquan/Desktop/RxSwift/RxSwiftStudy/004 Combination Operators/SwitchLatest.png)

根据图中可以看出，当切换了**Observable**之后，之前的**Observable**的事件就不会再**new Observable**中发生了，所以上面的代码打印的结果是：

```swift
---------- switchLatest ----------
⚽️
🏈
🏀
🍎
🍐
```



