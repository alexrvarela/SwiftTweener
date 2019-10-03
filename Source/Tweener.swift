//
//  Tweener.swift
//  Tweener
//
//  Created by Alejandro Ramirez Varela on 9/7/18.
//  Copyright © 2018 Alejandro Ramirez Varela. All rights reserved.
//

enum TweenState : Int
{
    case initial
    case started
    case paused
    case over
}

struct TweenList
{
    static var controls: Array<TweenControl> = []
    static var timelines: Array<Timeline> = []
    static var visualizers: Array<TweenVisualizer> = []

    static func isAdded(_ timeline:Timeline) -> Bool
    {
        if timelines.contains(where:{ObjectIdentifier($0).hashValue == ObjectIdentifier(timeline).hashValue}) {return true}
        return false
    }
    
    static func isAdded(_ controller:TweenControl) -> Bool
    {
        if controls.contains(where:{ObjectIdentifier($0).hashValue == ObjectIdentifier(controller).hashValue}) {return true}
        return false
    }
    
    static func remove(_ controller:TweenControl)
    {
        let index = controls.firstIndex(where:{ObjectIdentifier($0).hashValue == ObjectIdentifier(controller).hashValue})
        if index != NSNotFound {controls.remove(at: index!)}
    }
    
    static func remove(_ timeline:Timeline)
    {
        let index = timelines.firstIndex(where:{ObjectIdentifier($0).hashValue == ObjectIdentifier(timeline).hashValue})
        if index != NSNotFound {timelines.remove(at: index!)}
    }
    
    static func remove(_ visualizer:TweenVisualizer)
    {
        let index = visualizers.firstIndex(where:{ObjectIdentifier($0).hashValue == ObjectIdentifier(visualizer).hashValue})
        if index != NSNotFound {visualizers.remove(at: index!)}
    }
}

struct Engine
{
    static var sinceDate: Date = Date()
    static var timer: Timer = Timer()
    static var currentTime: TimeInterval = 0.0
    static var started : Bool = false
    static var isTweening : Bool = false
    
    //TODO: Move to public seteable properties
    static var timeScale: Double = 1.0
    
    static func start()
    {
        self.timer =  Timer.scheduledTimer(withTimeInterval: 1.0 / 60.0,
                                           repeats: true,
                                           block: { (timer) in
                                            Tweener.update()
        })
        
        RunLoop.main.add(self.timer, forMode: RunLoop.Mode.common)
        
        self.sinceDate = Date()
        self.started = true
    }
    
    static func update()
    {
        self.currentTime = Date().timeIntervalSince(self.sinceDate)
    }
    
    static func stop()
    {
        self.timer.invalidate()
        self.started = false
        self.currentTime = 0.0
    }
}

import Foundation

//TODO: Documentation

//MARK: Add Tweens to engine
public func add<T>(_ tween:Tween<T>)
{
    let control = Control(tween, time:Engine.currentTime + tween.delay)
    
    if tween.replaceTweens
    {
        //Remove twens by target and keyPaths
        removeTweens(target: tween.target, keys:Array(tween.keys.keys))
    }else
    {
        //Remove tweens that occur at the same time.
        removeTweensByTime(target:tween.target,
                                   keys:tween.keys,
                                   timeStart:control.timeStart,
                                   timeComplete:control.timeComplete,
                                   list:&TweenList.controls)
    }
    
    //Add to engine.
    TweenList.controls.append(control)
    
    //Run engine
    if !Engine.started {Engine.start()}
}

//MARK: Add Timelines to engine
public func add(_ timeline:Timeline, delay:Double)
{
    //Verify if timeline isn't empty
    if timeline.controls.count > 0
    {
        //Timeline isn't empty, add to engine
        if !TweenList.isAdded(timeline)
        {
            TweenList.timelines.append(timeline)
            timeline.reset(delay)
            timeline.state = .initial
        }
        
        if !Engine.started {Engine.start()}
    }
}

public func addVisualizer(_ visualizer: TweenVisualizer)
{
    //Add to update list
    TweenList.visualizers.append(visualizer)
}

public func removeVisualizer(_ visualizer: TweenVisualizer)
{
    //Remove from update list
    TweenList.remove(visualizer)
}

//MARK: Remove functions
public func removeTweens<T>(target:T)
{
    removeTweens(target: target, keys:[])
}

