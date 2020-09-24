//
//  SimpleTween.swift
//  Examples
//
//  Created by Alejandro Ramirez Varela on 6/1/19.
//  Copyright © 2019 Alejandro Ramirez Varela. All rights reserved.
//

import UIKit
import Tweener

class SimpleTween:UIView, FreezeProtocol
{
    let square:UIView = UIView(frame:CGRect(x:20.0, y:20.0, width:100.0, height:100.0))
    let button:UIButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        square.backgroundColor = UIColor.blue
        addSubview(square)
        
        self.button.frame = CGRect(x:20.0,
                                   y:self.frame.size.height -  70.0,
                                   width:self.frame.size.width - 40.0,
                                   height:50.0)
        addSubview(self.button)
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
        //Set initial states
        square.alpha = 0.25
        square.frame = CGRect(x:20.0, y:20.0, width:100.0, height:100.0)
        square.backgroundColor = UIColor.blue
        
        //Create tween
        Tween(target:square)//Target
        .duration(1.0)//One second
        .ease(Ease.inOutCubic)
        .keys(to:
            [\UIView.alpha:1.0,
             \UIView.frame:CGRect(x:20.0, y:20.0, width:UIScreen.main.bounds.width - 40, height:UIScreen.main.bounds.width - 40),
             //NOTE:This property is an optional, add ! to keypath.
             \UIView.backgroundColor!:UIColor.red])
        .onComplete { print("Tween complete") }
        .after()//Creates a new tween after with same target and properties.
        .duration(1.0)
        .ease(Ease.outBounce)
        .keys(to: [\UIView.alpha:0.25,
                   \UIView.frame:CGRect(x:20.0, y:20.0, width:100.0, height:100.0),
                   \UIView.backgroundColor!:UIColor.blue])
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
