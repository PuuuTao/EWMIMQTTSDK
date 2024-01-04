//
//  EWMicroInverterMQTTManager.swift
//  EwayBLETools
//
//  Created by developer on 2023/10/19.
//

import Foundation
import CocoaMQTT

//使用MQTT3.1.1

public class EWMicroInverterMQTTManager: NSObject {
    
    //单例
    public static let shared = EWMicroInverterMQTTManager()
    
    //服务器地址
    ///国内服务器
    private let cnHost = "10.168.9.29"
    ///国际服务器
    private let internationalHost = ""
    
    ///MQTT3.1.1服务
    private var mqtt: CocoaMQTT?
    
    //闭包
    ///连接回调（成功，失败，断开）
    var ewMQTTConnectCompletion: EWMQTTConnectCompletion?
    ///断开连接
    var ewMQTTDisconnectCompletion: EWMQTTDisconnectCompletion?
    ///订阅回调
    var ewMQTTSubscribeCompletion: EWMQTTSubscribeCompletion?
    ///全部订阅回调
    var ewMQTTSubscribeAllCompletion: EWMQTTSubscribeAllCompletion?
    ///PUB01 -- 设备信息回调
    var ewMQTTDeviceInfoCompletion: EWMQTTDeviceInfoCompletion?
    ///PUB02 -- 设备数据回调
    var ewMQTTDeviceDataCompletion: EWMQTTDeviceDataCompletion?
    ///PUB03 -- 设备离线回调
    var ewMQTTDeviceOfflineCompletion: EWMQTTDeviceOfflineCompletion?
    ///PUB04 -- 设备OTA升级进度
    var ewMQTTDeviceOTAProgressCompletion: EWMQTTDeviceOTAProgressCompletion?
    ///PUB05 -- OTA升级结果
    var ewMQTTDeviceOTAResultCompletion: EWMQTTDeviceOTAResultCompletion?
    ///PUB06 -- 重置结果
    var ewMQTTDeviceResetResultCompletion: EWMQTTDeviceResetResultCompletion?
    ///PUB07 -- 锁定结果
    var ewMQTTDeviceLockResultCompletion: EWMQTTDeviceFunctionResultCompletion?
    ///PUB07 -- 重启结果
    var ewMQTTDeviceRestartResultCompletion: EWMQTTDeviceFunctionResultCompletion?
    ///PUB08 -- 功率修改结果
    var ewMQTTDevicePowerResultCompletion: EWMQTTDevicePropertyResultCompletion?
    ///PUB08 -- 属性重置
    var ewMQTTDeviceReplaceResultCompletion: EWMQTTDevicePropertyResultCompletion?
    ///OTA数据回调
    var ewMQTTOTADataCompletion: EWMQTTOTADataCompletion?
    ///OTA开始升级回调
    var ewMQTTStartOTAResultCompletion: EWMQTTStartOTAResultCompletion?
    
    ///配置MQTT服务
    /// - Parameters:
    ///   - server: 国际/国内服务器
    ///   - keepAlive: 保活时长
    ///   - userName: 用户名，默认为easy-pv
    ///   - password: 密码
    public func ewMIMQTTInitialize(server: EWMIMQTTServer, keepAlive: UInt16, userName: String = "easy-pv", password: String){
        let clientID = "phone-\(Int(Date().timeIntervalSince1970))" //时间戳
        mqtt = CocoaMQTT(clientID: clientID, host: server == .cn ? cnHost : internationalHost, port: 1883)
        mqtt!.autoReconnect = true
        mqtt!.keepAlive = keepAlive
        mqtt!.username = userName
        mqtt!.password = password
        mqtt!.delegate = self
    }
    
    ///连接
    public func ewMIMQTTConnect(){
        _ = mqtt!.connect()
    }
    
    ///断开连接
    public func ewMIMQTTDisconnect(){
        mqtt!.disconnect()
        mqtt = nil
    }
    
