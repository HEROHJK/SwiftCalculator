//
//  ViewController.swift
//  SwiftCalculator
//
//  Created by HEROHJK on 2017. 11. 21..
//  Copyright © 2017년 herohjk. All rights reserved.
//

import UIKit


class ViewController: UIViewController{
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        displayString.text=""
        
        //버튼 테두리 설정
        ButtonBorderInit()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "testSegue" {
            let viewController : SettingView = segue.destination as! SettingView; viewController.delegate = self
        }
    }
    
    //계산기에 이용되는 모든 버튼들
    @IBOutlet var buttons: [UIButton]!
    
    @IBOutlet weak var displayString: UILabel!
    
    func ButtonBorderInit(){
        /*
        //클로저를 이용해서 테두리를 전부다 수정해준다.
        _ = buttons.map { $0.layer.borderColor = UIColor.black.cgColor }
        _ = buttons.map { $0.layer.borderWidth = 2 }
         */
        
        for button in buttons{
            button.layer.borderColor = UIColor.black.cgColor
            button.layer.borderWidth = 2
            button.layer.cornerRadius = 10
            button.layer.cornerRadius = 0.5 * button.bounds.size.width
        }
    }
    
    @IBAction func Button1Click(_ sender: Any) {
        DisplayAdd("1")
    }
    @IBAction func Button2Click(_ sender: Any) {
        DisplayAdd("2")
    }
    @IBAction func Button3Click(_ sender: Any) {
        DisplayAdd("3")
    }
    @IBAction func Button4Click(_ sender: Any) {
        DisplayAdd("4")
    }
    
    @IBAction func Button5Click(_ sender: Any) {
        DisplayAdd("5")
    }
    @IBAction func Button6Click(_ sender: Any) {
        DisplayAdd("6")
    }
    
    @IBAction func Button7Click(_ sender: Any) {
        DisplayAdd("7")
    }
    @IBAction func Button8Click(_ sender: Any) {
        DisplayAdd("8")
    }
    @IBAction func Button9Click(_ sender: Any) {
        DisplayAdd("9")
    }
    @IBAction func ButtonPlusClick(_ sender: Any) {
        if OperatorValidationCheck(displayString.text!) != false { DisplayAdd("+") }
    }
    @IBAction func ButtonMinusClick(_ sender: Any) {
        if OperatorValidationCheck(displayString.text!,isMinus: true) != false { DisplayAdd("-") }
    }
    @IBAction func ButtonMultipleClick(_ sender: Any) {
        if OperatorValidationCheck(displayString.text!) != false { DisplayAdd("*") }
    }
    @IBAction func ButtonDivideClick(_ sender: Any) {
        if OperatorValidationCheck(displayString.text!) != false { DisplayAdd("/") }
    }
    @IBAction func Button0Click(_ sender: Any) {
        //0은 계속 넣으면 보기 안좋으니 하나만 넣는다.
        if displayString.text != nil{
            let tmpValue = Double(displayString.text!)
            if tmpValue == 0 { return }
        }
        DisplayAdd("0")
    }
    @IBAction func ButtonDotClick(_ sender: Any) {
        if UserDefaults.standard.bool(forKey: "pointSetting") == false{
            return
        }
        
        if PointValidationCheck(displayString.text!) == true { DisplayAdd(".") }
    }
    @IBAction func ButtonLParenClick(_ sender: Any) {
        DisplayAdd("(")
    }
    @IBAction func ButtonRParenClick(_ sender: Any) {
        if RParenValidationCheck(displayString.text!) == true {
            DisplayAdd(")")}
    }
    @IBAction func ButtonCEClick(_ sender: Any) {
        //지우기
        if displayString.text != ""{
            var txtArr = Array(displayString.text!)
            txtArr.remove(at: txtArr.count-1)
            displayString.text=""
            while  txtArr.count > 0{
                displayString.text!.append(txtArr[0])
                txtArr.remove(at: 0)
            }
        }
        //소수점 On설정이 켜져있을때, 길이가 2 이상이고, 마지막문자가 .일경우 같이 지워준다
        if UserDefaults.standard.bool(forKey: "pointSetting"){
            if displayString != nil{
            var txtArr = Array(displayString.text!)
            if txtArr.count >= 2 {
                if txtArr[txtArr.count-1] == "."{
                    txtArr.remove(at: txtArr.count-1)
                    displayString.text = String(txtArr)
                }
            }
            }
        }
        //콤마 On설정이 켜져있을때, 콤마를 전부다 다시 멕여준다
        if UserDefaults.standard.bool(forKey: "commaSetting"){
            if displayString != nil{
                let txt = displayString.text!.replacingOccurrences(of: ",", with: "")
                displayString.text = txt.insertCommaAll
            }
        }

    }
    @IBAction func ButtonClearClick(_ sender: Any) {
        displayString.text=""
    }
    @IBAction func ButtonCalculatorClick(_ sender: Any) {
        //디스플레이의 텍스트를 읽어온다(중위식인 문자열)
        let commaExpression = displayString.text
        let expression = commaExpression?.replacingOccurrences(of: ",", with: "")
        
        //문자열을 계산기용 데이터로 변환한다(중위식인 데이터 배열)
        let deq = StringToCalculatorDataType(expression!)
        
        //데큐 -> 배열로 변환한다
        let deqToArr = deq.DequeueToArray()
        
        //데이터배열을 후위식으로 변환한다(후위식인 데이터 배열)
        let postfix = InfixToPostfix(deqToArr)
        
        //후위식인 데이터 배열을 연산한다
        let answer = StackCalculated(postfix)
        
        //화면을 비운다
        displayString.text=""
        
        //화면의 결과를 출력한다
        if UserDefaults.standard.bool(forKey: "pointSetting") == true{
        displayString.text=AddComma(answer.ToString)
        }
        else{
            displayString.text = String(format:"%.0f", answer)
        }
    }
    
    
    func DisplayAdd(_ char: Character){
        displayString.text?.append(char)
        if UserDefaults.standard.bool(forKey: "commaSetting") == true{
            switch char{
            case "0"..."9" :
                displayString.text = AddComma(displayString.text!)
            default:
                break
            }
        }
    }    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension ViewController: SettingDelegate{
    func CommaInsertDelegate() {
        displayString.text = displayString.text?.insertCommaAll
    }
    
    func CommaRemoveDelegate() {
        displayString.text = displayString.text?.replacingOccurrences(of: ",", with: "")
    }
    
    func PointRemoveDelegate() {
        if displayString.text != ""{
            let displayDoubleValue = Double(displayString.text!)
            displayString.text = String(format: "%.0f", displayDoubleValue!)
        }
    }
}
