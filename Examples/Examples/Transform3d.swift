//
//  Transform3d.swift
//  Examples
//
//  Created by Alejandro Ramirez Varela on 6/10/19.
//  Copyright © 2019 Alejandro Ramirez Varela. All rights reserved.
//


import UIKit
import Tweener

class Transform3d:UIView
{
    let circle = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 250.0, height: 250.0))
    var startPoint:CGPoint = .zero
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        
        backgroundColor = UIColor(red:116.0 / 255.0, green:244.0 / 255.0, blue:234.0 / 255.0, alpha:1.0)
        
        circle.backgroundColor = .white
        circle.layer.cornerRadius = 125.0
        circle.center = center
        addSubview(circle)
        
        let label = UILabel()
        label.textColor = UIColor(red:116.0 / 255.0, green:244.0 / 255.0, blue:234.0 / 255.0, alpha:1.0)
        label.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        label.text = "drag circle"
        label.sizeToFit()
        label.frame = CGRect(x: (circle.frame.size.width - label.frame.size.width) / 2.0,
                             y: (circle.frame.size.height - label.frame.size.height) / 2.0,
                             width: label.frame.size.width,
                             height: label.frame.size.height)
        circle.addSubview(label)
        
        //Add pan gesture recognizer
        let panRecognizer:UIPanGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(pan(recognizer:)))
        panRecognizer.maximumNumberOfTouches = 1
        addGestureRecognizer(panRecognizer)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
 
    @objc func pan(recognizer:UIPanGestureRecognizer)
    {
        if recognizer.numberOfTouches > 0 {
            
            let p = recognizer.location(ofTouch: 0, in: self)
            let translation:CGPoint = recognizer.translation(in: self)
            
            if recognizer.state == .began
            {
                //Store origin point
                startPoint = p
                //Remove existing tweens
                Tweener.removeTweens(target:circle.layer)
            }
            else if recognizer.state == .changed
            {
                let lenght = BasicMath.length(start: startPoint, end: CGPoint(x:startPoint.x + translation.x,
                                                                              y:startPoint.y + translation.y))
                let angle = BasicMath.angle(start:center, end: CGPoint(x:center.x + translation.x,
                                                                            y:center.y + translation.y))
                let aixs:CGPoint = BasicMath.arcRotationPoint(angle:angle * -1.0, radius: 1.0)
                
                //Rotate matrix
                circle.layer.transform = CATransform3DRotate(CATransform3DIdentity,
                                                                BasicMath.toRadians(degree:lenght),
                                                                aixs.y,
                                                                aixs.x,
                                                                0.0)
            }
        }else
        {
            //Touches ended, animate.
            Tween(target: circle.layer,
                  duration: 0.25,
                  ease:.outQuad,
                  to: [.key(\.transform, CATransform3DIdentity)]).play()
        }
    }
}