    ///设备订阅手机发布的信息 -- SUB01
    /// - Parameters:
    ///   - productCode: 机型码
    ///   - deviceNum: 设备编号
    public func ewMIMQTTPublishDeviceInfo(productCode: String, deviceNum: String){
        if mqtt != nil {
            mqtt!.publish("/\(productCode)/\(deviceNum)\(EWMIMQTTPublish.SUB01.rawValue)", withString: "", qos: .qos1, retained: false)
        }
    }
    
    ///设备订阅OTA升级 -- SUB02
    /// - Parameters:
    ///   - otaModel: OTA升级信息
    ///   - productCode: 机型码
    ///   - deviceNum: 设备编号
    private func ewMIMQTTPublishOTAInfo(otaModel: MIMQTTOTADataModel, productCode: String, deviceNum: String){
        if mqtt != nil {
            do {
                let encoder = JSONEncoder()
                encoder.outputFormatting = .prettyPrinted
                let jsonData = try encoder.encode(otaModel)
                
                if let jsonString = String(data: jsonData, encoding: .utf8) {
                    print(jsonString)
                    self.mqtt!.publish("/\(productCode)/\(deviceNum)\(EWMIMQTTPublish.SUB02.rawValue)", withString: jsonString.trimmingCharacters(in: CharacterSet.whitespaces), qos: .qos1, retained: false)
                }
            } catch {
                print("Error encoding JSON: \(error)")
            }
        }
    }
    
    ///设备订阅重置 -- SUB03
    /// - Parameters:
    ///   - productCode: 机型码
    ///   - deviceNum: 设备编号
    public func ewMIMQTTPublishReset(productCode: String, deviceNum: String){
        if mqtt != nil {
            let resetModel = MQTTResetModel()
            do {
                let encoder = JSONEncoder()
                encoder.outputFormatting = .prettyPrinted
                let jsonData = try encoder.encode(resetModel)
                
                if let jsonString = String(data: jsonData, encoding: .utf8) {
                    print(jsonString)
                    mqtt!.publish("/\(productCode)/\(deviceNum)\(EWMIMQTTPublish.SUB03.rawValue)", withString: jsonString.trimmingCharacters(in: CharacterSet.whitespaces), qos: .qos1, retained: false)
                }
            } catch {
                print("Error encoding JSON: \(error)")
            }
        }
    }
    
    ///设备订阅功能事件（设备锁定）-- SUB04
    /// - Parameters:
    ///   - lock: 是否锁定
    ///   - productCode: 机型码
    ///   - deviceNum: 设备编号
    public func ewMIMQTTPublishLockFunction(lock: EWMQTTLock, productCode: String, deviceNum: String){
        if mqtt != nil {
            let lockModel = MQTTFunctionLockModel(value: lock.rawValue)
            do {
                let encoder = JSONEncoder()
                encoder.outputFormatting = .prettyPrinted
                let jsonData = try encoder.encode(lockModel)
                
                if let jsonString = String(data: jsonData, encoding: .utf8) {
                    print(jsonString)
                    mqtt!.publish("/\(productCode)/\(deviceNum)\(EWMIMQTTPublish.SUB04.rawValue)", withString: jsonString.trimmingCharacters(in: CharacterSet.whitespaces), qos: .qos1, retained: false)
                }
            } catch {
                print("Error encoding JSON: \(error)")
            }
        }
    }
    
    ///设备订阅功能事件（设备重启）--  SUB04
    /// - Parameters:
    ///   - productCode: 机型码
    ///   - deviceNum: 设备编号
    public func ewMIMQTTPublishRestartFunction(productCode: String, deviceNum: String){
        if mqtt != nil {
            let restartModel = MQTTFunctionRestartModel()
            do {
                let encoder = JSONEncoder()
                encoder.outputFormatting = .prettyPrinted
                let jsonData = try encoder.encode(restartModel)
                
                if let jsonString = String(data: jsonData, encoding: .utf8) {
                    print(jsonString)
                    mqtt!.publish("/\(productCode)/\(deviceNum)\(EWMIMQTTPublish.SUB04.rawValue)", withString: jsonString.trimmingCharacters(in: CharacterSet.whitespaces), qos: .qos1, retained: false)
                }
            } catch {
                print("Error encoding JSON: \(error)")
            }
        }
    }
    
