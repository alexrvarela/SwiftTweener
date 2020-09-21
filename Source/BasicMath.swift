//
//  BasicMath.swift
//  Tweener
//
//  Created by Alejandro Ramirez Varela on 5/28/19.
//  Copyright © 2019 Alejandro Ramirez Varela. All rights reserved.
//

import Foundation

#if os(iOS) || os(tvOS)
import UIKit
#elseif os(macOS)
import AppKit
#elseif os(watchOS)
import WatchKit
#endif

/// A set of basic math functions.
public class BasicMath
{
    ///Time's round precision .
    static let timePrecision:Double = 10000000000000
    
    ///Round last digits to prevent Tween overwritting cause create and add Tweens takes a bit of computational effort.
    static func roundTime(_ t:Double) -> Double{ return Double(round(timePrecision * t) / timePrecision) }
    
    ///A function to calculate time intersections, more and less, not equal accuracy.
    static func intersects(x1:Double, x2:Double, y1:Double, y2:Double) -> Bool{
        return roundTime(x2) > roundTime(y1) && roundTime(y2) > roundTime(x1)
    }
    
    /**Convert degree to radian.
     - Parameter degree:    A `Double` value to turn into radian.
     - Returns:             A calculated radian in `Double` value type.
    */
    public static func toRadians(degree:Double) -> Double
    {
        return degree * Double.pi / 180.0
    }
    
    /**Convert degree to radian.
     - Parameter degree:    A `Float` value to turn into radian.
     - Returns:             A calculated radian in `Float` value type.
    */
    public static func toRadians(degree:Float) -> Float
    {
        return degree * Float.pi / 180.0
    }
    
    /**Convert degree to radian.
     - Parameter degree:    A `CGFloat` value to turn into radian.
     - Returns:             A calculated radian in `CGFloat` value type.
    */
    public static func toRadians(degree:CGFloat) -> CGFloat
    {
        return degree * CGFloat.pi / 180.0
    }
    
    /**Convert radian to degree.
     - Parameter radian:    A `Double` value to turn into degree.
     - Returns:             A calculated radian in `Double` value type.
    */
    public static func toDegrees(radian:Double) -> Double
    {
        return radian * 180.0 / Double.pi
    }
    
    /**Convert radian to degree.
     - Parameter radian:    A Float value to turn into degree.
    */
    public static func toDegrees(radian:Float) -> Float
    {
        return radian * 180.0 / Float.pi
    }
    
    /**Convert radian to degree.
     - Parameter radian:    A CGFloat value to turn into degree.
    */
    public static func toDegrees(radian:CGFloat) -> CGFloat
    {
        return radian * 180.0 / CGFloat.pi
    }
    
    /**Calculate angle rotation between 2 points.
     - Parameter start:     CGPoint 1.
     - Parameter end:       CGPoint 2.
    */
    public static func angle(start:CGPoint, end:CGPoint) -> CGFloat
    {
        return atan2(end.y - start.y, end.x - start.x)
    }
        
    /**Calculate length (distance) between 2 points.
     - Parameter start:     CGPoint 1.
     - Parameter end:       CGPoint 2.
    */
    public static func length(start:CGPoint, end:CGPoint) -> CGFloat
    {
        let a:CGFloat = start.x - end.x
        let b:CGFloat = start.y - end.y
        return sqrt(a * a + b * b)
    }
    
    /**Calculate point location into circular angle rotation.
     - Parameter radius:     CGFloat.
     - Parameter angle:      CGFloat.
     - Returns:              A calculated CGPoint postiton.
    */
    public static func arcRotationPoint(angle:CGFloat, radius:CGFloat) -> CGPoint
    {
        let x:CGFloat = cos(angle) * radius
        let y:CGFloat = sin(angle) * radius
        return CGPoint(x:x, y:y)
    }
    
    /**Calculate point location into elliptical angle rotation.
     - Parameter xradius:   CGFloat.
     - Parameter yradius:   CGFloat.
     - Parameter angle:     CGFloat.
     - Returns:             A calculated CGPoint postiton.
    */
    public static func ellipseRotationPoint(angle:CGFloat, xradius:CGFloat, yradius:CGFloat) -> CGPoint
    {
        let x:CGFloat = cos(angle) * xradius
        let y:CGFloat = sin(angle) * yradius
        return CGPoint(x:x, y:y)
    }
    
    //MARK: - Bezier functions.
    
    /// Calculates Quadratic tangent.
    public static func quadTangent(t:CGFloat, a:CGFloat, b:CGFloat, c:CGFloat) -> CGFloat
    {
        return (2 * (1 - t) * (b - a)) + (2 * t * (c - b))
    }
    
    /// Calculates Cubic tangent
    public static func cubicTangent(t:CGFloat, a:CGFloat, b:CGFloat, c:CGFloat, d:CGFloat) -> CGFloat
    {
        return (3 * pow(1 - t, 2) * (b - a)) +
            (6 * (1 - t) * t * (c - b)) +
            (3 * pow(t, 2) * (d - c))
    }
        
    /// Calculates Linear interpolation
    public static func linear(t:CGFloat, a:CGFloat, b:CGFloat) -> CGFloat
    {
        return a + (b - a) * t
    }
        
    /// Calculates Quadratic interpolation
    public static func quad(t:CGFloat, a:CGFloat, b:CGFloat, c:CGFloat) -> CGFloat
    {
        return (pow(1 - t, 2) * a)
            + (2 * (1 - t) * t * b)
            + (pow(t, 2) * c)
    }
        
    /// Calculates Cubic interpolation
    public static func cubic(t:CGFloat, a:CGFloat, b:CGFloat, c:CGFloat, d:CGFloat) -> CGFloat
    {
        return (pow(1 - t, 3) * a) +
            (3 * pow(1 - t, 2) * t * b) +
            (3 * (1 - t) * pow(t, 2) * c) +
            (pow(t, 3) * d)
    }
}
