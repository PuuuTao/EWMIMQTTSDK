//
//  EWMicroInverterMQTTClosure.swift
//  EwayBLETools
//
//  Created by developer on 2023/10/25.
//

import Foundation

///连接回调（连接成功，连接失败）
public typealias EWMQTTConnectCompletion = (Bool, EWMIMQTTError?) -> Void

///断开连接
public typealias EWMQTTDisconnectCompletion = (Bool) -> Void

///MQTT订阅回调
public typealias EWMQTTSubscribeCompletion = (EWMIMQTTSubscribe, Bool, EWMIMQTTError?) -> Void

///MQTT全部订阅回调
public typealias EWMQTTSubscribeAllCompletion = ([EWMIMQTTSubscribe]) -> Void

///PUB01 -- 设备信息回调
public typealias EWMQTTDeviceInfoCompletion = (MQTTDeviceInfoModel?, EWMIMQTTError?) -> Void

///PUB02 -- 设备数据
public typealias EWMQTTDeviceDataCompletion = ([MQTTDataModel], EWMIMQTTError?) -> Void

///PUB03 -- 设备离线
public typealias EWMQTTDeviceOfflineCompletion = (Bool) -> Void

///PUB04 -- OTA升级进度
public typealias EWMQTTDeviceOTAProgressCompletion = (MQTTOTAProgressModel?, EWMIMQTTError?) -> Void

///PUB05 -- OTA升级结果
public typealias EWMQTTDeviceOTAResultCompletion = (MQTTOTAResultModel?, EWMIMQTTError?) -> Void

///PUB06 -- 重置结果
public typealias EWMQTTDeviceResetResultCompletion = (MQTTResetResultModel?, EWMIMQTTError?) -> Void

///PUB07 -- 锁定/重启结果
public typealias EWMQTTDeviceFunctionResultCompletion = ([MQTTFunctionResultModel], EWMIMQTTError?) -> Void

///PUB08 -- 功率修改/属性重置
public typealias EWMQTTDevicePropertyResultCompletion = ([MQTTPropertyResultModel], EWMIMQTTError?) -> Void

///获取OTA数据回调
public typealias EWMQTTOTADataCompletion = ([OTADataModel], EWMIMQTTError?) -> Void

///OTA开始升级结果回调
public typealias EWMQTTStartOTAResultCompletion = (Bool, EWMIMQTTError?) -> Void
