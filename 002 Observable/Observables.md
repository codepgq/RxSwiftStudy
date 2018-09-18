

## Create Observables



##### 上一节中，我们从一个数组中大概的理解了一下Observable，现在让我们用Rx的形式去把上节的内容在实现一次



假设你还没有安装`RxSwift`到你的项目中，可以参考[官方文档](https://github.com/ReactiveX/RxSwift)，查看如何把`RxSwift`导入到工程中，过程很简单。



当你把上一步做完之后，就可以进入正题了。



1、新建一个**Observable**

```swift
 Observable.of(1,2,3,4,5,6,7,8) 
//or
 Observable.form([1,2,3,4,5,6,7,8])
```



2、然后对数据进行过滤`Filter`

```swift
 Observable.of(1,2,3,4,5,6,7,8)
 	.filter { $0 % 2 == 0 }
```



3、最后让我们把处理之后的结果**订阅**一下

```swift
 Observable.of(1,2,3,4,5,6,7,8)
 	.filter { $0 % 2 == 0 }
 	.subscribe(
 		onNext: { num in 
 			print(num)
 		}
 	)
```



4、最后运行起来，其结果应该如下:

```swift
2
4
6
8
```



然后作为程序员的你，一定注意到了这样子一行提示

`Result of call to 'subscribe(onNext:onError:onCompleted:onDisposed:)' is unused`,

虽然代码正常运行了，其结果也和我们预料的一致，但是这个提示究竟是想表达写什么呢？仅仅是告诉我们返回值没有用么？



—————————————————— 我是一条华丽丽的分割线——————————————————



结果当然不是啦，如果仅仅是因为返回值没有被使用而提示这个警告，大可以用`@discardableResult`修饰啦，如果你有看过官方的Demo的话，就可以看到在官方的示例中:

```swift

    let disposeBag = DisposeBag()
    let neverSequence = Observable<String>.never()
    
    let neverSequenceSubscription = neverSequence
        .subscribe { _ in
            print("This will never be printed")
    }
    
    neverSequenceSubscription.disposed(by: disposeBag)

```

在订阅之后，调用了一个`disposed`方法，并且还传入了一个`DisposeBag()`的对象，这究竟是为何？

这个是因为，RxSwift提供了一个类似RAII的机制，叫做`DisposeBag`，我们可以把所有的订阅对象放在一个`DisposeBag`里，当`DisposeBag`对象被销毁的时候，它里面“装”的所有订阅对象就会自动取消订阅，对应的事件序列的资源也就被自动回收了。

还有一种回收资源的形式直接调用`neverSequenceSubscription.dispose()`方法，但是这个并不是官方推荐的方法。



在了解了整个事件的执行过程之后，我们来看看还有有哪些**Create Observable**



***



#### of ： 用固定数量的元素生成一个Observable

```swift
example(title: "of") {
    let bag = DisposeBag()
    print("of 1")
    Observable.of(1,2,3,4,5,6,7,8)
        .subscribe(
            onNext:{
            print("\t",$0)
        }).disposed(by: bag)
    
    print("of 2")
    Observable.of([1,2,3,4,5,6,7,8], 
    			scheduler: MainScheduler.instance)
        .subscribe(
            onNext:{
                print("\t", $0)
        }).disposed(by: bag)
    
}
```



#### from:  用一个`Sequence`类型的对象创建一个Observable

```swift
example(title: "from") {
    let bag = DisposeBag()
    Observable.from([1,2,3,4,5,6,7,8])
        .subscribe(
            onNext:{
                print("\t",$0)
        }).disposed(by: bag)
}
```



#### never: 不会执行的Observable

```swift
example(title: "never") {
    let bag = DisposeBag()
    
    Observable<String>
        .never()
        .subscribe(
            onNext: { _ in
                 print("永远都不会打印")
            }
        ).disposed(by: bag)
}
```



#### empty: 一个空的Observable，会直接发送`onCompleted`事件

```swift
example("empty") {
    let disposeBag = DisposeBag()
    
    Observable<Int>.empty()
        .subscribe(
            onNext: { print("next \($0)") }
        ).disposed(by: bag)
```

emmm，上面的代码执行之后什么都不会打印，为什么呢？因为在**订阅**方法中，一共有四个事件组成，他们分别是：

`onNext:` 发生Next事件时候调用的方法，会把值传出来

`onError` 发生错误的方法，会把错误回调出来

`onCompleted` 完成时候调用的方法，不带参数

`onDisposed` 资源释放时候调用的方法，不带参数

然后我们把`empty`改成下面这个样子

```swift
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
```

其打印结果如下：

```swift
---------- empty ----------
completed
disposed
```



#### just:  只会发送一次值的Observable

```swift
example("just") {
    let disposeBag = DisposeBag()
    
    Observable.just("🔴")
        .subscribe(
            onNext: { print($0) }
            onError: { print("error \($0)") },
            onCompleted: { print("completed") },
            onDisposed: { print("disposed") })
        ).disposed(by: disposeBag)
}
```

其打印结果如下:

```swift
---------- just ----------
🔴
completed
disposed
```

`just` 是比较特殊的一个存在，因为在发送一次值之后，内部会自行调用`completed`方法

```
override func subscribe<O : ObserverType>(_ observer: O) ->
Disposable where O.E == Element {
    observer.on(.next(_element))
    observer.on(.completed)
    return Disposables.create()
}
代码片段为RxSwift源码
```



####  create： 创建一个Observable，他接收一个泛型参数T表示任意类型

```swift

example(title: "create") {
    let bag = DisposeBag()
    let observable = Observable<String>.create({ (observar) -> Disposable in
        observar.onNext("on next")
        observar.onCompleted()
        return Disposables.create()
    })
    
    observable.subscribe(
        onNext: { print($0) }
    ).disposed(by: bag)
}
```

其打印结果如下：

```swift
---------- create ----------
on next
completed
disposed
```





#### range: 新建Observable在某个范围内, 

`start`起始值

`count`后移个数

```swift
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
```

其结果如下：

```swift
---------- range ----------
1
2
3
4
5
6
7
8
9
10
completed
disposed
```



#### repeatElement ： 重复某个值的Observable

```swift
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
```

这里我们看到了一个新的方法`take`,

- `take`: 取前几次值

这里的`take(3)`是因为`repeatElement`会一直重复发送一个值，这里我们不需要一直监听，所以就取前三次值，

当然你也可以改为你想要取的次数

其打印结果如下：

```swift
---------- repeatElement ----------
🔴
🔴
🔴
completed
disposed
```



#### generate: 根据条件生成的Observable

`initialState`： 初始值

`condition` 条件

`iterate` 修改值的公式/方法

```swift
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
```

其打印结果如下：

```swift
---------- generate ----------
0
1
2
completed
disposed

```





#### deferred: 只有订阅之后才会开始执行操作的Observable

```swift
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
```

其打印结果如下：

```swift
---------- deferred ----------
Creating 1
Emitting...
🐶
🐱
🐵
Creating 2
Emitting...
🐶
🐱
🐵
```



#### error:  一个用于发送error的Observable

```
example("error") {
    enum TestError: Error {
        case test
    }
    
    let bag = DisposeBag()
    
    Observable<Int>.error(TestError.test)
        .subscribe { print($0) }
        .disposed(by: bag)
}
```

其打印结果如下：

```swift
---------- error ----------
error(test)
```



#### do: 用于观察每个事件的经过

```swift
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
```

这个的打印会和我们所想的稍有不同

```swift
---------- doOn ----------
do: 🍎
🍎
do: 🍐
🍐
do: 🍊
🍊
do: 🍋
🍋
do Completed
completed
disposed
do dispose
```

可以看到 `do dispose` 是最后调用的，这个从他们的单词拼写上就能看出点端倪，不过这也无伤大雅，了解一下就可以了。



既然介绍了`do`，那就把`debug`也顺带提及一下，`do`可以监听`on`的事件，那么`debug`就是详细的信息，这个在我们调试的时候，可以给我们不小的帮助



#### debug: 输出一些详细的信息

```swift
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

```

其打印信息如下：
```swift
---------- debug ----------
2018-09-17 22:34:33.492: Create.swift:212 (init()) -> subscribed
2018-09-17 22:34:33.525: Create.swift:212 (init()) -> Event next(🍎)
🍎
2018-09-17 22:34:33.525: Create.swift:212 (init()) -> Event next(🍐)
🍐
2018-09-17 22:34:33.525: Create.swift:212 (init()) -> Event next(🍊)
🍊
2018-09-17 22:34:33.526: Create.swift:212 (init()) -> Event next(🍋)
🍋
2018-09-17 22:34:33.526: Create.swift:212 (init()) -> Event completed
completed
disposed
2018-09-17 22:34:33.526: Create.swift:212 (init()) -> isDisposed
```



至此，**Observable**中的**Create Operators**就了解的差不多了