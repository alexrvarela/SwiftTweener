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
 Data type for equations.
 - Parameter t:         Current time (in frames or seconds).
 - Parameter b:         Starting value.
 - Parameter c:         Change needed in value.
 - Parameter d:         Expected easing duration (in frames or seconds).
 - returns:             A Double with the correct value.
 */

public typealias Equation = (_ t:Double, _ b:Double, _ c:Double, _ d:Double) -> Double

public class Ease
{
    //MARK: - None
    
    ///Easing equation function for a simple linear tweening, with no easing.
    public static let none : Equation = { (t, b, c, d) in
        return c * t / d + b
    }
    
    //MARK: - Quad
    
    /// Easing equation function for a quadratic (t^2) easing in: accelerating from zero velocity.
    /// - let i: Time interpolation
    public static let inQuad : Equation = { (t, b, c, d) in
        let i = t / d
        return c * i * i + b
    }
    
    /// Easing equation function for a quadratic (t^2) easing out: decelerating to zero velocity.
    /// - let i: Time interpolation
    public static let outQuad : Equation = { (t, b, c, d) in
        let i = t / d
        return (-c) * i * ( i - 2) + b
    }
    
    /// Easing equation function for a quadratic (t^2) easing in/out: acceleration until halfway, then deceleration.
    /// - var i: Time interpolation
    public static let inOutQuad : Equation = { (t, b, c, d) in
        if t < d/2 { return Ease.inQuad(t*2, b, c/2, d)}
        return Ease.outQuad((t*2)-d, b+c/2, c/2, d)
    }
    /// Easing equation function for a quadratic (t^2) easing out/in: deceleration until halfway, then acceleration.
    public static let outInQuad : Equation = { (t, b, c, d) in
        if t < d / 2 { return Ease.outQuad(t * 2, b, c / 2, d)}
        return Ease.inQuad((t * 2) - d, b + c / 2, c / 2, d)
    }

    //MARK: - Cubic
    
    /// Easing equation function for a cubic (t^3) easing in: accelerating from zero velocity.
    public static let inCubic : Equation = { (t, b, c, d) in
        let i = t/d
        return c*i*i*i+b
    }
    
    /// Easing equation function for a cubic (t^3) easing out: decelerating from zero velocity.
    public static let outCubic : Equation = { (t, b, c, d) in
        let i = t/d-1
        return c*(i*i*i+1)+b
    }
    
    /// Easing equation function for a cubic (t^3) easing in/out: acceleration until halfway, then deceleration.
    public static let inOutCubic : Equation = { (t, b, c, d) in
        var i = t/(d/2)
        if i < 1 {return c/2*i*i*i+b}
        i=i-2
        return c/2*(i*i*i+2)+b
    }
    
    /// Easing equation function for a cubic (t^3) easing out/in: deceleration until halfway, then acceleration.
    public static let outInCubic : Equation = { (t, b, c, d) in
        if t < d/2 {return Ease.outCubic(t*2,b,c/2,d)}
        return Ease.inCubic((t*2)-d,b+c/2,c/2,d)
    }

    //MARK: - Quart
    
    /// Easing equation function for a quartic (t^4) easing in: accelerating from zero velocity.
    public static let inQuart : Equation = { (t, b, c, d) in
        let i = (t/d)
        return c*i*i*i*i+b
    }
    
    /// Easing equation function for a quartic (t^4) easing out: decelerating from zero velocity.
    public static let outQuart : Equation = { (t, b, c, d) in
        let i = t/d-1
        return (-c)*(i*i*i*i-1)+b
    }
    
    /// Easing equation function for a quartic (t^4) easing in/out: acceleration until halfway, then deceleration.
    public static let inOutQuart : Equation = { (t, b, c, d) in
        var i = t/(d/2)
        if i < 1 {return c/2*i*i*i*i + b}
        i=i-2
        return (-c)/2*(i*i*i*i-2)+b
    }
    
