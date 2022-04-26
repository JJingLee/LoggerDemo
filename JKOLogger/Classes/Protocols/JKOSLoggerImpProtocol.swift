//
//  JKOSLoggerImpProtocol.swift
//  FBSnapshotTestCase
//
//  Created by chiehchun.lee on 2020/8/17.
//

import Foundation

@objc public protocol JKOSLoggerImpProtocol {
    func launch(_ launchOptions: [UIApplication.LaunchOptionsKey: Any]?)

    func setUserIdentify(_ userId: String?)

    func setUserProperties(_ properties: [String : Any]?)

    func sendEvent(eventName: String, properties: [String : Any])

    func sendImediately()
}
