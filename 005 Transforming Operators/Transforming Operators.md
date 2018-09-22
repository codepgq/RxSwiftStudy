### RxSwift Transforming Operators

<br>

上一节了解了一下**[Combination Operators](https://www.jianshu.com/p/41fc6804b0e2)**,现在我们进行看看还有哪些常用的**Operators**



### map

**通过一个`transform closure` 把`elements`进行一次形变，返回一个新的事件序列（Observable sequence）**

```swift
example("map") {
    let bag = DisposeBag()
    Observable.of(1, 2, 3)
        .map { $0 * $0 }
        .subscribe(onNext: { print($0) })
        .disposed(by: bag)
}
// 1 4 9
```

![map](/Users/panguoquan/Desktop/RxSwift/RxSwiftStudy/005 Transforming Operators/map.png)





<br>

### flatMap

**会把序列中的每一个事件，变成一个新的Observable，也就是说在flatMap的`transform closure`中要返回一个Observable。**

```swift
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
```

![flatMap](/Users/panguoquan/Desktop/RxSwift/RxSwiftStudy/005 Transforming Operators/flatMap.png)



<br>

### scan

**会需要输入一个初始值，然后在closure中进行修改，用于下一次事件使用**

```swift
example("scan") {
    let bag = DisposeBag()
    
    Observable.of(10, 100, 1000)
        .scan(1) { aggregateValue, newValue in
            aggregateValue + newValue
        }
        .subscribe(onNext: { print($0) })
        .disposed(by: bag)
    
    // 11 111 1111
    
    Observable.of("10", "100", "1000")
        .scan("1") { aggregateValue, newValue in
            aggregateValue + newValue
        }
        .subscribe(onNext: { print($0) })
        .disposed(by: bag)
    // "110" "110100" "1101001000"
}
```



![scan](/Users/panguoquan/Desktop/RxSwift/RxSwiftStudy/005 Transforming Operators/scan.png)



<br>

### buffer

需要我们传入三个参数，分别是:

-  `timeSpan` : 时间间隔
- `count`： 最大缓存数量
- `scheduler`： 在哪里进行调度

**所以`buffer`的意思就是允许我们把事件统一起来处理，其中不管是`timeSpan`还是`count`，只要有一种满足条件了，就会把事件从指定的调度发送出来。**

```swift
example("buffer") {
    let bag = DisposeBag()
    let subject = PublishSubject<String>()
    
    subject.asObserver()
        .buffer(timeSpan: 2, count: 5, scheduler:
MainScheduler.instance)
        .subscribe(onNext: { print($0) })
        .disposed(by: bag)
    
    subject.onNext("1")
    subject.onNext("2")
    subject.onNext("3")
    subject.onNext("4")
    subject.onNext("5")
    
    subject.onNext("6")
    subject.onNext("7")
    
    dispatchMain()
}
// ["1", "2", "3", "4", "5"]
// ["6", "7"]
```

![buffer](/Users/panguoquan/Desktop/RxSwift/RxSwiftStudy/005 Transforming Operators/buffer.png)

`可以看到，只要时间间隔后者达到最大缓存数中的两个条件，满足其中任意一个，都会把事件发送给订阅者`





<br>

### window

**和buffer类似，但是他返回但是一个Observable list**

```swift
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
        }![Window](http://reactivex.io/documentation/operators/images/window.C.png)
```

运行结果如下：

```swift
---------- window ----------
RxSwift.AddRef<Swift.String>
2018-09-22 14:39:58.589: TransformOperators.swift:97 (init()) -> subscribed
2018-09-22 14:39:58.591: TransformOperators.swift:97 (init()) -> Event next(a)
a
2018-09-22 14:39:58.591: TransformOperators.swift:97 (init()) -> Event next(b)
b
2018-09-22 14:39:58.591: TransformOperators.swift:97 (init()) -> Event next(c)
c
2018-09-22 14:39:58.591: TransformOperators.swift:97 (init()) -> Event next(d)
d
2018-09-22 14:39:58.591: TransformOperators.swift:97 (init()) -> Event next(e)
e
RxSwift.AddRef<Swift.String>
2018-09-22 14:39:58.592: TransformOperators.swift:97 (init()) -> Event next(f)
f
2018-09-22 14:39:58.592: TransformOperators.swift:97 (init()) -> Event next(g)
g
2018-09-22 14:39:58.592: TransformOperators.swift:97 (init()) -> Event next(h)
h
2018-09-22 14:39:59.137: TransformOperators.swift:97 (init()) -> Event next(i)
i
RxSwift.AddRef<Swift.String>
RxSwift.AddRef<Swift.String>
2018-09-22 14:40:02.594: TransformOperators.swift:97 (init()) -> Event next(j)
j
2018-09-22 14:40:02.594: TransformOperators.swift:97 (init()) -> Event next(k)
k
2018-09-22 14:40:02.595: TransformOperators.swift:97 (init()) -> Event next(l)
l
```

> 结论：只有满足过时间间隔或者最大缓存数之后才会开启一个新的Observable List。



这个和buffer类似了，偷个懒把官方的图拿过来

![Window](http://reactivex.io/documentation/operators/images/window.C.png)

