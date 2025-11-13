//
//  ViewController.swift
//  AES
//
//  Created by 裸山 on 2025/6/27.
//

import UIKit
import Toast

class ViewController: UIViewController, UITextViewDelegate {
    

    @IBOutlet weak var encrypText: UITextView!
    @IBOutlet weak var encrypLabel: UILabel!
    

    @IBOutlet weak var decrypText: UITextView!
    @IBOutlet weak var decrypLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGestureRecognizer)
        
        let encrypRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(encrypAction))
        encrypLabel.addGestureRecognizer(encrypRecognizer)

        let dencrypRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(decrypAction))
        decrypLabel.addGestureRecognizer(dencrypRecognizer)
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        let string = textView.text ?? ""
        if (textView == self.encrypText) {
            self.encrypLabel.text = AES.encryption(text: string)
        } else if (textView == self.decrypText) {
            self.decrypLabel.text = AES.decryption(text: string)
        }
    }
    
    @objc func encrypAction() {
        let string = self.encrypLabel.text ?? ""
        let pasteboard = UIPasteboard.general
        // 将字符串设置到粘贴板
        pasteboard.string = string
        print("复制加密内容 = %@", string)
        self.view.makeToast("复制加密内容成功")
        self.dismissKeyboard()
        self.decrypText.text = string
        self.decrypLabel.text = AES.decryption(text: string)
    }
    
    
    @IBAction func encrypPasteAction(_ sender: UIButton) {
        let pasteboard = UIPasteboard.general
        let string = pasteboard.string ?? ""
        if (string.count > 0) {
            self.encrypText.text = string;
            self.encrypLabel.text = AES.encryption(text: string);
        } else {
            self.view.makeToast("粘贴板没有内容")
        }
    }
    

    @objc func decrypAction() {
        let pasteboard = UIPasteboard.general
        // 将字符串设置到粘贴板
        pasteboard.string = self.decrypLabel.text
        print("复制解密内容 = %@", self.decrypLabel.text ?? "")
        self.view.makeToast("复制解密内容成功")
        self.dismissKeyboard()
    }
    
    
    @IBAction func decrypClearAction(_ sender: UIButton) {
        let pasteboard = UIPasteboard.general
        let string = pasteboard.string ?? ""
        if (string.count > 0) {
            self.decrypText.text = string;
            self.decrypLabel.text = AES.decryption(text: string);
        } else {
            self.view.makeToast("粘贴板没有内容")
        }
    }
    
    
    @objc func dismissKeyboard() {
        for view in self.view.subviews {
            if let textField = view as? UITextField {
                textField.resignFirstResponder()
            } else if let textView = view as? UITextView {
                textView.resignFirstResponder()
            }
        }
    }
    
}
