### Swift 4.2 适配





```swift
AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.record)
```

替换为

```swift
if #available(iOS 10.0, *) {
                try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback, mode: AVAudioSession.Mode.default, options: [.allowAirPlay, .allowBluetooth])
            } else {
                // Fallback on earlier versions
            }
```





```swift
 
public override var hashValue: Int {
        return 1
    }
```

替换为

```swift
public override var hash: Int {
        return 1
    }
```





```swift
UICollectionViewScrollDirection
```

替换为

```swift
UICollectionViewScroll.Direction
```





```swift
UIEdgeInsetsMake(10,10,10,10)
```

替换为

```swift
UIEdgeInsets(top:10, left:10, bottom:10, right:10)
```





```swift
func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool
```



替换为：

```swift
func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool
```





```
override func didMove(toParentViewController parent: UIViewController?) {
   super.didMove(toParentViewController: parent) 
   ...
}
```

替换为

```
override func didMove(toParent parent: UIViewController?) {
   super.didMove(toParent: parent) 
   ...
}
```





```
Runloop.Mode.commonModes
```

替换为

```
Runloop.Mode.common
```





```
UIViewAnimationOptions
```

替换为

```
UIView.AnimationOptions
```





```
UITableViewCellStyle
```



替换为

```
UITableViewCell.CellStyle
```



```
childViewControllers
```

替换为

```
children
```



```
addChildViewController
```

替换为

```
addChild
```



```
removeFromParentViewController
```

替换为

```
removeFromParent
```





```
UIImagePickerControllerSourceType
```

替换为

```
UIImagePickerController.SourceType
```





```
UICollectionViewScrollPosition
```

替换为

```
UICollectionView.ScrollPosition
```





```
UICollectionElementKindSectionHeader
```

替换为

````
UICollectionView.elementKindSectionHeader
````





```
UIImageJPEGRepresentation(,)
```

替换为

```
imaeg.jedpData(compressionQuality:)
```



```
UIImagePickerControllerOriginalImage
UIImagePickerControllerReferenceURL
```

替换为

```
UIImagePickerController.InfoKey.originalImage
UIImagePickerController.InfoKey.referenceURL
```





```
UITableViewAutomaticDimension
```

替换为

```
UITableView.automaticDimension
```





MJRefresh 适配

```objective-c
arrowImage = [[UIImage imageWithContentsOfFile:[[self mj_refreshBundle] pathForResource:@"arrow@2x" ofType:@"png"]] imageWithRenderingMode:AlwaysTemplate];
```

替换为

```objective-c
arrowImage = [[UIImage imageWithContentsOfFile:[[self mj_refreshBundle] pathForResource:@"arrow@2x" ofType:@"png"]] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
```





```objective-c
[[NSRunLoop currentRunLoop] addPort:[NSMachPort port] forMode:NSDefault]
```

替换为

```objective-c
[[NSRunLoop currentRunLoop] addPort:[NSMachPort port] forMode:NSDefaultRunLoopMode]
```

