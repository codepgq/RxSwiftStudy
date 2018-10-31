### RxSwift Debug operators

<br>



### debug

> 调试模式，会输出运行过程的一些详细信息

```swift
example("debug") {
            let bag = DisposeBag()
            var count = 1
            
            let sequenceThatErrors = Observable<String>.create { observer in
                observer.onNext("🍎")
                observer.onNext("🍐")
                observer.onNext("🍊")
                
                if count < 5 {
                    observer.onError(TestError.test)
                    print("Error encountered")
                    count += 1
                }
                
                observer.onNext("🐶")
                observer.onNext("🐱")
                observer.onNext("🐭")
                observer.onCompleted()
                
                return Disposables.create()
            }
            
            sequenceThatErrors
                .retry(3)
                .debug()
                .subscribe(onNext: { print($0) })
                .disposed(by: bag)
        }
```



```swift
---------- debug ----------
2018-10-09 22:02:05.737: Debug.swift:39 (init()) -> subscribed
2018-10-09 22:02:05.788: Debug.swift:39 (init()) -> Event next(🍎)
🍎
2018-10-09 22:02:05.790: Debug.swift:39 (init()) -> Event next(🍐)
🍐
2018-10-09 22:02:05.790: Debug.swift:39 (init()) -> Event next(🍊)
🍊
Error encountered
2018-10-09 22:02:05.798: Debug.swift:39 (init()) -> Event next(🍎)
🍎
2018-10-09 22:02:05.799: Debug.swift:39 (init()) -> Event next(🍐)
🍐
2018-10-09 22:02:05.799: Debug.swift:39 (init()) -> Event next(🍊)
🍊
Error encountered
2018-10-09 22:02:05.799: Debug.swift:39 (init()) -> Event next(🍎)
🍎
2018-10-09 22:02:05.800: Debug.swift:39 (init()) -> Event next(🍐)
🍐
2018-10-09 22:02:05.800: Debug.swift:39 (init()) -> Event next(🍊)
🍊
Error encountered
2018-10-09 22:02:05.812: Debug.swift:39 (init()) -> Event error(test)
Unhandled error happened: test
 subscription called from:

2018-10-09 22:02:05.812: Debug.swift:39 (init()) -> isDisposed
```











<br>

### Resources.total 

> 可以用来查看当前所有的**Observable**，可便于我们查看某些资源是否释放。
>
> 使用其需要做一些特殊操作
>
> **cocoaPods**
>
> ```objective-c
> use_frameworks!
> 
> target 'RxSwiftDemo' do
>     pod 'RxSwift',    '~> 4.0'
>     pod 'RxCocoa',    '~> 4.0'
> end
> 
> post_install do |installer|
>     installer.pods_project.targets.each do |target|
>         if target.name == 'RxSwift'
>             target.build_configurations.each do |config|
>                 if config.name == 'Debug'
>                     config.build_settings['OTHER_SWIFT_FLAGS'] ||= ['-D', 'TRACE_RESOURCES']
>                 end
>             end
>         end
>     end
> end
> 
> ```
>
>
>
> **carthage**
>
> ```objective-c
> carthage build --configuration Debug.
> ```
>
>

```swift
example("RxSwift.Resources.total") {
    print(RxSwift.Resources.total)
    
    let disposeBag = DisposeBag()
    
    print(RxSwift.Resources.total)
    
    let variable = Variable("🍎")
    
    let subscription1 = variable.asObservable().subscribe(onNext: { print($0) })
    
    print(RxSwift.Resources.total)
    
    let subscription2 = variable.asObservable().subscribe(onNext: { print($0) })
    
    print(RxSwift.Resources.total)
    
    subscription1.dispose()
    
    print(RxSwift.Resources.total)
    
    subscription2.dispose()
    
    print(RxSwift.Resources.total)
}
    
print(RxSwift.Resources.total)
```



```swift
---------- RxSwift.Resources.total ----------
1
ℹ️ [DEPRECATED] `Variable` is planned for future deprecation. Please consider `BehaviorRelay` as a replacement. Read more at: https://git.io/vNqvx
🍎
10
🍎
13
11
9
1
```



