### RxSwift connectable operators

<br>



### interval

> 创建一个定时器，定时触发任务，其中两个参数一个为触发事件间隔，一个为调度器。
>
> 当有一个新的订阅者进来之后，都会新开一个计时器，按照之前指定的时间间隔以及调度器去发送事件

```swift
        example("interval") {
            
            var bag: DisposeBag? = DisposeBag()
            let interval = Observable<Int>.interval(1, scheduler: MainScheduler.instance)
            
            interval
                .subscribe(
                    onNext:{
                        print(Date.time," Subscription: 1, Event: \($0)") }
                ).disposed(by: bag!)
            
            delay(5) {
                interval
                    .subscribe(onNext: { print(Date.time," Subscription: 2, Event: \($0)") })
                    .disposed(by: bag!)
            }
            
            delay(10, closure: {
                bag = nil
            })
        }
```



```swift
2018-09-28 09-04-55.055  Subscription: 1, Event: 0
2018-09-28 09-04-56.056  Subscription: 1, Event: 1
2018-09-28 09-04-57.057  Subscription: 1, Event: 2
2018-09-28 09-04-58.058  Subscription: 1, Event: 3
2018-09-28 09-04-59.059  Subscription: 1, Event: 4
2018-09-28 09-05-00.000  Subscription: 1, Event: 5
2018-09-28 09-05-01.001  Subscription: 2, Event: 0
2018-09-28 09-05-01.001  Subscription: 1, Event: 6
2018-09-28 09-05-02.002  Subscription: 2, Event: 1
2018-09-28 09-05-02.002  Subscription: 1, Event: 7
2018-09-28 09-05-03.003  Subscription: 2, Event: 2
2018-09-28 09-05-03.003  Subscription: 1, Event: 8
2018-09-28 09-05-04.004  Subscription: 2, Event: 3
2018-09-28 09-05-04.004  Subscription: 1, Event: 9
```



通过上面打印信息我们可以看到，在延时**5s**之后订阅的`Subscription: 2`的计数并没有和`Subscription: 1`一致，而是又从**0**开始了，如果想共享，则需要用到`puslish`。



