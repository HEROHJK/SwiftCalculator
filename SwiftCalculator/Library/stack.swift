//
//  stack.swift
//  SwiftCalculator
//
//  Created by HEROHJK on 2017. 11. 21..
//  Copyright © 2017년 herohjk. All rights reserved.
//

import Swift

public struct Stack<T>{
    private var stack: Array<T> = [T]()
    private var length: Int
    
    
    //선언과 동시에 스택 초기화
    public init (){
        stack.removeAll(keepingCapacity: false)
        length=0
    }
    
    //스택 값 삽입
    @discardableResult public mutating func Push(_ object: T) -> Int{
        //0번째에 값을 삽입한다
        stack.insert(object, at: length)
        //스택의 길이를 늘린다
        length=length+1
        
        return length
    }
    
    
    //스택 값 추출
    public mutating func Pop() -> T{
        
        //처음 값을 불러온다
        let object=stack[length-1]
        //처음 값을 삭제한다
        stack.remove(at: length-1)
        //길이를 줄인다
        length=length-1
        
        
        return object
    }
    
    //스택 초기화
    public mutating func Clear()->Int{
        //스택을 비운다
        stack.removeAll(keepingCapacity: false)
        //길이를 0으로 초기화한다
        length=0
        
        //길이 값 반환
        return length
    }
    
    
    //스택이 비어있는지 확인
    public var IsEmpty: Bool{
        //0보다 많으면 거짓을 반환
        
        if(length>0){
            return false
        }
        
        //아니면 참을 반환
        return true
    }
    
    //스택 Top확인
    public func Top() -> T{
        return stack[length-1]
    }
    
    //스택 길이 확인
    public var GetLength: Int{
        return length
    }
    
}
