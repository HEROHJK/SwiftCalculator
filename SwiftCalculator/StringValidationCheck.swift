//
//  StringValidationCheck.swift
//  SwiftCalculator
//
//  Created by HEROHJK on 2017. 11. 28..
//  Copyright © 2017년 herohjk. All rights reserved.
//  문자열 유효성 검사
/*
 UI에 들어가는 유효성 검사 리스트.
 
 문자열 확장기능, 문자 존재유무 확인, 콤마 삽입
 
 값 확인(IsValue) -> 문자가 값인지 확인한다.(숫자,콤마,소수점)
 
 값 추출(GetNumberReverse) -> 문자열을 역순으로 검사해 온전한 값을 추출해 낸다.
 
 소수점 유효성검사(PointValidationCheck) -> 값이있고 소수점이 들어갈만한 값인지 검사한다. (연산자나 괄호뒤에 소수점이 들어가선 안되고, 한 값에 소수점이 2개일수 없기 때문)
 
 연산자 유효성 검사(OperatorValidationCheck) -> 연산자가 들어갈만한 위치인지 검사한다. (연산자 앞뒤에 숫자가 와야하며, 여는 괄호 앞에 숫자가 갈수 없다, 음수표시는 예외)
 
 닫는 괄호 유효성 검사(RParenValidationCheck) -> 닫는 괄호가 들어갈만한 위치인지 검사한다. (괄호의 짝이 맞는지 검사하며, 닫는괄호앞에 숫자가 있는지 검사한다.)
 
 마지막 숫자 시작 위치 얻기(GetLastNumberStartIndex) -> 마지막 값의 시작 위치를 얻어온다
 
 콤마 삽입(AddComma) -> 콤마처리가 On이 되어있을때, 마지막숫자에 적절한 위치에 콤마를 삽입해준다.
 
 전체 콤마 삽입(AddCommaAll) -> 수식 전체에 콤마를 삽입해준다.
 */

import Foundation
import Swift

extension String{
    func exist(_ char: Character) -> Bool{
        let arr = Array(self)
        
        for i in arr{
            if i == char {
                return true
            }
        }
        return false
    }
    
    var insertComma: String{
        var arr = Array(self)
        var index: Int = self.count-1
        var count: Int = 0
        
        //소수점이 있는 경우 인덱스를 소수점 다음 수부터 잡아준다
        if self.exist(".") == true{
            //소수점이 아닐동안 Index를 뺀다
            while arr[index] != "."{
                index-=1
            }
            //소수점옆까지 뺀다
            index-=1
        }
        
        //인덱스가 1보다 클동안 반복한다
        while index > 0 {
            count+=1
            
            if(count == 3){
                arr.insert(",", at: index)
                count = 0
            }
            index-=1
        }
        return String(arr)
    }
    
    var insertCommaAll: String{
        var arr = Array(self)
        var startIndex: Int, endIndex: Int
        var count: Int = 0
        
        endIndex = arr.count-1
        
        while endIndex > 0{
            while endIndex > 0 && arr[endIndex] < "0" && arr[endIndex] > "9" { endIndex-=1 }
            startIndex = endIndex
            while startIndex > 0 && (arr[startIndex] == "." || (arr[startIndex] >= "0" && arr[startIndex] <= "9")){
                
                if startIndex > 0 && arr[startIndex] == "." { endIndex = startIndex-1 }
                startIndex-=1
            }
            
            if startIndex == -1 { startIndex = 0 }
            
            count = 0
            
            while endIndex > 0 && startIndex < endIndex{
                count+=1
                
                if endIndex > 0 && count == 3 && arr[endIndex-1] >= "0" && arr[endIndex-1] <= "9"{
                    arr.insert(",", at: endIndex)
                    count = 0
                }
                endIndex-=1
            }
            endIndex-=1
        }
        /*
         1. 전체를 역순으로 반복
         1. 숫자의 시작과 끝의 인덱스를 구함
         2. 숫자의 시작 인덱스까지 반복
         1. 3자리마다 컴마를 찍는다
         */
        return String(arr)
    }
}

extension Double{
    var ToString: String{
        let str = String(format: "%.4f", self)
        var strArr = Array(str)
        
        //소수점을 찾고, 맨뒤가 0인지 아닌지만 검사해서 0이라면 0이 아닐때까지 지워주면 된다.
        if str.exist(".") == true{
            while strArr[strArr.count-1] == "0"{
                strArr.remove(at: strArr.count-1)
            }
            if strArr.count > 1 && strArr[strArr.count-1] == "."{
                strArr.remove(at: strArr.count-1)
            }
            else if strArr.count == 1{
                return ""
            }
        }
        return String(strArr)
    }
}

func IsValue(_ char: Character) -> Bool{
    var ret: Bool
    
    switch char{
    //소수점 콤마 숫자인경우는 참을 반환, 그 외에는 거짓을 반환한다
    case ".", ",":
        fallthrough
    case "0"..."9":
        ret=true
    default:
        ret = false
    }
    
    return ret
}

