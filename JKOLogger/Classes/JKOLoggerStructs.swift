//
//  JKOLoggerStructs.swift
//  JKOLogger
//
//  Created by chiehchun.lee on 2020/8/18.
//

import Foundation

public struct JKOLoggerStruct : JKOLoggerComponentProtocol {
    public var module: String?

    public var componentDescription: String?

    public var componentHashKey: String?

    public var properties: [String : Any]?

    public init(module: String?, componentDescription: String?, componentHashKey: String?, properties: [String : Any]?) {
        self.module = module
        self.componentHashKey = componentHashKey
        self.componentDescription = componentDescription
        self.properties = properties
    }
}

public struct JKOLoggerDisplayStruct : JKOLoggerDisplayComponentProtocol {
    public var pageName: String?

    public var module: String?

    public var componentDescription: String?

    public var componentHashKey: String?

    public var properties: [String : Any]?

    public init(pageName: String?, module: String?, componentDescription: String?, componentHashKey: String?, properties: [String : Any]?) {
        self.pageName = pageName
        self.module = module
        self.componentHashKey = componentHashKey
        self.componentDescription = componentDescription
        self.properties = properties
    }
}