![Interval](http://reactivex.io/documentation/operators/images/interval.c.png)





<br>

### publish

> 共享一个Observable的事件序列，避免创建多个Observable sequence。
>
> 需要调用connect之后才会开始发送事件

```swift
        example("publish") {
            
            
            let intSequence = Observable<Int>.interval(1, scheduler: MainScheduler.instance)
                .publish()
            
            _ = intSequence
                .subscribe(onNext: { print(Date.time, " Subscription 1:, Event: \($0)") })
            
            delay(2) { _ = intSequence.connect() }
            
            delay(4) {
                _ = intSequence
                    .subscribe(onNext: { print(Date.time, " Subscription 2:, Event: \($0)") })
            }
            
            delay(6) {
                _ = intSequence
                    .subscribe(onNext: { print(Date.time, " Subscription 3:, Event: \($0)") })
            }
        }
```



```swift
---------- publish ----------
2018-09-28 09-05-44.044  Subscription 1:, Event: 0
2018-09-28 09-05-45.045  Subscription 1:, Event: 1
2018-09-28 09-05-45.045  Subscription 2:, Event: 1
2018-09-28 09-05-46.046  Subscription 1:, Event: 2
2018-09-28 09-05-46.046  Subscription 2:, Event: 2
2018-09-28 09-05-47.047  Subscription 1:, Event: 3
2018-09-28 09-05-47.047  Subscription 2:, Event: 3
2018-09-28 09-05-47.047  Subscription 3:, Event: 3
2018-09-28 09-05-48.048  Subscription 1:, Event: 4
2018-09-28 09-05-48.048  Subscription 2:, Event: 4
2018-09-28 09-05-48.048  Subscription 3:, Event: 4
2018-09-28 09-05-49.049  Subscription 1:, Event: 5
2018-09-28 09-05-49.049  Subscription 2:, Event: 5
2018-09-28 09-05-49.049  Subscription 3:, Event: 5
2018-09-28 09-05-50.050  Subscription 1:, Event: 6
2018-09-28 09-05-50.050  Subscription 2:, Event: 6
2018-09-28 09-05-50.050  Subscription 3:, Event: 6
2018-09-28 09-05-51.051  Subscription 1:, Event: 7
2018-09-28 09-05-51.051  Subscription 2:, Event: 7
2018-09-28 09-05-51.051  Subscription 3:, Event: 7
```

可以看到，现在无论有几个订阅订阅，都不会出现又从`0`开始订阅的尴尬了，但是后面来的订阅者，却无法得到之前已发生的事件，如何获取到之前已发生的事件呢？RxSwift提供一个**Operator**： `replay`



![Publish](http://reactivex.io/documentation/operators/images/publishConnect.c.png)



<br>

### replay

> 首先拥有和`publish`一样的能力，共享 **Observable sequence**， 其次使用`replay`还需要我们传入一个参数（**buffer size**）来缓存已发送的事件，当有新的订阅者订阅了，会把缓存的事件发送给新的订阅者

```swift
        example("replay") {
            
            let intSequence = Observable<Int>.interval(1, scheduler: MainScheduler.instance)
                .replay(5)
            
            _ = intSequence
                .subscribe(onNext: { print(Date.time, " Subscription 1:, Event: \($0)") })
            
            delay(2) { _ = intSequence.connect() }
            
            delay(4) {
                _ = intSequence
                    .subscribe(onNext: { print(Date.time, " Subscription 2:, Event: \($0)") })
            }
            
            delay(8) {
                _ = intSequence
                    .subscribe(onNext: { print(Date.time, " Subscription 3:, Event: \($0)") })
            }
        }
```



```swift
---------- replay ----------
2018-09-28 09-06-28.028  Subscription 1:, Event: 0
2018-09-28 09-06-29.029  Subscription 2:, Event: 0
2018-09-28 09-06-29.029  Subscription 1:, Event: 1
2018-09-28 09-06-29.029  Subscription 2:, Event: 1
2018-09-28 09-06-30.030  Subscription 1:, Event: 2
2018-09-28 09-06-30.030  Subscription 2:, Event: 2
2018-09-28 09-06-31.031  Subscription 1:, Event: 3
2018-09-28 09-06-31.031  Subscription 2:, Event: 3
2018-09-28 09-06-32.032  Subscription 1:, Event: 4
2018-09-28 09-06-32.032  Subscription 2:, Event: 4
2018-09-28 09-06-33.033  Subscription 3:, Event: 0
2018-09-28 09-06-33.033  Subscription 3:, Event: 1
2018-09-28 09-06-33.033  Subscription 3:, Event: 2
2018-09-28 09-06-33.033  Subscription 3:, Event: 3
2018-09-28 09-06-33.033  Subscription 3:, Event: 4
2018-09-28 09-06-33.033  Subscription 1:, Event: 5
2018-09-28 09-06-33.033  Subscription 2:, Event: 5
2018-09-28 09-06-33.033  Subscription 3:, Event: 5
2018-09-28 09-06-34.034  Subscription 1:, Event: 6
2018-09-28 09-06-34.034  Subscription 2:, Event: 6
2018-09-28 09-06-34.034  Subscription 3:, Event: 6
```

可以看到，当时间运行到第八秒的时候，`Subscription 3`开始订阅了，当`Subscription 3`订阅之后，马上就会收到之前缓存的事件。如果想把值广播到其他的Subject，就需要使用`multicast`



![Replay](http://reactivex.io/documentation/operators/images/replay.c.png)





<br>

### multicast

> 和publish功能一样，会共享其Observable sequence，同事需要传入一个参数（SubjectType）



```swift
        example("multicast") {
            
            let subject = PublishSubject<Int>()
            
            print(Date.time)
            _ = subject
                .subscribe(onNext: { print(Date.time, " Subject: \($0)") })
            
            let intSequence = Observable<Int>.interval(1, scheduler: MainScheduler.instance)
                .multicast(subject)
            
            _ = intSequence
                .subscribe(onNext: { print("\t\(Date.time) Subscription 1:, Event: \($0)") })
            
            delay(2) { _ = intSequence.connect() }
            
            delay(4) {
                _ = intSequence
                    .subscribe(onNext: { print("\t\(Date.time) Subscription 2:, Event: \($0)") })
            }
            
            delay(6) {
                _ = intSequence
                    .subscribe(onNext: { print("\t\(Date.time) Subscription 3:, Event: \($0)") })
            }
        }
```





```swift
---------- multicast ----------
2018-09-28 09-16-05.005
2018-09-28 09-16-08.008  Subject: 0
	2018-09-28 09-16-08.008 Subscription 1:, Event: 0
2018-09-28 09-16-09.009  Subject: 1
	2018-09-28 09-16-09.009 Subscription 1:, Event: 1
	2018-09-28 09-16-09.009 Subscription 2:, Event: 1
2018-09-28 09-16-10.010  Subject: 2
	2018-09-28 09-16-10.010 Subscription 1:, Event: 2
	2018-09-28 09-16-10.010 Subscription 2:, Event: 2
2018-09-28 09-16-11.011  Subject: 3
	2018-09-28 09-16-11.011 Subscription 1:, Event: 3
	2018-09-28 09-16-11.011 Subscription 2:, Event: 3
	2018-09-28 09-16-11.011 Subscription 3:, Event: 3
2018-09-28 09-16-12.012  Subject: 4
	2018-09-28 09-16-12.012 Subscription 1:, Event: 4
	2018-09-28 09-16-12.012 Subscription 2:, Event: 4
	2018-09-28 09-16-12.012 Subscription 3:, Event: 4
2018-09-28 09-16-13.013  Subject: 5
	2018-09-28 09-16-13.013 Subscription 1:, Event: 5
	2018-09-28 09-16-13.013 Subscription 2:, Event: 5
	2018-09-28 09-16-13.013 Subscription 3:, Event: 5
```

可以看到，当调用了`connect`之后会把值先发给**subject**，然后在发给**Observable**的订阅者

