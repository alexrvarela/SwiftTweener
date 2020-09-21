//
//  TweenControl.swift
//  Tweener
//
//  Created by Alejandro Ramirez Varela on 9/7/18.
//  Copyright © 2018 Alejandro Ramirez Varela. All rights reserved.
//

import Foundation

/// A Control  wrapper class.
class TweenControl
{
    /// Calculated Tween's Time start
    var timeStart:Double = 0.0
    /// Calculated Tween's Time complete
    var timeComplete:Double = 0.0
    /// Stores time when Tween is paused.
    var timePaused:Double = 0.0
    /// Tween's current state.
    var state:TweenState = .initial
    /// Stores last Tween's state.
    var lastState:TweenState = .initial
    
    /**Updates Tween's animation values.
     - Parameter time: Engine's current time value as Double.
    */
    func update(_ time:Double){
        //Warning
        print("Error, tween nil")
    }
    
    /// Control's accesor to `Tween` instance.
    /// - Returns:  Control's AnyTween instance.
    func getTween() -> AnyTween {
        print("Error, tween nil")
        return AnyTween()
    }
    
    /// Tween's reset function.
    func reset(){
        state = .initial
        timePaused = 0
    }
    
    /// Get Tween's keyPath count.
    /// - Returns:  Int value.
    func getKeysCount() -> Int{
        print("Error, tween nil")
        return -1
    }
    
    /// Tween's Keypath and Values accesor.
    /// - Returns:  Tween's collection of keypaths and Values.
    func getKeys() -> [AnyKeyPath : TweenArray]
    {
        print("Error, tween nil")
        return [:]
    }
    
    /// Function to check if it is the same target
    /// - Parameter target:    Target to check.
    /// - Returns:             A Bool value indicating if target is the same.
    func isTarget<U>( _ target:U) -> Bool{
        print("Error, tween nil")
        return false
    }

    /// Gets unsafeBitCast of Tween's target.
    /// - Returns: An Int representing the unsafeBitCast.
    func getTargetAddress()->Int{
        print("Error, tween nil")
        return 0
    }
    
    ///Removes current Tween from Engine.
    func remove(){
        print("Error, tween nil")
    }
    
    ///Removes specific KeyPaths from Tween instance.
    /// - Parameter keys:   A collection of KeyPaths to remove.
    /// - Returns:          An Int number representing total of keypaths that were removed.
    func remove<U>(_ keys:[PartialKeyPath<U>])->Int {
        print("Error, tween nil")
        return 0
    }
    
    /// Checks if Tween instance contains KeyPaths.
    /// - Parameter keys:   A collection of KeyPaths to check.
    /// - Returns:          An Int number representing total of matches found.
    func contains<U>(_ keys:[PartialKeyPath<U>]) -> Int
    {
        print("Error, tween nil")
        return 0
    }
    
    /// Splts Tween's keyPaths into a new Tween instance and creates a new TweenControl.
    /// - Parameter keys:   A collection of KeyPaths to split.
    /// - Returns:          A new TweenControl instance containing split keypaths.
    func split<U>(_ keys:[PartialKeyPath<U>]) -> TweenControl?
    {
        print("Error, tween nil")
        return nil
    }
}

/// Class that handles Tween animation updates associated to Tween's target Type.
class Control<T>: TweenControl
{
    override var timeStart:Double{ didSet {updateTimeComplete()} }
    
    ///Tween instance for animation handling.
    var tween :Tween<T>

    public init(_ tween:Tween<T>, time:Double){
        
        self.tween = tween
        super.init()
        timeStart = time
    }
    
    /// Get Tween's keyPath count.
    /// - Returns:  Int value.
    override func getKeysCount() -> Int{
        return tween.keys.count
    }
    
    /// Tween's Keypath and Values accesor.
    /// - Returns:  Tween's collection of keypaths and Values.
    override func getKeys() -> [AnyKeyPath : TweenArray]
    {
        var list:[AnyKeyPath : TweenArray] = [:]
        
        for keyValue in self.tween.keys
        {
            list[keyValue.key] = keyValue.value
        }
        
        return list
    }
    
    /// Function to check if it is the same target
    /// - Parameter target:    Target to check.
    /// - Returns:             A Bool value indicating if target is the same.
    override func isTarget<U>( _ target:U) -> Bool{
        
        if U.self == T.self {
            return unsafeBitCast(target, to:Int.self) == unsafeBitCast(tween.target, to:Int.self)
        }
        
        return false
    }
    
    ///Removes current Tween from Engine.
    override func remove(){ TweenList.remove(self) }
    