    ///设备订阅属性事件（修改功率）-- SUB05
    /// - Parameters:
    ///   - power: 功率
    ///   - productCode: 机型码
    ///   - deviceNum: 设备编号
    public func ewMIMQTTPublishPower(power: Int, productCode: String, deviceNum: String){
        if mqtt != nil {
            let powerModel = MQTTPropertyPowerModel(value: String(power))
            do {
                let encoder = JSONEncoder()
                encoder.outputFormatting = .prettyPrinted
                let jsonData = try encoder.encode(powerModel)
                
                if let jsonString = String(data: jsonData, encoding: .utf8) {
                    print(jsonString)
                    mqtt!.publish("/\(productCode)/\(deviceNum)\(EWMIMQTTPublish.SUB05.rawValue)", withString: jsonString.trimmingCharacters(in: CharacterSet.whitespaces), qos: .qos1, retained: false)
                }
            } catch {
                print("Error encoding JSON: \(error)")
            }
        }
    }
    
    ///设备订阅属性事件（属性重置）-- SUB05
    /// - Parameters:
    ///   - productCode: 机型码
    ///   - deviceNum: 设备编号
    public func ewMIMQTTPublishReplace(productCode: String, deviceNum: String){
        if mqtt != nil {
            let replaceModel = MQTTPropertyReplaceModel()
            do {
                let encoder = JSONEncoder()
                encoder.outputFormatting = .prettyPrinted
                let jsonData = try encoder.encode(replaceModel)
                
                if let jsonString = String(data: jsonData, encoding: .utf8) {
                    print(jsonString)
                    mqtt!.publish("/\(productCode)/\(deviceNum)\(EWMIMQTTPublish.SUB05.rawValue)", withString: jsonString.trimmingCharacters(in: CharacterSet.whitespaces), qos: .qos1, retained: false)
                }
            } catch {
                print("Error encoding JSON: \(error)")
            }
        }
    }
    
    ///订阅设备发布的信息
    /// - Parameters:
    ///   - num：需要订阅的信息类型（PUB01～PUB08）
    ///   - productCode: 机型码
    ///   - deviceNum: 设备编号
    public func ewMIMQTTSubscribe(num: EWMIMQTTSubscribe, productCode: String, deviceNum: String, completion: EWMQTTSubscribeCompletion?){
        ewMQTTSubscribeCompletion = completion
        if mqtt != nil{
            if productCode == "" || deviceNum == "" {
                completion?(num, false, .emptyIDSN)
            } else {
                mqtt!.subscribe("/\(productCode)/\(deviceNum)\(num.rawValue)", qos: .qos1)
            }
        } else {
            completion?(num, false, .mqttNotInit)
        }
    }
    
    ///订阅设备全部的Topics
    /// - Parameters:
    ///   - productCode: 机型码
    ///   - deviceNum: 设备编号
    public func ewMIMQTTSubscribeAllTopics(productCode: String, deviceNum: String, completion: EWMQTTSubscribeAllCompletion?){
        ewMQTTSubscribeAllCompletion = completion
        if mqtt != nil {
            if productCode == "" || deviceNum == "" {
                completion?([])
            } else {
                mqtt!.subscribe([
                    ("/\(productCode)/\(deviceNum)\(EWMIMQTTSubscribe.PUB01.rawValue)", .qos1),
                    ("/\(productCode)/\(deviceNum)\(EWMIMQTTSubscribe.PUB02.rawValue)", .qos1),
                    ("/\(productCode)/\(deviceNum)\(EWMIMQTTSubscribe.PUB03.rawValue)", .qos1),
                    ("/\(productCode)/\(deviceNum)\(EWMIMQTTSubscribe.PUB04.rawValue)", .qos1),
                    ("/\(productCode)/\(deviceNum)\(EWMIMQTTSubscribe.PUB05.rawValue)", .qos1),
                    ("/\(productCode)/\(deviceNum)\(EWMIMQTTSubscribe.PUB06.rawValue)", .qos1),
                    ("/\(productCode)/\(deviceNum)\(EWMIMQTTSubscribe.PUB07.rawValue)", .qos1),
                    ("/\(productCode)/\(deviceNum)\(EWMIMQTTSubscribe.PUB08.rawValue)", .qos1)
                ])
            }
        } else {
            completion?([])
        }
    }
    
