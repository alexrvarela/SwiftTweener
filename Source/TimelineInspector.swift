//
//  TimelineInspector.swift
//  Tweener
//
//  Created by Alejandro Ramirez Varela on 5/28/19.
//  Copyright © 2019 Alejandro Ramirez Varela. All rights reserved.
//

import Foundation

public class TimelineInspector:UIView, TimelineObserver
{
    var _timeline:Timeline?
    
    let CONTROL_BAR_HEIGHT:CGFloat = 40.0
    let TIME_BAR_HEIGHT:CGFloat = 35.0
    let TWEEN_BAR_HEIGHT:CGFloat = 25.0
    
    let SOLID_GRAY = UIColor(red:182.0 / 255.0, green:182.0 / 255.0, blue:182.0 / 255.0, alpha:1.0)
    let TRANSPARENT_SOLID_GRAY = UIColor(red:182.0 / 255.0, green:182.0 / 255.0, blue:182.0 / 255.0, alpha:0.5)
    let TRANSPARENT_LIGHT_GRAY = UIColor(red:182.0 / 255.0, green:182.0 / 255.0, blue:182.0 / 255.0, alpha:0.15)
    let SOLID_RED = UIColor(red:182.0 / 255.0, green:182.0 / 255.0, blue:182.0 / 255.0, alpha:1.0)
    
    public var uiColor:UIColor = UIColor(red:116.0 / 255.0, green:244.0 / 255.0, blue:234.0 / 255.0, alpha:1.0)
    {didSet {setNeedsDisplay()}}
    var line:UIView = UIView()
    var whitespace:UIView = UIView()
    var timeIndicator:UIView = UIView()
    var timeLabel:UILabel = UILabel()
    var playButton:UIControl = UIControl()
    var playModeButton:UIControl = UIControl()
    var directionButton:UIControl = UIControl()
    var stopButton:UIControl = UIControl()
    var logButton:UIControl = UIControl()
    var hideButton:UIControl = UIControl()
    
    var scale:CGFloat = 1.0
    var backupScale:CGFloat = 1.0
    var backupDuration:Double = 0.0
    var backupTimeDelay:Double = 0.0
    var touchArea:Double = -1
    var indexTouched:Int = -1
    var editMode:Int = 0
    
    //TODO:scroll timeline content
    
    var contentOffset:CGPoint = CGPoint.zero
    
    func makePlayIcon(origin:CGPoint) -> UIBezierPath
    {
        let path = UIBezierPath()
        
        path.move(to: CGPoint(x:origin.x - 6.9285, y:origin.y - 8.0))
        path.addLine(to: CGPoint(x:origin.x + 6.9285, y:origin.y))
        path.addLine(to: CGPoint(x:origin.x - 6.9285, y:origin.y + 8.0))
        path.close()
        
        return path
    }
    
    func makePauseIcon(origin:CGPoint) -> UIBezierPath
    {
        let path = UIBezierPath()
    
        path.move(to: CGPoint(x:origin.x - 6, y:origin.y - 8.0))
        path.addLine(to: CGPoint(x:origin.x - 6, y:origin.y + 8.0))
    
        path.move(to: CGPoint(x:origin.x + 6, y:origin.y - 8.0))
        path.addLine(to: CGPoint(x:origin.x + 6, y:origin.y + 8.0))

        return path
    }
    
    func makeRewindIcon(origin:CGPoint) -> UIBezierPath
    {
        let path = UIBezierPath()
        
        path.move(to: CGPoint(x:origin.x - 8, y:origin.y - 8.0))
        path.addLine(to: CGPoint(x:origin.x - 8, y:origin.y + 8.0))
        
        path.move(to: CGPoint(x:origin.x + 8.9285, y:origin.y - 8.0))
        path.addLine(to: CGPoint(x:origin.x - 4.9285, y:origin.y))
        path.addLine(to: CGPoint(x:origin.x + 8.9285, y:origin.y + 8.0))
        path.close()

        return path
    }
    
    func makeStopIcon(origin:CGPoint) -> UIBezierPath
    {
        let path = UIBezierPath()
        
        path.move(to: CGPoint(x:origin.x - 6, y:origin.y - 8.0))
        path.addLine(to: CGPoint(x:origin.x - 6, y:origin.y + 8.0))
        path.addLine(to: CGPoint(x:origin.x + 6, y:origin.y - 8.0))
        path.addLine(to: CGPoint(x:origin.x + 6, y:origin.y + 8.0))
        path.close()
        
        return path
    }
    
