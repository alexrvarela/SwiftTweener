//
//  Tweener.swift
//  Tweener
//
//  Created by Alejandro Ramirez Varela on 9/7/18.
//  Copyright © 2018 Alejandro Ramirez Varela. All rights reserved.
//

import Foundation

//MARK:Tween's Engine

///A internal set of Int enums to declare states of each tween.
enum TweenState : Int
{
    ///Tween added but no started.
    case initial
    ///Tween started (animating)
    case started
    ///Tween started and paused.
    case paused
    ///Tween finshed and waiting for removing.
    case over
}

///A struct that contains lists of played Tweens and Timelines.
struct TweenList
{
    ///TweenControl's list
    static var controls: Array<TweenControl> = []
    
    ///Timeline's list
    static var timelines: Array<Timeline> = []
    
    #if os(iOS)
    ///TweenVisualizer's list, only available for iOS.
    static var visualizers: Array<TweenVisualizer> = []
    #endif
    ///Verify if a `Tween` instance is added to Engine.
    static func isAdded(_ tween:AnyTween) -> Bool{
        return controls.contains(where:{ObjectIdentifier($0.getTween()).hashValue == ObjectIdentifier(tween).hashValue})
    }
    ///Verify if a `Timeline` instance is added to Engine.
    static func isAdded(_ timeline:Timeline) -> Bool{
        return timelines.contains(where:{ObjectIdentifier($0).hashValue == ObjectIdentifier(timeline).hashValue})
    }
    ///Verify if a `TweenControl` instance is added to Engine.
    static func isAdded(_ controller:TweenControl) -> Bool
    {
        return controls.contains(where:{ObjectIdentifier($0).hashValue == ObjectIdentifier(controller).hashValue})
    }
    ///Remove a `Tween` instance from Engine.
    static func remove(_ tween:AnyTween){
        controls.removeAll(where:{ObjectIdentifier($0.getTween()).hashValue == ObjectIdentifier(tween).hashValue})
    }
    
    ///Remove a `TweenControl` instance from Engine.
    static func remove(_ controller:TweenControl)
    {
        let index = controls.firstIndex(where:{ObjectIdentifier($0).hashValue == ObjectIdentifier(controller).hashValue})
        if index != NSNotFound {controls.remove(at: index!)}
    }
    
    ///Remove a `Timeline` instance from Engine.
    static func remove(_ timeline:Timeline)
    {
        let index = timelines.firstIndex(where:{ObjectIdentifier($0).hashValue == ObjectIdentifier(timeline).hashValue})
        if index != NSNotFound {timelines.remove(at: index!)}
    }
    
    #if os(iOS)
    ///Remove a `TweenVisualizer` instance from Engine.
    static func remove(_ visualizer:TweenVisualizer)
    {
        let index = visualizers.firstIndex(where:{ObjectIdentifier($0).hashValue == ObjectIdentifier(visualizer).hashValue})
        if index != NSNotFound {visualizers.remove(at: index!)}
    }
    #endif
}

///Engine's time scale property.
public var timeScale: Double = 1.0

///Struct with Tween's Engine functionality.
struct Engine
{
    static var sinceDate: Date = Date()
    static var timer: Timer = Timer()
    static var currentTime: TimeInterval = 0.0
    static var started : Bool = false
    
    ///Starts the Tween's animation engine.
    static func start()
    {
        //Creates a new `Timer`
        self.timer =  Timer.scheduledTimer(withTimeInterval: 1.0 / 60.0,
                                           repeats: true,
                                           block: { (timer) in
                                            Tweener.update()
        })
        //Attaches `Timer` in 'common' Mode to give high priority.
        RunLoop.main.add(self.timer, forMode: RunLoop.Mode.common)
        //Retains current Date as started date.
        self.sinceDate = Date()
        //Sets Engine's state as started.
        self.started = true
    }
    
    ///Time updating function, called from Timer.
    static func update()
    {
        self.currentTime = Date().timeIntervalSince(self.sinceDate)
    }
    ///Stops Engine.
    static func stop()
    {
        self.timer.invalidate()
        self.started = false
        self.currentTime = 0.0
    }
}

