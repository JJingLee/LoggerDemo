//
//  JJLoggerComponentProtocol.swift
//  JKOLogger
//
//  Created by chiehchun.lee on 2020/8/17.
//

import Foundation

public protocol JKOLoggerComponentProtocol {
//    var type        : String? { get }
    var module      : String? { get }
    var componentDescription : String? { get }
    var componentHashKey : String? { get }
    var properties : [String:Any]? { get }
}

public protocol JKOLoggerDisplayComponentProtocol : JKOLoggerComponentProtocol {
    var pageName : String? {get}
}