    /// Easing equation function for a quartic (t^4) easing out/in: deceleration until halfway, then acceleration.
    public static let outInQuart : Equation = { (t, b, c, d) in
        if t < d/2 {return Ease.outQuart(t*2, b, c/2, d)}
        return Ease.inQuart((t*2)-d, b+c/2, c/2, d)
    }
    
    //MARK: - Quint
    
    /// Easing equation function for a quintic (t^5) easing in: accelerating from zero velocity.
    public static let inQuint : Equation = { (t, b, c, d) in
        let i = t/d
        return c*i*i*i*i*i+b
    }
    
    /// Easing equation function for a quintic (t^5) easing out: decelerating from zero velocity.
    public static let outQuint : Equation = { (t, b, c, d) in
        let i = t/d-1
        return c*(i*i*i*i*i+1)+b
    }
    
    /// Easing equation function for a quintic (t^5) easing in/out: acceleration until halfway, then deceleration.
    public static let inOutQuint : Equation = { (t, b, c, d) in
        var i = t/(d/2)
        if i < 1 {return c/2*i*i*i*i*i+b}
        i = i-2
        return c/2*(i*i*i*i*i+2)+b
    }
    
    /// Easing equation function for a quintic (t^5) easing out/in: deceleration until halfway, then acceleration.
    public static let outInQuint : Equation = { (t, b, c, d) in
        if t < d/2 {return Ease.outQuint (t*2, b, c/2, d)}
        return Ease.inQuint((t*2)-d, b+c/2, c/2, d)
    }

    //MARK: - Sine
    
    /// Easing equation function for a sinusoidal (sin(t)) easing in: accelerating from zero velocity.
    public static let inSine : Equation = { (t, b, c, d) in
        return (-c)*cos(t/d*(Double.pi/2))+c+b
    }
    
    /// Easing equation function for a sinusoidal (sin(t)) easing out: decelerating from zero velocity.
    public static let outSine : Equation = { (t, b, c, d) in
        return c*sin(t/d * (Double.pi/2))+b
    }
    
    /// Easing equation function for a sinusoidal (sin(t)) easing in/out: acceleration until halfway, then deceleration.
    public static let inOutSine : Equation = { (t, b, c, d) in
        return (-c)/2*(cos(Double.pi*t/d)-1)+b
    }
    
    /// Easing equation function for a sinusoidal (sin(t)) easing out/in: deceleration until halfway, then acceleration.
    public static let outInSine : Equation = { (t, b, c, d) in
        if t < d/2 {return Ease.outSine(t*2, b, c/2, d)}
        return Ease.inSine((t*2)-d, b+c/2, c/2, d)
    }
    
    //MARK: - Expo
    
    /// Easing equation function for an exponential (2^t) easing in: accelerating from zero velocity.
    public static let inExpo : Equation = { (t, b, c, d) in
        return (t==0) ? b : c * pow(2, 10 * (t/d - 1)) + b - c * 0.001
    }
    
    /// Easing equation function for an exponential (2^t) easing out: decelerating from zero velocity.
    public static let outExpo : Equation = { (t, b, c, d) in
        return (t==d) ? b+c : c * 1.001 * (-pow(2, -10 * t/d) + 1) + b
    }
    
    /// Easing equation function for an exponential (2^t) easing in/out: acceleration until halfway, then deceleration.
    public static let inOutExpo : Equation = { (t, b, c, d) in
        if t==0 {return b}
        if t==d {return b+c}
        var i = t/(d/2)
        if i < 1 {return c/2 * pow(2, 10 * (i - 1)) + b - c * 0.0005}
        i = i-1
        return c/2 * 1.0005 * (-pow(2, -10 * i) + 2) + b
    }
    
    /// Easing equation function for an exponential (2^t) easing out/in: deceleration until halfway, then acceleration.
    public static let outInExpo : Equation = { (t, b, c, d) in
        if t < d/2 {return Ease.outExpo(t*2, b, c/2, d)}
        return Ease.inExpo((t*2)-d, b+c/2, c/2, d)
    }
    
    //MARK: - Circ
    
