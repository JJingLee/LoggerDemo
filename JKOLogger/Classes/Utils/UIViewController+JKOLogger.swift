//
//  UIViewController+JKOLogger.swift
//  JKOLogger
//
//  Created by chiehchun.lee on 2020/11/10.
//

import Foundation

extension UIViewController {
    public func sendPageBackLog() {
        if let _self = self as? JKOLoggerDisplayComponentProtocol{
            _self.sendBackLog()
        }
    }
}
