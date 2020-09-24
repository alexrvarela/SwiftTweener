//
//  Tween.swift
//  Tweener
//
//  Created by Alejandro Ramirez Varela on 9/7/18.
//  Copyright © 2018 Alejandro Ramirez Varela. All rights reserved.
//

///Type of block that interacts with Tween states, on start, on update, on remove and on finish
public typealias TweenHandler = () -> Void

///A Tween wrapper to handle any tween, don't use this class it's for utility purposes, use Tween<T> instead.
public class AnyTween
{
    //Set default params
    /// Animation duration in seconds.
    public var duration: Double = 0.0
    /// Animation Curve.
    public var ease: Ease = .none
    /// Animation time delay in seconds.
    public var delay: Double = 0.0
    /// TweenHandler block to run when animation starts.
    public var onStart: TweenHandler?
    /// TweenHandler block to run while animation is updating.
    public var onUpdate: TweenHandler?
    /// TweenHandler block to run when animation is done.
    public var onComplete: TweenHandler?
    /// TweenHandler block to run when animation is replaced.
    public var onOverwrite: TweenHandler?
    ///Read-only property to obtain calculated time-end.
    public var timeEnd: Double { return duration + delay }
    
    /// Function to add this tween to animation Engine.
    @discardableResult public func play() -> AnyTween{
        print("Warning: Can't add this Tween beause isn't defined any Yype")
        return self
    }
    
    /// Function to remove this tween from animation Engine.
    @discardableResult public func stop() -> AnyTween{
        print("Warning: Can't stop this Tween beause isn't defined any Type")
        return self
    }
    
    /// Function to add this tween to an Timeline.
    func add(to timeline:Timeline){
        print("Warning: Can't add this Tween because isn't defined any Type")
    }
}

/// Tween related to a specific target instance class or struct Type:`T`.
public class Tween<T>: AnyTween
{
    /// Animation target.
    internal var target: T!
    /// Collection of KeyPaths and animation Values.
    internal var keys:[PartialKeyPath<T> : TweenArray] = [:]
    /// Chainable Tween instance.
    internal var before: Tween<T>? = nil
    
    /**
    Creates a descartable Tween.
     - Parameter target: Required, target instance to perform animations.
     - Parameter duration: Optional, Time duration of tween in seconds.
     - Parameter ease: Optional, Easing equation for animation curve, the default value is linear.
     - Parameter delay: Optional, Time to delay after start this animation.
     - Parameter from: Optional,  collection of pair type KeyPath  and Any, this sets the intial animation values, if isn't defined the engine takes the current values from target as start.
     - Parameter keys: Optional,  collection of pair type KeyPath  and Any to animate a property with the desired end values, Tweens never start if not defined.
     - Parameter replace: Optional, Boolean value that indicates if the engine removes existing tweens for same property.
     - Parameter completion: Optional, A code block to execute when animation has finished.
     - Returns: A new `Tween` instance .
     */
    public convenience init(target: T,
                            duration: Double = 1.0,
                            ease:Ease = .none,
                            delay:Double = 0.0,
                            from: [PartialKeyPath<T> : Any]? = nil,//Optional
                            to: [PartialKeyPath<T> : Any]? = nil,
                            completion: TweenHandler? = nil)
    {
        self.init()
        self.target = target
        if to != nil { setKeys(to!, from) }
        self.duration = duration
        self.ease = ease
        self.delay = delay
        self.onComplete = completion
    }
    
    /**A method to set Tween's duration using declarative syntax.
     - Parameter duration:  Tween's time duration in seconds.
     - Returns:             Current`Tween` instance.
     */
    @discardableResult public func duration(_ duration : Double) -> Tween<T>
    {
        self.duration = duration
        return self
    }
    
    /**A method to set Tween's easing equation using declarative syntax.
     - Parameter ease:  Easing equation for animation curve.
     - Returns:         Current`Tween` instance.
     */
    @discardableResult public func ease(_ ease:Ease) -> Tween<T>
    {
       self.ease = ease
       return self
    }
    