    /// Easing equation function for a circular (sqrt(1-t^2)) easing in: accelerating from zero velocity.
    public static let inCirc : Equation = { (t, b, c, d) in
        let i = t/d//TODO:Bugfix nan
        return (-c)*(sqrt(1-i*i)-1)+b
    }
    
    /// Easing equation function for a circular (sqrt(1-t^2)) easing out: decelerating from zero velocity.
    public static let outCirc : Equation = { (t, b, c, d) in
        let i = t/d-1//TODO:Bugfix nan
        return c*sqrt(1-i*i)+b
    }
    
    /// Easing equation function for a circular (sqrt(1-t^2)) easing in/out: acceleration until halfway, then deceleration.
    public static let inOutCirc : Equation = { (t, b, c, d) in
        var i = t/(d/2)
        if i < 1 {return -c/2*(sqrt(1-i*i)-1)+b}
        i = i-2
        return c/2*(sqrt(1-i*i)+1)+b
    }
    
    /// Easing equation function for a circular (sqrt(1-t^2)) easing out/in: deceleration until halfway, then acceleration.
    public static let outInCirc : Equation = { (t, b, c, d) in
        if t < d/2 {return Ease.outCirc (t*2, b, c/2, d)}
        return Ease.inCirc((t*2)-d, b+c/2, c/2, d)
    }
    
    //MARK: - Elastic
    
    /// Easing equation function for an elastic (exponentially decaying sine wave) easing in: accelerating from zero velocity.
    public static let inElastic : Equation = { (t, b, c, d) in
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
    }
    
    /// Easing equation function for an elastic (exponentially decaying sine wave) easing out: decelerating from zero velocity.
    public static let outElastic : Equation = { (t, b, c, d) in
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
    }
    
    /// Easing equation function for an elastic (exponentially decaying sine wave) easing in/out: acceleration until halfway, then deceleration.
    public static let inOutElastic : Equation = { (t, b, c, d) in
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
    }
    
    public static let outInElastic : Equation = { (t, b, c, d) in
        if t < d/2.0 {return Ease.outElastic(t*2, b, c/2, d)}
        return Ease.inElastic((t*2)-d, b+c/2, c/2, d)
    }

    //MARK: - Back
    public static let inBack : Equation = { (t, b, c, d) in
        let i = t/d
        let s = 1.70158
        return c*i*i*((s+1)*i-s)+b
    }
    
    public static let outBack : Equation = { (t, b, c, d) in
        let i = t/d-1
        let s = 1.70158
        return c*(i*i*((s+1)*i+s)+1)+b
    }
    
    public static let inOutBack : Equation = { (t, b, c, d) in
        var i = t/(d/2)
        let s = 1.70158 * 1.525
        if i < 1 {return c/2*(i*i*((s+1)*i-s))+b}
        i = i-2
        return c/2*(i*i*((s+1)*i+s)+2)+b
    }
    
    public static let outInBack : Equation = { (t, b, c, d) in
        if t < d/2 {return Ease.outBack(t*2, b, c/2, d)}
        return Ease.inBack((t*2)-d, b+c/2, c/2, d)
    }
    
    //MARK: - Bounce
    public static let inBounce : Equation = { (t, b, c, d) in
        return c - Ease.outBounce(d-t, 0, c, d) + b
    }
    
    public static let outBounce : Equation = { (t, b, c, d) in
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
    }
    
    public static let inOutBounce : Equation = { (t, b, c, d) in
        if t < d/2 {return Ease.inBounce(t*2, 0.0, c, d) * 0.5 + b}
        return Ease.outBounce(t*2-d, 0.0, c, d) * 0.5 + c*0.5 + b
    }
    
    public static let outInBounce : Equation = { (t, b, c, d) in
        if t < d/2 {return Ease.outBounce (t*2, b, c/2, d)}
        return Ease.inBounce((t*2)-d, b+c/2, c/2, d)
    }
    
    //MARK:Utils
    
    //TODO:
//    public static func toString(equation: inout Equation) -> String
//    {
//
//    }
}