    ///Removes specific KeyPaths from Tween instance.
    /// - Parameter keys:   A collection of KeyPaths to remove.
    /// - Returns:          An Int number representing total of keypaths that were removed.
    override func remove<U>(_ keys:[PartialKeyPath<U>]) -> Int
    {
        //Verify if is same object type.
        if U.self == T.self {
            
            //Cast array.
            let replacingKeys = keys as! [PartialKeyPath<T>]
            //Create empty array.
            var newKeys:[PartialKeyPath<T>:TweenArray] = [:]
            
            //Use original key-value pairs to replace existing.
            for (key, value) in tween.keys
            {
                //Verify if contains key
                if !replacingKeys.contains(key){
                    //Tween doesn't contain key, insert.
                    newKeys[key] = value
                }
            }
            
            //Verify if all keys were replaced.
            if newKeys.count != tween.keys.count{
                //One or more keys were replaced, Tween has overwritten.
                if tween.onOverwrite != nil { DispatchQueue.main.async { self.tween.onOverwrite!() } }
            }
                    
            //Replace non-affected keys to original tween.
            (tween as Tween<T>).keys = newKeys
        }
        
        return tween.keys.count
    }
    
    /// Checks if Tween instance contains KeyPaths.
    /// - Parameter keys:   A collection of KeyPaths to check.
    /// - Returns:          An Int number representing total of matches found.
    override func contains<U>(_ keys:[PartialKeyPath<U>]) -> Int
    {
        var count:Int = 0
        
        if U.self == T.self {
            
            let keys_t = keys as? [PartialKeyPath<T>]

            for (key, _) in tween.keys{
                //Verify if contains key.
                if keys_t!.contains(key){
                    //Doesn't contain key, insert value.
                    count = count + 1
                }
            }
        }
        
        return count
    }
    
    /// Splts Tween's keyPaths into a new Tween instance and creates a new TweenControl.
    /// - Parameter keys:   A collection of KeyPaths to split.
    /// - Returns:          A new TweenControl instance containing split keypaths.
    override func split<U>(_ keys:[PartialKeyPath<U>]) -> TweenControl?{
        
        var splittedKeys:[PartialKeyPath<T>:TweenArray] = [:]
        
        //Verify if is same object type.
        if U.self == T.self {
            
            let replacingKeys = keys as? [PartialKeyPath<T>]
            
            for (key, value) in tween.keys
            {
                //Verify if keypath is added
                if replacingKeys!.contains(key) == false
                {
                    //Insert value
                    splittedKeys[key] = value
                }
            }
        }
        
        return clone( splittedKeys )
    }
    
    ///Creates a new Tween instance for current Tween's target.
    /// - Parameter keys:   A collection of KeyPaths to animate.
    /// - Returns:          A new TweenControl instance for created Tween.S
    func clone(_ keys:[PartialKeyPath<T>:TweenArray]) -> TweenControl
    {
        let newTween:Tween<T> = Tween(target:tween.target)
        
        //Set keys directly
        newTween.keys = keys
        newTween.duration = tween.duration
        newTween.ease = tween.ease
        newTween.delay = tween.delay
        newTween.onStart = tween.onStart
        newTween.onUpdate = tween.onUpdate
        newTween.onComplete = tween.onComplete
        newTween.onOverwrite = tween.onOverwrite
        
        return Control(newTween, time:self.timeStart)
    }
    
    /// Gets unsafeBitCast of Tween's target.
    /// - Returns: An Int representing the unsafeBitCast.
    override public func getTargetAddress()->Int { return unsafeBitCast(tween.target, to:Int.self) }
    
    /**Function that calls to update the Tween's values.
     - Parameter time: Engine's current value time.
    */
    override func update(_ time:Double) { updateKeys(tween.target!, keys:tween.keys, time:time) }
    
    /**Updates Tween's animation values.
     - Parameter target:    Target instance to perform animations.
     - Parameter keys:      Collection of KeyPaths and values to animate.
    */
    func updateKeys<T>(_ target:T, keys: [PartialKeyPath<T> : TweenArray], time:Double)
    {
        for (key, values) in keys
        {
            //Array for interpolated values
            var i:[Double] = []
            
            if time >= self.timeComplete
            {
                //Tween completed, set complete values
                i = values.to
            }
            else if time < self.timeStart
            {
                //Tween hasn't started, set start values
                i = values.from
            }
            else
            {
                //Calculate values using easing equations.
                let t = time - self.timeStart
                let d = self.timeComplete - self.timeStart
                
                //Apply equation
                for (index, b) in values.from.enumerated()
                {
                    let c = values.to[ index ] - b
                    i.append(self.tween.ease(t, b, c, d))
                }
            }
            
            //Update only certain types
            for (j, t) in SupportedTypes.list.enumerated() {
                if type(of: type(of: key).valueType ) == type(of: t) {
                    SupportedTypes.interpreters[j].write(target: target, key: key, values: i)
                    break
                }
            }
        }
    }
    
    ///Updates Tween's time complete.
    func updateTimeComplete(){timeComplete = timeStart + (tween.duration / timeScale)}
    
    /// Control's accesor to `Tween` instance.
    /// - Returns:  Control's AnyTween instance.
    override func getTween() -> AnyTween{
        return self.tween
    }
}
