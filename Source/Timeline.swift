//
//  Timeline.swift
//  Tweener
//
//  Created by Alejandro Ramirez Varela on 9/10/18.
//  Copyright © 2018 Alejandro Ramirez Varela. All rights reserved.
//

/// A Timeline's set of play options.
public enum TimelinePlayMode:Int{
    ///Play once, then remove.
    case once
    //TODO: Add loop-count option.
    ///Play repeating forever.
    case loop
    ///Play forward and reverse forever.
    case pingPong
}

///Observe changes.
protocol TimelineObserver: AnyObject {
    func valueChanged(
        _ keyPath: AnyKeyPath
    )
}
/// A class that contains and controls a collection of Tweens.
public class Timeline
{
    ///Value observer protocol.
    weak var observer: TimelineObserver?
    
    /// TimelinePlayMode option, .once is setted by default.
    public var playMode : TimelinePlayMode  = .once{
        didSet{
            observer?.valueChanged(\Timeline.playMode)
        }}
    
    ///Changes animation direction.
    public var reverse:Bool = false{
        didSet
        {
            //Ensures that value has changed.
            if self.reverse != oldValue
            {
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
    
    //public var loops:Int = 0//TODO:Implement functionality
    //public var loopCount:Int = 0//TODO:Implement functionality, protected?
    
    //Internal vars
    var duration:Double = 0.0//didset?
    var timeStart:Double = 0.0
    var timeComplete:Double = 0.0
    var timePaused:Double = 0.0
    var timeCurrent:Double = 0.0{didSet{observer?.valueChanged(\Timeline.timeCurrent)}}
    var controls: Array<TweenControl> = []
    var state:TweenState = .initial{didSet{observer?.valueChanged(\Timeline.state)}}
    var lastState:TweenState = .initial
    
    
    /**Internal function wich adds a Tween<T> to engine.
     - Parameter tween: A Tween<T> instance to add.
    */
    func addTween<T>(_ tween:Tween<T>){
           let control = Control(tween, time:tween.delay / timeScale)
           self.controls.append(control)
           updateTimeComplete()
    }
    
    /**Initilalizer.
     - Parameter tweens:    Optional, adds as many Tweens as there are.
     */
    public init(_ tweens:AnyTween... ){ for tween in tweens { tween.stop(); tween.add(to: self) } }
    
    //MARK:Public functions
    
    /**Add Tweens function.
     - Parameter tweens:    Adds as many Tweens as there are using declarative syntax.
     - Returns:             Current`Timeline` instance.
     */
    @discardableResult public func add(_ tweens:AnyTween... ) -> Timeline {
        for tween in tweens { tween.stop(); tween.add(to: self) }
        return self
    }
    
    /**Sets TimelinePlayMode option using declarative syntax.
     - Parameter playMode:  TimelinePlayMode option.
     - Returns:             Current`Timeline` instance.
     */
    @discardableResult public func mode(_ playMode: TimelinePlayMode) -> Timeline {
        self.playMode = playMode
        return self
    }
    
    /**Plays with zero-time delay.
     - Returns:             Current`Timeline` instance.
     */
    @discardableResult public func play() -> Timeline { return play(0.0) }
    
    /**Plays with time delay.
     - Returns:             Current`Timeline` instance.
     - Parameter delay:     Time to delay after animation starts.
     */
    @discardableResult public func play(_ delay:Double) -> Timeline{
        
        if !TweenList.isAdded(self)
        {
            Tweener.add(self, delay:delay)
        }else
        {
            if self.state == .paused { resume() }
        }
        
        return self
    }
    
    ///Removes Timeline from Engine.
    ///- Returns:             Current`Timeline` instance.
    @discardableResult public func stop() -> Timeline {
        //Remove from list
        TweenList.remove(self)
        return self
    }
    
    /**Pauses Timeline.
     - Returns:             Current`Timeline` instance.
     */
    @discardableResult public func pause() -> Timeline
    {
        self.timePaused = self.timeCurrent - self.timeStart
        if self.state != .paused {self.state = .paused}
        return self
    }
    
    /**Rewinds Timeline.
     - Returns:             Current`Timeline` instance.
    */
    @discardableResult public func rewind() -> Timeline
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
        
        return self
    }

    /**Sets timeline time manually.
     - Parameter currentTime:   Time in seconds.
     - Returns:                 Current`Timeline` instance.
    */
    @discardableResult public func setTime(_ currentTime:Double) -> Timeline
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
        
        return self
    }
    
    /// Gets Timeline's time duration in seconds.
    public func getDuration() -> Double {return duration}
    
    /// Checks if Timeline has added to Engine.
    public func isPlaying() -> Bool { return TweenList.isAdded(self) && state != .paused }
    
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
    
    func update()
    {
        //Caculate timeline time
        let time:Double = Engine.currentTime - self.timeStart

        //Update all timeline Tweens
        for control in controls
        {
            // Looping throught each Tweening and updating the values accordingly
            if !self.reverse
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
        self.timeStart = Engine.currentTime + (delay / timeScale)
        //Reset time paused
        self.timePaused = 0.0
        //Reset time complete & timeline duration.
        updateTimeComplete()
        
        //Reset each tween
        for control in self.controls{
            control.reset()
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
            control.timeStart = control.getTween().delay / timeScale
            //Get max time complete of all tweens.
            m = max(m, control.timeComplete)
        }
        
        //Set timeline duration.
        self.duration = m
        //Set timeline time complete.
        self.timeComplete = self.timeStart + self.duration
    }
}
