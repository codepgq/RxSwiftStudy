//
//  CLLocationManager+Rx.swift
//  RxSwiftDemo
//
//  Created by 盘国权 on 2018/10/20.
//  Copyright © 2018年 pgq. All rights reserved.
//

import CoreLocation
import RxSwift
import RxCocoa

/*
 如何给CLLocationManager的代理写扩展
 1、让他遵循HasDelegate协议，定义一个大写的Delegate，其类型为原类型的Delegate
 2、新建一个类，必须遵循DelegateProxy<Class, ClassDelegate>,DelegateProxyType,ClassDelegate
 3、重写两个方法
 public init(locationManager: CLLocationManager) {
 super.init(parentObject: locationManager, delegateProxy: RxCLLocationManagerDelegateProxy.self)
 }
 
 public static func registerKnownImplementations() {
 self.register { RxCLLocationManagerDelegateProxy(locationManager: $0) }
 }
 4、给Reactive写扩展，并且约束Base等于该类型
 5、定义个小写的delegate,并初始化他
 public var delegate: DelegateProxy<CLLocationManager, CLLocationManagerDelegate> {
 return RxCLLocationManagerDelegateProxy.proxy(for: base)
 }
 6、编写你想要代替Delegate的方法
 
 */

extension CLLocationManager: HasDelegate {
    public typealias Delegate = CLLocationManagerDelegate
}

public class RxCLLocationManagerDelegateProxy
    : DelegateProxy<CLLocationManager, CLLocationManagerDelegate>,
    DelegateProxyType,
CLLocationManagerDelegate {
    
    public init(locationManager: CLLocationManager) {
        super.init(parentObject: locationManager, delegateProxy: RxCLLocationManagerDelegateProxy.self)
    }
    
    public static func registerKnownImplementations() {
        self.register { RxCLLocationManagerDelegateProxy(locationManager: $0) }
    }
}

extension Reactive where Base: CLLocationManager {
    public var delegate: DelegateProxy<CLLocationManager, CLLocationManagerDelegate> {
        return RxCLLocationManagerDelegateProxy.proxy(for: base)
    }
    
    public var didUpdateLocations: Observable<[CLLocation]> {
        return delegate
            .methodInvoked(#selector(CLLocationManagerDelegate.locationManager(_:didUpdateLocations:)))
            .map {
                $0[1] as! [CLLocation]
            }
    }
    
    public var didChangeAuthorizationStatus: Observable<CLAuthorizationStatus> {
        return delegate
            .methodInvoked(#selector(CLLocationManagerDelegate.locationManager(_:didChangeAuthorization:)))
            .map { a in
                let number = try castOrThrow(NSNumber.self, a[1])
                return CLAuthorizationStatus(rawValue: Int32(number.intValue)) ?? .notDetermined
        }
    }
}

fileprivate func castOrThrow<T>(_ resultType: T.Type, _ object: Any) throws -> T {
    guard let returnValue = object as? T else {
        throw RxCocoaError.castingError(object: object, targetType: resultType)
    }
    
    return returnValue
}

fileprivate func castOptionalOrThrow<T>(_ resultType: T.Type, _ object: Any) throws -> T? {
    if NSNull().isEqual(object) {
        return nil
    }
    
    guard let returnValue = object as? T else {
        throw RxCocoaError.castingError(object: object, targetType: resultType)
    }
    
    return returnValue
}

