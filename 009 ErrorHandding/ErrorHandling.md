### RxSwift ErrorHanding operators

<br>



### catchErrorJustReturn

> 当捕获到异常时返回特定的值，这个是就是参数

```swift
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
```



```swift
---------- catchErrorJustReturn ----------
1
2
3
-1
onCompleted
onDisposed
```



通过上面打印信息我们可以看到，在发生了`error`事件之后，就会返回我们设置好的参数，然后结束掉整个**Observable**

![catchErrorJustReturn](/Users/panguoquan/Desktop/RxSwift/RxSwiftStudy/009 ErrorHandding/catchErrorJustReturn.png)







<br>

### catchError

> 顾名思义，捕获**Error**，不同于`catchErrorJustReturn`，`catchError`可以才`closure`中进行处理，可以用于一些更复杂的情况。

```swift
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
```



```swift
---------- catchError ----------
A
B
C
D
Error: test
1
onDisposed
```



![catchError](/Users/panguoquan/Desktop/RxSwift/RxSwiftStudy/009 ErrorHandding/catchError.png)



<br>

### retry

> 当遇到`onError`事件之后，会从头开始在进行重试，知道成功为止（不发送`onError`事件）

```swift
       example("retry") {
            let bag = DisposeBag()
            
            let sequenceThatErrors = Observable<String>.create { observer in
                observer.onNext("A")
                observer.onNext("B")
                observer.onNext("C")
                observer.onNext("D")
                // 这里如果打开，就会一直发送A B C D
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
```



```swift
//不打开onError
---------- retry ----------
A
B
C
D
1
2
3
onCompleted
onDisposed

//打开onError
---------- retry ----------
A
B
C
D
A
B
C
D
.....

```



![retry](/Users/panguoquan/Desktop/RxSwift/RxSwiftStudy/009 ErrorHandding/retry.png)





<br>

### retry(_:)

> 不同于上面的`retry`，`retry(_:)`要用户传入一个参数，表示重试的次数，需要注意1表示不重试，2表示重试一次，所以次数等于 **= n - 1**



```swift
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
```





```swift
---------- retry maxAttemptCount ----------
A
B
C
D
A
B
C
D
test
onDisposed
```



![retry(_)](/Users/panguoquan/Desktop/RxSwift/RxSwiftStudy/009 ErrorHandding/retry(_).png)