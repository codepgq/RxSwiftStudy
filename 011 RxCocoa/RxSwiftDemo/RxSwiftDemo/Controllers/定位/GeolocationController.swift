//
//  GeolocationController.swift
//  RxSwiftDemo
//
//  Created by 盘国权 on 2018/10/20.
//  Copyright © 2018年 pgq. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import CoreLocation

/// 为label新增一个binder，用于绑定获取到的坐标值
private extension Reactive where Base: UILabel {
    var coordinates: Binder<CLLocationCoordinate2D> {
        return Binder(base) { label, location in
            label.text = "Lat: \(location.latitude)\nLon: \(location.longitude)"
        }
    }
}

class GeolocationController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(noGeolocationView)
        
        //
        GeolocationService.shared
            .authorized
            .drive(noGeolocationView.rx.isHidden)
            .disposed(by: bag)
        
        GeolocationService.shared
            .location
            .drive(locationLabel.rx.coordinates)
            .disposed(by: bag)
        
        /// 监听按钮点击
        listenBtnPress(openSettingBtn)
        listenBtnPress(openSettingBtn2)
    }
    

    private var bag = DisposeBag()
    
    
    @IBOutlet weak var noGeolocationView: UIView!
    
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var openSettingBtn: UIButton!
    @IBOutlet weak var openSettingBtn2: UIButton!

}

extension GeolocationController {
    private func  listenBtnPress(_ btn: UIButton) {
        btn.rx
            .controlEvent(.touchUpInside)
            .subscribe(onNext: {
                UIApplication.shared.open(URL(string: UIApplicationOpenSettingsURLString)!, options: [:], completionHandler: nil)
            }).disposed(by: bag)
    }
}