func GetNumberReverse(_ displayString: String) -> String{
    let stringArray = Array(displayString)
    let length: Int = stringArray.count
    var index: Int = length-1//역순으로 검사하기 때문에 index의 초기값은 마지막 문자인 length-1
    var numberString: String = ""
    var tmpStack: Stack<Character> = Stack<Character>()
    
    //값일때만 해당 문자를 스택에 넣는다
    while index>=0 && IsValue(stringArray[index]) == true{
        tmpStack.Push(stringArray[index])
        index-=1
    }
    
    //사실 유효성검사이기때문에 음수여부는 필요 없지만, 혹시모를 범용성을 위해 추가한다, 나중에 최적화할때 점검해보고 필요없으면 삭제한다.
    if index>2 && stringArray[index] == "-" && (stringArray[index-1] == "-" || stringArray[index-1] == "+" || stringArray[index-1] == "*" || stringArray[index-1] == "/" || stringArray[index-1] == "(" ){
        tmpStack.Push(stringArray[index])
    }
    
    //스택의 문자들을 반환할 문자열에 넣는다
    while tmpStack.IsEmpty == false{
        numberString.append(tmpStack.Pop())
    }
    
    return numberString
}

func PointValidationCheck(_ displayString: String) -> Bool{
    let displayArray = Array(displayString)
    var ret: Bool = false
    
    if displayArray.count < 1 { return false }
    
    //먼저 앞에값이 숫자가 아니면 무조건 FALSE로 반환한다
    if IsValue(displayArray[displayArray.count-1]) == false{
        return false
    }
    
    //끝의 값을 추출해 온다
    let number: String = GetNumberReverse(displayString)
    
    //빈값이 아니라면 이미 존재하기때문에 거짓을 반환
    if number.exist(".") == true{
        ret = false
    }
        //빈값이라면 넣어도 되기에 참을 반환
    else{
        ret = true
    }
    
    return ret
}

func OperatorValidationCheck(_ displayString: String, isMinus: Bool = false) -> Bool{
    let stringArray = Array(displayString)
    let lastIndex = stringArray.count-1
    
    if stringArray.count < 1 { return false }
    
    //끝의 값이 숫자라면 연산자가 들어가도 된다
    if IsValue(stringArray[lastIndex]) && stringArray[lastIndex] != "."{//콤마는 올일이 없다.
        return true
    }
        //닫는 괄호여도 가능하다
    else if stringArray[lastIndex] == ")"{
        return true
    }
        //마이너스 연산자일경우에는, 하나까지는 추가가 가능하다.(=전전 값이 숫자일때만)
    else if isMinus == true && lastIndex>2 && IsValue(stringArray[lastIndex-2]) == true{
        return true
    }
    else{
        //그외에는 무조건 FALSE 반환
        return false
    }
}

func RParenValidationCheck(_ displayString: String) -> Bool{
    var count: Int = 0
    let stringArray = Array(displayString)
    let lastIndex: Int = stringArray.count-1
    
    if stringArray.count < 1 { return false }
    
    //우선 괄호의 짝이 맞는지 체크한다
    if displayString.exist("(") == false{
        //여는 괄호가 없다면 당연히 닫는괄호가 들어와서는 안된다
        return false
    }
    
    //전체 순회
    for i in stringArray{
        if i == "("{
            //여는 괄호라면 카운트를 센다
            count+=1
        }
        else if i == ")"{
            //닫는 괄호라면 카운트를 뺀다
            count-=1
        }
    }
    
    //카운트가 0보다 크지 않다면 닫는괄호가 들어와서는 안되기에, FALSE를 반환한다
    if count<1{
        return false
    }
    
    //짝이 맞다면 유효성을 검사한다. 닫는괄호앞에는 반드시 숫자나 똑같이 닫는 괄호여만 한다.
    if IsValue(stringArray[lastIndex]) == true || stringArray[lastIndex] == ")"{
        return true
    }
        //그 외에는 거짓을 반환
    else{
        return false
    }
    
}

func GetLastNumberStartIndex(_ displayString: String) -> Int{
    let stringArray = Array(displayString)
    var index: Int = stringArray.count-1//역순으로 검사하기 때문에 index의 초기값은 마지막 문자인 length-1
    
    //시작 위치를 찾는다
    while index>0 && IsValue(stringArray[index]) == true{
        index-=1
    }
    
    return index
}

public func AddComma(_ displayString: String) -> String{
    //var replaceString: String = GetNumberRevers(displayString)
    var numberValue: String
    let numberStartIndex: Int
    var newDisplayString = displayString
    
    //마지막 값을 받아온다
    numberValue = GetNumberReverse(displayString)
    //위치를 받아온다
    numberStartIndex = GetLastNumberStartIndex(displayString)
    if numberStartIndex > 0{
        //asdfasdfddadddf
        //마지막 값의 콤마표시를 지운다
        numberValue = numberValue.replacingOccurrences(of: ",", with: "")
        //기존 문자에서 마지막 값을 지운다
        let substrIndex = newDisplayString.index(newDisplayString.startIndex, offsetBy: numberStartIndex)
        newDisplayString = String(newDisplayString[newDisplayString.startIndex...substrIndex])
        //콤마를 추가한 마지막 값을 다시 추가해준다
        newDisplayString.append(numberValue.insertComma)
    }
    else{
        newDisplayString = numberValue.replacingOccurrences(of: ",", with: "").insertComma
    }
    
    return newDisplayString
}