    ///获取OTA相关（需要替换url，para），并添加返回值
    private func ewMIMQTTGetOTAInfo(sn: String, completion: EWMQTTOTADataCompletion?){
        let officalURL = "https://op.easycharging-tech.com/prod-api"
        let testURL = "http://10.168.9.29:1028/stage-api"
        
        ewMQTTOTADataCompletion = completion
        
        let urlString = "\(testURL)/api/inverterDevice/v1/getDeviceOtaList"
        guard var urlComponents = URLComponents(string: urlString) else {
            print("Invalid URL")
            completion?([], .urlError)
            return
        }
        // 创建查询参数
        let queryItems = [URLQueryItem(name: "deviceNum", value: sn)]
        urlComponents.queryItems = queryItems
        
        guard let url = urlComponents.url else {
            print("Invalid URL")
            completion?([], .urlError)
            return
        }
        
        // 创建URL请求
        var request = URLRequest(url: url)
        request.httpMethod = "GET" // 可根据需要更改HTTP方法
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: \(error)")
                return
            }
            
            guard let data = data else {
                print("No data received")
                completion?([], .noDataReceived)
                return
            }
            
            do {
                // 使用JSONDecoder解析数据
                let decoder = JSONDecoder()
                var responseData = try decoder.decode(OTAModel.self, from: data)
                
                //处理https转化http
                if !responseData.data.isEmpty{
                    for i in 0...responseData.data.count-1 {
                        let otaData = responseData.data[i]
                        var newData = otaData
                        let url = otaData.filePath
                        let urlArr = url.components(separatedBy: ":")
                        if urlArr[0] == "https"{
                            newData.filePath = "http:\(urlArr[1])"
                            responseData.data[i] = newData
                        }
                    }
                }
                
                completion?(responseData.data, nil)
                // 处理解析后的数据
                print("获取数据: \(urlString)\n\(responseData)")
                
            } catch {
                completion?([], .jsonDecodingError)
                print("JSON decoding error: \(error)")
            }
        }
        
        // 开始网络请求
        task.resume()
    }
    
}


extension EWMicroInverterMQTTManager: CocoaMQTTDelegate{
    // self signed delegate
    public func mqttUrlSession(_ mqtt: CocoaMQTT, didReceiveTrust trust: SecTrust, didReceiveChallenge challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void){
        
    }

    //连接
    public func mqtt(_ mqtt: CocoaMQTT, didConnectAck ack: CocoaMQTTConnAck) {
        
        switch ack {
        case .accept:
            ewMQTTConnectCompletion?(true, nil)
        case .unacceptableProtocolVersion:
            ewMQTTConnectCompletion?(false, .unacceptableProtocolVersion)
        case .identifierRejected:
            ewMQTTConnectCompletion?(false, .identifierRejected)
        case .serverUnavailable:
            ewMQTTConnectCompletion?(false, .serverUnavailable)
        case .badUsernameOrPassword:
            ewMQTTConnectCompletion?(false, .badUsernameOrPassword)
        case .notAuthorized:
            ewMQTTConnectCompletion?(false, .notAuthorized)
        case .reserved:
            ewMQTTConnectCompletion?(false, .reserved)
        }
        
    }

    //状态改变（3种状态：连接中、已连接、未连接）
    public func mqtt(_ mqtt: CocoaMQTT, didStateChangeTo state: CocoaMQTTConnState) {
        
    }

