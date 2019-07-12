//
//  RotationAim.swift
//  Tweener
//
//  Created by Alejandro Ramirez Varela on 5/28/19.
//  Copyright © 2019 Alejandro Ramirez Varela. All rights reserved.
//

import Foundation

public typealias AimRotationHandler = (CGFloat) -> Void

public class RotationAim
{
    public var onUpdateRotation:AimRotationHandler?
    public var target:UIView?//Optional
    private var _rotation:CGFloat = 0.0//in radians
    private var _rotationOffset:CGFloat = 0.0
    private var _distance:CGFloat = 0.0
    private var _orientation:CGPoint = CGPoint.zero
 
    public init(){}
    
    //init with target
    public convenience init(target:UIView)
    {
        self.init()
        self.target = target
    }
    
    //Set Rotation in degrees
    public var angle:CGFloat
    {
        set { rotation = BasicMath.toRadians(degree:newValue)}
        get { return BasicMath.toDegrees(radian:_rotation)}
    }
    
    public var angleOffset:CGFloat
    {//TODO:Use templates <T>
        set { rotationOffset = BasicMath.toRadians(degree:newValue)}
        get { return BasicMath.toDegrees(radian:_rotationOffset)}
    }

    //Set Rotation in radians
    public var rotation:CGFloat
    {
        set {
            _rotation = newValue
            
            if (onUpdateRotation != nil)
            {
                onUpdateRotation!(_rotation + _rotationOffset)
            }
            
            if (self.target != nil)
            {
                //Apply transform
                target!.transform = CGAffineTransform(rotationAngle: _rotation + _rotationOffset)
            }
        }
        get {return _rotation}
    }
    
    public var rotationOffset:CGFloat
    {
        set {
            _rotationOffset = newValue
            //update rotation
            rotation = _rotation
        }
        get {return _rotationOffset}
    }

    //Convert distance to specific angle
    public var distance:CGFloat
    {
        set {
            //Store value
            _distance = newValue
            //Refresh Angle
            angle = (newValue - floor(newValue)) * 360.0
        }
        get {return _distance}
    }

    //orient target to specific point
    public var orientation:CGPoint
    {
        set {
            _orientation = newValue
            //TODO:add offset?
            rotation = CGFloat(BasicMath.angle(start:target!.center, end:newValue))
        }
        get {return _orientation}
    }
}
