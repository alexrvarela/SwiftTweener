//
//  ArcAim.swift
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

/// Updates view's position over circular radius.
public class ArcAim : RotationAim
{
    private var _orientToArc:Bool = false
    private var _center:CGPoint = CGPoint.zero
    private var _radius:CGFloat = 0.0
    private var _arcAngle:CGFloat = 0.0
    private var _arcAngleOffset:CGFloat = 0.0
    private var _arcPoint:CGPoint = CGPoint.zero
    
    /// Angle offset which adds to current angle to change start point.
    public var arcAngleOffset:CGFloat
    {
        set {
            _arcAngleOffset = BasicMath.toRadians(degree:newValue)
            update()
        }
        get {return _arcAngleOffset}
    }
    
    /// Angle degree to center view.
    public var arcAngle:CGFloat
    {
        set {
            _arcAngle = BasicMath.toRadians(degree: newValue)
            update()
        }
        get {return _arcAngle}
    }

    /// Angle radius to center view.
    public var radius:CGFloat
    {
        set{
            _radius = newValue
            update()
        }
        get {return _radius}
    }
    
    /// Sets the center of rotation.
    public var center:CGPoint
    {
        set {
            _center = newValue
            update()
        }
        get {return _center}
    }
    
    ///Sets the desired angle by calculating point's angle from current center.
    public var arcPoint:CGPoint
    {
        set {
            _arcPoint = newValue
            _arcAngle = BasicMath.angle(start:_center, end:_arcPoint)
            update()
        }
        get {return _arcPoint}
    }
    
    ///Sets the desired angle by calculating point's angle from current center.
    public var orientToArc:Bool
    {
        set {
            _orientToArc = newValue
            update()
        }
        get {return _orientToArc}
    }
    /// Internal function to calculate and update view's position and rotation.
    private func update()
    {
        if self.target != nil {
            
            let rotation:CGPoint = BasicMath.arcRotationPoint(angle: _arcAngle + _arcAngleOffset,
                                                              radius:_radius)
            //Update position
            #if os(iOS) || os(tvOS)
            self.target!.center = CGPoint(x:_center.x + rotation.x, y:_center.y + rotation.y)
            #elseif os(macOS)
            self.target!.center( CGPoint(x:_center.x + rotation.x, y:_center.y + rotation.y) )
            #endif
            
            //Orient if is 
            if _orientToArc {self.orientation = _center}
        }
    }
}
