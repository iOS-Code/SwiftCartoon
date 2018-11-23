//
//  ULoginViewController.swift
//  U17
//
//  Created by 岳琛 on 2018/11/23.
//  Copyright © 2018 None. All rights reserved.
//

import UIKit

class ULoginViewController: UIViewController {
    
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var button: UIButton!
    
    @objc class func getVC() -> UINavigationController {
        let storyboard: UIStoryboard = UIStoryboard.init(name: "ULogin", bundle: nil)
        let vc:UINavigationController = storyboard.instantiateViewController(withIdentifier: "loginNav") as! UINavigationController
        return vc;
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func textFieldVallueChanged(_ sender: UITextField) {
        print(sender.text ?? "")
        let number1 = self.userNameTextField.text!.count
        let number2 = self.passwordTextField.text!.count
        
        if number1>0 && number2>0 {
            self.button.backgroundColor = UIColor(r: 104, g: 168, b: 229)
            self.button.setTitleColor(UIColor.white, for: UIControlState.normal)
        } else {
            self.button.backgroundColor = UIColor(r: 236, g: 236, b: 236)
            self.button.setTitleColor(UIColor(r: 165, g: 165, b: 165), for: UIControlState.normal)
        }
    }
    
    @IBAction func buttonAction(_ sender: UIButton) {
        let number1 = self.userNameTextField.text!.count
        let number2 = self.passwordTextField.text!.count
        
        if number1>0 && number2>0 {
            self.updateLocalData()
            self.dismiss(animated: true) {
                
            }
        }
    }
    
    private func updateLocalData() -> Void {
        // 更新本地缓存
        UserDefaults.standard.set(self.userNameTextField.text, forKey: "name")
        UserDefaults.standard.set(self.passwordTextField.text, forKey: "psd")
        UserDefaults.standard.set(true, forKey: "loginType")
    }
}
