//
//  Calculator.swift
//  SwiftCalculator
//
//  Created by HEROHJK on 2017. 11. 25..
//  Copyright © 2017년 herohjk. All rights reserved.
////

import Swift


//계산기 열거형
enum CalculatorEnumeration{
    //값(숫자)
    case value
    //소수점
    case dot
    //연산자들
    case operatorMultiple
    case operatorDivide
    case operatorPlus
    case operatorMinus
    //왼쪽괄호
    case lParen
    //오른쪽괄호
    case rParen
    //구분자
    case delimiter
    //그외
    case etc
}

//계산기 데이터
struct CalculatorData{
    public var value: String
    public var type: CalculatorEnumeration
    
    public init(_ dataType : CalculatorEnumeration, _ str : String){
        value=str
        type=dataType
    }
}

//타입 체크
func DataTypeCheck(_ char: Character) -> CalculatorEnumeration{
    switch char{
    case "0"..."9" :
        //숫자일 경우
        return CalculatorEnumeration.value
    case "." :
        //소수점일 경우
        return CalculatorEnumeration.dot
    case "+":
        //+일 경우
        return CalculatorEnumeration.operatorPlus
    case "-" :
        //-일 경우
        return CalculatorEnumeration.operatorMinus
    case "*" :
        //*일 경우
        return CalculatorEnumeration.operatorMultiple
    case "/" :
        // /일 경우
        return CalculatorEnumeration.operatorDivide
    case "(" :
        //왼쪽 괄호일 경우
        return CalculatorEnumeration.lParen
    case ")" :
        return CalculatorEnumeration.rParen
    default :
        //그 외의 경우 기본값을 반환
        return CalculatorEnumeration.etc
    }
}

//숫자 유효성 검사. 해당 문자가 숫자인지, 음수표시의 -인지, 소수점인지를 판별한다.
func NumberValidation(_ index: Int, _ string: String) -> Bool{
    //문자열 -> 문자배열로 변환
    let characters = Array(string)
    
    //먼저 숫자인지 판별, 숫자라면 참을 반환한다
    if DataTypeCheck(characters[index]) == CalculatorEnumeration.value{
        return true
    }
    
    //소수점인지 판별, 소수점이고, 앞에 값이 숫자라면 참을 반환한다
    if DataTypeCheck(characters[index]) == CalculatorEnumeration.dot{
        if DataTypeCheck(characters[index-1]) == CalculatorEnumeration.value{
            return true
        }
    }
    
    //음수표시인지 판별
    if DataTypeCheck(characters[index]) == CalculatorEnumeration.operatorMinus{
        //첫번째 자리라면 참을 반환
        if index == 0{
            return true
        }
        //앞의 값이 왼쪽괄호표시라면 참을 반환
        if DataTypeCheck(characters[index-1]) == CalculatorEnumeration.lParen{
            return  true
        }
        //앞의 값이 연산자 표시이고, 그 앞의 값이 숫자라면 참을 반환
        if DataTypeCheck(characters[index-1]) == CalculatorEnumeration.operatorMinus || DataTypeCheck(characters[index-1]) == CalculatorEnumeration.operatorPlus || DataTypeCheck(characters[index-1]) == CalculatorEnumeration.operatorMultiple || DataTypeCheck(characters[index-1]) == CalculatorEnumeration.operatorDivide{
            if DataTypeCheck(characters[index-2]) == CalculatorEnumeration.value{
                return true
            }
        }
    }
    
    //위의 조건들 외에는 무조건 거짓을 반환
    return false
}

//숫자 가져오기
func GetNumber(_ idx: Int, _ string: String) -> (index: Int, value: String){
    
    //인덱스
    var index=idx
    //문자열->문자집합
    let characters = Array(string)
    //추출될 값
    var value: String=""
    
    //해당 문자가 숫자나 소수점일동안 반복한다
    while index<string.count && NumberValidation(index, string){
        value.append(characters[index])
        index=index+1
    }
    
    return (index, value)
}

//전용 데이터타입으로 변환하기
func StringToCalculatorDataType(_ valueString: String) -> Dequeue<CalculatorData>{
    //배열로 변환한다
    var valueArray=Array(valueString)
    var dequeue: Dequeue<CalculatorData> = Dequeue<CalculatorData>()
    let maxIndex=valueString.count
    var index=0
    var type: CalculatorEnumeration = .etc
    
    //문장의 끝까지 반복
    while index<maxIndex{
        //문자의 데이터타입을 체크한다
        type=DataTypeCheck(valueArray[index])
        //타입에 따른 분류
        switch type{
        case .operatorMinus :
            //-표시일 경우 판별 결과에 따라 연산자인지, 숫자인지 판별한다
            if NumberValidation(index, valueString) == true{
                //값일 경우 값을 추출해온 후 데큐에 담는다
                let newTuple = GetNumber(index,valueString)
                let newDataType: CalculatorData = CalculatorData(.value, newTuple.1)
                dequeue.Insert(newDataType)
                //인덱스를 센다
                index=newTuple.0
            }
            else{
                //연산자, 괄호일경우에만 데큐에 담는다
                var tmpString: String = ""
                tmpString.append(valueArray[index])
                let newDataType: CalculatorData = CalculatorData(type, tmpString)
                dequeue.Insert(newDataType)
                //인덱스를 센다
                index=index+1
            }
        case .value :
            //값일 경우 값을 추출해온 후 데큐에 담는다
            let newTuple = GetNumber(index,valueString)
            let newDataType: CalculatorData = CalculatorData(type, newTuple.1)
            dequeue.Insert(newDataType)
            //인덱스를 센다
            index=newTuple.0
            
        case .operatorDivide, .operatorMultiple, .operatorPlus, .lParen, .rParen :
            //연산자, 괄호일경우에만 데큐에 담는다
            var tmpString: String = ""
            tmpString.append(valueArray[index])
            let newDataType: CalculatorData = CalculatorData(type, tmpString)
            dequeue.Insert(newDataType)
            //인덱스를 센다
            index=index+1
            
        default:
            //그 외에는 인덱스만 센다
            index=index+1
            break;
        }
    }
    
    return dequeue
}

