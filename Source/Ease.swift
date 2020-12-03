//
//  Ease.swift
//  Tweener
//
//  Created by Alejandro Ramirez Varela on 9/10/18.
//  Copyright © 2018 Alejandro Ramirez Varela. All rights reserved.
//

/*
 Disclaimer for Robert Penner's Easing Equations license:
 
 TERMS OF USE - EASING EQUATIONS
 
 Open source under the BSD License.
 
 Copyright © 2001 Robert Penner
 All rights reserved.
 
 Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
 
 * Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
 * Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
 * Neither the name of the author nor the names of contributors may be used to endorse or promote products derived from this software without specific prior written permission.
 
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

// (the original equations are Robert Penner's work as mentioned on the disclaimer)

import Foundation

/**
 Block for equations.
 - Parameter t:         Current time (in frames or seconds).
 - Parameter b:         Starting value.
 - Parameter c:         Change needed in value.
 - Parameter d:         Expected easing duration (in frames or seconds).
 - returns:             A Double with the correct value.
 */
public typealias Equation = (_ t:Double, _ b:Double, _ c:Double, _ d:Double) -> Double

///A base struct for Easing equations
public struct Ease {
    ///A public var for equation instance, linear by default.
    public var equation:Equation = { (t, b, c, d) in return c * t / d + b }
    ///Public constructor.
    public init(equation:@escaping Equation) { self.equation = equation }
}

///Ease extensions with equations declared statically.
extension Ease {
    //MARK: - None
    
    ///Easing equation function for a simple linear tweening, with no easing.
    public static let none = Ease(equation:{ (t, b, c, d) in
        return c * t / d + b
    })
    
    //MARK: - Quad
    
    /// Easing equation function for a quadratic (t^2) easing in: accelerating from zero velocity.
    public static let inQuad = Ease(equation:{ (t, b, c, d) in
        let i = t / d
        return c * i * i + b
    })
    
    /// Easing equation function for a quadratic (t^2) easing out: decelerating to zero velocity.
    public static let outQuad = Ease(equation:{ (t, b, c, d) in
        let i = t / d
        return (-c) * i * ( i - 2) + b
    })
    
    /// Easing equation function for a quadratic (t^2) easing in/out: acceleration until halfway, then deceleration.
    public static let inOutQuad = Ease(equation:{ (t, b, c, d) in
        if t < d/2 { return Ease.inQuad.equation(t*2, b, c/2, d)}
        return Ease.outQuad.equation((t*2)-d, b+c/2, c/2, d)
    })
    /// Easing equation function for a quadratic (t^2) easing out/in: deceleration until halfway, then acceleration.
    public static let outInQuad = Ease(equation:{ (t, b, c, d) in
        if t < d / 2 { return Ease.outQuad.equation(t * 2, b, c / 2, d)}
        return Ease.inQuad.equation((t * 2) - d, b + c / 2, c / 2, d)
    })

    //MARK: - Cubic
    
    /// Easing equation function for a cubic (t^3) easing in: accelerating from zero velocity.
    public static let inCubic = Ease(equation:{ (t, b, c, d) in
        let i = t/d
        return c*i*i*i+b
    })
    
    /// Easing equation function for a cubic (t^3) easing out: decelerating from zero velocity.
    public static let outCubic = Ease(equation:{ (t, b, c, d) in
        let i = t/d-1
        return c*(i*i*i+1)+b
    })
    
    /// Easing equation function for a cubic (t^3) easing in/out: acceleration until halfway, then deceleration.
    public static let inOutCubic = Ease(equation:{ (t, b, c, d) in
        var i = t/(d/2)
        if i < 1 {return c/2*i*i*i+b}
        i=i-2
        return c/2*(i*i*i+2)+b
    })
    
