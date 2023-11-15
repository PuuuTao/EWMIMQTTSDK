//
//  EWMicroInverterMQTTError.swift
//  EwayBLETools
//
//  Created by developer on 2023/10/20.
//

import Foundation
public enum EWMIMQTTError: Error, LocalizedError {
    case unacceptableProtocolVersion
    case identifierRejected
    case serverUnavailable
    case badUsernameOrPassword
    case notAuthorized
    case reserved
    case parseDataFailed
    case urlError
    case noDataReceived
    case jsonDecodingError
    case subscribeFailed
    case noUpgradeRequired
    case mqttNotInit
    case emptyIDSN
    case otaDataEncodeError
    
    var localizedDescription: String {
        switch self {
        case .unacceptableProtocolVersion:
            return NSLocalizedString("协议版本不接受", comment: "")
        case .identifierRejected:
            return NSLocalizedString("标识符拒绝", comment: "")
        case .serverUnavailable:
            return NSLocalizedString("服务器不可用", comment: "")
        case .badUsernameOrPassword:
            return NSLocalizedString("用户名或密码错误", comment: "")
        case .notAuthorized:
            return NSLocalizedString("未授权", comment: "")
        case .reserved:
            return NSLocalizedString("保留", comment: "")
        case .parseDataFailed:
            return NSLocalizedString("数据解析失败", comment: "")
        case .urlError:
            return NSLocalizedString("URL错误", comment: "")
        case .noDataReceived:
            return NSLocalizedString("未获取到数据", comment: "")
        case .jsonDecodingError:
            return NSLocalizedString("数据解码错误", comment: "")
        case .subscribeFailed:
            return NSLocalizedString("订阅失败", comment: "")
        case .noUpgradeRequired:
            return NSLocalizedString("当前模块无需升级", comment: "")
        case .mqttNotInit:
            return NSLocalizedString("未初始化MQTT服务", comment: "")
        case .emptyIDSN:
            return NSLocalizedString("机型码和设备编号不能为空", comment: "")
        case .otaDataEncodeError:
            return NSLocalizedString("OTA数据编码错误", comment: "")
        }
    }
}
