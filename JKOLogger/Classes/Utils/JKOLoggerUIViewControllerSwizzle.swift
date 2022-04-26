//
//  JKOLoggerUIViewControllerSwizzle.swift
//  JKOLogger
//
//  Created by chiehchun.lee on 2020/8/18.
//

import Foundation

var JKOLogerDisplayQueue : [String] = [] //pageName

extension UIViewController {
    class func JKOLoggerUIViewControllerSwizzle() {
        swizzleAppear()
        swizzleDisappear()
    }
    class func swizzleAppear() {
        let originalSelector = #selector(UIViewController.viewWillAppear(_:))
        let swizzledSelector = #selector(UIViewController.JKOLoggerSwizzleViewWillAppear(_:))
        let target = UIViewController.self
        SwizzleTool.swizzle(target, originalSelector, swizzledSelector)
    }
    class func swizzleDisappear() {
        let originalSelector = #selector(UIViewController.viewWillDisappear(_:))
        let swizzledSelector = #selector(UIViewController.JKOLoggerSwizzleViewWillDisappear(_:))
        let target = UIViewController.self
        SwizzleTool.swizzle(target, originalSelector, swizzledSelector)
    }

    @objc func JKOLoggerSwizzleViewWillAppear(_ animation:Bool) {
        var pageName: String?
        if let loggerPage = self as? JKOLoggerDisplayComponentProtocol {
            pageName = loggerPage.pageName
        } else {
            pageName = String(describing: Self.self)
        }
        if JKOLogger.default.validateDisplayPageName(pageName) {
            sendDisplayEvent()
            collectApearTime()
        }
        JKOLoggerSwizzleViewWillAppear(animation)
    }
    @objc func JKOLoggerSwizzleViewWillDisappear(_ animation:Bool) {
        var pageName: String?
        if let loggerPage = self as? JKOLoggerDisplayComponentProtocol {
            pageName = loggerPage.pageName
        } else {
            pageName = String(describing: Self.self)
        }
        if JKOLogger.default.validateDisplayPageName(pageName) {
            sendDisapearEvent()
        }
        JKOLoggerSwizzleViewWillDisappear(animation)
    }

    //MARK: - Collect Apear Time
    private func sendDisapearEvent() {
        var loggerStruct: JKOLoggerDisplayStruct
        if let loggerPage = self as? JKOLoggerDisplayComponentProtocol {
            loggerStruct = JKOLoggerDisplayStruct(pageName: loggerPage.pageName,
                                                  module: loggerPage.module,
                                                  componentDescription: loggerPage.componentDescription,
                                                  componentHashKey: loggerPage.componentHashKey,
                                                  properties: loggerPage.properties)
        } else {
            loggerStruct = getDefaultLoggerStruct()
        }

        if let t = calculateDisplayTime() {
            let roundedValue = (t * 100).rounded() / 100
            loggerStruct.properties?["displaytime"] = roundedValue
        }
        JKOLogger.default.disapearEvent(with: loggerStruct)
    }
    
    private func calculateDisplayTime()->Double? {
        let now = Date().timeIntervalSince1970
        var displaytime : Double?
        if let apearTime = getApearTime() {
            displaytime = now - apearTime
        }
        return displaytime
    }
    private func collectApearTime() {
        let now = Date().timeIntervalSince1970
        setApearTime(now)
    }
    static var JKOLOGGER_APEAR_TIME = "JKOLOGGER_APEAR_TIME"
    private func getApearTime()->Double? {
        guard let raw = (objc_getAssociatedObject(self, &UIViewController.JKOLOGGER_APEAR_TIME) as? NSNumber)?.doubleValue else {
            return nil
        }
        return raw
    }
    private func setApearTime(_ apearTime : Double?) {
        var num : NSNumber?
        if let t = apearTime {
            num = NSNumber(value: t)
        }
        objc_setAssociatedObject(self, &UIViewController.JKOLOGGER_APEAR_TIME, num, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }

    //MARK: - Collect Source
    private func sendDisplayEvent() {
        var loggerStruct: JKOLoggerDisplayStruct
        
        if let loggerPage = self as? JKOLoggerDisplayComponentProtocol {
            loggerStruct = JKOLoggerDisplayStruct(pageName: loggerPage.pageName,
                                                  module: loggerPage.module,
                                                  componentDescription: loggerPage.componentDescription,
                                                  componentHashKey: loggerPage.componentHashKey,
                                                  properties: loggerPage.properties)
        } else {
            loggerStruct = getDefaultLoggerStruct()
        }

        var source: String = ""
        collectSourceData()
        if let _source = self.getRecordSource() {
            source = _source
        }
        
        loggerStruct.properties?["source"] = source

        JKOLogger.default.displayEvent(with: loggerStruct)
    }
    
    private func collectSourceData() {
        var pageName: String = ""
        
        if let loggerPage = self as? JKOLoggerDisplayComponentProtocol {
            pageName = loggerPage.pageName ?? ""
        } else {
            pageName = String(describing: Self.self)
        }
        
        //clean front log if retains too much
        if JKOLogerDisplayQueue.count > 100 {
            JKOLogerDisplayQueue = Array<String>(JKOLogerDisplayQueue.dropFirst())
        }
        //record pageName in queue
        JKOLogerDisplayQueue.append(pageName)

        // Not the first page
        if JKOLogerDisplayQueue.count > 1 {
            let sourceName = JKOLogerDisplayQueue[JKOLogerDisplayQueue.count-2]
            self.setRecordSource(sourceName)
        } else {
            // First page
            self.setRecordSource("")
        }
    }

    static var JKOLOGGER_RECORED_SOURCE = "JKOLOGGER_RECORED_SOURCE"
    private func getRecordSource()->String? {
        guard let raw = objc_getAssociatedObject(self, &UIViewController.JKOLOGGER_RECORED_SOURCE) as? String else {
            return nil
        }
        return raw
    }
    private func setRecordSource(_ hasRecordSource : String) {
        objc_setAssociatedObject(self, &UIViewController.JKOLOGGER_RECORED_SOURCE, hasRecordSource, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    
    private func getDefaultLoggerStruct(properties: [String: Any] = [:]) -> JKOLoggerDisplayStruct {
        let pageName = String(describing: Self.self)
        return JKOLoggerDisplayStruct(pageName: pageName, module: pageName, componentDescription: "", componentHashKey: "", properties: properties)
    }

}