//MARK: - Supported Types

///A internal struct type to store animation values as Doble Arrays.
struct TweenArray
{
    ///A a Double Type Array to store 'from' values.
    let from:Array<Double>
    ///A a Double Type Array to store 'to' values.
    let to:Array<Double>
}

/**
 Method to add support to custom Types.
    - Parameter toType:     An instance of `ToTypeBlock` that converts values from Double's Array to declared Type.
    - Parameter toArray:    An instance of `ToArrayBlock` that converts values from declared Type to Double's Array.
    - Parameter isNumeric:  A Bool that declares if Type is a Numeric Type, Swift by default casts 1.0 as Double Type and 1 as Int Type, Tweener casts those Doubles and Ints to Type automatically.
 */
public func addType<T>(toType:@escaping ToTypeBlock<T>, toArray:@escaping ToArrayBlock<T>, isNumeric:Bool = false){
    
    //Verify if isn't a protected Type.
    if SupportedTypes.protected.contains(where: { type(of: $0 ) == type(of: T.self) }) {
        print("Warning, \(T.self) is protected Type.")
        return
    }
    
    //Add Type to list in pairs, Type.self and Interpreter.
    SupportedTypes.list.append(T.self)
    SupportedTypes.interpreters.append(Interpreter(toType, toArray))
    
    //Add to numeric's list if has declared as Numeric Type.
    if isNumeric { SupportedTypes.numerics.append(T.self) }
}

//MARK: - TweenBlock

///A generic Type Class with an animatable value and a block to handle each update with it's updated value called on value's 'didSet' event.
public class TweenBlock<T> {
    /// A value property with observer.
    public var value:T{ didSet { block( value ) } }
    /// A code block to run after value being updated.
    public var block:(T) -> Void
    /// Initializer.
    /// - Parameter value: An initial generic Type value.
    /// - Parameter block: A code block to handle when value is updated.
    public init(value:T, block:@escaping (T) -> Void) {
        self.block = block
        self.value =  value
    }
}

//MARK: - Add Tweens to engine

/**Adds `Tween` to Engine
  - Parameter tween: A `Tween` Type istance to animate.
*/
public func add<T>(_ tween:Tween<T>)
{
    //Make sure Tween isn't empty
    if tween.keys.count == 0  { print("Warning: Empty tween"); return }
    
    //Add same Tween instance once time to prevent conflicts while animating, remove it after calling .remove() from Tween's instance.
    if TweenList.isAdded( tween ) { TweenList.remove( tween ) }
    
    //Create a new control with Tween properties.
    let control = Control(tween, time:Engine.currentTime + tween.delay)

    //Remove other Tweens that occur at the same time.
    removeTweensByTime(target:tween.target,
                       keys:Array(tween.keys.keys),
                       timeStart:control.timeStart,
                       timeComplete:control.timeComplete,
                       list:&TweenList.controls)
    
    //Add to engine.
    TweenList.controls.append(control)
    
    //Run engine if hasn't started.
    if !Engine.started { Engine.start() }
}


//MARK: - Add Timelines to engine

/**Adds `Timeline` to Engine
 - Parameter timeline: A `Timeline` Type istance to animate.
 - Parameter delay: Time in seconds to delay animation in Double.
*/
public func add(_ timeline:Timeline, delay:Double)
{
    //Verify if timeline isn't empty
    if timeline.controls.count > 0 {
        
        //Timeline isn't empty, add to engine
        if !TweenList.isAdded(timeline){
            
            TweenList.timelines.append(timeline)
            timeline.reset(delay)
            timeline.state = .initial
        }
        //Start engine if hasn't started yet.
        if !Engine.started {Engine.start()}
    }
}

#if os(iOS)

/**Attaches a`TweenVisualizer` instance to Engine
 - Parameter visualizer: A `TweenVisualizer` Type istance to vizualize Engine's activity.
*/
public func addVisualizer(_ visualizer: TweenVisualizer){
    //Add to update list
    TweenList.visualizers.append(visualizer)
}

