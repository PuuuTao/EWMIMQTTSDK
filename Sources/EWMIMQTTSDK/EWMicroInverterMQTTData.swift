//
//  EWMicroInverterMQTTData.swift
//  EwayBLETools
//
//  Created by developer on 2023/10/25.
//

import Foundation

extension EWMicroInverterMQTTManager {
    
    ///连接成功，连接失败
    public func ewMIMQTTConnectStatus(completion: EWMQTTConnectCompletion?){
        ewMQTTConnectCompletion = completion
    }
    
    public func ewMIMQTTDisconnect(completion: EWMQTTDisconnectCompletion?){
        ewMQTTDisconnectCompletion = completion
    }
    
    ///订阅结果
    public func ewMIMQTTSubscribeResult(completion: EWMQTTSubscribeCompletion?){
        ewMQTTSubscribeCompletion = completion
    }
    
    ///PUB01 -- 设备信息
    public func ewMIMQTTDeviceInfo(completion: EWMQTTDeviceInfoCompletion?){
        ewMQTTDeviceInfoCompletion = completion
    }
    
    ///PUB02 -- 设备数据
    public func ewMIMQTTDeviceData(completion: EWMQTTDeviceDataCompletion?){
        ewMQTTDeviceDataCompletion = completion
    }
    
    ///PUB03 -- 设备离线
    public func ewMIMQTTDeviceOffline(completion: EWMQTTDeviceOfflineCompletion?){
        ewMQTTDeviceOfflineCompletion = completion
    }
    
    ///PUB04 -- OTA升级进度
    public func ewMIMQTTOTAProgress(completion: EWMQTTDeviceOTAProgressCompletion?){
        ewMQTTDeviceOTAProgressCompletion = completion
    }
    
    ///PUB05 -- OTA升级结果
    public func ewMIMQTTOTAResult(completion: EWMQTTDeviceOTAResultCompletion?){
        ewMQTTDeviceOTAResultCompletion = completion
    }
    
    ///PUB06 -- 重置结果
    public func ewMIMQTTResetResult(completion: EWMQTTDeviceResetResultCompletion?){
        ewMQTTDeviceResetResultCompletion = completion
    }
    
    ///PUB07 -- 锁定结果
    public func ewMIMQTTLockResult(completion: EWMQTTDeviceFunctionResultCompletion?){
        ewMQTTDeviceLockResultCompletion = completion
    }
    
    ///PUB07 -- 重启结果
    public func ewMIMQTTRestartResult(completion: EWMQTTDeviceFunctionResultCompletion?){
        ewMQTTDeviceRestartResultCompletion = completion
    }
    
    ///PUB08 -- 功率修改结果
    public func ewMIMQTTPowerResult(completion: EWMQTTDevicePropertyResultCompletion?){
        ewMQTTDevicePowerResultCompletion = completion
    }
    
    ///PUB08 -- 属性重置结果
    public func ewMIMQTTReplaceResult(completion: EWMQTTDevicePropertyResultCompletion?){
        ewMQTTDeviceReplaceResultCompletion = completion
    }
    
}

