//
//  Timeline.swift
//  Tweener
//
//  Created by Alejandro Ramirez Varela on 9/10/18.
//  Copyright © 2018 Alejandro Ramirez Varela. All rights reserved.
//

public enum TimelinePlayMode:Int
{
    case once
    case loop
    case pingPong
}

protocol TimelineObserver: AnyObject {
    func valueChanged(
        _ keyPath: AnyKeyPath
    )
}

public class Timeline
{
    //public vars
    public var playMode : TimelinePlayMode  = .once{
        didSet{
            //Update?
            observer?.valueChanged(\Timeline.playMode)
        }}
    
    public var reverse:Bool = false{
        
        didSet
        {
            //Make sure if value has changed
            if self.reverse != oldValue
            {
                //TODO:Replicate in CocoaTweener
                if TweenList.isAdded(self) && self.timeCurrent > self.timeStart && self.timeCurrent < self.timeComplete
                {
                    //Calculate timestart difference
                    let diff = (self.timeCurrent - self.timeComplete) + (self.timeCurrent - self.timeStart)
                    self.timeStart = self.timeStart + (self.reverse ? diff : -diff)
                    //Update time complete
                    self.timeComplete = self.timeStart + self.duration
                }
                //Call to observer
                observer?.valueChanged(\Timeline.reverse)
            }
        }
    }
    
    public var loops:Int = 0//TODO:Implement functionality
    public var loopCount:Int = 0//TODO:Implement functionality, protected?
    
    //Internal vars
    var duration:Double = 0.0//didset?
    var timeStart:Double = 0.0
    var timeComplete:Double = 0.0
    var timePaused:Double = 0.0
    var timeCurrent:Double = 0.0{didSet{observer?.valueChanged(\Timeline.timeCurrent)}}
    var controls: Array<TweenControl> = []
    var state:TweenState = .initial{didSet{observer?.valueChanged(\Timeline.state)}}
    var lastState:TweenState = .initial
    
    weak var observer: TimelineObserver?
    
    public init(){}

    //MARK:Public functions
    
    public func add<T>(_ tween:Tween<T>)
    {
        let control = Control(tween, time:tween.delay / Engine.timeScale)
        self.controls.append(control)
        updateTimeComplete()
    }
    
    //Play with zero delay
    public func play(){play(0.0)}
    
    //Play with delay
    public func play(_ delay:Double)
    {
        if !TweenList.isAdded(self)
        {
            Tweener.add(self, delay:delay)
        }else
        {
            if self.state == .paused { resume() }
        }
    }
    
    public func pause()
    {
        self.timePaused = self.timeCurrent - self.timeStart
        if self.state != .paused {self.state = .paused}
    }
    
    public func rewind()
    {
        if TweenList.isAdded(self) || self.state == .paused
        {
            //Timeline isn't added or paused, set curret time statically.
            setTime(0.0)
        }
        else
        {
            //Timeline is added and playing, simply remove with stop() and add with play().
            stop()
            play()
        }
    }

    //Set timeline time
    public func setTime(_ currentTime:Double)
    {
        var time = currentTime
        //Set boundaries
        if time < 0.0 {time = 0.0}
        if time > self.duration {time = self.duration}
        
        //reset timestart
        if self.timeStart > 0.0 {self.timeStart = 0.0}
        
        //Update all tweens
        for control in controls {control.update(time)}
        
        //Pause timeline
        if self.state != .paused {self.state = .paused}
        
        //Set time paused
        self.timePaused = time
        self.timeCurrent = time
    }
    
    //MARK:Internal
    
    func resume()
    {
        //Calculate time start
        let timeStart:Double = self.reverse ? -(self.duration - self.timePaused) : -self.timePaused
        //Reset time
        reset(timeStart)
        //Add this id isn't added.
        if !TweenList.isAdded(self) {Tweener.add(self, delay:0.0)}
        //Restore last state.
        self.state = self.lastState
    }
    
    func stop()
    {
        //Set state over to update and remove from engine.
        self.state = .over
    }
    
    func update()
    {
        //Caculate timeline time
        let time:Double = Engine.currentTime - self.timeStart

        //Update all timeline Tweens
        for control in controls
        {
            // Looping throught each Tweening and updating the values accordingly
            if (!self.reverse)
            {
                //Use engine, enable Tween handlers
                let _ : Bool = updateTween(control, time:time)
            }else
            {
                //Update values directly, ignore Tween handlers if timeline direction is reversed
                //TODO:Enable hadlers calculating reverse ranges
                control.update(self.duration - time)
            }
        }
        
        //Set time current
        self.timeCurrent = self.reverse ? (self.timeComplete - time) : Engine.currentTime
    }
    
    func reset(_ delay:Double)
    {
        //Reset time start
        self.timeStart = Engine.currentTime + (delay / Engine.timeScale)
        //Reset time paused
        self.timePaused = 0.0
        //Reset time complete & timeline duration.
        updateTimeComplete()
        
        //Reset each tween
        for control in self.controls
        {
            control.reset()
            //Set start value
            control.update(reverse ? duration : 0.0)
        }
    }
    
    func updateTimeComplete()
    {
        //First set timeStart as initial value.
        self.timeComplete = self.timeStart
        
        var m:Double = 0.0
        //Iterate in all tween controls to get the max time.
        for control in self.controls
        {
            //Update time start and time complete for each control.
            control.timeStart = control.getTween().delay / Engine.timeScale
            //Get max time complete of all tweens.
            m = max(m, control.timeComplete)
        }
        
        //Set timeline duration.
        self.duration = m
        //Set timeline time complete.
        self.timeComplete = self.timeStart + self.duration
    }
    
    public func getDuration() -> Double {return duration}
}
