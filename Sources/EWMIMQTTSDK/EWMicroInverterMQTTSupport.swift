//
//  EWMicroInverterMQTTSupport.swift
//  EwayBLETools
//
//  Created by developer on 2023/10/19.
//

import Foundation

///服务器
public enum EWMIMQTTServer: Int{
    ///国内
    case cn = 1
    ///国际
    case international = 2
}

///订阅
public enum EWMIMQTTPublish: String {
    ///订阅设备信息
    case SUB01 = "/info/get"
    ///订阅设备升级
    case SUB02 = "/ota/get"
    ///订阅设备重置指令
    case SUB03 = "/reset/get"
    ///订阅设备事件指令
    case SUB04 = "/function/get"
    ///订阅设备属性指令
    case SUB05 = "/property/get"
}

///发布
public enum EWMIMQTTSubscribe: String {
    ///发布设备信息
    case PUB01 = "/info/post"
    ///发布数据
    case PUB02 = "/data/post"
    ///遗嘱（直接发offline）
    case PUB03 = "/will/post"
    ///升级进度
    case PUB04 = "/ota/progress"
    ///升级回调
    case PUB05 = "/ota/post"
    ///重置回调
    case PUB06 = "/reset/post"
    ///事件指令回调
    case PUB07 = "/function/post"
    ///属性指令回调
    case PUB08 = "/property/post"
}

///固件版本类型
public enum EWMQTTFirmwareType: Int, Codable {
    ///网络模块
    case net = 1
    ///主控模块
    case main = 2
}

///设备锁定
public enum EWMQTTLock: String{
    ///锁定
    case lock = "0"
    ///未锁定
    case unlock = "1"
}
