//
//  AnimateArcRadius.swift
//  Examples
//
//  Created by Alejandro Ramirez Varela on 6/29/19.
//  Copyright © 2019 Alejandro Ramirez Varela. All rights reserved.
//

import UIKit
import Tweener

class AnimateArcRadius:UIView
{
    let eyeBall:UIView = UIView(frame: CGRect(x:0.0, y:0.0, width:180.0, height:180.0))
    let eyeLipTop:UIView = UIView()
    let eyeLipBottom:UIView = UIView()
    let eyePupil:PDFImageView = PDFImageView(bundlename: "eyepupil")
    let aim:ArcAim = ArcAim()
    
    var isClosed:Bool = false
    var canSleep:Bool = false
    var opennedTop:CGRect = CGRect.zero
    var opennedBottom:CGRect = CGRect.zero
    var closedTop:CGRect = CGRect.zero
    var closedBottom:CGRect = CGRect.zero
    
    override init(frame: CGRect){
        
        super.init(frame: frame)
        
        backgroundColor = UIColor(red:65.0/255.0, green:50.0/255.0, blue:160.0/255, alpha:1.0)
        
        //eyeball
        eyeBall.backgroundColor = UIColor(red:222.0/255.0, green:255.0/255.0, blue:220.0/255, alpha:1.0)
        eyeBall.center =  center
        eyeBall.clipsToBounds = true
        eyeBall.layer.cornerRadius = 180.0 / 2.0
        addSubview(eyeBall)
        eyeBall.isUserInteractionEnabled = false
        
        let targetCenter = CGPoint(x:eyeBall.frame.size.width / 2.0,
                                   y:eyeBall.frame.size.height / 2.0)
        
        //eyepupil
        eyePupil.scale = 1.25
        eyePupil.center = targetCenter
        eyeBall.addSubview(eyePupil)
        
        //animation frames
        opennedTop = CGRect(x:eyeBall.frame.origin.x,
                            y:eyeBall.frame.origin.y - eyeBall.frame.size.height / 2.0,
                            width:eyeBall.frame.size.width,
                            height:eyeBall.frame.size.height / 2.0)
        
        closedTop = CGRect(x:opennedTop.origin.x,
                           y:opennedTop.origin.y + opennedTop.size.height,
                           width:opennedTop.size.width,
                           height:opennedTop.size.height)
        
        opennedBottom = CGRect(x:eyeBall.frame.origin.x,
                               y:eyeBall.frame.origin.y + eyeBall.frame.size.height,
                               width:eyeBall.frame.size.width,
                               height:eyeBall.frame.size.height / 2.0)
        
        closedBottom = CGRect(x:opennedBottom.origin.x,
                              y:eyeBall.frame.origin.y + eyeBall.frame.size.height / 2.0,
                              width:opennedBottom.size.width,
                              height:opennedBottom.size.height)
        
        //eyelips
        eyeLipTop.frame = opennedTop
        eyeLipTop.backgroundColor = backgroundColor
        addSubview(eyeLipTop)
        

        eyeLipBottom.frame = opennedBottom
        eyeLipBottom.backgroundColor = backgroundColor
        addSubview(eyeLipBottom)
        
        //aim
        aim.target = eyePupil
        aim.radius = 0.0
        aim.center = targetCenter
        
        sleepEye()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func openEye()
    {
        isClosed = false
        animateLips(top:opennedTop, bottom:opennedBottom, duration: 0.1)
    }
    
    func sleepEye()
    {
        isClosed = false
        animateLips(top:closedTop, bottom:opennedBottom, duration: 0.25)
    }
    
    func closeEye()
    {
        isClosed = true
        animateLips(top:closedTop, bottom:closedBottom, duration: 0.1)
    }
    
    
    func animateRadius(radius:Double)
    {
        Tweener.removeTweens(target: aim)
        Tween(target: aim, duration: 0.1, ease:.outQuad, to:[\ArcAim.radius : radius]).play()
    }
    
    func animateLips(top:CGRect, bottom:CGRect, duration:Double)
    {
        //Remove delayed
        Tweener.removeTweens(target: eyeLipTop)
        
        //Animate top
        Tween(target: eyeLipTop, duration: duration, ease:.outQuad, to: [\UIView.frame : top]).play()
        
        //Animate bottom
        Tween(target: eyeLipBottom, duration: duration, ease:.outQuad, to: [\UIView.frame : bottom]).play()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        canSleep = false
        
        let touch:UITouch = event!.allTouches!.first!

        let distance = BasicMath.length(start: touch.location(in: self), end: CGPoint(x:frame.size.width / 2.0, y:frame.size.height / 2.0))
    
        if (distance < eyeBall.frame.size.width / 2.0)
        {
            if !isClosed {closeEye()}
        }
        else
        {
            animateRadius(radius:Double(eyeBall.frame.size.width / 2.0))
            aim.arcPoint = touch.location(in:eyeBall)
            openEye()
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        let touch:UITouch = event!.allTouches!.first!
        
        let distance = BasicMath.length(start: touch.location(in: self), end: CGPoint(x:frame.size.width / 2.0, y:frame.size.height / 2.0))
        
        if (distance < eyeBall.frame.size.width / 2.0)
        {
            if !isClosed
            {
                if (aim.radius != 0.0)
                {
                    animateRadius(radius:0.0)
                }
                closeEye()
            }
        }
        else
        {
            if (aim.radius == 0.0)
            {
                animateRadius(radius: Double(eyeBall.frame.size.width / 2.0))
            }
            
            aim.arcPoint = touch.location(in: eyeBall)
            
            if (isClosed)
            {
                openEye()
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        canSleep = true
        if isClosed {openEye()}
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
            self.delaySleep()
        })
        animateRadius(radius:0.0)
    }
    
    func delaySleep()
    {
        if canSleep {
            Tween(target: eyeLipTop, duration: 0.25, ease:.outQuad, to:[\UIView.frame : closedTop]).play()
        }
    }
}
