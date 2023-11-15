//
//  EWMicroInverterMQTTModel.swift
//  EwayBLETools
//
//  Created by developer on 2023/10/19.
//

import Foundation

///模块信息
public struct MQTTBoardInfoModel: Codable {
    ///模块名称
    let name: String
    ///芯片型号
    let chip: String
    ///硬件版本
    let hdVer: Double
}

///设备信息
public struct MQTTDeviceInfoModel: Codable {
    ///网络模块固件版本
    let netFirmVer: Double
    ///主控模块固件版本
    let appFirmVer: Double
    ///wifi名称
    let wifiSsid: String
    ///wifi是否可用
    let wifiIsNormal: Int
    ///是否锁定（0：是， 1：否）
    let isLock: Int
    ///错误码
    let errCode: Int?
    ///板子信息
    let board: [MQTTBoardInfoModel]
}

///OTA升级
public struct MQTTOTAModel: Codable {
    ///固件版本类型
    let type: EWMQTTFirmwareType.RawValue
    ///版本号
    let ver: Double
    ///固件下载地址
    let url: String
    ///文件md5编码
    let md5: String
}

///重置设备
struct MQTTResetModel: Codable{
    var id = "inverter-reset"
}

///锁定设备
struct MQTTFunctionLockModel: Codable {
    var id = "inverter-lock"
    var value: EWMQTTLock.RawValue
}

///设备重启
struct MQTTFunctionRestartModel: Codable {
    var id = "vn-restart"
    var value = "0"
}

///修改功率
struct MQTTPropertyPowerModel: Codable {
    var id = "vn-power"
    let value: String
}

///属性重置
struct MQTTPropertyReplaceModel: Codable {
    var id = "vn-replace"
    var value = "0"
}

///设备数据
public struct MQTTDataModel: Codable {
    ///序号
    let sort: Int
    ///输入电压(V)，小数点保留一位
    let inputVoltage: Double
    ///输入电流(A)，小数点保留一位
    let InputCurrent: Double
    ///电网电压(V)，小数点保留一位
    let gridVoltage: Double
    ///电网频率(Hz)，小数点保留一位
    let gridFreq: Double
    ///发电功率(W)，小数点保留一位
    let genPower: Double
    ///今日发电量(Wh)
    let genPowerToDay: Int
    ///总发电量(kWh)
    let genPowerTotal: Double
    ///温度(℃)，小数点保留一位
    let temperature: Double
    ///错误码
    let errCode: Int
    ///工作时长（s）
    let duration: Int?
}

///OTA进度
public struct MQTTOTAProgressModel: Codable {
    ///固件版本类型
    let type: EWMQTTFirmwareType
    ///版本号
    let ver: Double
    ///升级进度
    let value: Int
}

///OTA结果
public struct MQTTOTAResultModel: Codable {
    ///固件版本类型
    let type: EWMQTTFirmwareType
    ///版本号
    let ver: Double
    ///升级是否成功
    let value: Bool
    ///升级失败备注
    let remark: String
}

///重置结果
public struct MQTTResetResultModel: Codable {
    ///标识符，固定为：inverter-reset
    let id: String
    ///重置是否成功
    let value: Bool
    ///重置失败备注
    let remark: String
}

///功能重置结果
public struct MQTTFunctionResultModel: Codable {
    ///标识符
    let id: String
    ///重置是否成功
    let value: String
    ///重置失败备注
    let remark: String
}

///属性重置结果
public struct MQTTPropertyResultModel: Codable {
    ///标识符
    let id: String
    ///重置是否成功
    let value: String
    ///重置失败备注
    let remark: String
}

///OTA请求返回模型
public struct OTAModel: Codable {
    let code: Int
    let msg: String
    var data: [OTADataModel]
}

///OTA数据
public struct OTADataModel: Codable {
    ///固件ID
    let id: String
    ///固件版本类型(1网络模块 2主控模块 3功率模块 4UI模块)
    let type: Int
    ///固件名称
    let firmwareName: String
    ///固件版本
    let version: Double
    ///文件地址
    var filePath: String
    ///原文件名
    let fileName: String
    ///文件大小
    let fileSize: Int
    ///md5
    let md5: String
    ///更新日志
    let remark: String
}
