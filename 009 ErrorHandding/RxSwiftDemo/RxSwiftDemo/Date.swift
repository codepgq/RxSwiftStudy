//
//  Date.swift
//  RxSwiftDemo
//
//  Created by 盘国权 on 2018/9/28.
//  Copyright © 2018年 pgq. All rights reserved.
//

import Foundation

extension Date {
    static var time: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH-mm-ss.sss"
        return formatter.string(from: Date())
    }
}
