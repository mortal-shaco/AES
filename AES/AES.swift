import Foundation
import CommonCrypto

@objcMembers
public class AES: NSObject {
    static let keyString = "pC7FKeDrhg9lWTJpec9TmQg2GHTK6vxj"
    static let keySize = kCCKeySizeAES256
    static let blockSize = kCCBlockSizeAES128

    /// 解密数据
    @objc public static func decryption(text: String) -> String {
        guard let keyData = keyString.data(using: .utf8) else {
            print("解密keyData错误")
            return ""
        }
        guard var data = Data(base64Encoded: text) else {
            print("解密内容的解析格式错误")
            return ""
        }
        let ivLength = blockSize
        if (data.count < ivLength) {
            print("解密内容的解析格式错误")
            return ""
        }
        let iv = data[0..<ivLength]
        data = data[ivLength..<data.count]

        let decryptedData = aesDecrypt(data: data, key: keyData, iv: iv)!
        
        guard let decryptedString = String(data: decryptedData, encoding: .utf8) else {
            print("解密失败")
            return ""
        }
        
        return decryptedString
    }
    
    private static func aesDecrypt(data: Data, key: Data, iv: Data) -> Data? {
        let keyLength = keySize
        var buffer = [UInt8](repeating: 0, count: data.count + blockSize)
        var numBytesDecrypted: Int = 0
        
        let cryptStatus = data.withUnsafeBytes { (dataPtr) in
            iv.withUnsafeBytes { (ivPtr) in
                key.withUnsafeBytes { (keyPtr) in
                    CCCrypt(CCOperation(kCCDecrypt),
                            CCAlgorithm(kCCAlgorithmAES),
                            CCOptions(kCCOptionPKCS7Padding),
                            keyPtr.baseAddress, keyLength,
                            ivPtr.baseAddress,
                            dataPtr.baseAddress, data.count,
                            &buffer, buffer.count,
                            &numBytesDecrypted)
                }
            }
        }
        
        if UInt32(cryptStatus) == UInt32(kCCSuccess) {
            return Data(bytes: buffer, count: numBytesDecrypted)
        } else {
            return nil
        }
    }

    /// 加密数据
    @objc public static func encryption(text: String) -> String {
        guard let keyData = keyString.data(using: .utf8) else {
            print("加密keyData错误")
            return ""
        }
        guard let data = text.data(using: .utf8) else {
            print("加密内容的的解析格式错误")
            return ""
        }
        let ivLength = blockSize
        let ivString = self.randomString(length: 24)
        guard var iv = ivString.data(using: .utf8) else {
            print("加密向量的解析格式错误")
            return ""
        }
        if (data.count >= ivLength) {
            iv = data[0..<ivLength]
        } else {
            iv = iv[0..<ivLength]
        }
        
        var encryptedData = aesEncrypt(data: data, key: keyData, iv: iv)!
        encryptedData = iv + encryptedData;
        let encryptedString = encryptedData.base64EncodedString()
        return encryptedString
    }

    private static func aesEncrypt(data: Data, key: Data, iv: Data) -> Data? {
        let keyLength = keySize
        var buffer = [UInt8](repeating: 0, count: data.count + blockSize)
        var numBytesEncrypted: Int = 0
        
        let cryptStatus = data.withUnsafeBytes { (dataPtr) in
            iv.withUnsafeBytes { (ivPtr) in
                key.withUnsafeBytes { (keyPtr) in
                    CCCrypt(CCOperation(kCCEncrypt),
                            CCAlgorithm(kCCAlgorithmAES),
                            CCOptions(kCCOptionPKCS7Padding),
                            keyPtr.baseAddress, keyLength,
                            ivPtr.baseAddress,
                            dataPtr.baseAddress, data.count,
                            &buffer, buffer.count,
                            &numBytesEncrypted)
                }
            }
        }
        
        if UInt32(cryptStatus) == UInt32(kCCSuccess) {
            return Data(bytes: buffer, count: numBytesEncrypted)
        } else {
            return nil
        }
    }
    
    private static func randomString(length: Int) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789+-*/="
        var randomString = ""
        for _ in 0..<length {
            let randomIndex = Int(arc4random_uniform(UInt32(letters.count)))
            let randomCharacter = letters[letters.index(letters.startIndex, offsetBy: randomIndex)]
            randomString += String(randomCharacter)
        }
        return randomString
    }

}