/**Detaches a`TweenVisualizer` instance from Engine
 - Parameter visualizer: A `TweenVisualizer` Type istance to vizualize Engine's activity.
*/
public func removeVisualizer(_ visualizer: TweenVisualizer){
    //Remove from update list
    TweenList.remove(visualizer)
}
#endif
//MARK: - Pause, Resume and Removing functions

/** Remove tweens by a specific target.
    - Parameter target: A desired target to remove all existing Tweens.
 ```
 Tweener.removeTweens(target:myInstance)
 ```
 */
public func removeTweens<T>(target:T){
    
    removeTweens(target: target, keys:[])
}

/** Remove tweens by a specific target a specific KeyPaths, this method keeps existing tweens not declared in KeyPath list.
 - Parameter target:    A desired target to remove all existing Tweens.
 - Parameter keys:      A  `PartialKeyPath` list to remove Tweens.
*/
public func removeTweens<T>(target:T, keys:[PartialKeyPath<T>]){
    
    removeTweens(target: target, keys: keys, list:&TweenList.controls)
}

/** Internal function to find and remove tweens by specified target and keypaths
 - Parameter target:    A desired target to remove all existing Tweens.
 - Parameter keys:      A  `PartialKeyPath` list to remove Tweens.
 - Parameter list:      A  `TweenControl` list where to find occurrences and remove it.
 */
func removeTweens<T>(target:T, keys:[PartialKeyPath<T>], list: inout Array<TweenControl>)
{
    //Declare counter for removed items.
    var removed:Int = 0
    
    // Looping throught each Tween.
    for (index, control) in list.enumerated()
    {
        // Verify if is same target.
        if control.isTarget(target) {
            
            //Target is the same, try remove keys
            if keys.count == 0 || control.remove(keys) == 0{
                
                //All keys removed, remove from list.
                list.remove(at: index - removed)
                //Update counter.
                removed = removed + 1
            }
        }
    }
}

/** Internal function to find and remove tweens by specified target and keypaths that occurs at specific time.
 - Parameter target:        A desired target to remove all existing Tweens.
 - Parameter keys:          A  `PartialKeyPath` list to remove existing Tweens.
 - Parameter timeStart:     A time start range to find occurrences as Double Type.
 - Parameter timeComplete:  A time end range to find occurrences as Double Type.
 - Parameter list:          A  `TweenControl` list  where to find occurrences and remove it.
*/
func removeTweensByTime<T>(target:T, keys:[PartialKeyPath<T>], timeStart:Double, timeComplete:Double, list: inout Array<TweenControl>)
{
    //Declare counter for removed items.
    var removed:Int = 0
    
    // Looping throught each Tween
    for (index, control) in list.enumerated(){
        
        // Same target...
        if control.isTarget(target){
            
            // Check if affects time
            if BasicMath.intersects(x1:timeStart, x2:timeComplete, y1:control.timeStart, y2:control.timeComplete){
                
                // Remove keys and remove Tween if all keys are removed.
                if control.remove(keys) == 0 {
                    
                    //All keys were replaced, remove from list.
                    list.remove(at: index - removed)
                    //Update counter.
                    removed = removed + 1
                }
            }
        }
    }
}

/** Pause tweens by a specific target.
 - Parameter target: A desired target to pause all existing Tweens.
 ```
 //Usage:
 Tweener.pauseTweens(target:myInstance)
 ```
*/
public func pauseTweens<T>(target:T){
    pauseTweens(target:target, keys:[])
}

/** Pause tweens by a specific target a specific KeyPaths, this method ignores existing tweens not declared in KeyPath list.
 - Parameter target:    A desired target to pause all existing Tweens.
 - Parameter keys:      A  `PartialKeyPath` list to find same KeyPath Tweens and pause it.
*/
public func pauseTweens<T>(target:T, keys:[PartialKeyPath<T>]){
    //Find target & keyPath occurrences by calling affectedTweens and pause it.
    pause( affectedTweens(target:target, keys:keys, list: &TweenList.controls) )
}

