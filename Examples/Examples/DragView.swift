//
//  DragView.swift
//  Examples
//
//  Created by Alejandro Ramirez Varela on 6/6/19.
//  Copyright © 2019 Alejandro Ramirez Varela. All rights reserved.
//

import UIKit
import Tweener

class DragView:UIView
{
    var dragView:UIView?
    var frameOrigin:CGPoint = CGPoint.zero
    var viewIndex:Int = -1
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        
        backgroundColor = UIColor(red:55.0/255.0, green:65.0/255.0, blue:80.0/255, alpha:1.0)

        //Set color list
        let colors:Array<UIColor> = [UIColor(red:255.0/255.0, green:120.0/255.0, blue:180.0/255, alpha:1.0),
                                      UIColor(red:80.0/255.0, green:220.0/255.0, blue:170.0/255, alpha:1.0),
                                      UIColor(red:110.0/255.0, green:100.0/255.0, blue:240.0/255, alpha:1.0)]
        
        //Create assets
        
        for (index, color) in colors.enumerated()
        {
            let view:PDFImageView = PDFImageView()
            view.loadFromBundle("card")
            view.scale = Double((self.frame.size.width - 40.0) / view.frame.size.width)
            view.frame = CGRect(x:20.0,
                                y:20.0 + (view.frame.size.height + 20.0) * CGFloat(index),
                                width:view.frame.size.width,
                                height:view.frame.size.height)
            view.backgroundColor = color
            view.layer.cornerRadius = 10.0
            addSubview(view)
        }
        
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
        var p:CGPoint = CGPoint.zero
        let translation:CGPoint = recognizer.translation(in: self)
        
        if recognizer.numberOfTouches > 0 { p = recognizer.location(ofTouch: 0, in: self)
            
            if recognizer.state == .began
            {
                for (index, view) in subviews.enumerated()
                {
                    if (view.frame.contains(p))
                    {
                        dragView = view
                        viewIndex = index
                        frameOrigin = view.frame.origin
                        break
                    }
                }
            }
            else if recognizer.state == .changed
            {
                if dragView != nil
                {
                    dragView!.frame = CGRect(x:frameOrigin.x + translation.x,
                                                  y:frameOrigin.y + translation.y,
                                                  width:dragView!.frame.size.width,
                                                  height:dragView!.frame.size.height)
                    
                    var currentIndex:Int = viewIndex
                    
                    for index:Int in 0 ... subviews.count - 1
                    {
                        let _y:CGFloat = 20.0 + (dragView!.frame.size.height + 20.0) * CGFloat(index) + dragView!.frame.size.height
                        
                        if (dragView!.frame.origin.y < _y)
                        {
                            currentIndex = index
                            break
                        }
                    }
                    
                    if currentIndex != viewIndex
                    {
                        //Swap
                        viewIndex = currentIndex
                        insertSubview(dragView!, at:currentIndex)
                        alingViews()
                    }
                }
            }
        }else
        {
            //Touches ended
            dragView = nil
            alingViews()
        }
    }
    
    func alingViews()
    {
        for (index, view) in subviews.enumerated()
        {
            if dragView == nil || viewIndex != index
            {
                let destinationFrame:CGRect = CGRect(x:20.0,
                                                     y:20.0 + (view.frame.size.height + 20.0) * CGFloat(index),
                                                     width:view.frame.size.width,
                                                     height:view.frame.size.height)
                //Animate.
                Tween(target:view,
                      duration:0.25,
                      ease:.outQuad,
                      to:[.key(\.frame, destinationFrame)]).play()
            }
            
        }
    }
}
