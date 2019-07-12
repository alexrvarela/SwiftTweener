//
//  TweenControl.swift
//  Tweener
//
//  Created by Alejandro Ramirez Varela on 9/7/18.
//  Copyright © 2018 Alejandro Ramirez Varela. All rights reserved.
//

import Foundation

class TweenControl
{
    /* non-generic methods */
    var timeStart:Double = 0.0
    var timeComplete:Double = 0.0
    var timePaused:Double = 0.0
    var isTimelineTween:Bool = false
    var state:TweenState = .initial
    var lastState:TweenState = .initial
    
    func update(_ time:Double)
    {
        //Warning
        print("Error, tween nil")
    }
    
    func getTween() -> AnyTween
    {
        //Null
        print("Error, tween nil")
        return AnyTween()
    }
    
    func reset()//TODO: pass arg _ currentTime:Double
    {
        //TODO:
        //Engine.currentTime + tween.delay
        //self.timeStart = currentTime + tween.delay
        //self.timeComplete = self.timeStart + tween.duration
        state = .initial
        timePaused = 0
    }
    
    func getKeysCount() -> Int
    {
        print("Error, tween nil")
        return -1
    }
    
    func getKeys() -> [AnyKeyPath : TweenValues]
    {
        print("Error, tween nil")
        return [:]
    }
    
    func isTarget<U>( _ target:U) -> Bool{
        print("Error, tween nil")
        return false
    }
    
    func getTargetAddress()->Int{
        print("Error, tween nil")
        return 0
    }
    
    func remove(){
        print("Error, tween nil")
    }
    
    func remove<U>(_ keys:[PartialKeyPath<U>])->Int {
        print("Error, tween nil")
        return 0
    }
    
    func contains<U>(_ keys:[PartialKeyPath<U>]) -> Int
    {
        print("Error, tween nil")
        return 0
    }
    
    func split<U>(_ keys:[PartialKeyPath<U>]) -> TweenControl?
    {
        print("Error, tween nil")
        return nil
    }
}

protocol OptionalProtocol {}
extension Optional : OptionalProtocol{}

class Control<T>: TweenControl
{
    override var timeStart:Double{didSet {updateTimeComplete()}}
    var tween :Tween<T>

    public init(_ tween:Tween<T>, time:Double)
    {
//        print("Tween control init")
        self.tween = tween
//        super.init(tween, time:time)
        super.init()
        timeStart = time
    }
    
    func isOptional<U>(_ type:U) -> Bool
    {
        return U.self is OptionalProtocol.Type
    }
    
    override func getKeysCount() -> Int
    {
        return tween.keys.count
    }
    
    
    override func getKeys() -> [AnyKeyPath : TweenValues]
    {
        var list:[AnyKeyPath : TweenValues] = [:]
        
        for keyValue in self.tween.keys
        {
            list[keyValue.key] = keyValue.value
        }
        
        return list
    }
    
    override func isTarget<U>( _ target:U) -> Bool{
        
        if U.self == T.self {
            return unsafeBitCast(target, to:Int.self) == unsafeBitCast(tween.target, to:Int.self)
        }
        
        return false
    }
    
    //TODO:Remove self
    override func remove()
    {
        TweenList.remove(self)
    }
    
    //Remove specific keys only.
    override func remove<U>(_ keys:[PartialKeyPath<U>]) -> Int
    {
//        print("Tween Remove keys")
        //Verify if is same object type.
        if U.self == T.self {

            let replacingKeys = keys as? [PartialKeyPath<T>]
            var newKeys:[PartialKeyPath<T>:Any] = [:]
            
            for (key, value) in tween.keys
            {
                //Verify if keypath is added
                if replacingKeys!.contains(key) == false
                {
//                    print("key doesn't exist")
                    //Insert value
                    newKeys[key] = value
                }
            }
            
            //TODO:Verify if has overwitten
            if(newKeys.count != tween.keys.count)
            {
                //Tween has overwritten.
                if (tween.onOverwrite != nil){
                    DispatchQueue.main.async {
                        self.tween.onOverwrite!()
                    }
                }
                
                //TODO:Replace keys with changed here!
            }
            
            //Replace keys
            (tween as Tween<T>).setKeys(newKeys)
        }
        
        return tween.keys.count
    }
    
    //Remove specific keys only.
    override func contains<U>(_ keys:[PartialKeyPath<U>]) -> Int
    {
        print("Contains keys")

        var count:Int = 0
        
        if U.self == T.self {
            
            let keys_t = keys as? [PartialKeyPath<T>]
            
            //Verify if key exists
            for (key, _) in tween.keys
            {
                if keys_t!.contains(key)
                {
                    print("key doesn't exists")
                    //Insert value
                    count = count + 1
                }
            }
        }
        
        return count
    }
    