    func makePlayOnceIcon(origin:CGPoint) -> UIBezierPath
    {
        let path = UIBezierPath()
        
        path.move(to: CGPoint(x:origin.x, y:origin.y + 6))
        path.addLine(to: CGPoint(x:origin.x, y:origin.y - 6))
        path.addLine(to: CGPoint(x:origin.x - 3, y:origin.y - 6))
        
        path.move(to: CGPoint(x:origin.x - 4, y:origin.y + 6))
        path.addLine(to: CGPoint(x:origin.x + 4, y:origin.y + 6))
        
        path.close()
        
        return path
    }
    
    func makeLoopIcon(origin:CGPoint) -> UIBezierPath
    {
        let path = UIBezierPath()
    
        path.move(to: CGPoint(x:origin.x + 6, y:origin.y - 4))
        path.addLine(to: CGPoint(x:origin.x - 13, y:origin.y - 4))
        path.addLine(to: CGPoint(x:origin.x - 13, y:origin.y))
        
        path.move(to: CGPoint(x:origin.x - 13 - 3.4635, y:origin.y))
        path.addLine(to: CGPoint(x:origin.x - 13, y:origin.y + 6))
        path.addLine(to: CGPoint(x:origin.x - 13 + 3.4635, y:origin.y))
        path.close()
        
        path.move(to: CGPoint(x:origin.x - 6, y:origin.y + 4))
        path.addLine(to: CGPoint(x:origin.x + 13, y:origin.y + 4))
        path.addLine(to: CGPoint(x:origin.x + 13, y:origin.y))
        
        path.move(to: CGPoint(x:origin.x + 13 - 3.4635, y:origin.y))
        path.addLine(to: CGPoint(x:origin.x + 13, y:origin.y - 6))
        path.addLine(to: CGPoint(x:origin.x + 13 + 3.4635, y:origin.y))
        path.close()
    
        return path
    }
    
    func makePingPongIcon(origin:CGPoint) -> UIBezierPath
    {
        let path = UIBezierPath()
        
        path.move(to: CGPoint(x:origin.x - 10, y:origin.y))
        path.addLine(to: CGPoint(x:origin.x + 10, y:origin.y))
        
        path.move(to: CGPoint(x:origin.x + 10, y:origin.y - 3.4635))
        path.addLine(to: CGPoint(x:origin.x + 16, y:origin.y))
        path.addLine(to: CGPoint(x:origin.x + 10, y:origin.y + 3.4635))
        path.close()
        
        path.move(to: CGPoint(x:origin.x - 10, y:origin.y - 3.4635))
        path.addLine(to: CGPoint(x:origin.x - 16, y:origin.y))
        path.addLine(to: CGPoint(x:origin.x - 10, y:origin.y + 3.4635))
        path.close()
        
        return path
    }
    
    func makeFowardIcon(origin:CGPoint) -> UIBezierPath
    {
        let path = UIBezierPath()
        
        path.move(to: CGPoint(x:origin.x - 13, y:origin.y))
        path.addLine(to: CGPoint(x:origin.x + 7, y:origin.y))
        
        path.move(to: CGPoint(x:origin.x + 7, y:origin.y - 3.4635))
        path.addLine(to: CGPoint(x:origin.x + 13, y:origin.y))
        path.addLine(to: CGPoint(x:origin.x + 7, y:origin.y + 3.4635))
        path.close()
        
        return path
    }
    
    func makeBackwardIcon(origin:CGPoint) -> UIBezierPath
    {
        let path = UIBezierPath()
        
        path.move(to: CGPoint(x:origin.x - 7, y:origin.y))
        path.addLine(to: CGPoint(x:origin.x + 13, y:origin.y))
        
        path.move(to: CGPoint(x:origin.x - 7, y:origin.y - 3.4635))
        path.addLine(to: CGPoint(x:origin.x - 13, y:origin.y))
        path.addLine(to: CGPoint(x:origin.x - 7, y:origin.y + 3.4635))
        path.close()
        
        return path
    }
    
    func makeLogIcon(origin:CGPoint) -> UIBezierPath
    {
        let path = UIBezierPath()
        
        path.move(to: CGPoint(x:origin.x - 14.0, y:origin.y - 8.0))
        path.addLine(to: CGPoint(x:origin.x - 2.0, y:origin.y))
        path.addLine(to: CGPoint(x:origin.x - 14.0, y:origin.y + 8.0))
        
        path.move(to: CGPoint(x:origin.x + 2.0, y:origin.y + 8.0))
        path.addLine(to: CGPoint(x:origin.x + 14.0, y:origin.y + 8.0))
        
        return path
    }
    
