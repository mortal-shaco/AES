//
//  main.swift
//  AES
//
//  Created by 裸山 on 2026/3/31.
//

import Foundation

var index = 1;

while true {
    if (index > 1) {
        print("\n")
    }
    print("\(index).请输入一些文本：")
    if let string = readLine() {
        let decrypString = AES.decryption(text: string)
        if (decrypString.count > 0) {
            print("\n解密后内容：\n\(decrypString)")
        } else {
            let encrypString = AES.encryption(text: string)
            print("\n加密后内容：\n\(encrypString)")
        }
    } else {
        print("没有输入内容。。。")
    }
    index += 1
}
