import Foundation

let jsonData = """
{
    "resultCode":1,
    "arrays":
        {
            "deviceList":
            [
                {
                    "mobileUUID":"fs11fserfefvfdv89sdfds",
                    "platform":"iOS",
                    "appVersion":"V1.0.0",
                    "model":"iPhone X",
                    "additionalInfo":
                        {
                            "deviceName":"SW4的iphone"
                        }
                } ,
                {
                    "mobileUUID":"hghrfefvfdv89sr44bs",
                    "platform":"iOS",
                    "appVersion":"V1.0.0",
                }
            ]
        }
}
""".data(using: .utf8)!

struct BindingDevice {
    
    var mobileUUID: String
    var platform: String
    var appVersion: String
    var model: String?
    var deviceName: String?
    
    enum CodingKeys: String, CodingKey {
        case mobileUUID
        case platform
        case appVersion
        case model
        case additionalInfo
    }
    
    enum AdditionalInfoKeys: String, CodingKey {
        case deviceName
    }
    
}

extension BindingDevice: Decodable {
    
    init(from decoder: Decoder) throws {
        
        let values = try decoder.container(keyedBy: CodingKeys.self)
        mobileUUID = try values.decode(String.self, forKey: .mobileUUID)
        platform = try values.decode(String.self, forKey: .platform)
        appVersion = try values.decode(String.self, forKey: .appVersion)
        model = try? values.decode(String.self, forKey: .model)
        
        let additionalInfo = try? values.nestedContainer(keyedBy: AdditionalInfoKeys.self, forKey: .additionalInfo)
        
        deviceName = try additionalInfo?.decode(String.self, forKey: .deviceName)
        
    }
    
}


struct MobileDeviceListResult {

    var resultCode: Int
    
    var deviceList: [BindingDevice]
 
    enum CodingKeys: String, CodingKey{
        case resultCode
        case arrays
    }
    
    enum arraysKeys: String, CodingKey {
        case deviceList
    }
    
}

extension MobileDeviceListResult: Decodable {
    
    init(from decoder: Decoder) throws {
        
        let values = try decoder.container(keyedBy: CodingKeys.self)
        resultCode = try values.decode(Int.self, forKey: .resultCode)
        
        let arrayContainer = try values.nestedContainer(keyedBy: arraysKeys.self, forKey: .arrays)
        
        deviceList = try arrayContainer.decode(Array<BindingDevice>.self, forKey: .deviceList)
        
    }
    
}

let decoder = JSONDecoder()

let mobileDeivceListResult = try decoder.decode(MobileDeviceListResult.self, from: jsonData)

print(mobileDeivceListResult.deviceList[0])
print(mobileDeivceListResult.deviceList[1])
