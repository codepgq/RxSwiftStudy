## Subject



上一节的中我们知道了**Observable**，**Observable**不具备发送事件的能力，但是在日常项目开发之中呢，发送事件的能力还是很重要的，比如发起一个网络请求这种操作，如果还是使用**Observable**就不是那么舒服的一件事情了，为此[RxSwift](https://github.com/ReactiveX/RxSwift)提供了一种可以发送事件又可以订阅事件值的对象，他就是**Subject**。



### PublishSubject

新建一个`DisposedBag`和一个`PublishSubject`对象

```swift
// 创建一个DisposeBag对象
let bag = DisposeBag()
// 创建一个subject对象，发送的事件值类型为String
let subject = PublishSubject<String>()
```

按照之前的说法，**Subject**有用发送和订阅的能力，既然这样。我们把他们实现。

```swift
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
```

可以看到，我们先是发送了值🐶和🐱，然后我们订阅，在发送了值🅰️和🅱️。

那么真正打印到控制台中的是什么呢？

```swift
---------- PublishSubject ----------
🅰️
🅱️
Disposed
```

结果是值打印了订阅之后发送的值，与似乎就可以得出一个结论**PublishSubject**要先订阅，后发送，否则可能就会造成，获取不到订阅的值。

套用一张官网的图

![PublishSubject](http://reactivex.io/documentation/operators/images/S.PublishSubject.png)

从图中可以看到：**只有先订阅了，才可以收到事件**。



***



### ReplaySubject

新建一个`DisposedBag`和一个`ReplaySubject`对象

```swift
// 创建一个DisposeBag对象
let bag = DisposeBag()
// 创建一个subject对象，发送的事件值类型为String 设置缓冲区为大小 1
let subject = ReplaySubject<String>.create(bufferSize: 1)
```

和之前的`PublishSubject`一样，我们发送一些值并订阅他们

```swift
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
```



这次又会打印什么呢？

```swift
---------- ReplaySubject ----------
订阅者1 -  🐶
订阅者1 -  🐱
订阅者2 -  🐱
订阅者1 -  🅰️
订阅者2 -  🅰️
订阅者1 -  🅱️
订阅者2 -  🅱️
订阅者1 -  Disposed
订阅者2 -  Disposed
```

前两次的值打印和`PublishSubject`是一样的，正常打印值，和`PublishSubject`不一样的是`ReplaySubject`会缓存之前发送过的值，当有新的订阅者订阅之后，会把之前缓存的值先发给新的订阅者，缓存多少的值由他的`init`方法中的`bufferSize`确定，这里我们写了**1**，所以只缓存了上一次的值 🐱 。

![ReplaySubject](http://reactivex.io/documentation/operators/images/S.ReplaySubject.png)

从图中我们可以看到：**基本操作和PublishSubject一样，只是在有新的订阅者之后会把之前缓存的值发送出来，缓冲区大小由自己设置**。





### BehaviorSubject

新建一个`DisposedBag`和一个`BehaviorSubject`对象

```swift
// 新建一个DisposeBag 对象
let bag = DisposeBag()
// 新建一个BehaviorSubject，BehaviorSubject创建时会要求我们输一个初始值
let subject = BehaviorSubject(value: "🔴")
```

国际惯例，发送和监听

```swift
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
```

咋的一看，为什么这次要发送这么多信息和这么多订阅者啊……

打印结果如下：

```swift
---------- BehaviorSubject ----------
订阅者1 -  🔴
订阅者1 -  🐶
订阅者1 -  🐱
订阅者2 -  🐱
订阅者1 -  🅰️
订阅者2 -  🅰️
订阅者1 -  🅱️
订阅者2 -  🅱️
订阅者2 -  test
订阅者1 -  Disposed
订阅者2 -  test
订阅者2 -  Disposed
订阅者3 -  test
订阅者3 -  Disposed
```

通过打印我们可以看到：

- 当订阅者1开始订阅之后，就马上收到了我们创建`BehaviorSubject`的初始值
- 然后就收到了前面两次发送的两个数据🐶和🐱
- 之后我们就又来了一个订阅者，这时候因为我们的`BehaviorSubject`已经发送过两次值了，最后一次发送的是🐱，所以当有了订阅者2之后，就马上收到了值🐱
- 然后在下一个订阅值订阅之前，我们发送了`onError`事件
- 之后就看到，所有subject的订阅者都调用了onError事件之后就释放了

在之后的代码就和之前的类似了，这里就不分析了，再来看看官方的图片

![BehaviorSubject](http://reactivex.io/documentation/operators/images/S.BehaviorSubject.png)

以及发送错误之后

![BehaviorSubject](http://reactivex.io/documentation/operators/images/S.BehaviorSubject.e.png)

从两个图中可以得出结论：**BehaviorSubject会初始化一个默认值，当有新的订阅之后会把上一次的值，发送给新的订阅者，当发生onError事件之后，后面的onNext事件将不会处理，然后就释放资源。**



### Variable

新建一个`DisposedBag`和一个`BehaviorSubject`对象

```swift
//建一个DisposeBag 对象
let bag = DisposeBag()
// 新建一个Variable 对象, Variable 携带一个初始值
let variable = Variable("🔴")
```

还是老套路，订阅和发送

```swift
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
```

其打印结果如下：

```swift
---------- Variable ----------
ℹ️ [DEPRECATED] `Variable` is planned for future deprecation. Please consider `BehaviorRelay` as a replacement. Read more at: https://git.io/vNqvx
订阅者1 -  🔴
订阅者1 -  🐶
订阅者1 -  🐱
订阅者2 -  🐱
订阅者1 -  🅰️
订阅者2 -  🅰️
订阅者1 -  🅱️
订阅者2 -  🅱️
订阅者1 -  Completed
订阅者1 -  Disposed
订阅者2 -  Completed
订阅者2 -  Disposed

```

emmmm，这个和`BehaviorSubject`打印的结果一模一样，那为什么我们还要知道这货呢？

这是因为在项目开发中，我们希望某些值都可以具有响应式，比如通过一个值控制按钮的`enable`，通过一些值显示/隐藏UI，这个正是`Variable`用武之地。

但是稍稍有点遗憾的告诉你，`Variable`会在将来废弃掉，看我们初始化Variable的时候打印的信息，官方目前给出的方案是使用`BehaviorSubject`代替。