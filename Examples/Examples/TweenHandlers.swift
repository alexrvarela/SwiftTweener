//
//  TweenHandlers.swift
//  Examples
//
//  Created by Alejandro Ramirez Varela on 6/1/19.
//  Copyright © 2019 Alejandro Ramirez Varela. All rights reserved.
//

import UIKit
import Tweener

class TweenHandlers:UIView, FreezeProtocol
{
    let circle:UIView = UIView(frame:CGRect(x:20.0, y:20.0, width:50.0, height:50.0))
    let button:UIButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        circle.backgroundColor = UIColor.black
        circle.layer.cornerRadius = 25.0
        addSubview(circle)
        
        button.frame = CGRect(x:20.0,
                                   y:self.frame.size.height -  70.0,
                                   width:self.frame.size.width - 40.0,
                                   height:50.0)
        addSubview(button)
        button.setTitle("ADD TWEEN", for:.normal)
        button.addTarget(self, action:#selector(addTween), for:.touchUpInside)
        button.setTitleColor(UIColor.white, for:.normal)
        button.backgroundColor = UIColor.black
        button.layer.cornerRadius = 7.0
        addSubview(button)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func addTween()
    {        
        //Set initial value
        self.circle.frame = CGRect(x:20.0, y:20.0, width:50.0, height:50.0)
        
        //Create tween
        let tween:Tween = Tween(target:circle,//Target
            duration:1.0,//One second
            ease:Ease.inOutCubic,//Transition
            delay:1.0,//One second delay
            to:[\UIView.frame : CGRect(x:250.0, y:20.0, width:50.0, height:50.0)])
        
        //set initial value
        self.backgroundColor = UIColor.white
        
        //Setup handlers
        tween.onStart = {
            self.backgroundColor = UIColor.green
        }
        
        tween.onUpdate = {
            //Place stuff here!
        }
        
        tween.onComplete = {
            self.backgroundColor = UIColor.red
        }
        
        tween.onOverwrite = {
            self.backgroundColor = UIColor.blue
        }
        
        //Add tween
        tween.play()
    }
    
    func freeze()
    {
        Tweener.pauseTweens(target: circle)
    }
    
    func warm()
    {
        Tweener.resumeTweens(target: circle)
    }
    
}
