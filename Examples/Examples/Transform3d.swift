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
    let moon : PDFImageView = PDFImageView()
    var startPoint:CGPoint = CGPoint.zero
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        
        backgroundColor = UIColor.blue
        
        moon.loadFromBundle("moon")
        moon.scale = 2.0
        moon.center = center
        addSubview(moon)
        
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
                Tweener.removeTweens(target:moon.layer)
            }
            else if recognizer.state == .changed
            {
                let lenght = BasicMath.length(start: startPoint, end: CGPoint(x:startPoint.x + translation.x,
                                                                              y:startPoint.y + translation.y))
                let angle = BasicMath.angle(start:center, end: CGPoint(x:center.x + translation.x,
                                                                            y:center.y + translation.y))
                let aixs:CGPoint = BasicMath.arcRotationPoint(angle:angle * -1.0, radius: 1.0)
                
                //Rotate matrix
                moon.layer.transform = CATransform3DRotate(CATransform3DIdentity,
                                                                BasicMath.toRadians(degree:lenght),
                                                                aixs.y,
                                                                aixs.x,
                                                                0.0)
            }
        }else
        {
            //Touches ended, animate.
            Tween(target: moon.layer,
                  duration: 0.25,
                  ease:Ease.outQuad,
                  keys: [\CALayer.transform : CATransform3DIdentity]).play()
        }
    }
}