func InfixToPostfix(_ array: Array<CalculatorData>) -> Array<CalculatorData>{
    var tmpStack: Stack<CalculatorData> = Stack<CalculatorData>()
    let length = array.count-1
    var postfixDequeue: Dequeue<CalculatorData> = Dequeue<CalculatorData>()
    var type: CalculatorEnumeration = .etc
    
    for index in 0...length{
        //값일때는 그냥 배열에 넣고 다음 반복으로 넘어간다
        if(array[index].type == .value){
            postfixDequeue.Insert(array[index])
            continue
        }
        
        //연산자이거나, 괄호인 경우에는...
        type=array[index].type
        switch type{
        case .lParen :
            //왼쪽 괄호일 경우, 현재 기호를 넣는다
            tmpStack.Push(array[index])
        case .rParen :
            //오른쪽 괄호 일 경우 왼쪽 괄호가 나올때까지의 값을 식에 넣는다
            while tmpStack.Top().type != .lParen{
                postfixDequeue.Insert(tmpStack.Pop())
            }
            // ( 괄호를 지운다
            _ = tmpStack.Pop()
        case .operatorPlus, .operatorMinus :
            //덧셈, 뺄셈일 경우에는 스택이 비거나, 괄호가 나올때까지 값을 식에 넣는다
            while tmpStack.IsEmpty == false && tmpStack.Top().type != .lParen{
                postfixDequeue.Insert(tmpStack.Pop())
            }
            //기호는 스택에 넣는다
            tmpStack.Push(array[index])
        case .operatorMultiple, .operatorDivide :
            //곱셈,나눗셈일 경우에는 스택이 비거나, 현재 값이 곱셈,나눗셈일 동안 스택에 넣는다
            while tmpStack.IsEmpty == false && (tmpStack.Top().type == .operatorMultiple || tmpStack.Top().type == .operatorDivide){
                postfixDequeue.Insert(tmpStack.Pop())
            }
            //기호는 스택에 넣는다
            tmpStack.Push(array[index])
        default:
            //그 외에는 그냥 넘어간다(그외에 들어오는것은 에러)
            break
        }
    }
    
    //스택의 남은 값들을 식에 넣는다
    while tmpStack.IsEmpty == false{
        postfixDequeue.Insert(tmpStack.Pop())
    }
    
    //식을 반환한다
    return postfixDequeue.DequeueToArray()
}

func StackCalculated(_ postfix: Array<CalculatorData>) -> Double{
    var stack: Stack<Double> = Stack<Double>()
    var data: CalculatorData
    
    //전체 반복
    for i in 0...postfix.count-1{
        data = postfix[i]
        if data.type == .value{
            //값일 경우 스택에 넣는다
            stack.Push(Double(data.value)!)
        }
        else{
            //값이 아닐 경우
            var opr1: Double, opr2: Double
            //스택의 두 값을 저장한다
            opr2=stack.Pop()
            opr1=stack.Pop()
            switch data.type{
            //각 경우에 따라 연산한 후 집어넣는다
            case .operatorMultiple :
                stack.Push(Double(opr1*opr2))
            case .operatorDivide :
                stack.Push(Double(opr1/opr2))
            case .operatorPlus :
                stack.Push(Double(opr1+opr2))
            case .operatorMinus :
                stack.Push(Double(opr1-opr2))
            default :
                break
            }
        }
    }
    
    return stack.Pop()
}

/*
 테스트 코드
 //중위식
 let expression = "(-55*-55)+(25+65*7)"
 
 //문자열을 계산기용 데이터로 변환한다(중위식인 데이터 배열)
 let deq = StringToCalculatorDataType(expression!)
 
 //데큐 -> 배열로 변환한다
 let deqToArr = deq.DequeueToArray()
 
 //데이터배열을 후위식으로 변환한다(후위식인 데이터 배열)
 let postfix = InfixToPostfix(deqToArr)
 
 //후위식인 데이터 배열을 연산한다
 let answer = StackCalculated(postfix)
 
 print(answer)
 */