/**Internal function to find and pause tweens by specified target and keypaths
 - Parameter list:  A  `TweenControl` list  where to find occurrences and pause it.
 */
func pause(_ list:Array<TweenControl>){
    
    //Iterate over list.
    for control in list {
        
        //Verify if Tween's state isn't paused.
        if control.state != .paused{
            
            control.timePaused = Engine.currentTime - control.timeStart
            control.state = .paused
        }
    }
}

/** Resume tweens by a specific target.
 - Parameter target: A desired target to resume existing Tweens.
 ```
 //Usage:
 Tweener.resumeTweens(target:myInstance)
 ```
*/
public func resumeTweens<T>(target:T){
    
    resumeTweens(target:target, keys:[])
}

/** Resume tweens by a specific target a specific KeyPaths, this method ignores existing tweens not declared in KeyPath list.
 - Parameter target:    A desired target to pause all existing Tweens.
 - Parameter keys:      A  `PartialKeyPath` list to find same KeyPath Tweens and resume it.
*/
public func resumeTweens<T>(target:T, keys:[PartialKeyPath<T>])
{
    resume(affectedTweens(target:target, keys:keys, list: &TweenList.controls))
}

/**Internal function to find and resume tweens by specified target and keypaths
- Parameter list:  A  `TweenControl` list  where to find occurrences and resume it.
*/
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

/// Pause all existing Tweens and Timelines in Engine.
public func pauseAll()
{
    pauseAllTweens()
    pauseAllTimelines()
}

/// Resume all existing Tweens and Timelines in Engine.
public func resumeAll()
{
    resumeAllTweens()
    resumeAllTimelines()
}

/// Remove all existing Tweens and Timelines in Engine.
public func removeAll()
{
    removeAllTweens()
    removeAllTimelines()
}

/// Pause all existing Tweens in Engine.
public func pauseAllTweens(){pause(TweenList.controls)}
/// Resume all existing Tweens in Engine.
public func resumeAllTweens(){resume(TweenList.controls)}
/// Remove all existing Tweens in Engine.
public func removeAllTweens(){TweenList.controls = []}//Empty list

/// Pause all existing Timelines in Engine.
public func pauseAllTimelines(){
    for timeline in TweenList.timelines { if timeline.state != .paused{timeline.pause()} }
}

/// Resume all existing Timelines in Engine.
public func resumeAllTimelines()
{
    for timeline in TweenList.timelines { if timeline.state == .paused{timeline.resume()} }
}
/// Remove all existing Timelines in Engine.
public func removeAllTimelines(){TweenList.timelines = []}//Empty list

//MARK: - Get affected tweens list

/** Method to get a list of Tween occurrences.
 - Parameter target:    A target to find.
 - Parameter keys:      A  `PartialKeyPath` list to find keyPath occurrences.
 - Parameter list:      A  `TweenControl` list where to find occurrences.
 - Returns: A TweenControl list containing affected Tweens.
*/
@discardableResult func affectedTweens<T>(target:T, keys:[PartialKeyPath<T>],  list: inout Array<TweenControl>) -> Array<TweenControl>
{
    var affected:Array<TweenControl> = []
    var splitted:Array<TweenControl> = []
    var removed:Int = 0
    
    // Looping throught each Tween.
    for (index, control) in list.enumerated()
    {
        //Search by target
        if control.isTarget(target) {
            
            //Validate if hasn't keys.
            if keys.count == 0 {
                //Append to remove
                affected.append(control)
            }else if control.contains(keys) > 0//Validate same keys
            {
                //Split
                let split = control.split(keys)
                
                //Add to spltitted list
                splitted.append(split!)
                
                //If all keys are removed, delete
                if control.getKeysCount() == 0 {
                    //Remove from list.
                    list.remove(at: index - removed)
                    //Update counter.
                    removed = removed + 1
                }
                
                //Add control to affected list
                affected.append(control)
            }
        }
    }
    
    //Add new ones to Engine
    for control in splitted { list.append( control ) }

    return affected
}


