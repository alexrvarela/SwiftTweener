//
//  TouchPoint.swift
//  Examples
//
//  Created by Alejandro Ramirez Varela on 6/5/19.
//  Copyright © 2019 Alejandro Ramirez Varela. All rights reserved.
//

import UIKit
import Tweener

class TouchPoint:UIView, FreezeProtocol
{
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        
        backgroundColor = UIColor(red:69.0/255.0, green:255.0/255.0, blue:247.0/255, alpha:1.0)
        clipsToBounds = true
        makeAssets()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func makeAssets()
    {
        let colors:Array<UIColor> = [
            UIColor(red:66.0/255.0, green:0.0, blue:162/255, alpha:1.0),
            UIColor(red:129.0/255.0, green:16.0/255, blue:152.0/255.0, alpha:1.0),
            UIColor(red:192.0/255.0, green:32.0/255.0, blue:141.0/255.0, alpha:1.0),
            UIColor(red:255.0/255.0, green:48.0/255.0, blue:131.0/255.0, alpha:1.0),
            UIColor(red:255.0/255.0, green:117.0/255.0, blue:131.0/255.0, alpha:1.0),
            UIColor(red:255.0/255.0, green:186.0/255.0, blue:131.0/255.0, alpha:1.0),
            UIColor(red:255.0/255.0, green:255.0/255.0, blue:131.0/255.0, alpha:1.0),
            UIColor(red:193.0/255.0, green:255.0/255.0, blue:170.0/255.0, alpha:1.0),
            UIColor(red:131.0/255.0, green:255.0/255.0, blue:208.0/255.0, alpha:1.0)
        ]
    
        for (index, color) in colors.enumerated()
        {
            let v:UIView = UIView(frame:CGRect(x:0.0,
                                               y:0.0,
                                               width:60.0 + 80.0 * CGFloat(index),
                                               height:60.0 + 80.0 * CGFloat(index)))
            v.backgroundColor = color
            v.layer.cornerRadius = v.frame.size.width / 2.0
            v.center = center
            insertSubview(v, at:0)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        let touch:UITouch = event!.allTouches!.first!
        let p:CGPoint = touch.location(in: self)
        
        //Animate.
        
        for index in 0 ... subviews.count - 1
        {            
            Tween(target:subviews[index],
                  duration:2.0,
                  ease:.outElastic,
                  delay:0.025 * Double(subviews.count - index),
                  to:[.key(\UIView.center, p)]).play()
        }
    }
    
    func freeze()
    {
        for index in 0 ... subviews.count - 1
        {
            Tweener.pauseTweens(target: subviews[index])
        }
    }
    
    func warm()
    {
        for index in 0 ... subviews.count - 1
        {
            Tweener.resumeTweens(target: subviews[index])
        }
    }
}
