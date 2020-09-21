//
//  SimpleTimeline.swift
//  Examples
//
//  Created by Alejandro Ramirez Varela on 6/14/19.
//  Copyright © 2019 Alejandro Ramirez Varela. All rights reserved.
//


import UIKit
import Tweener

class SimpleTimeline:UIView, FreezeProtocol
{
    
    let circle:UIView = UIView()
    let timeline:Timeline = Timeline()
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        //Set background color
        backgroundColor = UIColor(red:55.0/255.0, green:65.0/255.0, blue:80.0/255, alpha:1.0)
        
        //Initialize target
        circle.frame = CGRect(x: (self.frame.size.width -  200.0) / 2.0,
                                   y: 20.0,
                                   width: 200.0,
                                   height: 200.0)
        
        circle.backgroundColor = UIColor(red: 80.0 / 255.0,
                                              green: 220.0 / 255.0,
                                              blue: 170.0 / 255,
                                              alpha: 1.0)
        circle.layer.cornerRadius = 100.0
        addSubview(circle)
        
        //Declare destination frame
        let newFrame = CGRect(x:circle.frame.origin.x,
                           y:self.frame.size.height - circle.frame.size.height - 20.0,
                           width:circle.frame.size.width,
                           height:circle.frame.size.height)
        
        //Add a tween to timeline
        timeline.add( Tween(target:circle,
                                duration:1.5,
                                ease:Ease.outBounce,
                                to:[\UIView.frame : newFrame]) )
        
        //Setup timeline
        timeline.playMode = .loop
        timeline.play()
        
        //Freeze
        freeze()
        
        //Add gesture recognizer
        addGestureRecognizer(UITapGestureRecognizer(target:self,
                                                    action:#selector(tap)))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func tap(sender:UITapGestureRecognizer )
    {
        //Verify current playmode
        if (timeline.playMode == .loop)
        {
            //Change playmode
            timeline.playMode = .pingPong
            //Update target color
            circle.backgroundColor = UIColor(red: 255.0 / 255.0,
                                             green: 120.0 / 255.0,
                                             blue: 180.0 / 255,
                                             alpha: 1.0)
        }else
        {
            //Change playmode
            timeline.playMode = .loop
            //Disable reverse
            timeline.reverse = false
            //Update target color
            circle.backgroundColor = UIColor(red: 80.0 / 255.0,
                                             green: 220.0 / 255.0,
                                             blue: 170.0 / 255,
                                             alpha: 1.0)
            
        }
    }
    
    func freeze()
    {
        timeline.pause()
    }
    
    func warm()
    {
        timeline.play()
    }
    
}

