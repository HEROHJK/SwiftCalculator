//
//  SettingView.swift
//  SwiftCalculator
//
//  Created by 300만원 on 2017. 11. 27..
//  Copyright © 2017년 herohjk. All rights reserved.
//

import Foundation
import UIKit

protocol SettingDelegate{
    func CommaInsertDelegate()
    func CommaRemoveDelegate()
    func PointRemoveDelegate()
}

class SettingView: UIViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //셋팅값을 읽어온다
        if UserDefaults.standard.bool(forKey: "commaSetting") == true{
            //콤마설정이 참이라면 스위치를 켠다
            commaSetting.setOn(true, animated: false)
        }
        else{//아니면 끈다
            commaSetting.setOn(false,animated: false)
        }
        if UserDefaults.standard.bool(forKey: "pointSetting") == true{
            //소수점세팅이 참이라면 스위치를 켠다
            pointSetting.setOn(true, animated: false)
            
        }
        else{//아니면 끈다
            pointSetting.setOn(false, animated: false)
        }
    }
    @IBOutlet weak var commaSetting: UISwitch!
    @IBOutlet weak var pointSetting: UISwitch!
    
    var delegate: SettingDelegate?
    
    @IBAction func CommaSettingAction(_ sender: Any) {
        
        if commaSetting.isOn == true{
            //콤마세팅이 On일때
            //세팅값을 저장한다
            UserDefaults.standard.set(true, forKey: "commaSetting")
            delegate?.CommaInsertDelegate()
        }
        else{
            //콤마세팅이 Off일때
            //세팅값을 저장한다
            UserDefaults.standard.set(false, forKey: "commaSetting")
            delegate?.CommaRemoveDelegate()
        }
    }
    @IBAction func PointSettingAction(_ sender: Any) {
        if pointSetting.isOn == true{
            //소수점세팅이 On일때
            //세팅값을 저장한다
            UserDefaults.standard.set(true, forKey: "pointSetting")
        }
        else{
            //소수점세팅이 Off일때
            //세팅값을 저장한다
            UserDefaults.standard.set(false, forKey: "pointSetting")
            delegate?.PointRemoveDelegate()
        }
    }
}
