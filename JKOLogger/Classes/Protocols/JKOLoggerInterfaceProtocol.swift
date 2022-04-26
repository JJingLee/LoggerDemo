//
//  JKOLoggerInterfaceProtocol.swift
//  JKOLogger
//
//  Created by chiehchun.lee on 2020/9/23.
//

import Foundation

public protocol JKOLoggerInterfaceProtocol {
    //MARK: - global parameter
    func setUserIdentify(_ userId : String?)
    func setUserProperties(_ properties : [String:Any]?)

    //MARK: - send events
    func clickEvent(with eventStruct : JKOLoggerStruct)
    func viewEvent(with eventStruct : JKOLoggerStruct)
    func displayEvent(with eventStruct:JKOLoggerDisplayStruct)
    func disapearEvent(with eventStruct:JKOLoggerDisplayStruct)
    func scrollEvent(with eventStruct:JKOLoggerDisplayStruct)
    func inputEvent(with eventStruct:JKOLoggerDisplayStruct)
    func devEvent(with eventStruct : JKOLoggerStruct)

    //MARK: - event action
    func sendImediately()
}
