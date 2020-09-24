//
//  Extensions.swift
//  Tweener
//
//  Created by Alejandro Ramirez Varela on 12/08/20.
//

#if os(iOS) || os(tvOS)
import UIKit

///A collection of predefined animations ready to use for UIView.
extension UIView{
   
    ///Associated objects to encapsulate a tween block to make accessible to any instance.
    private struct UIViewAssociatedBlock { static var block:TweenBlock<CGFloat> = TweenBlock(value: 0.0 ){ value in } }
    
    ///Associated tween block.
    var tweenBlock: TweenBlock<CGFloat> {
        get {
            //Verify if has associated for first time.
            guard let block = objc_getAssociatedObject(self, &UIViewAssociatedBlock.block) as? TweenBlock<CGFloat>
            else { return UIViewAssociatedBlock.block }
            return block }
        set(value) {
            //Make sure to remove existing tweens after replacing.
            Tweener.removeTweens(target: self.tweenBlock)
            //FInally associate a new one.
            objc_setAssociatedObject(self, &UIViewAssociatedBlock.block, value, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    
    /**
    Spring, animates CATransform3D `x` and  `y` scale and returns to normal transformation.
     - Parameter scale:     Initial `x` and `y` scale transform after call `srpringBack()`.
     - Parameter duration:  Time duration in seconds.
     - Returns:             A new Tween<CALayer>.
    */
    @discardableResult public func spring(scale:CGFloat = 0.5, duration:Double = 1.0) -> Tween<CALayer> {
        
        self.layer.transform = CATransform3DMakeScale(scale, scale, 1.0)
        return springBack(duration:duration)
    }

    /**
    Spring Back, animates CATransform3D `x` and  `y` to normal transformation with an `.outElastic` curve.
     - Parameter duration:  Time duration in seconds.
     - Returns:             A new Tween<CALayer>.
    */
    @discardableResult public func springBack(duration:Double = 1.0) -> Tween<CALayer> {
        
        return Tween(target: self.layer)
            .duration(duration)
            .ease(.outElastic)
            .keys(to: [\CALayer.transform : CATransform3DMakeScale(1.0, 1.0, 1.0)] )
            .play()
    }
    
    /**
    Zoom, animates CATransform3D `x` and  `y` scale to normal position with an `.outCirc` animation curve.
    WARNING: Using zero scale value in CALayer's transform causes program error.
     - Parameter scale:     Initial `x` and `y` scale.
     - Parameter duration:  Time duration in seconds.
     - Returns:             A new Tween<CALayer>.
    */
    @discardableResult public func zoom(scale:CGFloat = 1.5, duration:Double = 0.75) -> Tween<CALayer> {
        
        self.layer.transform = CATransform3DMakeScale(scale, scale, 1.0)
        
        return Tween(target: self.layer)
            .duration(duration)
            .ease(.outCirc)
            .keys( to:[\CALayer.transform : CATransform3DMakeScale(1.0, 1.0, 1.0)])
            .play()
    }
    
    /**
    Zoom In, animates CATransform3D `x` and  `y` scale from 0.1 to normal position.
     - Parameter duration:  Time duration in seconds.
     - Returns:             A new Tween<CALayer>.
    */
    @discardableResult public func zoomIn(duration:Double = 0.75) -> Tween<CALayer> {
        return zoom(scale:0.01, duration:duration)
    }
    
    /**
    Zoom Out, animates CATransform3D `x` and  `y` scale from 2.0 to normal position.
     - Parameter duration:  Time duration in seconds.
     - Returns:             A new Tween<CALayer>.
    */
    @discardableResult public func zoomOut(duration:Double = 0.75) -> Tween<CALayer> {
        return zoom(scale:2.0, duration:duration)
    }
    
    /**
    Fade effect, animates CALayer's opacity.
    - Parameter opacity:    Custom opacity.
    - Parameter duration:   Time duration in seconds.
    - Returns: A new Tween<CALayer>.
    */
    @discardableResult public func fade(opacity:Float = 0.0, duration:Double = 0.75) -> Tween<CALayer> {

        return Tween(target: self.layer)
            .duration(duration)
            .keys(to: [\CALayer.opacity : opacity])
            .play()
    }
    
    /**
    Fade In, animates opacity  from 0.0  to 1.0.
     - Parameter duration:  Time duration in seconds.
     - Returns: A new Tween<CALayer>.
    */
    @discardableResult public func fadeIn(duration:Double = 0.75) -> Tween<CALayer> {
        
        self.layer.opacity = 0.01
        return self.fade(opacity:1.0, duration:duration)
    }
    
    /**
    Fade Out, animates opacity  from 1.0  to 0.0.
     - Parameter duration:  Time duration in seconds.
     - Returns: A new Tween<CALayer>.
    */
    @discardableResult public func fadeOut(duration:Double = 0.75) -> Tween<CALayer> {
        
        self.layer.opacity = 1.0
        return self.fade(opacity:0.01, duration:duration)
    }
    
    /**
    Pop, animates CATransform3D `x` and  `y` scale and returns to normal transformation.
     - Parameter scale: Desired scale to animate after call srpringBack() and animate to normal transformation.
     - Returns: A new Tween<CALayer>.
    */
    @discardableResult public func pop(scale:CGFloat = 1.25) -> Tween<CALayer> {
                
        self.layer.transform = CATransform3DIdentity

        return Tween(target: self.layer)
            .duration(0.25)
            .ease(.outCirc)
            .keys(to: [\CALayer.transform : CATransform3DMakeScale(scale, scale, 1.0)])
            .onComplete { self.springBack() }
            .play()
    }

    /**
    Basic In, animates  CATransform3D `x` and  `y`"from" desired translation "to" normal translation.
     - Parameter distanceX: Desired intial translation over x coordinate.
     - Parameter distanceY: Desired intial translation over y coordinate.
     - Parameter duration:  Time duration in seconds.
     - Parameter ease:      An `Equation` block for animation curve, `.none` by default.
     - Returns: A new Tween<CALayer>.
    */
    @discardableResult public func basicIn(distanceX:CGFloat = 100, distanceY:CGFloat = 100, duration:Double = 1.0, ease:Ease = .none)  -> Tween<CALayer>  {

        //Go to initial position
        self.layer.transform = CATransform3DMakeTranslation(distanceX, distanceY, 0.0)

        return Tween(target: self.layer)
            .duration(duration)
            .ease(ease)
            .keys(to: [\CALayer.transform : CATransform3DIdentity])
            .play()
    }

    /**
    Basic Out, animates  CATransform3D `x` and  `y`"from" normal translation "to" desired translation.
     - Parameter distanceX: Desired destination translation over `x` coordinate.
     - Parameter distanceY: Desired destination translation over `y` coordinate.
     - Parameter duration:  Time duration in seconds.
     - Parameter ease:      An `Equation` block for animation curve, `.none` by default.
     - Returns: A new Tween<CALayer>.
    */
    @discardableResult public func basicOut(distanceX:CGFloat = 100, distanceY:CGFloat = 100, duration:Double = 1.0, ease:Ease = .none) -> Tween<CALayer> {

        //Go to initial position
        self.layer.transform = CATransform3DIdentity

        return Tween(target: self.layer)
            .duration(duration)
            .ease(ease)
            .keys(to: [\CALayer.transform : CATransform3DMakeTranslation(distanceX, distanceY, 0.0)])
            .play()
    }
    
    /**
    Fly, animates to normal translation calling `basicIn()` with `.outBack` as animation curve.
    - Parameter distanceX: Desired initial translation over `x` coordinate.
    - Parameter distanceY: Desired initial translation over `y` coordinate.
    - Parameter duration:  Time duration in seconds.
    - Returns: A new Tween<CALayer>.
    */
    @discardableResult public func fly(distanceX:CGFloat = 200, distanceY:CGFloat = 200, duration:Double = 1.0) -> Tween<CALayer> {
        return basicIn(distanceX: distanceX, distanceY: distanceY, duration: duration, ease: .outBack)
    }

    /**
    Fly left, animates from left to normal translation calling `fly()` over horizontal axis from a positive intial translation.
    - Parameter distance:   Desired initial translation over `x` coordinate.
    - Parameter duration:   Time duration in seconds.
    - Returns: A new Tween<CALayer>.
    */
    @discardableResult public func flyLeft(distance:CGFloat = 200, duration:Double = 0.75 ) -> Tween<CALayer> {
       return fly(distanceX:(distance < 0 ? distance : distance * -1.0), distanceY:0, duration: duration )
    }
    
    /**
    Fly right, animates from right to normal translation calling `fly()` over horizontal axis from a negative intial translation.
    - Parameter distance:   Desired initial translation over `x` coordinate.
    - Parameter duration:   Time duration in seconds.
    - Returns: A new Tween<CALayer>.
    */
    @discardableResult public func flyRight(distance:CGFloat = 200, duration:Double = 0.75 ) -> Tween<CALayer> {
       return fly(distanceX:(distance > 0 ? distance : distance * -1.0), distanceY:0, duration: duration )
    }

    /**
    Fly top, animates from top to normal translation calling `fly()` over vertical axis from a negative intial translation.
    - Parameter distance:   Desired initial translation over `y` coordinate.
    - Parameter duration:   Time duration in seconds.
    - Returns: A new Tween<CALayer>.
    */
    @discardableResult public func flyTop(distance:CGFloat = 200, duration:Double = 0.75 ) -> Tween<CALayer> {
       return fly(distanceX: 0, distanceY: (distance < 0 ? distance : distance * -1.0), duration: duration)
    }
    
    /**
    Fly bottom, animates from bottom to normal translation calling `fly()` over vertical axis from a positive intial translation.
    - Parameter distance:   Desired initial translation over `y` coordinate.
    - Parameter duration:   Time duration in seconds.
    - Returns: A new Tween<CALayer>.
    */
    @discardableResult public func flyBottom(distance:CGFloat = 200, duration:Double = 0.75 ) -> Tween<CALayer> {
       return fly(distanceX: 0, distanceY: (distance > 0 ? distance : distance * -1.0), duration:duration)
    }
    
    /**
    Slide, animates to normal translation calling `basicIn()` with `.outCubic` as animation curve.
    - Parameter distanceX: Desired initial translation over `x` coordinate.
    - Parameter distanceY: Desired initial translation over `y` coordinate.
    - Parameter duration:  Time duration in seconds.
    - Returns: A new Tween<CALayer>.
    */
    @discardableResult public func slide(distanceX:CGFloat = 200, distanceY:CGFloat = 200, duration:Double = 1.0) -> Tween<CALayer> {
        return basicIn(distanceX: distanceX, distanceY: distanceY, duration: duration, ease: .outCubic)
    }
    
    /**
    Slide left, animates from left to normal translation calling `slide()` over horizontal axis from a positive intial translation.
    - Parameter distance:   Desired initial translation over `x` coordinate.
    - Parameter duration:   Time duration in seconds.
    - Returns: A new Tween<CALayer>.
    */
    @discardableResult public func slideLeft(distance:CGFloat = 200, duration:Double = 0.75 ) -> Tween<CALayer> {
        slide(distanceX: (distance < 0 ? distance : distance * -1.0), distanceY:0, duration: duration )
    }
    
    /**
    Slide right, animates from right to normal translation calling `slide()` over horizontal axis from a negative intial translation.
    - Parameter distance:   Desired initial translation over `x` coordinate.
    - Parameter duration:   Time duration in seconds.
    - Returns: A new Tween<CALayer>.
    */
    @discardableResult public func slideRight(distance:CGFloat = 200, duration:Double = 0.75 ) -> Tween<CALayer> {
        slide(distanceX: (distance > 0 ? distance : distance * -1.0), distanceY:0, duration: duration )
    }

    /**
    Slide top, animates from top to normal translation calling `slide()` over vertical axis from a negative intial translation.
    - Parameter distance:   Desired initial translation over `y` coordinate.
    - Parameter duration:   Time duration in seconds.
    - Returns: A new Tween<CALayer>.
    */
    @discardableResult public func slideTop(distance:CGFloat = 200, duration:Double = 0.75 ) -> Tween<CALayer> {
        slide(distanceX:0, distanceY: (distance < 0 ? distance : distance * -1.0), duration: duration)
    }
    
    /**
    Slide bottom, animates from bottom to normal translation calling `slide()` over vertical axis from a positive intial translation.
    - Parameter distance:   Desired initial translation over `y` coordinate.
    - Parameter duration:   Time duration in seconds.
    - Returns: A new Tween<CALayer>.
    */
    @discardableResult public func slideBottom(distance:CGFloat = 200, duration:Double = 0.75 ) -> Tween<CALayer> {
        slide(distanceX:0, distanceY: (distance > 0 ? distance : distance * -1.0), duration:duration)
    }
    
    /**
    Swing, animates CATransform3D `z` axis rotation from a desired angle back to normal rotation 'swinging".
    - Parameter angle:      Desired initial rotation over `z` coordinate.
    - Parameter duration:   Time duration in seconds.
    - Returns: A new Tween<TweenBlock<CGFloat>>.
    */
    @discardableResult public func swing(angle:CGFloat = 22.5, duration:Double = 1.0) -> Tween<TweenBlock<CGFloat>> {
        
        //Replace associated block
        self.tweenBlock = TweenBlock(value: 0.0 ) { value in
            //Play with updated value.
            self.layer.transform = CATransform3DMakeRotation(BasicMath.toRadians(degree: value),
                                                             0.0,
                                                             0.0,
                                                             1.0)
        }
        
        //Animation chain
        return  Tween(target:self.tweenBlock)
            .duration(duration * 0.35)
            .ease(.inOutQuad)
            .keys(to:[\TweenBlock<CGFloat>.value : angle])
            .after(duration:duration * 0.3)
            .keys(to:[\TweenBlock<CGFloat>.value : -1.0 * angle])
            .after(duration:duration * 0.2)
            .keys(to:[\TweenBlock<CGFloat>.value : angle * 0.75])
            .after(duration:duration * 0.15)
            .keys(to: [\TweenBlock<CGFloat>.value : 0.0 ])
            .play()
    }
    
    /**
    Flip, animates CATransform3D `x` and/or `y` axis rotation performing a 3D flip effect with perspective.
    - Parameter xAxis:      A Bool value to enable `x` axis.
    - Parameter yAxis:      A Bool value to enable `y` axis.
    - Parameter inverted:   A Bool value to invert enabled axles.
    - Parameter duration:   Time duration in seconds.
    - Returns: A new Tween<TweenBlock<CGFloat>>.
    */
    @discardableResult public func flip(xAxis:Bool = false, yAxis:Bool = false, inverted:Bool = false, duration:Double = 1.0) -> Tween<TweenBlock<CGFloat>> {

        self.tweenBlock = TweenBlock(value: 0.0 ) { value in
            //Create a perspective matrix
            var perspective = CATransform3DIdentity
            perspective.m34 = 1.0 / 500.0
            
            //And rotate while updating.
            self.layer.transform = CATransform3DRotate(perspective,
                                                       BasicMath.toRadians(degree:inverted  ? -value : value ),
                                                       yAxis ? 1.0 : 0.0,
                                                       xAxis ? 1.0 : 0.0,
                                                       0.0)
        }
        
        return Tween(target:self.tweenBlock)
        .duration(duration)
        .ease(.inOutQuad)
        .keys(to: [\TweenBlock<CGFloat>.value :180.0])
        .play()

    }
    
    /**
    Flip X, animates CATransform3D `x` axis rotation performing a 3D flip effect with perspective.
    - Parameter inverted:  A Bool value to invert `x` axis and flip in opposite direction.
    - Parameter duration:  Time duration in seconds.
    - Returns: A new Tween<TweenBlock<CGFloat>>.
    */
    @discardableResult public func flipX(inverted:Bool = false) -> Tween<TweenBlock<CGFloat>> { return flip(xAxis: true, inverted: inverted) }
    
    /**
    Flip Y, animates CATransform3D `y` axis rotation performing a 3D flip effect with perspective.
    - Parameter inverted:  A Bool value to invert `y` axis and flip in opposite direction.
    - Parameter duration:  Time duration in seconds.
    - Returns: A new Tween<TweenBlock<CGFloat>>.
    */
    @discardableResult public func flipY(inverted:Bool = false) -> Tween<TweenBlock<CGFloat>> { return flip(yAxis: true, inverted: inverted) }
    
    /**
    Spin, animates CATransform3D `x` and/or `y` axis rotation performing a 3D flip effect with perspective.
    - Parameter leaps:      An Int value that indicates number of leaps.
    - Parameter duration:   Time duration in seconds.
    - Parameter clockwise:  A Bool value that indicates if turns clockwise
    - Returns: A new Tween<TweenBlock<CGFloat>>.
    */
    @discardableResult public func spin(leaps:Int = 1, duration:Double = 0.5, clockwise:Bool = true)  -> Tween<TweenBlock<CGFloat>> {

        self.tweenBlock = TweenBlock(value: 0.0 )  { value in
            //Play with updated value.
            self.layer.transform = CATransform3DMakeRotation(BasicMath.toRadians(degree: value),
                                                             0.0,
                                                             0.0,
                                                             1.0)
        }
        
        let rotation = 360.0 * CGFloat( leaps )
        return Tween(target:self.tweenBlock, duration:0.75, ease: .inOutQuad, to: [\TweenBlock<CGFloat>.value : clockwise ? rotation : -rotation ]).play()
    }
    
    /**
    Shake, creates an animated shake effect with layer's CATransform3D translating over `x` coordinate.
    - Parameter distance: Desired shake translation distance over `x` coordinate.
    - Parameter leaps:    An Int value that indicates number of shakes.
    - Returns: A new Tween<CALayer>.
    */
    @discardableResult public func shake(distance:CGFloat = 10, shakes:Int = 5)  -> Tween<CALayer> {
        
        var tween = Tween(target:self.layer).ease(.inOutQuad).duration(0.1)
        
        for i in 0 ... shakes{
            tween.keys(to:[\CALayer.transform : CATransform3DMakeTranslation(i % 2 == 0 ? -distance : distance, 0.0, 0.0)])
            tween = tween.after()//Important!
        }
        
        //Use last to return normal position
        return tween.keys(to:[\CALayer.transform : CATransform3DMakeTranslation(0.0, 0.0, 0.0)])
            .play()
    }
    
    /**
    Jiggle, creates an elastic transfrom effect by scaling layer's CATransform3D.
    - Parameter transformX: Initial `x` transformation scale.
    - Parameter transformY: Initial `y` transformation scale.
    - Returns: A new Tween<CALayer>.
    */
    @discardableResult public func jiggle(transformX:CGFloat =  1.25, transformY:CGFloat = 0.75) -> Tween<CALayer> {
        
        return Tween(target:self.layer)
            .keys(to:[\CALayer.transform : CATransform3DMakeScale(transformX, transformY, 1.0)])
            .duration(0.25)
            .ease(.outCirc)
            .after()
            .duration(0.125)
            .ease(.outBack)
            .keys(to: [\CALayer.transform : CATransform3DMakeScale(1.0 + ((1.0 - transformX) * 0.75), 1.0 + ((1.0 - transformY) * 0.75), 1.0)] )
            .after()
            .duration(0.75)
            .ease(.outElastic)
            .keys(to: [\CALayer.transform : CATransform3DMakeScale(1.0, 1.0, 1.0)] )
            .play()
    }
    
    /**
    Bounce, creates an bouncing transfrom effect by translating layer's CATransform3D.
    - Parameter transformX: Initial `x` transformation scale.
    - Parameter transformY: Initial `y` transformation scale.
    - Returns: A new Tween<CALayer>.
    */
    @discardableResult public func bounce(distance:CGFloat = -50, duration:Double = 0.75) -> Tween<CALayer> {
        
        return Tween(target:self.layer)
            .keys(to:[\CALayer.transform : CATransform3DMakeTranslation(0.0, distance, 0.0)])
            .duration(duration * 0.25)
            .ease(.outQuad)
            .after()
            .duration(duration * 0.75)
            .ease(.outBounce)
            .keys(to: [\CALayer.transform : CATransform3DMakeTranslation(0.0, 0.0, 0.0)] )
            .play()
    }
    
    /**
    Bounce, creates an bouncing transfrom effect by translating layer's CATransform3D.
    - Parameter speed:      Leap's time duration in seconds.
    - Parameter clockwise:  A Bool value that indicates if turns clockwise
    - Returns: A new Tween<TweenBlock<CGFloat>>.
    */
    @discardableResult public func loop(speed:Double = 2.0, clockwise:Bool = true) -> Tween< TweenBlock <CGFloat> > {

        //Create and replace new block
        self.tweenBlock = TweenBlock(value: 0.0 ) { value in
           self.layer.transform = CATransform3DMakeRotation( BasicMath.toRadians(degree: value), 0.0, 0.0, 1.0 )
        }
        
        return Tween(target:self.tweenBlock)
            .duration(speed)
            .keys(from: [\TweenBlock<CGFloat>.value : 0.0], to: [\TweenBlock<CGFloat>.value : clockwise ? 360.0 : -360.0])
            .onComplete { self.loop(speed: speed, clockwise: clockwise) }//Infinite loop
            .play()
    }
    
    ///Function to stop `loop()` anmation block.
    public func stopLoop(){
        //Remove tween block, Here comes Obj-c associated object to the rescue.
        Tweener.removeTweens(target: self.tweenBlock)
    }
}

#elseif os(macOS)
import AppKit

//Generate randomColor
extension NSColor{
    
    public static var randomColor: NSColor {
        get {
            return NSColor.init(red: CGFloat.random(in: 0 ..< 1.0),
            green: CGFloat.random(in: 0 ..< 1.0),
            blue: CGFloat.random(in: 0 ..< 1.0),
            alpha: 1.0)
        }
    }
}

///A collection of predefined animations ready to use for NSView.
extension NSView{
    
    ///Associated objects to encapsulate a tween block to make accessible to any instance.
    private struct NSViewAssociatedBlock { static var block:TweenBlock<CGFloat> = TweenBlock(value: 0.0 ){ value in } }
    
    ///Associated tween block.
    var tweenBlock: TweenBlock<CGFloat> {
        get {
            //Verify if has associated for first time.
            guard let block = objc_getAssociatedObject(self, &NSViewAssociatedBlock.block) as? TweenBlock<CGFloat>
            else { return NSViewAssociatedBlock.block }
            return block }
        set(value) {
            //Make sure to remove existing tweens after replacing.
            Tweener.removeTweens(target: self.tweenBlock)
            //FInally associate a new one.
            objc_setAssociatedObject(self, &NSViewAssociatedBlock.block, value, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    ///Get center point according view's current position.
    public func center() -> CGPoint  {
        return CGPoint(x: (self.frame.origin.x + (self.frame.size.width * 0.5)),
                       y: (self.frame.origin.y + (self.frame.size.height * 0.5)))
    }
    
    ///Center view to target point.
    public func center(_ point:CGPoint)  {
        self.frame.origin = CGPoint(x: (point.x - (self.frame.size.width * 0.5)), y: (point.y - (self.frame.size.height * 0.5)))
    }
        
    ///Move anchor keeping layer position, must be a value between 0.0 and 1.0
    public func translateLayerAnchor(_ point:CGPoint){
        self.layer!.anchorPoint = point
        self.layer!.position = CGPoint(x: self.frame.origin.x + self.frame.size.width * point.x,
                                       y: self.frame.origin.y + self.frame.size.height * point.y)
    }
    
    /**
    Spring, animates CATransform3D `x` and  `y` scale and returns to normal transformation.
     - Parameter scale:     Initial `x` and `y` scale transform after call `srpringBack()`.
     - Parameter duration:  Time duration in seconds.
     - Returns:             A new Tween<CALayer>.
    */
    @discardableResult public func spring(scale:CGFloat = 0.5, duration:Double = 1.0) -> Tween<CALayer> {
        
        if self.layer == nil { self.wantsLayer = true}
        self.translateLayerAnchor(CGPoint(x:0.5, y:0.5))
        
        self.layer!.transform = CATransform3DMakeScale(scale, scale, 1.0)
        return springBack(duration:duration)
    }

    /**
    Spring Back, animates CATransform3D `x` and  `y` to normal transformation with an `.outElastic` curve.
     - Parameter duration:  Time duration in seconds.
     - Returns:             A new Tween<CALayer>.
    */
    @discardableResult public func springBack(duration:Double = 1.0) -> Tween<CALayer> {
        
        if self.layer == nil { self.wantsLayer = true}
        self.translateLayerAnchor(CGPoint(x:0.5, y:0.5))
    
        return Tween(target: self.layer!)
            .duration(duration)
            .ease(.outElastic)
            .keys(to: [\CALayer.transform : CATransform3DMakeScale(1.0, 1.0, 1.0)] )
            .play()
    }
    
    /**
    Zoom, animates CATransform3D `x` and  `y` scale to normal position with an `.outCirc` animation curve.
    WARNING: Using zero scale value in CALayer's transform causes program error.
     - Parameter scale:     Initial `x` and `y` scale.
     - Parameter duration:  Time duration in seconds.
     - Returns:             A new Tween<CALayer>.
    */
    @discardableResult public func zoom(scale:CGFloat = 1.5, duration:Double = 0.75) -> Tween<CALayer> {
        
        if self.layer == nil { self.wantsLayer = true}
        self.translateLayerAnchor(CGPoint(x:0.5, y:0.5))
        self.layer!.transform = CATransform3DMakeScale(scale, scale, 1.0)
        
        return Tween(target: self.layer!)
            .duration(duration)
            .ease(.outCirc)
            .keys( to:[\CALayer.transform : CATransform3DMakeScale(1.0, 1.0, 1.0)])
            .play()
    }
    
    /**
    Zoom In, animates CATransform3D `x` and  `y` scale from 0.1 to normal position.
     - Parameter duration:  Time duration in seconds.
     - Returns:             A new Tween<CALayer>.
    */
    @discardableResult public func zoomIn(duration:Double = 0.75) -> Tween<CALayer> {
        return zoom(scale:0.01, duration:duration)
    }
    
    /**
    Zoom Out, animates CATransform3D `x` and  `y` scale from 2.0 to normal position.
     - Parameter duration:  Time duration in seconds.
     - Returns:             A new Tween<CALayer>.
    */
    @discardableResult public func zoomOut(duration:Double = 0.75) -> Tween<CALayer> {
        return zoom(scale:2.0, duration:duration)
    }
    
    /**
    Fade effect, animates CALayer's opacity.
    - Parameter opacity:    Custom opacity.
    - Parameter duration:   Time duration in seconds.
    - Returns: A new Tween<CALayer>.
    */
    @discardableResult public func fade(opacity:Float = 0.0, duration:Double = 0.75) -> Tween<CALayer> {
        
        if self.layer == nil { self.wantsLayer = true}
        
        return Tween(target: self.layer!)
            .duration(duration)
            .keys(to: [\CALayer.opacity : opacity])
            .play()
    }
    
    /**
    Fade In, animates opacity  from 0.0  to 1.0.
     - Parameter duration:  Time duration in seconds.
     - Returns: A new Tween<CALayer>.
    */
    @discardableResult public func fadeIn(duration:Double = 0.75) -> Tween<CALayer> {
        if self.layer == nil { self.wantsLayer = true}
        self.layer!.opacity = 0.0
        return self.fade(opacity:1.0, duration:duration)
    }
    
    /**
    Fade Out, animates opacity  from 1.0  to 0.0.
     - Parameter duration:  Time duration in seconds.
     - Returns: A new Tween<CALayer>.
    */
    @discardableResult public func fadeOut(duration:Double = 0.75) -> Tween<CALayer> {
        if self.layer == nil { self.wantsLayer = true}
        self.layer!.opacity = 1.0
        return self.fade(opacity:0.0, duration:duration)
    }
    
    /**
    Pop, animates CATransform3D `x` and  `y` scale and returns to normal transformation.
     - Parameter scale: Desired scale to animate after call srpringBack() and animate to normal transformation.
     - Returns: A new Tween<CALayer>.
    */
    @discardableResult public func pop(scale:CGFloat = 1.25) -> Tween<CALayer> {
        
        if self.layer == nil { self.wantsLayer = true}
        
        self.translateLayerAnchor(CGPoint(x:0.5, y:0.5))
        self.layer!.transform = CATransform3DIdentity

        return Tween(target: self.layer!)
            .duration(0.25)
            .ease(.outCirc)
            .keys(to: [\CALayer.transform : CATransform3DMakeScale(scale, scale, 1.0)])
            .onComplete { self.springBack() }
            .play()
    }

    
    /**
    Basic In, animates  CATransform3D `x` and  `y`"from" desired translation "to" normal translation.
     - Parameter distanceX: Desired intial translation over x coordinate.
     - Parameter distanceY: Desired intial translation over y coordinate.
     - Parameter duration:  Time duration in seconds.
     - Parameter ease:      An `Equation` block for animation curve, `.none` by default.
     - Returns: A new Tween<CALayer>.
    */
    @discardableResult public func basicIn(distanceX:CGFloat = 100, distanceY:CGFloat = 100, duration:Double = 1.0, ease:Ease = .none)  -> Tween<CALayer>  {

        if self.layer == nil { self.wantsLayer = true}
        self.translateLayerAnchor(CGPoint(x:0.5, y:0.5))

        //Go to initial position
        self.layer!.transform = CATransform3DMakeTranslation(distanceX, distanceY, 0.0)

        return Tween(target: self.layer!)
            .duration(duration)
            .ease(ease)
            .keys(to: [\CALayer.transform : CATransform3DIdentity])
            .play()
    }

    /**
    Basic Out, animates  CATransform3D `x` and  `y`"from" normal translation "to" desired translation.
     - Parameter distanceX: Desired destination translation over `x` coordinate.
     - Parameter distanceY: Desired destination translation over `y` coordinate.
     - Parameter duration:  Time duration in seconds.
     - Parameter ease:      An `Equation` block for animation curve, `.none` by default.
     - Returns: A new Tween<CALayer>.
    */
    @discardableResult public func basicOut(distanceX:CGFloat = 100, distanceY:CGFloat = 100, duration:Double = 1.0, ease:Ease = .none) -> Tween<CALayer> {

        if self.layer == nil { self.wantsLayer = true}
        self.translateLayerAnchor(CGPoint(x:0.5, y:0.5))

        //Go to initial position
        self.layer!.transform = CATransform3DIdentity

        return Tween(target: self.layer!)
            .duration(duration)
            .ease(ease)
            .keys(to: [\CALayer.transform : CATransform3DMakeTranslation(distanceX, distanceY, 0.0)])
            .play()
    }
    
    /**
    Fly, animates to normal translation calling `basicIn()` with `.outBack` as animation curve.
    - Parameter distanceX: Desired initial translation over `x` coordinate.
    - Parameter distanceY: Desired initial translation over `y` coordinate.
    - Parameter duration:  Time duration in seconds.
    - Returns: A new Tween<CALayer>.
    */
    @discardableResult public func fly(distanceX:CGFloat = 200, distanceY:CGFloat = 200, duration:Double = 0.5) -> Tween<CALayer> {
        return self.basicIn(distanceX: distanceX, distanceY: distanceY, duration: duration, ease: .outBack)
    }

    /**
    Fly left, animates from left to normal translation calling `fly()` over horizontal axis from a positive intial translation.
    - Parameter distance:   Desired initial translation over `x` coordinate.
    - Parameter duration:   Time duration in seconds.
    - Returns: A new Tween<CALayer>.
    */
    @discardableResult public func flyLeft(distance:CGFloat = 200, duration:Double = 0.75 ) -> Tween<CALayer> {
        fly(distanceX:(distance < 0 ? distance : distance * -1.0), distanceY:0, duration: duration )
    }
    
    /**
    Fly right, animates from right to normal translation calling `fly()` over horizontal axis from a negative intial translation.
    - Parameter distance:   Desired initial translation over `x` coordinate.
    - Parameter duration:   Time duration in seconds.
    - Returns: A new Tween<CALayer>.
    */
    @discardableResult public func flyRight(distance:CGFloat = 200, duration:Double = 0.75 ) -> Tween<CALayer> {
        fly(distanceX:(distance > 0 ? distance : distance * -1.0), distanceY:0, duration: duration )
    }

    /**
    Fly top, animates from top to normal translation calling `fly()` over vertical axis from a negative intial translation.
    - Parameter distance:   Desired initial translation over `y` coordinate.
    - Parameter duration:   Time duration in seconds.
    - Returns: A new Tween<CALayer>.
    */
    @discardableResult public func flyTop(distance:CGFloat = 200, duration:Double = 0.75 ) -> Tween<CALayer> {
        fly(distanceX: 0, distanceY: (distance > 0 ? distance : distance * -1.0), duration:duration)
    }
    
    /**
    Fly bottom, animates from bottom to normal translation calling `fly()` over vertical axis from a positive intial translation.
    - Parameter distance:   Desired initial translation over `y` coordinate.
    - Parameter duration:   Time duration in seconds.
    - Returns: A new Tween<CALayer>.
    */
    @discardableResult public func flyBottom(distance:CGFloat = 200, duration:Double = 0.75 ) -> Tween<CALayer> {
        fly(distanceX: 0, distanceY: (distance < 0 ? distance : distance * -1.0), duration: duration)
    }
    
    /**
    Slide, animates to normal translation calling `basicIn()` with `.outCubic` as animation curve.
    - Parameter distanceX: Desired initial translation over `x` coordinate.
    - Parameter distanceY: Desired initial translation over `y` coordinate.
    - Parameter duration:  Time duration in seconds.
    - Returns: A new Tween<CALayer>.
    */
    @discardableResult public func slide(distanceX:CGFloat = 200, distanceY:CGFloat = 200, duration:Double = 1.0) -> Tween<CALayer> {
        return self.basicIn(distanceX: distanceX, distanceY: distanceY, duration: duration, ease: .outCubic)
    }
    
    /**
    Slide left, animates from left to normal translation calling `slide()` over horizontal axis from a positive intial translation.
    - Parameter distance:   Desired initial translation over `x` coordinate.
    - Parameter duration:   Time duration in seconds.
    - Returns: A new Tween<CALayer>.
    */
    @discardableResult public func slideLeft(distance:CGFloat = 200, duration:Double = 0.75 ) -> Tween<CALayer> {
        slide(distanceX: (distance < 0 ? distance : distance * -1.0), distanceY:0, duration: duration )
    }
    
    /**
    Slide right, animates from right to normal translation calling `slide()` over horizontal axis from a negative intial translation.
    - Parameter distance:   Desired initial translation over `x` coordinate.
    - Parameter duration:   Time duration in seconds.
    - Returns: A new Tween<CALayer>.
    */
    @discardableResult public func slideRight(distance:CGFloat = 200, duration:Double = 0.75 ) -> Tween<CALayer> {
        slide(distanceX: (distance > 0 ? distance : distance * -1.0), distanceY:0, duration: duration )
    }

    /**
    Slide top, animates from top to normal translation calling `slide()` over vertical axis from a negative intial translation.
    - Parameter distance:   Desired initial translation over `y` coordinate.
    - Parameter duration:   Time duration in seconds.
    - Returns: A new Tween<CALayer>.
    */
    @discardableResult public func slideTop(distance:CGFloat = 200, duration:Double = 0.75 ) -> Tween<CALayer> {
        slide(distanceX:0, distanceY: (distance > 0 ? distance : distance * -1.0), duration:duration)
    }
    
    /**
    Slide bottom, animates from bottom to normal translation calling `slide()` over vertical axis from a positive intial translation.
    - Parameter distance:   Desired initial translation over `y` coordinate.
    - Parameter duration:   Time duration in seconds.
    - Returns: A new Tween<CALayer>.
    */
    @discardableResult public func slideBottom(distance:CGFloat = 200, duration:Double = 0.75 ) -> Tween<CALayer> {
        slide(distanceX:0, distanceY: (distance < 0 ? distance : distance * -1.0), duration: duration)
    }
    
    /**
    Swing, animates CATransform3D `z` axis rotation from a desired angle back to normal rotation 'swinging".
    - Parameter angle:      Desired initial rotation over `z` coordinate.
    - Parameter duration:   Time duration in seconds.
    - Returns: A new Tween<TweenBlock<CGFloat>>.
    */
    @discardableResult public func swing(angle:CGFloat = 22.5, duration:Double = 1.0) -> Tween<TweenBlock<CGFloat>> {
        
        if self.layer == nil { self.wantsLayer = true}
        self.translateLayerAnchor(CGPoint(x:0.5, y:0.5))

        //Replace associated block
        self.tweenBlock = TweenBlock(value: 0.0 ) { value in
            //Play with updated value.
            self.layer!.transform = CATransform3DMakeRotation(BasicMath.toRadians(degree: value),
                                                             0.0,
                                                             0.0,
                                                             1.0)
        }
        
        //Animation chain
        return  Tween(target:self.tweenBlock)
            .ease(.inOutQuad)
            .duration(duration * 0.35)
            .keys(to: [\TweenBlock<CGFloat>.value : angle])
            .after(duration:duration * 0.3)//Creates new after
            .keys(to: [\TweenBlock<CGFloat>.value : -1.0 * angle])
            .after(duration:duration * 0.2)//Creates new after
            .keys(to: [\TweenBlock<CGFloat>.value : angle * 0.75])
            .after(duration:duration * 0.15)//Creates new after
            .keys(to:[\TweenBlock<CGFloat>.value : 0.0 ])
            .play()
    }
    
    /**
    Flip, animates CATransform3D `x` and/or `y` axis rotation performing a 3D flip effect with perspective.
    - Parameter xAxis:      A Bool value to enable `x` axis.
    - Parameter yAxis:      A Bool value to enable `y` axis.
    - Parameter inverted:   A Bool value to invert enabled axles.
    - Parameter duration:   Time duration in seconds.
    - Returns: A new Tween<TweenBlock<CGFloat>>.
    */
    @discardableResult public func flip(xAxis:Bool = false, yAxis:Bool = false, inverted:Bool = false, duration:Double = 1.0) -> Tween<TweenBlock<CGFloat>> {
                
        if self.layer == nil { self.wantsLayer = true}
        self.translateLayerAnchor(CGPoint(x:0.5, y:0.5))
        
        self.tweenBlock = TweenBlock(value: 0.0 ) { value in
            //Create a perspective matrix
            var perspective = CATransform3DIdentity
            perspective.m34 = 1.0 / 500.0
            //And rotate while updating.
            self.layer!.transform = CATransform3DRotate(perspective,
                                                       BasicMath.toRadians(degree:inverted ? -value : value),
                                                       yAxis ? 1.0 : 0.0,
                                                       xAxis ? 1.0 : 0.0,
                                                       0.0)
        }
        
        return Tween(target:self.tweenBlock)
        .duration(duration)
        .ease(.inOutQuad)
        .keys(to: [\TweenBlock<CGFloat>.value:180.0])
        .play()

    }
    
    /**
    Flip X, animates CATransform3D `x` axis rotation performing a 3D flip effect with perspective.
    - Parameter inverted:  A Bool value to invert `x` axis and flip in opposite direction.
    - Parameter duration:  Time duration in seconds.
    - Returns: A new Tween<TweenBlock<CGFloat>>.
    */
    @discardableResult public func flipX(inverted:Bool = false) -> Tween<TweenBlock<CGFloat>> { return flip(xAxis: true, inverted: inverted) }
    
    /**
    Flip Y, animates CATransform3D `y` axis rotation performing a 3D flip effect with perspective.
    - Parameter inverted:  A Bool value to invert `y` axis and flip in opposite direction.
    - Parameter duration:  Time duration in seconds.
    - Returns: A new Tween<TweenBlock<CGFloat>>.
    */
    @discardableResult public func flipY(inverted:Bool = false) -> Tween<TweenBlock<CGFloat>> { return flip(yAxis: true, inverted: inverted) }
    
    /**
    Spin, animates CATransform3D `x` and/or `y` axis rotation performing a 3D flip effect with perspective.
    - Parameter leaps:      An Int value that indicates number of leaps.
    - Parameter duration:   Time duration in seconds.
    - Parameter clockwise:  A Bool value that indicates if turns clockwise
    - Returns: A new Tween<TweenBlock<CGFloat>>.
    */
    @discardableResult public func spin(leaps:Int = 1, duration:Double = 0.5, clockwise:Bool = true)  -> Tween<TweenBlock<CGFloat>> {
        
        if self.layer == nil { self.wantsLayer = true}
        self.translateLayerAnchor(CGPoint(x:0.5, y:0.5))
        
        self.tweenBlock = TweenBlock(value: 0.0 )  { value in
            //Play with updated value.
            self.layer!.transform = CATransform3DMakeRotation(BasicMath.toRadians(degree: value),
                                                             0.0,
                                                             0.0,
                                                             1.0)
        }
        let rotation = 360.0 * CGFloat( leaps )
        return Tween(target:self.tweenBlock)
                    .duration( 0.75 )
                    .ease( .inOutQuad )
                    .keys(to: [\TweenBlock<CGFloat>.value : clockwise ? rotation : -rotation ])
                    .play()
    }
    
    /**
    Shake, creates an animated shake effect with layer's CATransform3D translating over `x` coordinate.
    - Parameter distance: Desired shake translation distance over `x` coordinate.
    - Parameter leaps:    An Int value that indicates number of shakes.
    - Returns: A new Tween<CALayer>.
    */
    @discardableResult public func shake(distance:CGFloat = 10, shakes:Int = 5)  -> Tween<CALayer> {
        
        if self.layer == nil { self.wantsLayer = true}
        self.translateLayerAnchor(CGPoint(x:0.5, y:0.5))
        
        var tween = Tween(target:self.layer!).ease(.inOutQuad).duration(0.1)
        
        for i in 0 ... shakes{
            tween.keys(to:[\CALayer.transform : CATransform3DMakeTranslation(i % 2 == 0 ? -distance : distance, 0.0, 0.0)])
            tween = tween.after()//Important!
        }
        
        //Use last to return normal position
        return tween.keys(to:[\CALayer.transform : CATransform3DMakeTranslation(0.0, 0.0, 0.0)])
            .play()
    }
    
    /**
    Jiggle, creates an elastic transfrom effect by scaling layer's CATransform3D.
    - Parameter transformX: Initial `x` transformation scale.
    - Parameter transformY: Initial `y` transformation scale.
    - Returns: A new Tween<CALayer>.
    */
    @discardableResult public func jiggle(transformX:CGFloat =  1.25, transformY:CGFloat = 0.75) -> Tween<CALayer> {
        
        if self.layer == nil { self.wantsLayer = true}
        self.translateLayerAnchor(CGPoint(x:0.5, y:0.5))
        
        return Tween(target:self.layer!)
            .keys(to:[\CALayer.transform : CATransform3DMakeScale(transformX, transformY, 1.0)])
            .duration(0.25)
            .ease(.outCirc)
            .after()
            .duration(0.125)
            .ease(.outBack)
            .keys(to: [\CALayer.transform : CATransform3DMakeScale(1.0 + ((1.0 - transformX) * 0.75), 1.0 + ((1.0 - transformY) * 0.75), 1.0)] )
            .after()
            .duration(0.75)
            .ease(.outElastic)
            .keys(to: [\CALayer.transform : CATransform3DMakeScale(1.0, 1.0, 1.0)] )
            .play()
    }
    
    /**
    Bounce, creates an bouncing transfrom effect by translating layer's CATransform3D.
    - Parameter transformX: Initial `x` transformation scale.
    - Parameter transformY: Initial `y` transformation scale.
    - Returns: A new Tween<CALayer>.
    */
    @discardableResult public func bounce(distance:CGFloat = 50, duration:Double = 0.75) -> Tween<CALayer> {
        
        if self.layer == nil { self.wantsLayer = true}
        self.translateLayerAnchor(CGPoint(x:0.5, y:0.5))
        
        return Tween(target:self.layer!)
            .keys(to:[\CALayer.transform : CATransform3DMakeTranslation(0.0, distance, 0.0)])
            .duration(duration * 0.25)
            .ease(.outQuad)
            .after()
            .duration(duration * 0.75)
            .ease(.outBounce)
            .keys(to: [\CALayer.transform : CATransform3DMakeTranslation(0.0, 0.0, 0.0)] )
            .play()
    }
    
    /**
    Bounce, creates an bouncing transfrom effect by translating layer's CATransform3D.
    - Parameter speed:      Leap's time duration in seconds.
    - Parameter clockwise:  A Bool value that indicates if turns clockwise
    - Returns: A new Tween<TweenBlock<CGFloat>>.
    */
    @discardableResult public func loop(speed:Double = 2.0, clockwise:Bool = true) -> Tween< TweenBlock <CGFloat> > {
        
        if self.layer == nil { self.wantsLayer = true}
        self.translateLayerAnchor(CGPoint(x:0.5, y:0.5))
        
        //Create and replace new block
        self.tweenBlock = TweenBlock(value: 0.0 ) { value in
           self.layer!.transform = CATransform3DMakeRotation( BasicMath.toRadians(degree: value), 0.0, 0.0, 1.0 )
        }
        
        return Tween(target:self.tweenBlock)
            .duration(speed)
            .keys(from: [\TweenBlock<CGFloat>.value : 0.0], to: [\TweenBlock<CGFloat>.value : clockwise ? 360.0 : -360.0])
            .onComplete { self.loop(speed: speed, clockwise: clockwise) }//Infinite loop
            .play()
    }
    
    ///Function to stop `loop()` anmation block.
    public func stopLoop(){
        //Remove tween block, Here comes Obj-c associated object to the rescue.
        Tweener.removeTweens(target: self.tweenBlock)
    }
}
#endif

//TODO:SwiftUI View extensions, iOS 13.0 and macOS 10.15 target

/*#if canImport(SwiftUI)
import SwiftUI
#endif

#if os(iOS) || os(macOS)
@available(iOS 13, macOS 10.15, *)
    //extension View { }
#endif*/



