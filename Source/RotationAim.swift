//
//  RotationAim.swift
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


public typealias AimRotationHandler = (CGFloat) -> Void

/// Roatates view's CALayer over z-axis.
public class RotationAim
{
    ///An optional block to handle updates.
    public var onUpdateRotation:AimRotationHandler?
    
    #if os(iOS) || os(tvOS)
    /// UIView target.
    public var target:UIView?
    #elseif os(macOS)
    /// NSView target.
    public var target:NSView?
    #endif
    
    private var _rotation:CGFloat = 0.0//in radians
    private var _rotationOffset:CGFloat = 0.0
    private var _distance:CGFloat = 0.0
    private var _orientation:CGPoint = CGPoint.zero
    
    public init(){}
    
#if os(iOS) || os(tvOS)
    /**
    Initializer.
    - Parameter target: An UIView to handle rotation.
    */
    public convenience init(target:UIView)
    {
        self.init()
        self.target = target
    }
#elseif os(macOS)
    /**
    Initializer.
    - Parameter target: An NSView to handle rotation.
    */
    public convenience init(target:NSView)
    {
        self.init()
        if target.layer == nil {target.wantsLayer = true}
        target.layer?.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.target = target
    }
#endif
    
    ///Sets Rotation in degrees.
    public var angle:CGFloat
    {
        set { rotation = BasicMath.toRadians(degree:newValue)}
        get { return BasicMath.toDegrees(radian:_rotation)}
    }
    
    /// Adds an offset to adjust current angle in degrees.
    public var angleOffset:CGFloat
    {
        set { rotationOffset = BasicMath.toRadians(degree:newValue)}
        get { return BasicMath.toDegrees(radian:_rotationOffset)}
    }

    /// Sets Rotation in radians.
    public var rotation:CGFloat
    {
        set {
            _rotation = newValue
            
            if onUpdateRotation != nil { onUpdateRotation!(_rotation + _rotationOffset) }
            
            //Apply transform
            #if os(iOS) || os(tvOS)
            self.target?.layer.transform = CATransform3DMakeRotation(_rotation + _rotationOffset, 0.0, 0.0, 1.0)
            #elseif os(macOS)
            self.target?.layer?.transform = CATransform3DMakeRotation(_rotation + _rotationOffset, 0.0, 0.0, 1.0)
            #endif
        }
        get {return _rotation}
    }
    
    /// Adds an offset to adjust current angle in radians.
    public var rotationOffset:CGFloat
    {
        set {
            _rotationOffset = newValue
            //update rotation
            rotation = _rotation
        }
        get {return _rotationOffset}
    }

    ///Converts linear distance to rotation angle.
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

    ///Orients target to specific point.
    public var orientation:CGPoint
    {
        set {
            _orientation = newValue
            //TODO:add offset?
            #if os(iOS) || os(tvOS)
            rotation = CGFloat(BasicMath.angle(start:target!.center, end:newValue))
            #elseif os(macOS)
            rotation = CGFloat(BasicMath.angle(start:target!.center(), end:newValue))
            #endif
        }
        get {return _orientation}
    }
}
