import CryptoSwift
import CommonCrypto
import Foundation

print("Hello, world!")

let algorithm = CCHmacAlgorithm(kCCHmacAlgSHA256)
let digestLength = Int(CC_SHA256_DIGEST_LENGTH)

extension String {

    func hmac256(key: String) -> String {
        let str = self.cString(using: .utf8)
        let strLen = Int(self.lengthOfBytes(using: .utf8))
        let digestLen = digestLength
        let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digestLen)
        let keyStr = key.cString(using: .utf8)
        let keyLen = Int(key.lengthOfBytes(using: .utf8))

        CCHmac(algorithm, keyStr!, keyLen, str!, strLen, result)

        let digest = stringFromResult(result: result, length: digestLen)

        defer { result.deallocate() }

        return digest
    }

    private func stringFromResult(result: UnsafeMutablePointer<CUnsignedChar>, length: Int) -> String {
        return Data(bytes: result, count: length)
            .reduce("", { $0 + String(format: "%02x", $1) })
    }

}

let cryptoResult = try HMAC.init(key: "key", variant: .sha256).authenticate("message".bytes).toHexString()
let rubyResult = "6e9ef29b75fffc5b7abae527d58fdadb2fe42e7219011976917343065f58ed4a"


assert("message".hmac256(key: "key") == rubyResult)
assert(cryptoResult == rubyResult)
