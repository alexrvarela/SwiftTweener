//
//  WindBlow.swift
//  Examples
//
//  Created by Alejandro Ramirez Varela on 6/29/19.
//  Copyright © 2019 Alejandro Ramirez Varela. All rights reserved.
//

import UIKit
import Tweener

class WindBlow:UIView, FreezeProtocol
{
    let dart:PDFImageView = PDFImageView(bundlename: "dart")
    let rotation:RotationAim = RotationAim()
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        
        backgroundColor = UIColor(red:222.0/255.0,
                                      green:255.0/255.0,
                                      blue:220.0/255,
                                      alpha:1.0)
        
        let sunny = PDFImageView(bundlename: "sunny")
        sunny.scale = 0.75
        sunny.frame = CGRect(x:center.x - sunny.frame.size.width / 2.0,
                             y:(center.y - sunny.frame.size.height) / 2.0,
                             width:sunny.frame.size.width,
                             height:sunny.frame.size.height)
        
        addSubview(sunny)
        
        let grass = UIView(frame:CGRect(x:0.0,
                                        y:self.frame.size.height * 0.9,
                                        width:self.frame.size.width,
                                        height:self.frame.size.height * 0.1))
        grass.backgroundColor = UIColor(red:130.0/255.0,
                                        green:255.0/255.0,
                                        blue:170.0/255,
                                        alpha:1.0)
        addSubview(grass)
        
        let stick = UIView(frame:CGRect(x:center.x - 5.0,
                                        y:self.frame.size.height - 220.0,
                                        width:10.0,
                                        height:220.0))
        
        stick.backgroundColor = UIColor(red:0.0, green:0.0, blue:140.0/255, alpha:1.0)
        addSubview(stick)
        

        dart.center = CGPoint(x:center.x, y:self.frame.size.height - 220.0)
        addSubview(dart)
        
        rotation.target = dart
        
        //Start animation
        animate()
        
        //Freeze
        freeze()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func animate()
    {
        let random = CGFloat.random(in: 1.0...5.0)
        
        Tween(target: rotation,
              duration: Double(random) * 2.0,
              ease: Ease.inOutQuad,
              delay: 0.0,
              to:[.key(\.distance, random)],
              completion: { self.animate() }).play()
    }
    
    func freeze()
    {
        Tweener.pauseTweens(target: rotation)
    }
    
    func warm()
    {
        Tweener.resumeTweens(target: rotation)
    }
}
