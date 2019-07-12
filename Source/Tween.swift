//
//  Tween.swift
//  Tweener
//
//  Created by Alejandro Ramirez Varela on 9/7/18.
//  Copyright © 2018 Alejandro Ramirez Varela. All rights reserved.
//

public typealias TweenHandler = () -> Void

public class AnyTween
{
    //Set default params
    public var duration: Double = 0.0
    public var ease: Equation = Ease.none
    public var delay: Double = 0.0
    public var replaceTweens: Bool = true
    
    public var onStart: TweenHandler?
    public var onUpdate: TweenHandler?
    public var onComplete: TweenHandler?
    public var onOverwrite: TweenHandler?
    
    public func play()
    {
        print("Warning: Can't add this Tween beause isn't defined type")
    }
    
    public func addTo(timeline:Timeline)
    {
        print("Warning: Can't add this Tween because isn't defined type")
    }
}

public class Tween<T>: AnyTween
{
    internal var target: T!
    internal var keys:[PartialKeyPath<T> : TweenValues] = [:]
    
    public convenience init(target: T,
                            duration: Double,
                            keys: [PartialKeyPath<T> : Any])
    {
        self.init()
        
        self.target = target
        
        setKeys(keys)
        
        self.duration = duration
    }
    
    public convenience init(target: T,
                            duration: Double,
                            ease:@escaping Equation,
                            keys: [PartialKeyPath<T> : Any])
    {
        self.init(target: target, duration: duration, keys: keys)
        self.ease = ease
    }
    
    public convenience init(target: T,
                            duration: Double,
                            ease:@escaping Equation,
                            delay:Double,
                            keys: [PartialKeyPath<T> : Any])
    {
        self.init(target: target, duration: duration, ease:ease, keys: keys)
        self.delay = delay
    }
    
    public convenience init(target: T,
                            duration: Double,
                            ease:@escaping Equation,
                            delay:Double,
                            keys: [PartialKeyPath<T> : Any],
                            completion:@escaping TweenHandler
        )
    {
        self.init(target: target, duration: duration, ease:ease, delay:delay, keys: keys)
        self.onComplete = completion
    }
    
    public override func play(){Tweener.add(self)}
    
    //TODO:deprecate?
    public override func addTo(timeline:Timeline)//tween:Tween<T>
    {
        //TODO:move to Timeline add
//        let control = Control(self, time:self.delay / Engine.timeScale)
//        timeline.controls.append(control)
        timeline.add(self)
    }
    
    func setKeys(_ keys:[PartialKeyPath<T> : Any])
    {
        var validKeys : [PartialKeyPath<T> : TweenValues] = [:]
        
        //Set valid keypaths
        for (key, value) in keys
        {
            let keyType = type(of: self.target![keyPath: key])
            let valueType = type(of: value)
            
//            print("type of key : \(keyType), type of value : \(valueType)")
            
            if keyType is Int.Type && isNumberType(valueType)
            {
                let start:Int = self.target![keyPath:key as! ReferenceWritableKeyPath<T, Int>]
                validKeys[key] = TweenValues(start:TweenValues.getValues(start), complete:TweenValues.getValues(value))
            }
            else if keyType is Float.Type && isNumberType(valueType)
            {
                let start:Float = self.target![keyPath:key as! ReferenceWritableKeyPath<T, Float>]
                validKeys[key] = TweenValues(start:TweenValues.getValues(start), complete:TweenValues.getValues(value))
            }
            else if keyType is Double.Type && isNumberType(valueType)
            {
                let start:Double = self.target![keyPath:key as! ReferenceWritableKeyPath<T, Double>]
                validKeys[key] = TweenValues(start:TweenValues.getValues(start), complete:TweenValues.getValues(value))
            }
            else if keyType is CGFloat.Type && isNumberType(valueType)
            {
                let start:CGFloat = self.target![keyPath:key as! ReferenceWritableKeyPath<T, CGFloat>]
                validKeys[key] = TweenValues(start:TweenValues.getValues(start), complete:TweenValues.getValues(value))
            }
            else if(keyType is CGPoint.Type && valueType is CGPoint.Type)
            {
                let start:CGPoint = self.target![keyPath:key as! ReferenceWritableKeyPath<T, CGPoint>]
                validKeys[key] = TweenValues(start:TweenValues.getValues(start), complete:TweenValues.getValues(value))
            }
            else if keyType is CGRect.Type && valueType is CGRect.Type
            {
                let start:CGRect = self.target![keyPath:key as! ReferenceWritableKeyPath<T, CGRect>]
                validKeys[key] = TweenValues(start:TweenValues.getValues(start), complete:TweenValues.getValues(value))
            }
            else if keyType is UIColor.Type && valueType is UIColor.Type
            {
                let start:UIColor = self.target![keyPath:key as! ReferenceWritableKeyPath<T, UIColor>]
                validKeys[key] = TweenValues(start:TweenValues.getValues(start), complete:TweenValues.getValues(value))
            }
            else if keyType is CGAffineTransform.Type && valueType is CGAffineTransform.Type
            {
                let start:CGAffineTransform = self.target![keyPath:key as! ReferenceWritableKeyPath<T, CGAffineTransform>]
                validKeys[key] = TweenValues(start:TweenValues.getValues(start), complete:TweenValues.getValues(value))
            }
            else if keyType is CATransform3D.Type && valueType is CATransform3D.Type
            {
                let start:CATransform3D = self.target![keyPath:key as! ReferenceWritableKeyPath<T, CATransform3D>]
                validKeys[key] = TweenValues(start:TweenValues.getValues(start), complete:TweenValues.getValues(value))
            }
            else
            {
                print("Warning: invalid property.")
            }
        }
        
//        print("Set keys : \(validKeys)")
        self.keys = validKeys
    }

    private func isNumberType<T>(_ type:T)-> Bool
    {
        return (type is Double.Type || type is CGFloat.Type || type is Float.Type || type is Int.Type)
    }
}
