//
//  NSObject+JKOLogger.swift
//  JKOLogger
//
//  Created by chiehchun.lee on 2020/11/10.
//

import Foundation

extension NSObject {
    public func sendInputEvent(key:String, _ loggerStruct : JKOLoggerDisplayStruct) {
        var hasSentedKeys = getHasSendLog()
        var input_key = "input_\(key)"
        if hasSentedKeys.contains(input_key)==false {
            JKOLogger.default.inputEvent(with: loggerStruct)
            hasSentedKeys.append(input_key)
            setHasSendLog(hasSentedKeys)
        }
    }
    public func sendScrollEvent(key:String, _ loggerStruct : JKOLoggerDisplayStruct) {
        var scrollKey = "scroll_\(key)"
        var hasSentedKeys = getHasSendLog()
        if hasSentedKeys.contains(scrollKey)==false {
            JKOLogger.default.scrollEvent(with: loggerStruct)
            hasSentedKeys.append(scrollKey)
            setHasSendLog(hasSentedKeys)
        }
    }
    public func clearEventLog() {
        setHasSendLog([])
    }
    static var kNSOBJECTLOGGERLOG = "kNSOBJECTLOGGERLOG"
    func setHasSendLog(_ obj : [String]) {
        objc_setAssociatedObject(self, &NSObject.kNSOBJECTLOGGERLOG, obj, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }

    func getHasSendLog()->[String] {
        guard let resultObj = objc_getAssociatedObject(self, &NSObject.kNSOBJECTLOGGERLOG ) as? [String] else {
            return []
        }
        return resultObj
    }
}
