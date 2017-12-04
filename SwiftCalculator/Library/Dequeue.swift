//
//  Dequeue.swift
//  SwiftCalculator
//
//  Created by HEROHJK on 2017. 11. 25..
//  Copyright © 2017년 herohjk. All rights reserved.
//

import Swift

public enum DequeuePosition{
    case first
    case last
}

public struct Dequeue<T>{
    private var dequeue = [T]()     //배열로 이루어져 있다.
    private var length: Int = 0     //길이
    
    //선언과 동시에 데큐 초기화
    public init (){
        dequeue.removeAll(keepingCapacity: false)
        length=0
    }
    
    //값 삽입(값은 항상 맨 뒤로 들어가며, 길이가 반환된다)
    @discardableResult public mutating func Insert(_ object: T) -> Int{
        
        //마지막에 값을 삽입한다
        dequeue.append(object)
        //데큐의 길이를 늘린다
        length=length+1
        
        return dequeue.count
    }
    
    //값 추출(데큐 위치에 따라 다른 값이 반환된다)
    public mutating func Get(_ position: DequeuePosition) -> T{
        //앞부분일경우
        if position == DequeuePosition.first{
            //맨 앞 값을 불러온다
            let object=dequeue[0]
            //처음 값을 삭제한다
            dequeue.remove(at: 0)
            //길이를 줄인다
            length=length-1
            
            return object
        }
            //뒷부분일경우
        else{
            //맨 뒷 값을 불러온다
            let object=dequeue[length-1]
            //맨 뒷 값을 삭제한다
            dequeue.remove(at: length-1)
            //길이를 줄인다
            length=length-1
            
            return object
        }
    }
    
    //데큐 값 확인
    public func View(_ position: DequeuePosition) -> T{
        //앞부분일 경우
        if position == .first{
            return dequeue[0]
        }
        //뒷부분일 경우
        else{
            return dequeue[length-1]
        }
    }
    
    //데큐 초기화
    public mutating func Clear()->Int{
        //데큐를 비운다
        dequeue.removeAll(keepingCapacity: false)
        //길이를 0으로 초기화한다
        length=0
        
        //길이 값 반환
        return length
    }
    
    //데큐가 비어있는지 확인
    public var IsEmpty: Bool{
        //0보다 많으면 거짓을 반환
        
        if(length>0){
            return false
        }
        
        //아니면 참을 반환
        return true
    }
    
    //데큐 길이 확인
    public var GetLength: Int{
        return length
    }
    
    //데큐 -> 배열로 변경
    public func DequeueToArray() -> Array<T>{
        var array: Array<T>
        
        array=dequeue
        
        return array
    }
    
    //배열 -> 데큐로 변경
    public mutating func ArrayToDequeue(_ array: Array<T>) -> Int{
        
        dequeue=array
        length=array.count
        
        return length
        
    }
    
}
