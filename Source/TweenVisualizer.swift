//
//  TweenVisualizer.swift
//  Tweener
//
//  Created by Alejandro Ramirez Varela on 6/30/19.
//  Copyright © 2019 Alejandro Ramirez Varela. All rights reserved.
//

import Foundation

public class TweenVisualizer:UIView
{
    var scale:CGFloat = 1.0
    var backupScale:CGFloat = 1.0

    public init() {
        
        
        let frame = CGRect(x:0.0,
                           y:UIScreen.main.bounds.size.height - 140,
                           width:UIScreen.main.bounds.size.width,
                           height:140)
        
        print("timeline screen whidth : \(UIScreen.main.bounds.size.width)")
        print("timeline whidth : \(frame.size.width)")
        
        super.init(frame:frame)
        
        addGestureRecognizer(UIPinchGestureRecognizer(target: self, action: #selector(pinch)))
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    @objc func pinch(recognizer:UIPinchGestureRecognizer)
    {
        print("pinch action, scale : \(recognizer.scale)")
        
        if (recognizer.state == .began)
        {
            backupScale = scale
            
        }else if (recognizer.state == .changed)
        {
            
            scale = round(backupScale * recognizer.scale)
            
            if scale > 200.0 {scale = 200.0}
            if scale < 20.0 {scale = 20.0}
            
            print("current scale : \(self.scale)")
            
            setNeedsDisplay()
        }
        else if recognizer.state == .ended || recognizer.state == .cancelled
        {
//            resetTouches()
        }
    }
    
    func update()
    {
        print("update visualizer")
    }
    
    //Draw code
}
