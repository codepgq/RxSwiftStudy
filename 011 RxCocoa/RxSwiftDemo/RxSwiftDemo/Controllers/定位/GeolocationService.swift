//
//  GeolocationService.swift
//  RxSwiftDemo
//
//  Created by 盘国权 on 2018/10/20.
//  Copyright © 2018年 pgq. All rights reserved.
//

import CoreLocation
import RxSwift
import RxCocoa

/*
 如何优雅的请求权限呢？
 */

class GeolocationService {
    static let shared = GeolocationService()
    
    private (set) var authorized: Driver<Bool>
    private (set) var location: Driver<CLLocationCoordinate2D>
    
    private let locationManager = CLLocationManager()
    
    init() {
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        
        /// deferred 在没有订阅者的时候，不会执行，当有多个订阅者，会为每一个订阅者都创建一个Observable
        authorized = Observable.deferred {
            [weak locationManager] in
            
            let status = CLLocationManager.authorizationStatus()
            guard let locationManager = locationManager else {
                return Observable.just(status)
            }
            return locationManager.rx
                .didChangeAuthorizationStatus
                .startWith(status)
        }.asDriver(onErrorJustReturn: CLAuthorizationStatus.notDetermined)
        .map {
            switch $0 {
            case .authorizedAlways,
                 .authorizedWhenInUse:
                return true
            default:
                return false
            }
        }
        
        location = locationManager.rx.didUpdateLocations
            .asDriver(onErrorJustReturn: [])
            .flatMap {
                return $0.last.map(Driver.just) ?? Driver.empty()
            }
            .map { $0.coordinate }
        locationManager.requestWhenInUseAuthorization()
    }
}