    /**A method to set Tween's delay using declarative syntax.
     - Parameter delay:  Time to delay after start this animation.
     - Returns:         Current`Tween` instance.
     */
    @discardableResult public func delay(_ delay: Double) -> Tween<T>
    {
        self.delay = delay
        return self
    }
    
    /**A method to set Tween's onStart handler using declarative syntax.
     - Parameter handler:   TweenHandler block to run when animation starts.
     - Returns:             Current`Tween` instance.
     */
    @discardableResult public func onStart(_ handler: @escaping TweenHandler) -> Tween<T>
    {
        self.onStart = handler
        return self
    }
    
    /**A method to set Tween's onUpdate handler using declarative syntax.
     - Parameter handler:   TweenHandler block to run while animation is updating.
     - Returns:             Current`Tween` instance.
     */
    @discardableResult public func onUpdate(_ handler: @escaping TweenHandler) -> Tween<T>
    {
        self.onUpdate = handler
        return self
    }
    
    /**A method to set Tween's onComplete handler using declarative syntax.
     - Parameter handler:   TweenHandler block to run when animation is done.
     - Returns:             Current`Tween` instance.
     */
    @discardableResult public func onComplete(_ handler: @escaping TweenHandler) -> Tween<T>
    {
        self.onComplete = handler
        return self
    }
    
    /**A method to set Tween's onOverwrite handler using declarative syntax.
     - Parameter handler:   TweenHandler block to run when animation is replaced..
     - Returns:             Current`Tween` instance.
     */
    @discardableResult public func onOverwrite(_ handler: @escaping TweenHandler) -> Tween<T>
    {
        self.onOverwrite = handler
        return self
    }
    ///Adds self to animation Engine.
    @discardableResult public override func play() -> Tween<T>{
        
        //First, play all before associated tween chain.
        if self.before != nil { self.before!.play() }
        
        //TODO: Remove from timeline if added.
        
        //Finally add self
        Tweener.add(self)
        
        return self
    }
    
    ///Adds self Tween to Timeline.
    override func add(to timeline:Timeline){
        //Add entire chain
        if self.before != nil { self.before!.add(to:timeline) }
        //Finally add self
        timeline.addTween( self )
    }
    
    ///A function that creates a new tween after this, and chain.
    ///- Returns:   A new`Tween` instance with time delay after current.
    @discardableResult public func after(duration: Double? = nil,
                                         ease:Ease? = nil,
                                         delay:Double? = nil,
                                         from: [PartialKeyPath<T> : Any]? = nil,
                                         to: [PartialKeyPath<T> : Any]? = nil,
                                         completion: TweenHandler? = nil) -> Tween<T>{
        
        //Create a new tween with same target, if tween parameters aren't defined it takes from this one, except keys, must be defined by user.
        let after = Tween(target: self.target!,
                          duration: duration != nil ? duration! : self.duration,
                          ease: ease != nil ? ease! : self.ease,
                          delay: self.timeEnd + ( delay != nil ? delay! : 0.0 ),
                          from: from != nil ? from : completeKeyValues(),
                          to: to,
                          completion:completion)
        
        //Chain new tween to self.
        after.before = self
        
        //Returns a new Tween instance.
        return after
    }
    
    /**A method to set Tween's keyPaths and values using declarative syntax.
     - Parameter from:  Optional,  collection of pair type KeyPath  and Any, this sets the intial animation values, if isn't defined the engine takes the current values from target as start.
     - Parameter to:    Required,  collection of pair type KeyPath  and Any to animate a property with the desired end values, Tweens never start if not defined.
     - Returns:         Current`Tween` instance.
     */
    @discardableResult public func keys(from:[PartialKeyPath<T> : Any]? = nil, to:[PartialKeyPath<T> : Any]) -> Tween<T> {
        //Verify if isn't animating.
        if TweenList.isAdded( self ) {
            print("Warning: Keys Can't be modifed while animation is runnig, call .remove() to remove it.")
            return self
        }
        //Modify keys
        setKeys(to, from == nil && self.before != nil ? self.before!.completeKeyValues() : from)
        return self
    }
    