    ////Remove specific keys and create new one with these keys
    override func split<U>(_ keys:[PartialKeyPath<U>]) -> TweenControl?
    {
        print("Split tween")
        var splittedKeys:[PartialKeyPath<T>:Any] = [:]
        
        //Verify if is same object type.
        if U.self == T.self {
            
            let replacingKeys = keys as? [PartialKeyPath<T>]
            
            for (key, value) in tween.keys
            {
                //Verify if keypath is added
                if replacingKeys!.contains(key) == false
                {
                    print("key doesn't exists")
                    //Insert value
                    splittedKeys[key] = value
                }
            }
        }
        
        return clone(splittedKeys)
    }
    
    func clone(_ keys:[PartialKeyPath<T>:Any]) -> TweenControl
    {
        let newTween = Tween(target:tween.target, duration:tween.duration, keys:keys.count > 0 ? keys : tween.keys)

        newTween.ease = tween.ease
        newTween.delay = tween.delay
        newTween.replaceTweens = tween.replaceTweens
        newTween.onStart = tween.onStart
        newTween.onUpdate = tween.onUpdate
        newTween.onComplete = tween.onComplete
        newTween.onOverwrite = tween.onOverwrite
        
        return Control(newTween, time:self.timeStart)
    }
    
    override public func getTargetAddress()->Int
    {
        return unsafeBitCast(tween.target, to:Int.self)
    }
    
    override func update(_ time:Double)
    {
        setKeys(tween.target!, keys:tween.keys, time:time)
    }
    
    func setKeys<T>(_ target:T, keys: [PartialKeyPath<T> : TweenValues], time:Double)
    {
        for (key, values) in keys
        {
            //Array for interpolated values
            var i:Array<Double> = []
            
            if time >= self.timeComplete
            {
                //Tween completed, set complete values
                i = values.complete
            }
            else if time < self.timeStart
            {
                //Tween hasn't started, set start values
                i = values.start
            }
            else
            {
                //Calculate values using easing equations.
                let t = time - self.timeStart
                let d = self.timeComplete - self.timeStart
                
                //Apply equation
                for (index, b) in values.start.enumerated()
                {
                    let c = values.complete[index] - b
                    i.append(self.tween.ease(t, b, c, d))
                }
            }
            
            //Update only certain types
            if type(of: key).valueType is Int.Type
            {
                let wirtableKey =  key as! ReferenceWritableKeyPath<T, Int>
                target[keyPath: wirtableKey] = TweenValues.getInt(i)
            }else if type(of: key).valueType is Double.Type
            {
                let wirtableKey =  key as! ReferenceWritableKeyPath<T, Double>
                target[keyPath: wirtableKey] = TweenValues.getDouble(i)
            }else if type(of: key).valueType is Float.Type
            {
                let wirtableKey =  key as! ReferenceWritableKeyPath<T, Float>
                target[keyPath: wirtableKey] = TweenValues.getFloat(i)
            }else if type(of: key).valueType is CGFloat.Type
            {
                let wirtableKey =  key as! ReferenceWritableKeyPath<T, CGFloat>
                target[keyPath: wirtableKey] = TweenValues.getCGFloat(i)
            }else if type(of: key).valueType is CGPoint.Type
            {
                let wirtableKey =  key as! ReferenceWritableKeyPath<T, CGPoint>
                target[keyPath: wirtableKey] = TweenValues.getPoint(i)
            }else if type(of: key).valueType is CGRect.Type
            {
                let wirtableKey =  key as! ReferenceWritableKeyPath<T, CGRect>
                target[keyPath: wirtableKey] = TweenValues.getRect(i)
            }else if type(of: key).valueType is UIColor.Type
            {
                let wirtableKey =  key as! ReferenceWritableKeyPath<T, UIColor>
                target[keyPath: wirtableKey] = TweenValues.getColor(i)
            }else if type(of: key).valueType is CGAffineTransform.Type
            {
                let wirtableKey =  key as! ReferenceWritableKeyPath<T, CGAffineTransform>
                target[keyPath: wirtableKey] = TweenValues.getMatrix(i)
            }else if type(of: key).valueType is CATransform3D.Type
            {
                let wirtableKey =  key as! ReferenceWritableKeyPath<T, CATransform3D>
                target[keyPath: wirtableKey] = TweenValues.getMatrix3d(i)
            }
        }
    }
    
    func updateTimeComplete(){timeComplete = timeStart + (tween.duration / Engine.timeScale)}
    
    override func getTween() -> AnyTween
    {
        return self.tween
    }
}
