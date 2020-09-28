//
//  PathsSample.swift
//  Examples-macOs
//
//  Created by Alejandro Ramirez Varela on 23/08/20.
//  Copyright © 2020 Alejandro Ramirez Varela. All rights reserved.
//

import Cocoa
import Tweener

class PathSample: NSView {
    
    //Path 1
    let p1:NSBezierPath = {
        let path = NSBezierPath()
        path.move(to: CGPoint(x:468.497, y:323.5) )
        path.curve(to: CGPoint(x:431.997, y:287), controlPoint1: CGPoint(x:468.497, y:303.3416), controlPoint2: CGPoint(x:452.1553, y:287))
        path.line(to: CGPoint(x:378.497, y:287) )
        path.line(to: CGPoint(x:378.497, y:240) )
        path.line(to: CGPoint(x:348.497, y:240) )
        path.line(to: CGPoint(x:348.497, y:360) )
        path.line(to: CGPoint(x:376.4956, y:360) )
        path.line(to: CGPoint(x:378.497, y:360) )
        path.line(to: CGPoint(x:431.997, y:360) )
        path.curve(to: CGPoint(x:468.497, y:323.5), controlPoint1: CGPoint(x:452.1553, y:360), controlPoint2: CGPoint(x:468.497, y:343.6584))
        return path
    }()
    
    //Path 2
    let p2:NSBezierPath = {
        let path = NSBezierPath()
        path.move(to: CGPoint(x:431.997, y:317) )
        path.line(to: CGPoint(x:378.497, y:317) )
        path.line(to: CGPoint(x:378.497, y:330) )
        path.line(to: CGPoint(x:431.997, y:330) )
        path.curve(to: CGPoint(x:438.497, y:323.5), controlPoint1: CGPoint(x:435.5869, y:330), controlPoint2: CGPoint(x:438.497, y:327.0898))
        path.curve(to: CGPoint(x:431.997, y:317), controlPoint1: CGPoint(x:438.497, y:319.9102), controlPoint2: CGPoint(x:435.5869, y:317))
        path.close()
        return path
    }()
    
    //Path 3
    let a1:NSBezierPath = {
       let path = NSBezierPath()
        path.move(to: CGPoint(x:491.5626, y:254.9905) )
        path.line(to: CGPoint(x:446.443, y:254.9905) )
        path.line(to: CGPoint(x:440.9522, y:240) )
        path.line(to: CGPoint(x:409.003, y:240) )
        path.line(to: CGPoint(x:452.9576, y:360) )
        path.line(to: CGPoint(x:485.0479, y:360) )
        path.line(to: CGPoint(x:529.003, y:240) )
        path.line(to: CGPoint(x:497.0533, y:240) )
        path.line(to: CGPoint(x:491.5626, y:254.9905) )
        return path
    }()
    
    //Path 4
    let a2:NSBezierPath =  {
        let path = NSBezierPath()
        path.move(to: CGPoint(x:457.4322, y:284.9905) )
        path.line(to: CGPoint(x:469.003, y:316.5801) )
        path.line(to: CGPoint(x:480.5738, y:284.9905) )
        path.line(to: CGPoint(x:457.4322, y:284.9905) )
        path.close()
        return path
    }()
    
    //Path 5
    let t:NSBezierPath = {
        let path = NSBezierPath()
        path.move(to: CGPoint(x:605.0032, y:360) )
        path.line(to: CGPoint(x:485.0032, y:360) )
        path.line(to: CGPoint(x:485.0032, y:330) )
        path.line(to: CGPoint(x:530.0032, y:330) )
        path.line(to: CGPoint(x:530.0032, y:240) )
        path.line(to: CGPoint(x:560.0032, y:240) )
        path.line(to: CGPoint(x:560.0032, y:330) )
        path.line(to: CGPoint(x:605.0032, y:330) )
        path.line(to: CGPoint(x:605.0032, y:360) )
        path.close()
        return path
    }()
    