    /// Easing equation function for a cubic (t^3) easing out/in: deceleration until halfway, then acceleration.
    public static let outInCubic = Ease(equation:{ (t, b, c, d) in
        if t < d/2 {return Ease.outCubic.equation(t*2,b,c/2,d)}
        return Ease.inCubic.equation((t*2)-d,b+c/2,c/2,d)
    })

    //MARK: - Quart
    
    /// Easing equation function for a quartic (t^4) easing in: accelerating from zero velocity.
    public static let inQuart = Ease(equation:{ (t, b, c, d) in
        let i = (t/d)
        return c*i*i*i*i+b
    })
    
    /// Easing equation function for a quartic (t^4) easing out: decelerating from zero velocity.
    public static let outQuart = Ease(equation:{ (t, b, c, d) in
        let i = t/d-1
        return (-c)*(i*i*i*i-1)+b
    })
    
    /// Easing equation function for a quartic (t^4) easing in/out: acceleration until halfway, then deceleration.
    public static let inOutQuart = Ease(equation:{ (t, b, c, d) in
        var i = t/(d/2)
        if i < 1 {return c/2*i*i*i*i + b}
        i=i-2
        return (-c)/2*(i*i*i*i-2)+b
    })
    
    /// Easing equation function for a quartic (t^4) easing out/in: deceleration until halfway, then acceleration.
    public static let outInQuart = Ease(equation:{ (t, b, c, d) in
        if t < d/2 {return Ease.outQuart.equation(t*2, b, c/2, d)}
        return Ease.inQuart.equation((t*2)-d, b+c/2, c/2, d)
    })
    
    //MARK: - Quint
    
    /// Easing equation function for a quintic (t^5) easing in: accelerating from zero velocity.
    public static let inQuint = Ease(equation:{ (t, b, c, d) in
        let i = t/d
        return c*i*i*i*i*i+b
    })
    
    /// Easing equation function for a quintic (t^5) easing out: decelerating from zero velocity.
    public static let outQuint = Ease(equation:{ (t, b, c, d) in
        let i = t/d-1
        return c*(i*i*i*i*i+1)+b
    })
    
    /// Easing equation function for a quintic (t^5) easing in/out: acceleration until halfway, then deceleration.
    public static let inOutQuint = Ease(equation:{ (t, b, c, d) in
        var i = t/(d/2)
        if i < 1 {return c/2*i*i*i*i*i+b}
        i = i-2
        return c/2*(i*i*i*i*i+2)+b
    })
    
    /// Easing equation function for a quintic (t^5) easing out/in: deceleration until halfway, then acceleration.
    public static let outInQuint = Ease(equation:{ (t, b, c, d) in
        if t < d/2 {return Ease.outQuint.equation(t*2, b, c/2, d)}
        return Ease.inQuint.equation((t*2)-d, b+c/2, c/2, d)
    })

    //MARK: - Sine
    
    /// Easing equation function for a sinusoidal (sin(t)) easing in: accelerating from zero velocity.
    public static let inSine = Ease(equation:{ (t, b, c, d) in
        var i = t/d*(Double.pi/2)
        i = cos(i)
        i = (-c)*i+c+b
        return i
    })
    
    /// Easing equation function for a sinusoidal (sin(t)) easing out: decelerating from zero velocity.
    public static let outSine = Ease(equation:{ (t, b, c, d) in
        let i = t/d*(Double.pi/2)
        return c*sin(i)+b
    })
    
    /// Easing equation function for a sinusoidal (sin(t)) easing in/out: acceleration until halfway, then deceleration.
    public static let inOutSine = Ease(equation:{ (t, b, c, d) in
        var i = Double.pi*t/d
        i = cos(i)-1
        i = (-c)/2*i+b
        return i
    })
    
    /// Easing equation function for a sinusoidal (sin(t)) easing out/in: deceleration until halfway, then acceleration.
    public static let outInSine = Ease(equation:{ (t, b, c, d) in
        if t < d/2 {return Ease.outSine.equation(t*2, b, c/2, d)}
        return Ease.inSine.equation((t*2)-d, b+c/2, c/2, d)
    })
    