    func makeHideIcon(origin:CGPoint) -> UIBezierPath
    {
        let path = UIBezierPath()
        
        path.move(to: CGPoint(x:origin.x - 12.0, y:origin.y - 6.0))
        path.addLine(to: CGPoint(x:origin.x, y:origin.y + 6.0))
        path.addLine(to: CGPoint(x:origin.x + 12.0, y:origin.y - 6.0))
        
        return path
    }
    
    func makeShowIcon(origin:CGPoint) -> UIBezierPath
    {
        let path = UIBezierPath()
        
        path.move(to: CGPoint(x:origin.x - 12.0, y:origin.y + 6.0))
        path.addLine(to: CGPoint(x:origin.x, y:origin.y - 6.0))
        path.addLine(to: CGPoint(x:origin.x + 12.0, y:origin.y + 6.0))
        
        return path
    }
    
    func makeShapeLayer(path:UIBezierPath) -> CAShapeLayer
    {
        let shapeLayer:CAShapeLayer = CAShapeLayer()
        
        shapeLayer.fillColor = nil
        shapeLayer.strokeColor = SOLID_GRAY.cgColor
        shapeLayer.borderWidth = 2.0
        shapeLayer.path = path.cgPath
        shapeLayer.isHidden = true
        
        return shapeLayer
    }
    
    //MARK:initializer
    