    //发布信息
    public func mqtt(_ mqtt: CocoaMQTT, didPublishMessage message: CocoaMQTTMessage, id: UInt16) {
        print("mqtt发布：\(message)")
    }

    
    public func mqtt(_ mqtt: CocoaMQTT, didPublishAck id: UInt16) {
        
    }

    //接收信息
    public func mqtt(_ mqtt: CocoaMQTT, didReceiveMessage message: CocoaMQTTMessage, id: UInt16 ) {
        if message.topic.contains(EWMIMQTTSubscribe.PUB01.rawValue) {
            print("当前topic为获取设备信息")
            if message.string != nil{
                parseDevicInfoData(infoJSONStr: message.string!.trimmingCharacters(in: CharacterSet.whitespaces), topic: message.topic)
            }
        } else if message.topic.contains(EWMIMQTTSubscribe.PUB02.rawValue) {
            print("当前topic为获取设备数据")
            if message.string != nil {
                parseDeviceMIData(dataJSONStr: message.string!.trimmingCharacters(in: CharacterSet.whitespaces))
            }
        } else if message.topic.contains(EWMIMQTTSubscribe.PUB03.rawValue) {
            print("当前topic为获取设备离线")
            if message.string == "offline" {
                //设备离线
                ewMQTTDeviceOfflineCompletion?(true)
            }
        } else if message.topic.contains(EWMIMQTTSubscribe.PUB04.rawValue) {
            print("当前topic为获取OTA升级进度")
            if message.string != nil {
                parseDeviceOTAProgressData(progressJSONStr: message.string!.trimmingCharacters(in: CharacterSet.whitespaces))
            }
        } else if message.topic.contains(EWMIMQTTSubscribe.PUB05.rawValue) {
            print("当前topic为获取OTA升级结果")
            if message.string != nil {
                parseDeviceOTAResultData(resultJSONStr: message.string!.trimmingCharacters(in: CharacterSet.whitespaces))
            }
        } else if message.topic.contains(EWMIMQTTSubscribe.PUB06.rawValue) {
            print("当前topic为获取重置结果")
            if message.string != nil {
                parseDeviceResetResultData(resultJSONStr: message.string!.trimmingCharacters(in: CharacterSet.whitespaces))
            }
        } else if message.topic.contains(EWMIMQTTSubscribe.PUB07.rawValue) {
            print("当前topic为获取设备锁定/重启结果")
            if message.string != nil {
                parseDeviceFunctionResultData(resultJSONStr: message.string!.trimmingCharacters(in: CharacterSet.whitespaces))
            }
        } else if message.topic.contains(EWMIMQTTSubscribe.PUB08.rawValue) {
            print("当前topic为获取攻略设置/属性重置结果")
            if message.string != nil {
                parseDevicePropertyResultData(resultJSONStr: message.string!.trimmingCharacters(in: CharacterSet.whitespaces))
            }
        }
        print("mqtt接收：\(message.string), \(message.topic)")
    }

