//
//  CustomTypes.swift
//  Examples
//
//  Created by Alejandro Ramirez Varela on 05/09/20.
//  Copyright © 2020 Alejandro Ramirez Varela. All rights reserved.
//

import UIKit
import Tweener

//An example of a 3-Dimension custom type.
public struct Vector3{
    var x, y, z: Double
    func buffer() -> [Double] { return [x, y, z] }
    static func zero() -> Vector3 { return Vector3(x:0.0, y:0.0, z:0.0) }
}

class CustomTypes:UIView, FreezeProtocol
{
    //Declare Assets
    let square:UIView = {
        let view = UIView(frame:CGRect(x:20.0, y:20.0, width:250.0, height:250.0))
        view.backgroundColor = UIColor(hue: CGFloat.random(in: 0 ..< 1.0), saturation: 1.0, brightness: 1.0, alpha: 1.0)
        return view
    }()
    let button:UIButton = {
        let button = UIButton()
        button.setTitle("RANDOM ROTATION", for:.normal)
        button.setTitleColor(UIColor.white, for:.normal)
        button.backgroundColor = UIColor.black
        button.layer.cornerRadius = 7.0
        return button
    }()
    
    //Use as property
    var point3d:Vector3 = Vector3.zero() {
        didSet{
            //Do somethig
            print("Pont3D updated!")
        }
    }
    
    //Use as block
    var updateBlock:TweenBlock<Vector3>!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        //Tell Tweener how convert from Array buffer to type and from Type to array buffer.
        Tweener.addType(toType:{ values in return Vector3(x:values[0], y:values[1], z:values[2])},
                        toArray:{ point in return point.buffer() })
        
        //Create an update Block with initial value, to use 'self', declare after call super.init().
        updateBlock = TweenBlock(value:Vector3.zero()){ value in
            
            //Decide what to do with updated value here.
            
            //Create a identity matrix
            var perspective = CATransform3DIdentity
            //Add perspective
            perspective.m34 = 1.0 / 500.0
            //Rotate x
            perspective = CATransform3DRotate(perspective, BasicMath.toRadians(degree:CGFloat(value.x)), 0, 1, 0)
            //Rotate y
            perspective = CATransform3DRotate(perspective, BasicMath.toRadians(degree:CGFloat(value.y)), 1, 0, 0)
            //Rotate z
            perspective = CATransform3DRotate(perspective, BasicMath.toRadians(degree:CGFloat(value.z)), 0, 0, 1)
            
            //Apply tranformation
            self.square.layer.transform = perspective
        }
        
        square.center = center
        addSubview(square)
        
        button.addTarget(self, action:#selector(addTween), for:.touchUpInside)
        self.button.frame = CGRect(x:20.0,
                                   y:self.frame.size.height -  70.0,
                                   width:self.frame.size.width - 40.0,
                                   height:50.0)
        addSubview(button)
        
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    @objc func addTween()
    {
        //Animate property
        Tween(target:self)
        .ease(Ease.inBounce)
        .duration(1.0)
        .keys(to:[\CustomTypes.point3d:Vector3(x:Double.random(in: 0...1.0),
                                               y:Double.random(in: 0...1.0),
                                               z:Double.random(in: 0...1.0))])
        .play()
        
        //Animate with block
        Tween(target: updateBlock)
            .ease(Ease.outBack)
            .duration(1.0)
            .keys(to:[\TweenBlock<Vector3>.value:Vector3(x:Double.random(in: -360...360),
                                                         y:Double.random(in: -360...360),
                                                         z:Double.random(in: -360...360))])
            .play()
        
        Tween(target: square)
            .duration(1.0)
            .keys(to: [\UIView.backgroundColor! : UIColor.random()])
            .play()
    }
    
    func freeze()
    {
        Tweener.pauseTweens(target: square)
    }
    
    func warm()
    {
        Tweener.resumeTweens(target: square)
    }
}
