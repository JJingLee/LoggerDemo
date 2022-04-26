//
//  JKOLoggerDisplayComponentProtocol+back.swift
//  JKOLogger
//
//  Created by chiehchun.lee on 2020/11/10.
//

import Foundation

extension JKOLoggerDisplayComponentProtocol {
    public func sendBackLog() {
        let logger = JKOLoggerStruct(module: self.pageName, componentDescription: "Back", componentHashKey: "", properties: [:])
        JKOLogger.default.clickEvent(with: logger)
    }
}