    public init() {

        let h = CONTROL_BAR_HEIGHT + TIME_BAR_HEIGHT + TWEEN_BAR_HEIGHT * 4.0
        
        let frame = CGRect(x:0.0,
                           y:0.0,
                           width:UIScreen.main.bounds.size.width,
                           height:h)
        
        super.init(frame:frame)
        
        backgroundColor = UIColor.white
        
        scale = 100
        
        //TODO:use UIScrollView to navigate
        addGestureRecognizer(UIPinchGestureRecognizer(target: self, action: #selector(pinch)))
        
        let panRecognizer:UIPanGestureRecognizer = UIPanGestureRecognizer(target:self, action:#selector(pan))
        
        panRecognizer.maximumNumberOfTouches = 1
        addGestureRecognizer(panRecognizer)

        
        //setup buttons
        line.frame = CGRect(x:0.0,
                                 y:CONTROL_BAR_HEIGHT,
                                 width:1.0,
                                 height:self.frame.size.height - CONTROL_BAR_HEIGHT)
        line.isUserInteractionEnabled = false
        line.backgroundColor = SOLID_GRAY
        
        addSubview(line)
        
        whitespace.frame = CGRect(x:0.0,
                                  y:CONTROL_BAR_HEIGHT + TIME_BAR_HEIGHT,
                                  width:self.frame.size.width,
                                  height:self.frame.size.height - CONTROL_BAR_HEIGHT - TIME_BAR_HEIGHT)
        whitespace.isUserInteractionEnabled = false
        whitespace.backgroundColor = UIColor(red:1.0, green:1.0, blue:1.0, alpha:0.5)
        addSubview(whitespace)
        
        timeIndicator.frame = CGRect(x:0.0,
                                     y:CONTROL_BAR_HEIGHT,
                                     width:15.0,
                                     height:7.0)
        
        //Make polygon
        let shape = CAShapeLayer()
        shape.fillColor = SOLID_GRAY.cgColor
        
        let path = UIBezierPath()
        path.move(to: CGPoint(x:0.0, y:0.0))
        path.addLine(to: CGPoint(x:15.0, y:0.0))
        path.addLine(to: CGPoint(x:7.5, y:7.0))
        
        shape.path = path.cgPath
        
        timeIndicator.layer.addSublayer(shape)
        addSubview(timeIndicator)
        
        let buttonWidth:CGFloat = frame.size.width / 7.0
        let centerShape = CGPoint(x:buttonWidth / 2.0, y:CONTROL_BAR_HEIGHT / 2.0)
        
        //PLAY/PAUSE CONTROL
        playButton.frame = CGRect(x:0.0,
                                  y:0.0,
                                  width:buttonWidth,
                                  height:CONTROL_BAR_HEIGHT)

        playButton.addTarget(self, action: #selector(playAction), for: .touchUpInside)
        playButton.backgroundColor = TRANSPARENT_LIGHT_GRAY
        playButton.layer.addSublayer(makeShapeLayer(path:makePlayIcon(origin:centerShape)))
        playButton.layer.addSublayer(makeShapeLayer(path:makePauseIcon(origin:centerShape)))
        playButton.layer.sublayers![0].isHidden = false//show first by default
        addSubview(playButton)
        
        //PLAY MODE CONTROL
        playModeButton.frame = CGRect(x:buttonWidth + 1.0,
                                      y:0.0,
                                      width:buttonWidth,
                                      height:CONTROL_BAR_HEIGHT)
        playModeButton.backgroundColor = TRANSPARENT_LIGHT_GRAY
        playModeButton.addTarget(self, action:#selector(playModeAction), for:.touchUpInside)
        playModeButton.layer.addSublayer(makeShapeLayer(path:makePlayOnceIcon(origin:centerShape)))
        playModeButton.layer.addSublayer(makeShapeLayer(path:makeLoopIcon(origin:centerShape)))
        playModeButton.layer.addSublayer(makeShapeLayer(path: makePingPongIcon(origin:centerShape)))
        
        playModeButton.layer.sublayers![0].isHidden = false//show first by default
        
        addSubview(playModeButton)
        
        //DIRECTION CONTROL
        directionButton.frame = CGRect(x:(buttonWidth + 1.0) * 2.0,
                                       y:0.0,
                                       width:buttonWidth,
                                       height:CONTROL_BAR_HEIGHT)
        directionButton.backgroundColor = TRANSPARENT_LIGHT_GRAY
        directionButton.addTarget(self, action:#selector(playDirectionAction), for:.touchUpInside)
        directionButton.layer.addSublayer(makeShapeLayer(path:makeFowardIcon(origin:centerShape)))
        directionButton.layer.addSublayer(makeShapeLayer(path:makeBackwardIcon(origin:centerShape)))
        
        directionButton.layer.sublayers![0].isHidden = false//show first by default
        
        addSubview(directionButton)

        
        timeLabel.frame = CGRect(x:(buttonWidth + 1.0) * 3.0,
                                 y:0.0,
                                 width:buttonWidth,
                                 height:CONTROL_BAR_HEIGHT)
        timeLabel.font = UIFont.init(name:"Menlo-Regular", size:12.0)
        timeLabel.textColor = SOLID_GRAY
        timeLabel.text = "00:00"
        timeLabel.textAlignment = .center
        addSubview(timeLabel)
        
        //STOP/REWIND CONTROL
        stopButton.frame = CGRect(x:(buttonWidth + 1.0) * 4.0,
                                       y:0.0,
                                       width:buttonWidth,
                                       height:CONTROL_BAR_HEIGHT)
        stopButton.addTarget(self, action:#selector(stopAction), for:.touchUpInside)
        stopButton.backgroundColor = TRANSPARENT_LIGHT_GRAY
        stopButton.layer.addSublayer(makeShapeLayer(path:makeRewindIcon(origin:centerShape)))
        stopButton.layer.addSublayer(makeShapeLayer(path:makeStopIcon(origin:centerShape)))
        stopButton.layer.sublayers![0].isHidden = false//show first by default
        addSubview(stopButton)
        
        logButton.frame = CGRect(x:(buttonWidth + 1.0) * 5.0,
                                 y:0.0,
                                 width:buttonWidth,
                                 height:CONTROL_BAR_HEIGHT)
        logButton.addTarget(self, action:#selector(logAction), for:.touchUpInside)
        logButton.layer.addSublayer(makeShapeLayer(path:makeLogIcon(origin:centerShape)))
        logButton.backgroundColor = TRANSPARENT_LIGHT_GRAY
        logButton.layer.sublayers![0].isHidden = false//show first by default
        addSubview(logButton)
        
        hideButton.frame = CGRect(x:(buttonWidth + 1.0) * 6.0,
                                  y:0.0,
                                  width:buttonWidth,
                                  height:CONTROL_BAR_HEIGHT)
        hideButton.addTarget(self, action:#selector(hideAction), for:.touchUpInside)
        hideButton.layer.addSublayer(makeShapeLayer(path:makeHideIcon(origin:centerShape)))
        hideButton.layer.addSublayer(makeShapeLayer(path:makeShowIcon(origin:centerShape)))
        hideButton.backgroundColor = TRANSPARENT_LIGHT_GRAY
        hideButton.layer.sublayers![0].isHidden = false//show first by default
        addSubview(hideButton)
        
        contentOffset = CGPoint.zero
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    //init with timeline
    public convenience init(timeline:Timeline)
    {
        self.init()
        self.timeline = timeline
    }
    
    override public func didMoveToSuperview() {

        if(superview != nil)
        {
            let h = CONTROL_BAR_HEIGHT + TIME_BAR_HEIGHT + TWEEN_BAR_HEIGHT * 4.0
            
            self.frame = CGRect(x:0.0,
                                y:superview!.frame.size.height - h,
                                width:superview!.frame.size.width,
                                height:h)
        }
    }
    
    public var timeline:Timeline
    {
        set{
            if _timeline != nil
            {
                //Remove observers
                _timeline!.observer = nil
            }
            
            //guard?
            _timeline = newValue
            
            if (_timeline != nil)
            {
                timeline.observer = self
                updatePlayButtonIcons()
            }
            else
            {
                return//release timeline
            }
            
            //self.duration = _timeline.timeComplete
            setNeedsDisplay()
            
            updateTimeLocation()
            updateTimeLabel()
            updatePlayButtonIcons()
            updatePlayModeIcons()
        }
        get{ return _timeline!}
    
    }
    
    //MARK: - Draw
    
    override public func draw(_ rect: CGRect)
    {
        super.draw(rect)
        
        let context:CGContext = UIGraphicsGetCurrentContext()!
        
        //Draw Time Bar
        context.saveGState()
        
        let components = uiColor.cgColor.components!
        let colorWithAlpha = UIColor(red: components[0], green: components[1], blue: components[2], alpha: 0.25)
        context.setFillColor(colorWithAlpha.cgColor)
        context.fill(CGRect(x:0.0,
                            y:CONTROL_BAR_HEIGHT,
                            width:self.frame.size.width,
                            height:TIME_BAR_HEIGHT))
        
        context.restoreGState()
        
        //Draw time bar gird with numbers as seconds
        let steps = Int(round( (self.frame.size.width ) / scale ))
        //        print("draw steps : \(steps))")
        
        //TODO:catch content offset and set index to start
        
        context.saveGState()
        context.setFillColor(uiColor.cgColor)
        
        //draw lines
        for indexSecond in 0 ... steps + 1
        {
            //Translate
            if indexSecond != 0{context.translateBy(x: scale, y: 0.0)}
            
            //Add 1/2 line
            var lineHeigth = TIME_BAR_HEIGHT / 2.0
            context.fill(CGRect(x:0,
                                y:CONTROL_BAR_HEIGHT + TIME_BAR_HEIGHT - lineHeigth,
                                width:1.0,
                                height:lineHeigth))
            
            //Add 1/4 line
            lineHeigth = TIME_BAR_HEIGHT / 4.0
            context.fill(CGRect(x:scale / 2.0,
                                y:CONTROL_BAR_HEIGHT + TIME_BAR_HEIGHT - lineHeigth,
                                width:1.0,
                                height:lineHeigth))
            
            //Add 1/8 lines
            lineHeigth = TIME_BAR_HEIGHT / 8.0
            context.fill(CGRect(x:scale / 4.0,
                                y:CONTROL_BAR_HEIGHT + TIME_BAR_HEIGHT - lineHeigth,
                                width:1.0,
                                height:lineHeigth))
            
            context.fill(CGRect(x:scale / 2.0 + scale / 4.0,
                                y:CONTROL_BAR_HEIGHT + TIME_BAR_HEIGHT - lineHeigth,
                                width:1.0,
                                height:lineHeigth))
        }
        
        context.restoreGState()
        context.saveGState()
        
        context.setFillColor(self.uiColor.cgColor)
        context.translateBy(x: -6.0, y: CONTROL_BAR_HEIGHT + 5.0)
        
        //draw lines
        for indexSecond in 0 ... steps + 1
        {
            //Text paths
            let textPath = CGPathUtils.getFontPath(string:"\(indexSecond)", fontName:"Menlo-Regular", fontSize:12.0)
            let transformTextPath = CGPathUtils.flipPathVertically(path:textPath)
         
            //Translate
            if indexSecond != 0
            {
                //TODO: center path "x"
                context.translateBy(x: scale, y: 0.0)
            }
            
            //Add
            context.addPath(transformTextPath)
            
            //Fill
            context.fillPath()
        }
        
        context.restoreGState()
        
        //Draw tweens
        context.saveGState()
        
        //TODO:if timeline == nil display message "Add timeline to inspect"
        //TODO: add offset
        let base_y = CONTROL_BAR_HEIGHT + TIME_BAR_HEIGHT
        
        for (index, control) in timeline.controls.enumerated()
        {
            //Draw Tween bars
            let alphaColor = UIColor(red:components[0], green:components[1], blue:components[2], alpha:0.5)
            context.setFillColor(index == indexTouched ? alphaColor.cgColor : uiColor.cgColor)
            
//            let path:CGPath = CGPath(roundedRect: CGRect(x:CGFloat(control.getTween().delay) * scale,
//                                       y:base_y + (TWEEN_BAR_HEIGHT * CGFloat(index)) + 1.0,
//                                       width:CGFloat(control.getTween().duration) * scale,
//                                       height:TWEEN_BAR_HEIGHT - 1.0),
//                   cornerWidth: 5.0,
//                   cornerHeight: 5.0,
//                   transform: nil)
            
            let path:CGPath =  CGPathUtils.makeRoundRect(rect:CGRect(x:CGFloat(control.getTween().delay) * scale,
                                                         y:base_y + (TWEEN_BAR_HEIGHT * CGFloat(index)) + 1.0,
                                                         width:CGFloat(control.getTween().duration) * scale,
                                                         height:TWEEN_BAR_HEIGHT - 1.0),
                                             cornerRadius:5.0)
            context.addPath(path)
            context.fillPath()
        }
        
        context.restoreGState()
        
        //draw time locations
        context.saveGState()
        
        if (indexTouched != -1)
        {
            let control = timeline.controls[indexTouched]
            let drawStart:Bool = (editMode == 0 || editMode == 2)
            let drawEnd:Bool = (editMode == 0 || editMode == 1)
            
            //draw red lines!!!
            //set fill color 255 119 208
            context.setFillColor(UIColor(red:255.0 / 255.0,
                                         green:119.0 / 255.0,
                                         blue:208.0 / 255.0,
                                         alpha:1.0).cgColor)
            
            if(drawStart)
            {
                context.fill(CGRect(x:CGFloat(control.getTween().delay) * scale,
                                    y:CONTROL_BAR_HEIGHT,
                                    width:1.0,
                                    height:TIME_BAR_HEIGHT))
            }
            
            if(drawEnd)
            {
                context.fill(CGRect(x:CGFloat(control.getTween().delay + control.getTween().duration) * scale,
                                    y:CONTROL_BAR_HEIGHT,
                                    width:1.0,
                                    height:TIME_BAR_HEIGHT))
            }
        }
        
        context.restoreGState()
    }


    //MARK: - Gesture recognizers
    @objc func pinch(recognizer:UIPinchGestureRecognizer)
    {
        if recognizer.state == .began
        {
            backupScale = scale
            
        }else if recognizer.state == .changed
        {
            
            scale = round(backupScale * recognizer.scale)
            
            if scale > 200.0 {scale = 200.0}
            if scale < 20.0 {scale = 20.0}
            
            setNeedsDisplay()
            updateTimeLabel()
            updateTimeLocation()
        }
        else if recognizer.state == .ended || recognizer.state == .cancelled
        {
            resetTouches()
        }
    }
    
    @objc func pan(recognizer:UIPanGestureRecognizer)
    {
        //TODO:
        var p = CGPoint.zero
        let translation = recognizer.translation(in: self)
        
        if recognizer.numberOfTouches > 0 {p = recognizer.location(ofTouch: 0, in: self)}
        
        if recognizer.state == .began
        {
            //print("began")
        }
        else if recognizer.state == .changed
        {
            
            if(touchArea == 0)
            {
                //print("pan controls")
            }
            else if(touchArea == 1)
            {
                let currentTime = p.x / scale
                timeline.setTime(Double(currentTime))
            }
            else if touchArea == 2
            {
                if indexTouched != -1
                {
                    let control = timeline.controls[indexTouched]
                    
                    if (editMode == 1)
                    {
                        //change duration
                        let newDuration = backupDuration + Double(translation.x / scale)
                        control.getTween().duration = (newDuration < 0.1) ? 0.1 : newDuration
                    }
                    else if (self.editMode == 2)
                    {
                        //change booth
                        let newDelay = backupTimeDelay + Double(translation.x / self.scale)
                        let newDuration = backupDuration - Double(translation.x / self.scale)
                        
                        if (newDelay < ((self.backupTimeDelay + self.backupDuration) - 0.1))
                        {
                            control.getTween().delay = (newDelay < 0.0) ? 0.0 : newDelay
                            control.getTween().duration = newDuration
                        }
                    }
                    else
                    {
                        //change time delay
                        let newDelay = self.backupTimeDelay + Double(translation.x / self.scale)
                        control.getTween().delay = (newDelay < 0.0) ? 0.0 : newDelay
                    }
                    
                    control.timeStart = control.getTween().delay / Engine.timeScale//refresh controller
                    timeline.setTime(timeline.timeCurrent)//update tween
                    setNeedsDisplay()//redraw
                }else
                {
                    print("pan content offset")
                }
            }
            
        }else if (recognizer.state == .ended || recognizer.state == .cancelled)
        {
            resetTouches()
        }
    }
    
    //MARK: - Touches
    
    override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        if _timeline == nil {return}
        
        let touch = touches.first!
        let p = touch.location(in: self)
        
        if CGRect(x:0.0,
                  y:0.0,
                  width:self.frame.size.width,
                  height:CONTROL_BAR_HEIGHT).contains(p)
        {
            //touch controls
            self.touchArea = 0
        }
        else if CGRect(x:0.0,
                       y:CONTROL_BAR_HEIGHT,
                       width:frame.size.width,
                       height:TIME_BAR_HEIGHT).contains(p)
        {
            //touch timebar
            self.touchArea = 1
            
            if TweenList.isAdded(timeline) {timeline.pause()}
            //if(self.timeline.state != kTimelineStatePaused)[self.timeline pause]
            
            let time = p.x / self.scale
            timeline.setTime(Double(time))
        }
        else
        {
            //touch tween bars
            self.touchArea = 2
            
            let base_y = CONTROL_BAR_HEIGHT + TIME_BAR_HEIGHT
            
            for(index, control) in timeline.controls.enumerated()
            {
                
                let edgeTolerance:CGFloat = 10.0
                
                if CGRect(x:CGFloat(control.getTween().delay) * self.scale - edgeTolerance,
                          y:base_y + (TWEEN_BAR_HEIGHT * CGFloat(index)) + 1.0,
                          width:CGFloat(control.getTween().duration) * self.scale + edgeTolerance * 2.0,
                          height:TWEEN_BAR_HEIGHT - 1.0).contains(p)
                {
                    
                    indexTouched = index
                    
                    //pause timeline if is playing
                    if TweenList.isAdded(timeline) {timeline.pause()}
                    backupTimeDelay = control.getTween().delay
                    backupDuration = control.getTween().duration
                    //then, detect if touch is near to rieght corner
                    
                    let x_start = CGFloat(control.getTween().delay) * self.scale
                    let start_x_distance = p.x - x_start
                    
                    let x_end = CGFloat(control.getTween().delay + control.getTween().duration) * self.scale
                    let end_x_distance = p.x - x_end
                    
                    editMode = 0//move
                    
                    if end_x_distance < edgeTolerance &&  end_x_distance > -edgeTolerance
                    {
                        //edit end
                        editMode = 1
                    }else if start_x_distance < edgeTolerance &&  start_x_distance > -edgeTolerance
                    {
                        //edit start
                        editMode = 2
                    }
                    
                    break
                }
            }
            if self.indexTouched != -1 {setNeedsDisplay()}//redraw data
        }
    }
    
    override public func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        resetTouches()
    }
    
    func resetTouches()
    {
        //print("reset touches")
        
        if self.indexTouched != -1
        {
            self.timeline.reset(self.timeline.timeStart)
            setNeedsDisplay()//redraw data
        }
        
        self.indexTouched = -1
    }

    
    //MARK:Button actions
    
    @objc func playAction()
    {
        if TweenList.isAdded(self.timeline) && self.timeline.state != .paused
        {
            self.timeline.pause()
        }
        else
        {
            self.timeline.play()
        }
    }
    

    @objc func stopAction()
    {
        self.timeline.rewind()
    }

    func updatePlayButtonIcons()
    {
        let stopped:Bool = timeline.state == .paused || timeline.state == .over || timeline.state == .initial
        playButton.layer.sublayers![0].isHidden = !stopped
        playButton.layer.sublayers![1].isHidden = stopped
    }
    
    func updatePlayModeIcons()
    {
    
        for layer in playModeButton.layer.sublayers!
        {
            layer.isHidden = true
        }
    
        playModeButton.layer.sublayers![timeline.playMode.rawValue].isHidden = false
    
    }
    
    func updateDirectionIcons()
    {
        directionButton.layer.sublayers![0].isHidden = self.timeline.reverse
        directionButton.layer.sublayers![1].isHidden = !self.timeline.reverse
    }
    
    @objc func playModeAction()
    {
        //TODO:guard?
        timeline.playMode = timeline.playMode.rawValue <
            TimelinePlayMode.pingPong.rawValue ?
                TimelinePlayMode(rawValue: timeline.playMode.rawValue + 1)! :
            .once
    }
    
    @objc func playDirectionAction()
    {
        timeline.reverse = !timeline.reverse
    }
    
    @objc func logAction()
    {
        print("Log timeline's tweens code:")
        
        var logString:String = String()
        for (index, control) in timeline.controls.enumerated()
        {
            let tweenName = "tween\(index)"
            
            //initial values
            var values = String()
            
            //    //keys
            var keys = "[\n"
            let keysCount = control.getKeys().count
            
            for (indexKey, key) in control.getKeys().enumerated()
            {
                let rootType = type(of: key.key).rootType
                let valueType = type(of: key.key).valueType
                
                print("key \(key.key)")
                print("root type \(rootType)")
                print("value type \(valueType)")
                
                //TODO:Get keyName
                let keyName = "keyname"
                
                let keyPath = "\\\(rootType).\(keyName)"

                values += "[target].\(keyName) = \(key.value.start)\n"//todo format value
                
                keys += "   "
                keys += "\(keyPath)\" : \(key.value.complete)"//todo format
                //Avoid "," in last object
                keys += (indexKey < keysCount - 1 ? ",\n" : "\n")
                
            }
            
            keys += "]\n"
            
            //tween  params
            
            logString += """
            let \(tweenName) = Tween(target:[target]\n
            duration:\(control.getTween().duration)\n\
            ease:\(control.getTween().ease)\n\
            keys:keys\n\
            delay:\(control.getTween().delay)\n\
            )\n
            """
            
//            print("\(values)\n")
//            print("\(keys)\n")
        }
        
        print("\(logString)\n")
    }
    
    @objc func hideAction()
    {
        if(superview != nil)
        {
            let y = frame.origin.y !=  superview!.frame.size.height - CONTROL_BAR_HEIGHT ?
                superview!.frame.size.height - CONTROL_BAR_HEIGHT :
                superview!.frame.size.height - frame.size.height
            
            self.frame = CGRect(x:0.0,
                                y:y,
                                width:superview!.frame.size.width,
                                height:frame.size.height)
        }
    }
    
    //MARK: - Observers
    func valueChanged(_ keyPath: AnyKeyPath)
    {
        if keyPath == \Timeline.timeCurrent
        {
            updateTimeLabel()
            updateTimeLocation()
        }
        else if keyPath == \Timeline.state
        {
            updatePlayButtonIcons()
        }
        else if keyPath == \Timeline.playMode
        {
            updatePlayModeIcons()
        }
        else if keyPath == \Timeline.reverse
        {
            updateDirectionIcons()
        }
    }

    func updateTimeLabel()
    {
        let time = self.timeline.timeCurrent - self.timeline.timeStart
        let seconds = Int(time.truncatingRemainder(dividingBy: 60))
        let milliseconds = (time - Double(seconds))  * 100
        self.timeLabel.text = String(format:"%02i:%02i", Int(seconds), Int(milliseconds))
    }
    
    func updateTimeLocation()
    {
        //update location
        let timeLocation = CGFloat(self.timeline.timeCurrent - self.timeline.timeStart) * self.scale
        
        timeIndicator.frame = CGRect(x:timeLocation - timeIndicator.frame.size.width / 2.0,
                                     y:timeIndicator.frame.origin.y,
                                     width:timeIndicator.frame.size.width,
                                     height:timeIndicator.frame.size.height)
        
        line.frame = CGRect(x:timeLocation,
                            y:line.frame.origin.y,
                            width:line.frame.size.width,
                            height:line.frame.size.height)
        
        whitespace.frame = CGRect(x:timeLocation,
                                  y:whitespace.frame.origin.y,
                                  width:whitespace.frame.size.width,
                                  height:whitespace.frame.size.height)
    
    }
}