    ///Removes from Engine immediatelly.
    @discardableResult public override func stop() -> Tween<T> {
        //First, stop all 'before' associated tween chain.
        if self.before != nil { self.before!.stop() }
        
        //Remove from Animation engine immediatelly.
        TweenList.remove(self)
        return self
    }
    
    ///Internal function for KeyPath and value validation for Supported Types only, discards other Types.
    func setKeys(_ toKeys:[PartialKeyPath<T> : Any], _ fromKeys:[PartialKeyPath<T> : Any]? = nil)
    {
        var validKeys : [PartialKeyPath<T> : TweenArray] = [:]
        
        //Set valid keypaths
        for (key, toValue) in toKeys
        {
            // Iterate over supported types.
            for (j, t) in SupportedTypes.list.enumerated() {
                
                let keyType  = type(of: key).valueType
                
                if type( of:keyType ) == type(of: t) {

                    let intepreter = SupportedTypes.interpreters[j]
                    var from:[Double]?
                    
                    // Verify if "from" key exists.
                    if let fromValue = fromKeys?[key] {
                        
                        //Try get "from" value array
                        from = intepreter.toArray( fromValue )
                
                       // Sometimes numeric values are other type.
                        if from == nil {
                            if isNumber(type(of: key).valueType) && isNumber( type(of: fromValue) ){
                                from = SupportedTypes.cast( fromValue )
                            }
                        }
                        
                    }else {
                        //Read value directly from target
                        from = intepreter.read(target:target, key: key)
                    }
                    
                    if from == nil { print("Warning: Couldn't read 'from' values") }
                                            
                    // Try get "to" value array
                    var to:[Double]? = intepreter.toArray( toValue )
                   
                    if to == nil {
                        // Sometimes numeric values are other type.
                        if isNumber( type(of: key).valueType ) && isNumber( type(of: toValue) ){
                            to = SupportedTypes.cast( toValue )
                        }
                    }
                    
                    if to == nil { print("Warning: Couldn't read 'to' values") }
                    
                    //Add valid keys only
                    if from?.count == to?.count { validKeys[key] = TweenArray(from:from!, to:to!) }
                    
                    //Typa found, break iteration.
                    break
                }
            }
        }
        
        //Replace keys
        self.keys = validKeys
    }
    
    ///Converts current 'from' key values to KeyPath:Value collection with original Types.
    func fromKeyValues() -> [PartialKeyPath<T> : Any]{

        var _keys : [PartialKeyPath<T> : Any] = [:]
        for (key, values) in self.keys {
            for (j, t) in SupportedTypes.list.enumerated() {
                if type( of:type(of: key).valueType ) == type(of: t) {
                    _keys[ key ] = SupportedTypes.interpreters[j].toType( values.from )
                    break
                }
            }
        }
        return _keys
    }
    
    ///Converts current 'to' key values to KeyPath:Value collection with original Types.
    func completeKeyValues() -> [PartialKeyPath<T> : Any]{

        var _keys : [PartialKeyPath<T> : Any] = [:]
        for (key, values) in self.keys {
            for (j, t) in SupportedTypes.list.enumerated() {
                if type( of:type(of: key).valueType ) == type(of: t) {
                    _keys[ key ] = SupportedTypes.interpreters[j].toType( values.to )
                    break
                }
            }
        }
        return _keys
    }
    
    ///Function to check if value is numeric Type.
    func isNumber<T>(_ t:T)-> Bool {
        return SupportedTypes.numerics.contains { type(of: $0 ) == type(of: t) }
    }
    
    //deinit { print("Tween destroyed") }//NOTE:Use for debbug only.
}
