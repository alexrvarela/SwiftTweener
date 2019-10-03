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
    //Constants
    let TIME_BAR_HEIGHT:CGFloat = 14.0
    let uiColor:UIColor = UIColor(red: 0.0, green: 0.0, blue: 0.75, alpha: 1.0)
    let DARK_ALPHA = UIColor(red: 0.0, green: 0.0, blue: 0.5, alpha: 0.5)
    let LIGHT_ALPHA = UIColor(red: 0.5, green: 0.5, blue: 1.0, alpha: 0.5)
    
    //Variables
    var resize = false
    var scale:CGFloat = 10.0
    var backupScale:CGFloat = 1.0
    var backupFrame:CGRect = CGRect.zero
    //Public
    public var barHeight:CGFloat = 3.0 {didSet{setNeedsDisplay()}}
    public var tweenColor:UIColor = UIColor.cyan {didSet {setNeedsDisplay()}}
    public var timelineColor:UIColor = UIColor.magenta {didSet {setNeedsDisplay()}}
    
    
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
        context.setFillColor(uiColor.cgColor)
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
        context.setFillColor(DARK_ALPHA.cgColor)
  
        //Draw right-half frame
        context.fill(CGRect(x:0.0,
                            y:TIME_BAR_HEIGHT,
                            width:frame.size.width / 2.0,
                            height:frame.size.height - TIME_BAR_HEIGHT))
        
        context.restoreGState()
        
        context.saveGState()

        //TODO:Make energy efficient
        //Draw lines
        for indexSecond in 0 ... steps + 1
        {
            context.setFillColor(DARK_ALPHA.cgColor)
            
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
            
            //Fill
            context.setFillColor(UIColor.white.cgColor)

            //Get Text path
            var textPath = CGPathUtils.getFontPath(string:"\(indexSecond)", fontName:"Menlo-Regular", fontSize:5.0)
            
            //Add
            context.addPath(CGPathUtils.translatePath(path:CGPathUtils.flipPathVertically(path:textPath), x:scale * CGFloat(indexSecond), y:5.0))
            context.fillPath()
            
            //Get Text path
            textPath = CGPathUtils.getFontPath(string:"-\(indexSecond)", fontName:"Menlo-Regular", fontSize:5.0)
            
            //Add
            context.addPath(CGPathUtils.translatePath(path:CGPathUtils.flipPathVertically(path:textPath), x:-(scale * CGFloat(indexSecond)), y:5.0))
            context.fillPath()
        }
        
        context.restoreGState()
        
        //Draw tweens
        context.saveGState()

        var base_y = TIME_BAR_HEIGHT + 1
        
        //Draw tweens
        //TODO:Mix tweens and timelines by time
        for control in TweenList.controls
        {
            //Draw Tween bars
            context.setFillColor(tweenColor.cgColor)
            
            let x = CGFloat(control.state == .paused ? -control.timePaused : control.timeStart - Engine.currentTime) * scale
            
            let path:CGPath =  CGPathUtils.makeRoundRect(rect:CGRect(x:x,
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
            
            let x = CGFloat(timeline.state == .paused ? -timeline.timePaused : timeline.timeStart - Engine.currentTime) * scale

            let path:CGPath =  CGPathUtils.makeRoundRect(rect:CGRect(x:x,
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
        context.setFillColor(DARK_ALPHA.cgColor)
        
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