    //MARK: - Expo
    
    /// Easing equation function for an exponential (2^t) easing in: accelerating from zero velocity.
    public static let inExpo = Ease(equation:{ (t, b, c, d) in
        var i = pow(2, 10 * (t/d - 1))
        i = (t==0) ? b : c * i + b - c * 0.001
        return i
    })
    
    /// Easing equation function for an exponential (2^t) easing out: decelerating from zero velocity.
    public static let outExpo = Ease(equation:{ (t, b, c, d) in
        var  i = -pow(2, -10 * t/d) + 1
        i = (t==d) ? b+c : c * 1.001 * i + b
        return i
    })
    
    /// Easing equation function for an exponential (2^t) easing in/out: acceleration until halfway, then deceleration.
    public static let inOutExpo = Ease(equation:{ (t, b, c, d) in
        if t==0 {return b}
        if t==d {return b+c}
        var i = t/(d/2)
        if i < 1 {return c/2 * pow(2, 10 * (i - 1)) + b - c * 0.0005}
        i = i-1
        return c/2 * 1.0005 * (-pow(2, -10 * i) + 2) + b
    })
    
    /// Easing equation function for an exponential (2^t) easing out/in: deceleration until halfway, then acceleration.
    public static let outInExpo = Ease(equation:{ (t, b, c, d) in
        if t < d/2 {return Ease.outExpo.equation(t*2, b, c/2, d)}
        return Ease.inExpo.equation((t*2)-d, b+c/2, c/2, d)
    })
    
    //MARK: - Circ
    
    /// Easing equation function for a circular (sqrt(1-t^2)) easing in: accelerating from zero velocity.
    public static let inCirc = Ease(equation:{ (t, b, c, d) in
        let i = t/d//TODO:Bugfix nan
        return (-c)*(sqrt(1-i*i)-1)+b
    })
    
    /// Easing equation function for a circular (sqrt(1-t^2)) easing out: decelerating from zero velocity.
    public static let outCirc = Ease(equation:{ (t, b, c, d) in
        let i = t/d-1//TODO:Bugfix nan
        return c*sqrt(1-i*i)+b
    })
    
    /// Easing equation function for a circular (sqrt(1-t^2)) easing in/out: acceleration until halfway, then deceleration.
    public static let inOutCirc = Ease(equation:{ (t, b, c, d) in
        var i = t/(d/2)
        if i < 1 {return -c/2*(sqrt(1-i*i)-1)+b}
        i = i-2
        return c/2*(sqrt(1-i*i)+1)+b
    })
    
    /// Easing equation function for a circular (sqrt(1-t^2)) easing out/in: deceleration until halfway, then acceleration.
    public static let outInCirc = Ease(equation:{ (t, b, c, d) in
        if t < d/2 {return Ease.outCirc.equation(t*2, b, c/2, d)}
        return Ease.inCirc.equation((t*2)-d, b+c/2, c/2, d)
    })
    
    //MARK: - Elastic
    
    /// Easing equation function for an elastic (exponentially decaying sine wave) easing in: accelerating from zero velocity.
    public static let inElastic = Ease(equation:{ (t, b, c, d) in
        if t==0.0 {return b}
        var i = t/d
        if i==1.0 {return b+c}
        var p = d*0.3
        var s = 0.0
        var a = c
        if a < fabs(c) {s = p/4.0}
        else {s = p/(2.0*Double.pi)*(a==0.0 ? 0.0:asin(c/a))}
        i = i-1
        return -(a*pow(2.0,10.0*i)*sin((i*d-s)*(2.0*Double.pi)/p))+b
    })
    
