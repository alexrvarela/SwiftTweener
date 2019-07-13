//
//  SimpleTimeline.swift
//  Examples
//
//  Created by Alejandro Ramirez Varela on 6/14/19.
//  Copyright © 2019 Alejandro Ramirez Varela. All rights reserved.
//


import UIKit
import Tweener

class SimpleTimeline:UIView
{
    let circle:UIView = UIView()
    let timeline:Timeline = Timeline()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor(red:55.0/255.0, green:65.0/255.0, blue:80.0/255, alpha:1.0)
        
        circle.frame = CGRect(x:(self.frame.size.width -  200.0) / 2.0,
                                   y:20.0,
                                   width:200.0,
                                   height:200.0)
        circle.backgroundColor = UIColor(red:80.0/255.0,
                                              green:220.0/255.0,
                                              blue:170.0/255,
                                              alpha:1.0)
        circle.layer.cornerRadius = 100.0
        addSubview(circle)
        
        let newFrame = CGRect(x:circle.frame.origin.x,
                           y:self.frame.size.height - circle.frame.size.height - 20.0,
                           width:circle.frame.size.width,
                           height:circle.frame.size.height)
        
        let tween = Tween(target:circle,
                          duration:1.5,
                          ease:Ease.outBounce,
                          keys:[\UIView.frame : newFrame])
        
        timeline.add(tween)
        

        timeline.playMode = .loop
        timeline.play()
        
        addGestureRecognizer(UITapGestureRecognizer(target:self,
                                                         action:#selector(tap)))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func tap(sender:UITapGestureRecognizer )
    {
        //Change playmode
        if (timeline.playMode == .loop)
        {
            timeline.playMode = .pingPong
            circle.backgroundColor = UIColor(red:255.0/255.0,
                                                  green:120.0/255.0,
                                                  blue:180.0/255,
                                                  alpha:1.0)
        }else
        {
            timeline.playMode = .loop
            timeline.reverse = false
            circle.backgroundColor = UIColor(red:80.0/255.0,
                                                  green:220.0/255.0,
                                                  blue:170.0/255,
                                                  alpha:1.0)
            
        }
    }
    
}

