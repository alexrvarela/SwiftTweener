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
    let TIME_BAR_HEIGHT:CGFloat = 14.0
    let BLACK_ALPHA = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.5)
    let LIGHT_ALPHA = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.5)
    var resize = false
    
    public var barHeight:CGFloat = 3.0 {didSet{setNeedsDisplay()}}
    public var uiColor:UIColor = UIColor(red:116.0 / 255.0,
                                         green:244.0 / 255.0,
                                         blue:234.0 / 255.0,
                                         alpha:1.0)
    {didSet {setNeedsDisplay()}}
    
    public var timelineColor:UIColor = UIColor(red:255.0 / 255.0,
                                               green:119.0 / 255.0,
                                               blue:208.0 / 255.0,
                                               alpha:1.0)
    {didSet {setNeedsDisplay()}}
    
    var scale:CGFloat = 10.0
    var backupScale:CGFloat = 1.0
    var backupFrame:CGRect = CGRect.zero

    public init() {

        let frame = CGRect(x:10.0,
                           y:10.0,
                           width:200.0,
                           height:75.0)

        super.init(frame:frame)
        
        backgroundColor = UIColor.clear
        clipsToBounds = true
        layer.cornerRadius = 7.0
        
        addGestureRecognizer(UIPinchGestureRecognizer(target: self, action: #selector(pinch)))
        
        let panRecognizer:UIPanGestureRecognizer = UIPanGestureRecognizer(target:self, action:#selector(pan))
        panRecognizer.maximumNumberOfTouches = 1
        addGestureRecognizer(panRecognizer)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    @objc func pinch(recognizer:UIPinchGestureRecognizer)
    {
        if (recognizer.state == .began)
        {
            backupScale = scale
            
        }else if (recognizer.state == .changed)
        {
            scale = round(backupScale * recognizer.scale)
            
            if scale > 200.0 {scale = 200.0}
            if scale < 10.0 {scale = 10.0}
            
            setNeedsDisplay()
        }
    }
    
    @objc func pan(recognizer:UIPanGestureRecognizer)
    {
        let translation = recognizer.translation(in: self)
        
        if recognizer.state == .began
        {
            backupFrame = frame
            if BasicMath.length(start: recognizer.location(ofTouch: 0, in: self),
                                end: CGPoint(x: frame.size.width, y: frame.size.height)) < 40.0
            {
                resize = true
            }
        }
        else if recognizer.state == .changed
        {
            if !resize
            {
                //Drag
                self.frame = CGRect(x: backupFrame.origin.x + translation.x,
                                    y: backupFrame.origin.y + translation.y,
                                    width: frame.size.width,
                                    height: frame.size.height)
            }else
            {
                //Resize
                let newWidth = backupFrame.size.width + translation.x
                let newHeight = backupFrame.size.height + translation.y
                
                self.frame = CGRect(x: frame.origin.x,
                                    y: frame.origin.y,
                                    width: newWidth > 40 ? newWidth : 40,
                                    height: newHeight > 40 ? newHeight : 40)
            }
            
            //Redraw
            setNeedsDisplay()
        }else
        {
            resize = false
        }
    }
    
    func update(){setNeedsDisplay()}
    
    //Draw code
    override public func draw(_ rect: CGRect)
    {
        super.draw(rect)
        
        let context:CGContext = UIGraphicsGetCurrentContext()!
        
        //Draw background fill
        context.saveGState()
        context.setFillColor(LIGHT_ALPHA.cgColor)
        context.fill(rect)
        context.restoreGState()
        
        //Draw Time Bar
        context.saveGState()
        context.setFillColor(UIColor.black.cgColor)
        context.fill(CGRect(x:0.0,
                            y:0.0,
                            width:self.frame.size.width,
                            height:TIME_BAR_HEIGHT))
        
        context.restoreGState()
        
        //Draw time bar gird with numbers as seconds
        let steps = Int(round( (self.frame.size.width / 2) / scale ))
        //        print("draw steps : \(steps))")
        
        //TODO:catch content offset and set index to start
        //Set center
        context.translateBy(x: self.frame.size.width / 2.0,
                            y: 0.0)
        
        context.saveGState()
        //Set fill color
        context.setFillColor(BLACK_ALPHA.cgColor)
  
        //Draw right-half frame
        context.fill(CGRect(x:0.0,
                            y:TIME_BAR_HEIGHT,
                            width:frame.size.width / 2.0,
                            height:frame.size.height - TIME_BAR_HEIGHT))
        
        context.restoreGState()
        
        context.saveGState()

        context.setFillColor(BLACK_ALPHA.cgColor)
        
        //Draw lines
        for indexSecond in 0 ... steps + 1
        {
            //Draw positive line
            context.fill(CGRect(x:scale * CGFloat(indexSecond),
                                y:TIME_BAR_HEIGHT,
                                width:1.0,
                                height:frame.size.height - TIME_BAR_HEIGHT))
            
            //Draw negative line
            context.fill(CGRect(x:-(scale * CGFloat(indexSecond)),
                                y:TIME_BAR_HEIGHT,
                                width:1.0,
                                height:frame.size.height - TIME_BAR_HEIGHT))
        }
        
        /*/
         
         //TODO:Display seconds
         
         //Text paths
         let textPath = CGPathUtils.getFontPath(string:"\(indexSecond)", fontSize:9.0)
         //TODO: center path "x", Bugfix: remove undesired frame.
         let transformTextPath = CGPathUtils.flipPathVertically(path:textPath)
         //Add
         context.addPath(transformTextPath)
         //Fill
         context.setFillColor(uiColor.cgColor)
         context.fillPath()
         */
        
        context.restoreGState()
        
        //Draw tweens
        context.saveGState()

        var base_y = TIME_BAR_HEIGHT + 1
        
        //Draw tweens
        //TODO:Mix tweens and timelines by time
        for control in TweenList.controls
        {
            //Draw Tween bars
            context.setFillColor(uiColor.cgColor)

            let path:CGPath =  CGPathUtils.makeRoundRect(rect:CGRect(x:CGFloat(control.timeStart - Engine.currentTime) * scale,
                                                                     y:base_y,
                                                                     width:CGFloat(control.getTween().duration) * scale,
                                                                     height:barHeight),
                                                         cornerRadius:barHeight/2.0)
            base_y = base_y + barHeight + 1.0
            
            context.addPath(path)
            context.fillPath()
        }
        
        //Draw timelines
        for timeline in TweenList.timelines
        {
            //Draw Tween bars
            context.setFillColor(timelineColor.cgColor)
            
            let path:CGPath =  CGPathUtils.makeRoundRect(rect:CGRect(x:CGFloat(timeline.timeStart - Engine.currentTime) * scale,
                                                                     y:base_y,
                                                                     width:CGFloat(timeline.duration) * scale,
                                                                     height:barHeight),
                                                         cornerRadius:barHeight / 2.0)
            
            base_y = base_y + barHeight + 1.0
            
            context.addPath(path)
            context.fillPath()
        }
        
        context.restoreGState()

        context.saveGState()
        //Set fill color
        context.setFillColor(BLACK_ALPHA.cgColor)
        
        //Draw left-half frame
        context.fill(CGRect(x:-(frame.size.width / 2.0),
                            y:TIME_BAR_HEIGHT,
                            width:frame.size.width / 2.0,
                            height:frame.size.height - TIME_BAR_HEIGHT))
        
        //Draw middle line
        context.setFillColor(UIColor.white.cgColor)
        context.fill(CGRect(x:0.0,
                            y:TIME_BAR_HEIGHT,
                            width:1.0,
                            height:frame.size.height - TIME_BAR_HEIGHT))

        context.restoreGState()
    }
}
