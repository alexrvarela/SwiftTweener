//
//  BasicMath.swift
//  Tweener
//
//  Created by Alejandro Ramirez Varela on 5/28/19.
//  Copyright © 2019 Alejandro Ramirez Varela. All rights reserved.
//

import Foundation

public class BasicMath
{
    public static func randomInt(max:Int) -> Int
    {
        return Int(arc4random_uniform(UInt32(max)))
    }
    
    public static func randomIntRange(max:Int, min:Int) -> Int
    {
        //TODO:
        //Int.random(in: 0..<6)
        return randomInt(max:(max - min) + min)
    }
    
    public static func randomDouble(max:Double) -> Double
    {
        return drand48() * max
    }
    
    public static func randomDoubleRange(max:Double, min:Double) -> Double
    {
        //TODO:
        //let randomDouble = Double.random(in: 2.71828...3.14159)
        return randomDouble(max:((max - min)) + min)
    }
    
    //TODO:Add random Float & CGFloat
    
    public static func toRadians(degree:Double) -> Double
    {
        return degree * Double.pi / 180.0
    }
    
    public static func toRadians(degree:Float) -> Float
    {
        return degree * Float.pi / 180.0
    }
    
    public static func toRadians(degree:CGFloat) -> CGFloat
    {
        return degree * CGFloat.pi / 180.0
    }
    
    public static func toDegrees(radian:Double) -> Double
    {
        return radian * 180.0 / Double.pi
    }
    
    public static func toDegrees(radian:Float) -> Float
    {
        return radian * 180.0 / Float.pi
    }
    
    public static func toDegrees(radian:CGFloat) -> CGFloat
    {
        return radian * 180.0 / CGFloat.pi
    }
    
    //Angle from 2 points
    public static func angle(start:CGPoint, end:CGPoint) -> CGFloat
    {
        return atan2(end.y - start.y, end.x - start.x)
    }
        
    //Distance from 2 points
    public static func length(start:CGPoint, end:CGPoint) -> CGFloat
    {
        let a:CGFloat = start.x - end.x
        let b:CGFloat = start.y - end.y
        return sqrt(a * a + b * b)
    }
    
    public static func arcRotationPoint(angle:CGFloat, radius:CGFloat) -> CGPoint
    {
        let x:CGFloat = cos(angle) * radius
        let y:CGFloat = sin(angle) * radius
        return CGPoint(x:x, y:y)
    }
    
    public static func ellipseRotationPoint(angle:CGFloat, xradius:CGFloat, yradius:CGFloat) -> CGPoint
    {
        let x:CGFloat = cos(angle) * xradius
        let y:CGFloat = sin(angle) * yradius
        return CGPoint(x:x, y:y)
    }
        
    public static func quadTangent(t:CGFloat, a:CGFloat, b:CGFloat, c:CGFloat) -> CGFloat
    {
        return (2 * (1 - t) * (b - a)) + (2 * t * (c - b))
    }
        
    public static func cubicTangent(t:CGFloat, a:CGFloat, b:CGFloat, c:CGFloat, d:CGFloat) -> CGFloat
    {
        return (3 * pow(1 - t, 2) * (b - a)) +
            (6 * (1 - t) * t * (c - b)) +
            (3 * pow(t, 2) * (d - c))
    }
        
    //Linear interpolation
    public static func linear(t:CGFloat, a:CGFloat, b:CGFloat) -> CGFloat
    {
        return a + (b - a) * t
    }
        
    //Quad interpolation
    public static func quad(t:CGFloat, a:CGFloat, b:CGFloat, c:CGFloat) -> CGFloat
    {
        return (pow(1 - t, 2) * a)
            + (2 * (1 - t) * t * b)
            + (pow(t, 2) * c)
    }
        
    //Cubic interpolation
    public static func cubic(t:CGFloat, a:CGFloat, b:CGFloat, c:CGFloat, d:CGFloat) -> CGFloat
    {
        return (pow(1 - t, 3) * a) +
            (3 * pow(1 - t, 2) * t * b) +
            (3 * (1 - t) * pow(t, 2) * c) +
            (pow(t, 3) * d)
    }
}