public func removeTweens<T>(target:T, keys:[PartialKeyPath<T>])
{
    removeTweens(target: target, keys: keys, list:&TweenList.controls)
}

func removeTweens<T>(target:T, keys:[PartialKeyPath<T>], list: inout Array<TweenControl>)
{
    //Declare counter for removed items.
    var removed:Int = 0
    
    // Looping throught each Tween.
    for (index, control) in list.enumerated()
    {
        if (control.isTarget(target)){
            
            //Target is the same, try remove keys
            if keys.count == 0 || control.remove(keys) == 0
            {
                //Remove from list.
                list.remove(at: index - removed)
                //Update counter.
                removed = removed + 1
            }
        }
    }
}

//Remove by time.
//TODO:CocoaTweener replicate code.
func removeTweensByTime<T>(target:T, keys:[PartialKeyPath<T>:Any], timeStart:Double, timeComplete:Double, list: inout Array<TweenControl>)
{
    //Declare counter for removed items.
    var removed:Int = 0
    
    // Looping throught each Tween
    for (index, control) in list.enumerated()
    {
        // Same object...
        if (control.isTarget(target))
        {
            // Check if affects time
            if (timeComplete > control.timeStart && timeStart < control.timeComplete)
            {
                // Remove keys and remove Tween if all keys are removed.
                if control.remove(Array(keys.keys)) == 0
                {
                    //Remove from list.
                    list.remove(at: index - removed)
                    //Update counter.
                    removed = removed + 1
                }
            }
        }
    }
}

//MARK - Pause tweens
public func pauseTweens<T>(target:T)
{
    pauseTweens(target:target, keys:[])
}

public func pauseTweens<T>(target:T, keys:[PartialKeyPath<T>])
{
    pause(affectedTweens(target:target, keys:keys, list: &TweenList.controls))
}

func pause(_ list:Array<TweenControl>)
{
    for control in list
    {
        if control.state != .paused
        {
            control.timePaused = Engine.currentTime - control.timeStart
            control.state = .paused
        }
    }
}

public func resumeTweens<T>(target:T)
{
    resumeTweens(target:target, keys:[])
}

public func resumeTweens<T>(target:T, keys:[PartialKeyPath<T>])
{
    resume(affectedTweens(target:target, keys:keys, list: &TweenList.controls))
}

func resume(_ list:Array<TweenControl>)
{
    for control in list
    {
        if control.state == .paused
        {
            control.timeStart = Engine.currentTime - control.timePaused
            control.timeComplete = control.timeStart + control.getTween().duration
            control.timePaused = 0.0
            control.state = control.lastState
        }
    }
}

public func pauseAll()
{
    pauseAllTweens()
    pauseAllTimelines()
}

public func resumeAll()
{
    resumeAllTweens()
    resumeAllTimelines()
}

public func removeAll()
{
    removeAllTweens()
    removeAllTimelines()
}

public func pauseAllTweens(){pause(TweenList.controls)}
public func resumeAllTweens(){resume(TweenList.controls)}
public func removeAllTweens(){TweenList.controls = []}//Empty list

public func pauseAllTimelines()
{
    for timeline in TweenList.timelines { if timeline.state != .paused{timeline.pause()} }
}

public func resumeAllTimelines()
{
    for timeline in TweenList.timelines { if timeline.state == .paused{timeline.resume()} }
}

public func removeAllTimelines(){TweenList.timelines = []}//Empty list

//MARK - Get affected tweens list
func affectedTweens<T>(target:T, keys:[PartialKeyPath<T>],  list: inout Array<TweenControl>) -> Array<TweenControl>
{
    var affected:Array<TweenControl> = []
    var splitted:Array<TweenControl> = []
    var removed:Int = 0
    
    // Looping throught each Tween.
    for (index, control) in list.enumerated()
    {
        if (control.isTarget(target)){
            
            //Search by target
            if keys.count == 0
            {
                //Append
                affected.append(control)
                
            } else if control.contains(keys) > 0 //Search by keypaths
            {
                //TODO:Don't remove, create internal list with affected keys.
                
                //Split
                let split = control.split(keys)
                //Add to spltitted list
                splitted.append(split!)
                
                if control.getKeysCount() == 0
                {
                    //Remove from list.
                    list.remove(at: index - removed)
                    //Update counter.
                    removed = removed + 1
                }
                
                //Add to affected list
                affected.append(split!)
            }
        }
    }
    
    //Add new ones to Engine
    for control in splitted{list.append(control)}

    return affected
}


