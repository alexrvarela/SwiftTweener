//
//  BezierUtils.swift
//  Tweener
//
//  Created by Alejandro Ramirez Varela on 5/28/19.
//  Copyright © 2019 Alejandro Ramirez Varela. All rights reserved.
//

#if os(iOS) || os(tvOS)
import UIKit
#elseif os(macOS)
import AppKit
#endif

public class BezierUtils
{
    //Linear interpolation between 2 points
    public static func linearInterpolation(time:CGFloat, start:CGPoint, end:CGPoint) -> CGPoint
    {
        return CGPoint(x:BasicMath.linear(t:time, a:start.x, b:end.x),
                       y:BasicMath.linear(t:time, a:start.y, b:end.y))
    }
    
    //Quadratic interpolation between 3 points
    public static func quadInterpolation(time:CGFloat, start:CGPoint, control:CGPoint, end:CGPoint) -> CGPoint
    {
        let x:CGFloat = BasicMath.quad(t:time, a:start.x, b:control.x, c:end.x)
        let y:CGFloat = BasicMath.quad(t:time, a:start.y, b:control.y, c:end.y)
        return CGPoint(x:x, y:y)
    }
    
    //Bezier Cubic interpolation between 4 points
    public static func bezierCubicInterpolation(time:CGFloat, start:CGPoint, controlStart:CGPoint, controlEnd:CGPoint, end:CGPoint) -> CGPoint
    {
        return CGPoint(x:BasicMath.cubic(t:time, a:start.x, b:controlStart.x, c:controlEnd.x, d:end.x),
                       y:BasicMath.cubic(t:time, a:start.y, b:controlStart.y, c:controlEnd.y, d:end.y))
    }
    
    //Quadratic angle
    public static func quadAngle(time:CGFloat, start:CGPoint, control:CGPoint, end:CGPoint) -> CGFloat
    {
        let x:CGFloat = BasicMath.quadTangent(t:time, a:start.x, b:control.x, c:end.x)
        let y:CGFloat = BasicMath.quadTangent(t:time, a:start.y, b:control.y, c:end.y)
        return atan2(y, x)
    }
    
    //Bezier cubic angle
    public static func bezierCubicAngle(time:CGFloat, start:CGPoint, controlStart:CGPoint, controlEnd:CGPoint, end:CGPoint) -> CGFloat
    {
        let x:CGFloat = BasicMath.cubicTangent(t:time, a:start.x, b:controlStart.x, c:controlEnd.x, d:end.x)
        let y:CGFloat = BasicMath.cubicTangent(t:time, a:start.y, b:controlStart.y, c:controlEnd.y, d:end.y)
        return atan2(y, x)
    }

    //Quad lenght
    public static func quadLength(start:CGPoint, control:CGPoint, end:CGPoint) -> CGFloat
    {
        //TODO:Pass inout array to collect points
        var divisions:CGFloat = 50.0
        var step:CGFloat = 1.0 / divisions
        
        //Optimize number of divisions
        let testPoint:CGPoint = quadInterpolation(time:step, start:start, control:control, end:end)
        let testLength:CGFloat = CGFloat(BasicMath.length(start:start, end:testPoint))
        
        //fit divisions
        divisions = divisions * (testLength / 5.0)
        step = 1.0 / divisions
        
        var length:CGFloat = 0.0
        var prevPoint:CGPoint = start
        
        for i:Int in 1 ... Int(divisions)
        {
            let point:CGPoint =  quadInterpolation(time:CGFloat(i) * step, start:start, control:control, end:end)
            length += CGFloat(BasicMath.length(start: prevPoint, end:point))
            prevPoint = point
        }
        
        return length
    }
    
    
    //Bezier cubic lenght
    public static func bezierCubicLength(start:CGPoint, controlStart:CGPoint, controlEnd:CGPoint, end:CGPoint) -> CGFloat
    {
        //TODO:Pass array pointer to collect points
        
        var divisions:CGFloat = 50.0
        var step:CGFloat = 1.0 / divisions
        
        //TODO:optimize number of divisions
        let testPoint:CGPoint = bezierCubicInterpolation(time:step, start: start, controlStart: controlStart, controlEnd: controlEnd, end: end)
        let testLength:CGFloat = CGFloat(BasicMath.length(start:start, end:testPoint))
        
        //fit divisions
        divisions = divisions * (testLength / 5.0)
        step = 1.0 / divisions
        
        var length:CGFloat = 0.0
        var prevPoint:CGPoint = start
        
        for i:Int in 1 ... Int(divisions)
        {
            let point:CGPoint = bezierCubicInterpolation(time:CGFloat(i) * step, start: start, controlStart: controlStart, controlEnd: controlEnd, end: end)
            length += CGFloat(BasicMath.length(start: prevPoint, end:point))
            prevPoint = point
        }
        
        return length
    }
    
    //Calculate entire path lenght
    public static func bezierPathLength(path:CGPath) -> CGFloat
    {
        //TODO: pass array to collect separate lenghts
        return  CGFloat(0.0)
    }
}