//MARK: - Tween updating functions

///A recurrent update function dispatched from Engine's Timer.
func update()
{
    //Refresh current time
    Engine.update()

    //Update Tweens
    updateTweens(&TweenList.controls, time:Engine.currentTime)
    
    //Update Timelines
    updateTimelines()
    
    #if os(iOS)
    //Update Visualizers
    if TweenList.controls.count > 0 || TweenList.timelines.count > 0 { updateVisualizers() }
    #endif
}


/**
 Update all Tweens added to Engine.
 - Parameter list:  A  `TweenControl` list for Tween updating.
 - Parameter time:  Engine's current time.
*/
func updateTweens(_ list: inout Array<TweenControl>, time:Double)
{
    //Declare counter for removed items.
    var removed:Int = 0
    
    // Looping throught each Tween and update it.
    for (index, control) in list.enumerated()
    {
        //Skip if tween is paused.
        if control.state != .paused
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

/**
 Update a single Tween added to Engine.
 - Parameter control:   A  `TweenControl` instance.
 - Parameter time:      Engine's current time.
*/
func updateTween(_ control:TweenControl, time:Double) -> Bool
{
    //Verify if time is on start to end range
    if time >= control.timeStart && control.state != .over
    {
        let tween:AnyTween = control.getTween()

        //Verify if hasn't ended.
        if time >= control.timeComplete
        {
            //Whether or not it's over the update time
            control.state = .over
            
            //Dispatch on complete
            if tween.onComplete != nil { DispatchQueue.main.async { tween.onComplete!() } }
        }
        
        if control.state != .started && control.state != .over
        {
            control.state = .started
                        
            //Dispatch on tween start
            if tween.onStart != nil{ DispatchQueue.main.async { tween.onStart!() } }
        }
                
        //Update values
        control.update(time)
        
        //Dispatch on update
        if tween.onUpdate != nil{ DispatchQueue.main.async { tween.onUpdate!() } }
        
        return !(control.state == .over)
    }
    
    // On delay, hasn't started, so returns true
    return true
}

///Update all Timelines added to Engine.
func updateTimelines()
{
    //Declare a removed counter.
    var removed:Int = 0
    
    //Iterate over all Timeline's list.
    for (index, timeline) in TweenList.timelines.enumerated(){
        
        //Verify if timelie isn't paused.
        if timeline.state != .paused{
            
            //Verify if timeline is over.
            if timeline.state == .over {
                //If true remove from timeline list
                TweenList.timelines.remove(at: index - removed)
                //Increase removed counter.
                removed = removed + 1
            }
            else{
                //Else, timeline hasn't started yet or is playing, verify timeline's time.
                if Engine.currentTime >= timeline.timeStart{
                    
                    //Timeline has started, update.
                    timeline.update()
                    if timeline.state != .started {timeline.state = .started}
                    
                    //Verify if timeline hasn't completed yet.
                    if (Engine.currentTime - timeline.timeStart) >= (timeline.timeComplete - timeline.timeStart){
                        
                        //Timeline has completed, decide if play again or remove.
                        if timeline.playMode == .once{
                            
                            //Play mode is once, set state as over and delete next time.
                            timeline.state = .over
                        }else{
                            
                            if timeline.playMode == .loop{
                                //TODO: Handle loop count
                                //timeline.loopCount = timeline.loopCount + 1
                            }else{
                                timeline.reverse = !timeline.reverse
                            }
                            
                            //Play mode isn't .once, set state as intial.
                            timeline.state = .initial
                            //Reset time to play again!.
                            timeline.reset(0.0)
                        }
                    }
                }
            }
        }
    }
}

#if os(iOS)
///Update all TweenVisualizers attached to Engine.
func updateVisualizers()
{
    for visualizer in TweenList.visualizers {visualizer.update()}
}
#endif
