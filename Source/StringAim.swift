//
//  StringAim.swift
//  Tweener
//
//  Created by Alejandro Ramirez Varela on 5/28/19.
//  Copyright © 2019 Alejandro Ramirez Varela. All rights reserved.
//

import Foundation

public enum TransitionType
{
    case lenght
    case linear
    case random
}

class AnyKeyPathWrapper{ public func update(string:String){} }

class keyPathWrapper<T>:AnyKeyPathWrapper
{
    var target:T?
    var keyPath:ReferenceWritableKeyPath<T,String>?
    
    convenience init(target:T, keyPath:ReferenceWritableKeyPath<T, String>)
    {
        self.init()
        self.target = target
        self.keyPath = keyPath
    }
    
    override func update(string: String) { target![keyPath:keyPath!] = string }
}

public class StringAim
{
    var wrapper:AnyKeyPathWrapper?
    
    public var from:String = ""
    public var to:String = ""
    private var _interpolation:Double = 0.0
    public var transitionType:TransitionType = .lenght
    public var randomSet:[Character] = ["A","a","B","b","C","c","D","d","E","e","F","f","G","g","H","h","I","i","J","j","K","k","L","l","M","m","N","n","O","o","P","p","Q","q","R","r","S","s","T","t","U","u","V","v","W","w","X","x","Y","y","Z","z", "1", "2", "3", "4", "5", "6", "7", "8", "9", "0"]
    
    //TODO:Set CharacterSet and convert to array.
//    public var charset = CharacterSet.alphanumerics {
//        didSet
//        {
//            set = []
//            for plane: UInt8 in 0...16 where charset.hasMember(inPlane: plane) {
//                for unicode in UInt32(plane) << 16 ..< UInt32(plane + 1) << 16 {
//                    if let uniChar = UnicodeScalar(unicode), charset.contains(uniChar)
//                    {
//                        set.append(Character(uniChar))
//                    }
//                }
//            }
//        }
//    }
    
    //Declare as public
    public init(){}
    
    public convenience init<T>(target:T, keyPath:ReferenceWritableKeyPath<T, String>){
        self.init()
        bind(target:target, keyPath:keyPath)
    }
    
    /**
     Binds target with keypath
     - Parameter target:         Any object with a writable key path type String
     - Parameter keyPath:        A writable key path type String to update.
     */
    public func bind<T>(target:T, keyPath:ReferenceWritableKeyPath<T, String>)
    {
        self.wrapper = keyPathWrapper(target:target, keyPath:keyPath)
    }
    
    /// Linear, animates char code value.
    public func linear(interpolation:Double, from:String, to:String) -> String
    {
        //Enable mutable strings
        var from = from
        var to = to

        //Fill with white spaces
        while from.count < to.count{from.append(" ")}
        while to.count < from.count{to.append(" ")}
        
        //Declare output mutable string
        var output:String = String()
        var index:Int = 0
        
        //Inspect char per char
        for char:CChar in from.utf8CString
        {
            if index < from.count
            {
                //Calculate
                let diff = Int(to.utf8CString[index]) - Int(char)
                let add = Int(Double(diff) * interpolation)
                var new = Int(char) + Int(add)

                //Define boundaries.
                if new < 20 {new = 20}
                if new > 127 {new = 127}
                
                //Add to output
                output = output + [Character( UnicodeScalar( new )!)]
            }
            
            index = index + 1
        }
        
        return output
    }
    
    /// Lenght, hides and shows char per char.
    public func length(interpolation:Double, from:String, to:String) -> String
    {
        let totalLength:Int = from.count + to.count
        let ratio:Double = Double( from.count ) / Double( totalLength )
        var string:String = ""
        
        if interpolation < ratio
        {
            let transformValue:Double = 1.0 - (interpolation / ratio)
            
            if from.count > 0
            {
                let end:Int = Int(transformValue * Double(from.count))
                
                if end > 0 {
                    string = String(from[from.startIndex..<from.index(from.startIndex, offsetBy: end)])
                }
            }
        }
        else
        {
            let transformValue:Double = 1.0 - ((1.0 - interpolation) / (1.0 - ratio))
            
            if to.count > 0
            {
                let end:Int = Int(transformValue * Double(to.count))
                
                if end > 0 {
                    string = String(to[to.startIndex..<to.index(to.startIndex, offsetBy: end)])
                }
            }
        }
        
        return string
    }

    /// Random, fills with random characters.
    public func random(interpolation:Double, from:String, to:String) -> String
    {
        let start = Int(floor(Double(to.count) * interpolation))
        var randomString = ""

        while randomString.count < (to.count - start)
        {
            let randomInt = BasicMath.randomIntRange(max: randomSet.count - 1, min:0)
            randomString = randomString + [randomSet[randomInt]]
        }
        
        let string = String(to[to.startIndex..<to.index(to.startIndex, offsetBy: start)])
        return string + randomString
    }

    ///
    public var interpolation:Double
    {
        set {setInterpolation(value:newValue)}
        get {return _interpolation}
    }
    
    ///
    private func setInterpolation(value:Double)
    {
        _interpolation = value
        
        //Prevent empty strings
        if from == "" || to == "" {return}

        //Prevent target nil
        if self.wrapper == nil {return}
        
        var output = ""
        
        switch transitionType
        {
            case .lenght:
                output = length(interpolation:_interpolation, from:self.from, to:self.to)
            case .linear:
                output = linear(interpolation:_interpolation, from:self.from, to:self.to)
            case .random:
                output = random(interpolation:_interpolation, from:self.from, to:self.to)
        }
        
        self.wrapper?.update(string: output)
    }
}