    //订阅
    public func mqtt(_ mqtt: CocoaMQTT, didSubscribeTopics success: NSDictionary, failed: [String]) {
        print("mqtt订阅：\(mqtt),success: \(success.allKeys), failed: \(failed)")
        var successArr: [EWMIMQTTSubscribe] = []
        if failed.isEmpty{
            //订阅成功
            let res = success.allKeys.first as! String
            if res.contains(EWMIMQTTSubscribe.PUB01.rawValue) {
                ewMQTTSubscribeCompletion?(.PUB01, true, nil)
            } else if res.contains(EWMIMQTTSubscribe.PUB02.rawValue) {
                ewMQTTSubscribeCompletion?(.PUB02, true, nil)
            } else if res.contains(EWMIMQTTSubscribe.PUB03.rawValue) {
                ewMQTTSubscribeCompletion?(.PUB03, true, nil)
            } else if res.contains(EWMIMQTTSubscribe.PUB04.rawValue) {
                ewMQTTSubscribeCompletion?(.PUB04, true, nil)
            } else if res.contains(EWMIMQTTSubscribe.PUB05.rawValue) {
                ewMQTTSubscribeCompletion?(.PUB05, true, nil)
            } else if res.contains(EWMIMQTTSubscribe.PUB06.rawValue) {
                ewMQTTSubscribeCompletion?(.PUB06, true, nil)
            } else if res.contains(EWMIMQTTSubscribe.PUB07.rawValue) {
                ewMQTTSubscribeCompletion?(.PUB07, true, nil)
            } else if res.contains(EWMIMQTTSubscribe.PUB08.rawValue) {
                ewMQTTSubscribeCompletion?(.PUB08, true, nil)
            }
            
            let resArr = success.allKeys as! [String]
            for res in resArr {
                if res.contains(EWMIMQTTSubscribe.PUB01.rawValue) {
                    successArr.append(.PUB01)
                } else if res.contains(EWMIMQTTSubscribe.PUB02.rawValue) {
                    successArr.append(.PUB02)
                } else if res.contains(EWMIMQTTSubscribe.PUB03.rawValue) {
                    successArr.append(.PUB03)
                } else if res.contains(EWMIMQTTSubscribe.PUB04.rawValue) {
                    successArr.append(.PUB04)
                } else if res.contains(EWMIMQTTSubscribe.PUB05.rawValue) {
                    successArr.append(.PUB05)
                } else if res.contains(EWMIMQTTSubscribe.PUB06.rawValue) {
                    successArr.append(.PUB06)
                } else if res.contains(EWMIMQTTSubscribe.PUB07.rawValue) {
                    successArr.append(.PUB07)
                } else if res.contains(EWMIMQTTSubscribe.PUB08.rawValue) {
                    successArr.append(.PUB08)
                }
            }
            ewMQTTSubscribeAllCompletion?(successArr)
        } else {
            if failed.first!.contains(EWMIMQTTSubscribe.PUB01.rawValue) {
                ewMQTTSubscribeCompletion?(.PUB01, false, .subscribeFailed)
            }
        }
    }

    //取消订阅
    public func mqtt(_ mqtt: CocoaMQTT, didUnsubscribeTopics topics: [String]) {
        
    }

    public func mqttDidPing(_ mqtt: CocoaMQTT) {
        
    }

    public func mqttDidReceivePong(_ mqtt: CocoaMQTT) {
        
    }

    //断开连接
    public func mqttDidDisconnect(_ mqtt: CocoaMQTT, withError err: Error?) {
        ewMQTTDisconnectCompletion?(false)
    }
}

//MARK: 数据解析
extension EWMicroInverterMQTTManager{
    
    ///PUB01 -- 设备信息数据解析
    private func parseDevicInfoData(infoJSONStr: String, topic: String){

        if let jsonData = infoJSONStr.data(using: .utf8) {
            do {
                let device = try JSONDecoder().decode(MQTTDeviceOldInfoModel.self, from: jsonData)
                let components = topic.components(separatedBy: "/")
                let power = getPowerForProductID(productID: components[1])
                let model = MQTTDeviceInfoModel(
                    netFirmVer: device.netFirmVer,
                    appFirmVer: device.appFirmVer,
                    wifiSsid: device.wifiSsid,
                    isLock: device.isLock,
                    power: power,
                    errCode: device.errCode)
                ewMQTTDeviceInfoCompletion?(model, nil)
            } catch {
                ewMQTTDeviceInfoCompletion?(nil, .parseDataFailed)
            }
        }
    }
    
    private func getPowerForProductID(productID: String) -> Int?{
        // 获取第4和第5位的字符
        if productID.count >= 5 {
            let index4 = productID.index(productID.startIndex, offsetBy: 4)
            let index5 = productID.index(productID.startIndex, offsetBy: 5)
            
            let digit4 = productID[index4]
            let digit5 = productID[index5]
            
            // 将第4和第5位的字符转换成整数
            if let number4 = Int(String(digit4)),
               let number5 = Int(String(digit5)) {
                
                // 计算数据
                let result = number4 * 10 + number5
                print("计算结果：\(result)")
                return result * 100
            } else {
                print("无法转换为整数")
                return nil
            }
        } else {
            print("字符串长度不足")
            return nil
        }
    }
    
