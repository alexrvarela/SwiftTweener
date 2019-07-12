//
//  TweenValues.swift
//  Tweener
//
//  Created by Alejandro Ramirez Varela on 2/20/19.
//  Copyright © 2019 Alejandro Ramirez Varela. All rights reserved.
//

import Foundation

class TweenValues
{
    var start:Array<Double>
    var complete:Array<Double>
    //TODO:Use this for restore splitted actions
    var originalComplete:Array<Double>
    var completed:Bool = false
    
    init(start:Array<Double>, complete:Array<Double>)
    {
        self.start = start
        self.complete = complete
        self.originalComplete = complete
    }
    
    static func getInt(_ values:Array<Double>) -> Int
    {
        if values.count == 1
        {
            return Int(values[0])
        }
        return 0
    }
    
    static func getFloat(_ values:Array<Double>) -> Float
    {
        if values.count == 1
        {
            return Float(values[0])
        }
        return 0.0
    }
    
    static func getCGFloat(_ values:Array<Double>) -> CGFloat
    {
        if values.count == 1
        {
            return CGFloat(values[0])
        }
        return 0.0
    }
    
    static func getDouble(_ values:Array<Double>) -> Double
    {
        if values.count == 1
        {
            return values[0]
        }
        return 0.0
    }
    
    static func getPoint(_ values:Array<Double>) -> CGPoint
    {
        if values.count == 2
        {
            return CGPoint(x: values[0],
                           y: values[1])
        }
        
        return CGPoint.zero
    }
    
    static func getSize(_ values:Array<Double>) -> CGSize
    {
        if values.count == 2
        {
            return CGSize(width:values[0],
                          height:values[1])
        }
        
        return CGSize.zero
    }
    
    static func getRect(_ values:Array<Double>) -> CGRect
    {
        if values.count == 4
        {
            return CGRect(x: values[0],
                          y: values[1],
                          width: values[2],
                          height: values[3])
        }
        return CGRect.zero
    }
    
    static func getColor(_ values:Array<Double>) -> UIColor
    {
        switch values.count
        {
        case 1:
            //G
            return UIColor(red: CGFloat(values[0]),
                               green: CGFloat(values[0]),
                               blue: CGFloat(values[0]),
                               alpha: 0.0)
        case 2:
            //GRAY+A
            return UIColor(red: CGFloat(values[0]),
                           green: CGFloat(values[0]),
                           blue: CGFloat(values[0]),
                           alpha: CGFloat(values[1]))
        case 3:
            //RGB
            return UIColor(red: CGFloat(values[0]),
                           green: CGFloat(values[1]),
                           blue: CGFloat(values[2]),
                           alpha: 1.0)
        case 4:
            //RGB+A
            return UIColor(red: CGFloat(values[0]),
                           green: CGFloat(values[1]),
                           blue: CGFloat(values[2]),
                           alpha: CGFloat(values[3]))
        default:
            return UIColor.black
        }
    }
    
    static func getMatrix(_ values:Array<Double>) -> CGAffineTransform
    {
        if values.count == 6
        {
            return CGAffineTransform(a: CGFloat(values[0]),
                                     b: CGFloat(values[1]),
                                     c: CGFloat(values[2]),
                                     d: CGFloat(values[3]),
                                     tx: CGFloat(values[4]),
                                     ty: CGFloat(values[5]))
        }
        
        return CGAffineTransform.identity
    }
    
    
    static func getMatrix3d(_ values:Array<Double>) -> CATransform3D
    {
        if values.count == 16
        {
            return CATransform3D(m11: CGFloat(values[0]),
                                 m12: CGFloat(values[1]),
                                 m13: CGFloat(values[2]),
                                 m14: CGFloat(values[3]),
                                 
                                 m21: CGFloat(values[4]),
                                 m22: CGFloat(values[5]),
                                 m23: CGFloat(values[6]),
                                 m24: CGFloat(values[7]),
                                 
                                 m31: CGFloat(values[8]),
                                 m32: CGFloat(values[9]),
                                 m33: CGFloat(values[10]),
                                 m34: CGFloat(values[11]),
                                 
                                 m41: CGFloat(values[12]),
                                 m42: CGFloat(values[13]),
                                 m43: CGFloat(values[14]),
                                 m44: CGFloat(values[15]))
        }
        
        return CATransform3D.init()
    }
    
    static func getValues(_ value:Any) -> Array<Double>
    {
        var values:Array<Double> = []
        
        switch type(of:value)
        {
        case is Int.Type:
            values = [Double(value as! Int)]
        case is Float.Type:
            values = [Double(value as! Float)]
        case is Double.Type:
            values = [value as! Double]
        case is CGFloat.Type:
            values = [Double(value as! CGFloat)]
        case is CGPoint.Type:
            let cast = value as! CGPoint
            values = [Double(cast.x), Double(cast.y)]
        case is CGSize.Type:
            let cast = value as! CGSize
            values = [Double(cast.width), Double(cast.height)]
        case is CGRect.Type:
            let cast = value as! CGRect
            values = [Double(cast.origin.x), Double(cast.origin.y), Double(cast.size.width), Double(cast.size.height)]
        case is UIColor.Type:
            let cast = value as! UIColor
            //TODO:Bugfix, multiple UIColor types.
            let components = cast.cgColor.components!
//            print("component count : \(components.count)")
            for component in components
            {
                values.append(Double(component))
            }
//            values = [Double(components[0]), Double(components[1]), Double(components[2]), Double(components[3])]
        case is CGAffineTransform.Type:
            let cast = value as! CGAffineTransform
            values = [Double(cast.a), Double(cast.b), Double(cast.c), Double(cast.d), Double(cast.tx), Double(cast.ty)]
        case is CATransform3D.Type:
            let cast = value as! CATransform3D
            values = [Double(cast.m11), Double(cast.m12), Double(cast.m13), Double(cast.m14),
                      Double(cast.m21), Double(cast.m22), Double(cast.m23), Double(cast.m24),
                      Double(cast.m31), Double(cast.m32), Double(cast.m33), Double(cast.m34),
                      Double(cast.m41), Double(cast.m42), Double(cast.m43), Double(cast.m44)]
        default:
            values = []
        }
        
        return values
    }
}