//MARK: Update functions

func update()
{
    //Refresh current time
    Engine.update()

    //Update Tweens
    updateTweens(&TweenList.controls, time:Engine.currentTime)
    
    //Update Timelines
    updateTimelines()

    //Update Visualizers
    if TweenList.controls.count > 0 || TweenList.timelines.count > 0 { updateVisualizers() }
}

func updateTweens(_ list: inout Array<TweenControl>, time:Double)
{
    //Declare counter for removed items.
    var removed:Int = 0
    
    // Looping throught each Tween and update it.
    for (index, control) in list.enumerated()
    {
        //Skip if tween is paused.
        if (control.state != .paused)
        {
            //Update tween values.
            let update : Bool =  updateTween(control, time:time)
            
            //If isn't possible update or tween is over, remove it.
            if !update || control.state == .over
            {
                //Remove from list.
                list.remove(at: index - removed)
                
                //Update counter.
                removed = removed + 1
            }
        }
    }
}

func updateTween(_ control:TweenControl, time:Double) -> Bool
{
    //Verify if time is on start to end range
    if time >= control.timeStart && control.state != .over
    {
        let tween:AnyTween = control.getTween()

        //Verify if hasn't ended.
        if time >= control.timeComplete
        {
            // Whether or not it's over the update time
            control.state = .over
            
            //On complete
            if (tween.onComplete != nil) {
                DispatchQueue.main.async {
                    tween.onComplete!()
                }
            }
        }
        
        if control.state != .started && control.state != .over
        {
            control.state = .started
            
            //Refresh properties!
            if (!control.isTimelineTween && tween.delay > 0.0)
            {
                //[tweenControl setupController]//TODO:???
            }
            
            if (tween.onStart != nil)
            {
                DispatchQueue.main.async {
                    tween.onStart!()
                }
            }
        }
                
        //Update values
        control.update(time)
        
        //On update
        if (tween.onUpdate != nil){
            DispatchQueue.main.async {
                tween.onUpdate!()
            }
        }
        
        return !(control.state == .over)
    }
//    else
//    {
//        if(control.state == .initial){print("Tween not started")}
//        if(control.state == .over){print("Tween is over")}
//    }
    
    // On delay, hasn't started, so returns true
    return true
}


func updateTimelines()
{
    //Declare removed count.
    var removed:Int = 0
    
    for (index, timeline) in TweenList.timelines.enumerated()
    {
        //Verify if timelie isn't paused.
        if timeline.state != .paused
        {
            //Verify if timeline is over.
            if timeline.state == .over
            {
                //If true remove from timeline list
                TweenList.timelines.remove(at: index - removed)
                //Increase removed counter.
                removed = removed + 1
            }
            else
            {
                //Else, timeline hasn't started or is playing.
                
                //Verify timeline time.
                if Engine.currentTime >= timeline.timeStart
                {
                    //Timeline has started, verify if timeline hasn't completed yet.
                    if (Engine.currentTime - timeline.timeStart) >= (timeline.timeComplete - timeline.timeStart)
                    {

                        //Timeline has completed, decide if play again or remove.
                        if timeline.playMode == .once
                        {
                            //Play mode is once, set state as over.
                            timeline.state = .over
                            //Remove from timeline list.
                            TweenList.timelines.remove(at: index - removed)
                            //Increase removed counter.
                            removed = removed + 1
                        }else
                        {
                            if timeline.playMode == .loop
                            {
                                //TODO: Handle loop count
                                timeline.loopCount = timeline.loopCount + 1
                            }else
                            {
                                timeline.reverse = !timeline.reverse
                            }
                            
                            //Play mode isn't .once, set state as intial.
                            timeline.state = .initial
                            //Reset time to play again!.
                            timeline.reset(0.0)
                        }
                        
                    }else
                    {
                        //Timeline has started, update.
                        timeline.update()
                        if timeline.state != .started {timeline.state = .started}
                    }
                }
            }
        }
    }
}

func updateVisualizers()
{
    for visualizer in TweenList.visualizers {visualizer.update()}
}