    ///PUB02 -- 设备数据解析
    private func parseDeviceMIData(dataJSONStr: String){
        if let jsonData = dataJSONStr.data(using: .utf8) {
            do {
                let dataArr = try JSONDecoder().decode([MQTTDataModel].self, from: jsonData)
                ewMQTTDeviceDataCompletion?(dataArr, nil)
            } catch {
                ewMQTTDeviceDataCompletion?([], .jsonDecodingError)
            }
        }
    }
    
    ///PUB04 -- OTA升级进度数据解析
    private func parseDeviceOTAProgressData(progressJSONStr: String){
        if let jsonData = progressJSONStr.data(using: .utf8) {
            do {
                let progress = try JSONDecoder().decode(MQTTOTAProgressModel.self, from: jsonData)
                ewMQTTDeviceOTAProgressCompletion?(progress, nil)
            } catch {
                ewMQTTDeviceOTAProgressCompletion?(nil, .parseDataFailed)
            }
        }
    }
    
    ///PUB05 -- OTA升级结果数据解析
    private func parseDeviceOTAResultData(resultJSONStr: String){
        if let jsonData = resultJSONStr.data(using: .utf8) {
            do {
                let result = try JSONDecoder().decode(MQTTOTAResultModel.self, from: jsonData)
                ewMQTTDeviceOTAResultCompletion?(result, nil)
            } catch {
                ewMQTTDeviceOTAResultCompletion?(nil, .parseDataFailed)
            }
        }
    }
    
    ///PUB06 -- 重置结果数据解析
    private func parseDeviceResetResultData(resultJSONStr: String){
        if let jsonData = resultJSONStr.data(using: .utf8) {
            do {
                let result = try JSONDecoder().decode(MQTTResetResultModel.self, from: jsonData)
                ewMQTTDeviceResetResultCompletion?(result, nil)
            } catch {
                ewMQTTDeviceResetResultCompletion?(nil, .parseDataFailed)
            }
        }
    }
    
    ///PUB07 -- 设备锁定/重启结果数据解析
    private func parseDeviceFunctionResultData(resultJSONStr: String){
        if let jsonData = resultJSONStr.data(using: .utf8) {
            do {
                let result = try JSONDecoder().decode([MQTTFunctionResultModel].self, from: jsonData)
                if result[0].id == "inverter-lock" {
                    //锁定
                    ewMQTTDeviceLockResultCompletion?(result, nil)
                } else if result[0].id == "vn-restart" {
                    //重启
                    ewMQTTDeviceRestartResultCompletion?(result, nil)
                }
            } catch {
                if resultJSONStr.contains("inverter-lock") {
                    //锁定数据解析失败
                    ewMQTTDeviceLockResultCompletion?([], .parseDataFailed)
                } else if resultJSONStr.contains("vn-restart") {
                    //重启数据解析失败
                    ewMQTTDeviceRestartResultCompletion?([], .parseDataFailed)
                }
            }
        }
    }
    
    ///PUB08 -- 设备修改功率/属性重置结果数据解析
    private func parseDevicePropertyResultData(resultJSONStr: String){
        if let jsonData = resultJSONStr.data(using: .utf8) {
            do {
                let result = try JSONDecoder().decode([MQTTPropertyResultModel].self, from: jsonData)
                if result[0].id == "vn-power" {
                    //功率修改
                    ewMQTTDevicePowerResultCompletion?(result, nil)
                } else if result[0].id == "vn-replace" {
                    //重置
                    ewMQTTDeviceReplaceResultCompletion?(result, nil)
                }
            } catch {
                if resultJSONStr.contains("vn-power") {
                    //功率修改数据解析失败
                    ewMQTTDevicePowerResultCompletion?([], .parseDataFailed)
                } else if resultJSONStr.contains("vn-replace") {
                    //属性重置数据解析失败
                    ewMQTTDeviceReplaceResultCompletion?([], .parseDataFailed)
                }
            }
        }
    }
    
    
}
