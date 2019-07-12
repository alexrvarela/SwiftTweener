//
//  ArcAim.swift
//  Tweener
//
//  Created by Alejandro Ramirez Varela on 5/28/19.
//  Copyright © 2019 Alejandro Ramirez Varela. All rights reserved.
//

import Foundation

public class ArcAim : RotationAim
{
    private var _orientToArc:Bool = false
    private var _center:CGPoint = CGPoint.zero
    private var _radius:CGFloat = 0.0
    private var _arcAngle:CGFloat = 0.0
    private var _arcAngleOffset:CGFloat = 0.0
    private var _arcPoint:CGPoint = CGPoint.zero
    
    public var arcAngleOffset:CGFloat
    {
        set {
            _arcAngleOffset = BasicMath.toRadians(degree:newValue)
            update()
        }
        get {return _arcAngleOffset}
    }
    
    public var arcAngle:CGFloat
    {
        set {
            _arcAngle = BasicMath.toRadians(degree: newValue)
            update()
        }
        get {return _arcAngle}
    }

    public var radius:CGFloat
    {
        set{
            _radius = newValue
            update()
        }
        get {return _radius}
    }

    public var center:CGPoint
    {
        set {
            _center = newValue
            update()
        }
        get {return _center}
    }

    public var arcPoint:CGPoint
    {
        set {
            _arcPoint = newValue
            //TODO:add arcAngleOffset?
            _arcAngle = BasicMath.angle(start:_center, end:_arcPoint)
            update()
        }
        get {return _arcPoint}
    }
    
    public var orientToArc:Bool
    {
        set {
            _orientToArc = newValue
            update()
        }
        get {return _orientToArc}
    }
    
    private func update()
    {
        if self.target != nil {
            
            let rotation:CGPoint = BasicMath.arcRotationPoint(angle: _arcAngle + _arcAngleOffset,
                                                              radius:_radius)
            //Update position
            self.target!.center = CGPoint(x:_center.x + rotation.x, y:_center.y + rotation.y)
            
            //Orient if is 
            if _orientToArc {self.orientation = _center}
        }
    }
}