    /// Easing equation function for an elastic (exponentially decaying sine wave) easing out: decelerating from zero velocity.
    public static let outElastic = Ease(equation:{ (t, b, c, d) in
        if t==0.0 {
            return b}
        var i = t/d
        if i==1.0 {
            return b+c}
        var p = d*0.3
        var s = 0.0
        var a = c
        if a < fabs(c){s = p/4.0}
        else {s = p/(2.0*Double.pi)*(a==0.0 ? 0.0:asin(c/a))}
        return (a*pow(2.0,-10.0*i)*sin((i*d-s)*(2.0*Double.pi)/p)+c+b)
    })
    
    /// Easing equation function for an elastic (exponentially decaying sine wave) easing in/out: acceleration until halfway, then deceleration.
    public static let inOutElastic = Ease(equation:{ (t, b, c, d) in
        if t==0.0 {return b}
        var i = t/(d/2.0)
        if i==2.0 {return b+c}
        var p = d*(0.3*1.5)
        var s = 0.0
        var a = c
        if (a < fabs(c)){s = p/4.0}
        else {s = p/(2.0*Double.pi)*(a==0.0 ? 0.0:asin(c/a))}
        if (i < 1.0){
            i = i-1
            return -0.5*(a*pow(2.0,10*i)*sin((i*d-s)*(2.0*Double.pi)/p))+b}
        else{
            i = i-1.0
            return a*pow(2.0,-10.0*i)*sin((i*d-s)*(2*Double.pi)/p)*0.5+c+b}
    })
    
    public static let outInElastic = Ease(equation:{ (t, b, c, d) in
        if t < d/2.0 {return Ease.outElastic.equation(t*2, b, c/2, d)}
        return Ease.inElastic.equation((t*2)-d, b+c/2, c/2, d)
    })

    //MARK: - Back
    public static let inBack = Ease(equation:{ (t, b, c, d) in
        let i = t/d
        let s = 1.70158
        return c*i*i*((s+1)*i-s)+b
    })
    
    public static let outBack = Ease(equation:{ (t, b, c, d) in
        let i = t/d-1
        let s = 1.70158
        return c*(i*i*((s+1)*i+s)+1)+b
    })
    
    public static let inOutBack = Ease(equation:{ (t, b, c, d) in
        var i = t/(d/2)
        let s = 1.70158 * 1.525
        if i < 1 {return c/2*(i*i*((s+1)*i-s))+b}
        i = i-2
        return c/2*(i*i*((s+1)*i+s)+2)+b
    })
    
    public static let outInBack = Ease(equation:{ (t, b, c, d) in
        if t < d/2 {return Ease.outBack.equation(t*2, b, c/2, d)}
        return Ease.inBack.equation((t*2)-d, b+c/2, c/2, d)
    })
    
    //MARK: - Bounce
    public static let inBounce = Ease(equation:{ (t, b, c, d) in
        return c - Ease.outBounce.equation(d-t, 0, c, d) + b
    })
    
    public static let outBounce = Ease(equation:{ (t, b, c, d) in
        var i = t/d
        if i < (1/2.75) {
            return c*(7.5625*i*i)+b
        } else if i < (2/2.75) {
            i = i-(1.5/2.75)
            return c*(7.5625*i*i+0.75)+b
        } else if i < (2.5/2.75) {
            i = i-(2.25/2.75)
            return c*(7.5625*i*i+0.9375)+b
        } else {
            i = i-(2.625/2.75)
            return c*(7.5625*i*i+0.984375)+b
        }
    })
    
    public static let inOutBounce = Ease(equation:{ (t, b, c, d) in
        if t < d/2 {return Ease.inBounce.equation(t*2, 0.0, c, d) * 0.5 + b}
        return Ease.outBounce.equation(t*2-d, 0.0, c, d) * 0.5 + c*0.5 + b
    })
    
    public static let outInBounce = Ease(equation:{ (t, b, c, d) in
        if t < d/2 {return Ease.outBounce.equation(t*2, b, c/2, d)}
        return Ease.inBounce.equation((t*2)-d, b+c/2, c/2, d)
    })
    
}