    //Path 6
    let h:NSBezierPath = {
        let path = NSBezierPath()
        path.move(to: CGPoint(x:650.003, y:360) )
        path.line(to: CGPoint(x:650.003, y:315) )
        path.line(to: CGPoint(x:590.0032, y:315) )
        path.line(to: CGPoint(x:590.0032, y:360) )
        path.line(to: CGPoint(x:560.0032, y:360) )
        path.line(to: CGPoint(x:560.0032, y:240) )
        path.line(to: CGPoint(x:590.0032, y:240) )
        path.line(to: CGPoint(x:590.0032, y:285) )
        path.line(to: CGPoint(x:650.003, y:285) )
        path.line(to: CGPoint(x:650.003, y:240) )
        path.line(to: CGPoint(x:680.003, y:240) )
        path.line(to: CGPoint(x:680.003, y:360) )
        path.line(to: CGPoint(x:650.003, y:360) )
        path.close()
        return path
    }()
    
    //P
    let aim_p1 = PathAim()
    let aim_p2 = PathAim()
    //A
    let aim_a1 = PathAim()
    let aim_a2 = PathAim()
    //T
    let aim_t = PathAim()
    //H
    let aim_h = PathAim()
    
    var green = NSColor(red: 30 / 255 , green: 190 / 255, blue:0 / 255, alpha: 1.0)
    var blue = NSColor(red: 0 / 255 , green: 90 / 255, blue: 255 / 255, alpha: 1.0)
    var red = NSColor(red: 255 / 255 , green: 0 / 255, blue: 86 / 255, alpha: 1.0)
    var yellow = NSColor(red: 255 / 255 , green: 200 / 255, blue: 0 / 255, alpha: 1.0)

    override init(frame: CGRect) {
    
        super.init(frame: frame)
        
        //Draw paths:
        wantsLayer = true

        aim_p1.path = p1
        addSubview( createDot(color:green) )
        aim_p1.target = subviews.last
        
        //Animate with timeline
        Timeline(
            Tween(aim_p1)
            .duration(5.0)
            .to(.key(\.interpolation, 1.0))
        )
        .mode(.loop)
        .play()
        
        aim_p2.path = p2
        addSubview( createDot(color:green) )
        aim_p2.target = subviews.last
        
        //Animate with timeline
        Timeline(
            Tween(target: aim_p2)
            .duration(2.0)
            .to(.key(\.interpolation, 1.0))
        )
        .mode(.loop)
        .play()
        
        aim_a1.path = a1
        addSubview( createDot(color:blue) )
        aim_a1.target = subviews.last
        
        //Animate with timeline
        Timeline(
            Tween(target: aim_a1)
            .duration(4.0)
            .to(.key(\.interpolation, 1.0))
        )
        .mode(.loop)
        .play()
        
        aim_a2.path = a2
        addSubview( createDot(color:blue) )
        aim_a2.target = subviews.last
        
        //Animate with timeline
        Timeline(
            Tween(target: aim_a2)
            .duration(1.5)
            .to(.key(\.interpolation, 1.0))
        )
        .mode(.loop)
        .play()
        
        aim_t.path = t
        addSubview( createDot(color:red) )
        aim_t.target = subviews.last
        
        //Animate with timeline
        Timeline(
            Tween(target: aim_t)
            .duration(5.0)
            .to(.key(\.interpolation, 1.0))
        )
        .mode(.loop)
        .play()
        
        aim_h.path = h
        addSubview( createDot(color:yellow) )
        aim_h.target = subviews.last
        
        //Animate with timeline
        Timeline(
            Tween(target: aim_h)
            .duration(6.0)
            .to(.key(\.interpolation, 1.0))
        )
        .mode(.loop)
        .play()
        
    }
    
    func createDot(color:NSColor) -> NSView {
        let dot = NSView(frame: NSRect(x: 0, y: 0, width: 10, height: 10))
        dot.wantsLayer = true
        dot.layer?.cornerRadius = 5
        dot.layer?.backgroundColor = color.cgColor
        return dot
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    //Draw paths
    override func draw(_ dirtyRect: NSRect) {
        
        let ctx = NSGraphicsContext.current!.cgContext
        ctx.saveGState()
        
        green.set()
        p1.stroke()
        p2.stroke()

        blue.set()
        a1.stroke()
        a2.stroke()
        
        red.set()
        t.stroke()
        
        yellow.set()
        h.stroke()
        
        ctx.restoreGState()
    }
    
}
