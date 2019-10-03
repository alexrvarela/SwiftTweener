//
//  TimelineBasic.swift
//  Examples
//
//  Created by Alejandro Ramirez Varela on 6/24/19.
//  Copyright © 2019 Alejandro Ramirez Varela. All rights reserved.
//

import Foundation

import UIKit
import Tweener


class TimelineBasic:UIView, FreezeProtocol
{
    let asset1 = UIView(frame: CGRect(x:0.0, y:20.0 + 75.0, width:50.0, height:50.0))
    let asset2 = UIView(frame: CGRect(x:0.0, y:20.0 + 75.0 * 2, width:50.0, height:50.0))
    let asset3 = UIView(frame:CGRect(x:0.0, y:20.0 + 75.0 * 3, width:50.0, height:50.0))
    let asset4 = UIView(frame:CGRect(x:0.0, y:20.0 + 75.0 * 4, width:50.0, height:50.0))
    
    let timeline = Timeline()
    let inspector = TimelineInspector()
    
    //Create rotation var for asset 3
    public var rotationAngle:CGFloat{
        didSet {
            asset3.transform = CGAffineTransform(rotationAngle:rotationAngle * CGFloat.pi / 180.0)
        }
    }
    
    override init(frame: CGRect) {
        
        rotationAngle = 0.0
        
        super.init(frame:frame)
        
        backgroundColor = UIColor(red:116.0 / 255.0,
                                       green:244.0 / 255.0,
                                       blue:234.0 / 255.0,
                                       alpha:1.0)

        //---- Shape 1 ----
        asset1.backgroundColor = UIColor.white
        let polyShape = CAShapeLayer()
        polyShape.path = makePolygon(divisions:5, radius:25.0, origin:CGPoint(x:25.0, y:25.0))
        asset1.layer.mask = polyShape
        addSubview(asset1)
        
        //---- Shape 2 ----
        asset2.backgroundColor = UIColor.white
        asset2.layer.cornerRadius = 25.0//make circle
        addSubview(asset2)
        
        //---- Shape 3 ----
        
        asset3.backgroundColor = UIColor.white
        let triangleShape = CAShapeLayer()
        triangleShape.path = makePolygon(divisions:3, radius:25.0, origin:CGPoint(x:25.0, y:25.0))
        asset3.layer.mask = triangleShape
        addSubview(asset3)
        
        //---- Shape 4 ----
        asset4.backgroundColor = UIColor.white
        addSubview(asset4)
        
        //TWEEN 1
        var newFrame = asset1.frame
        newFrame.origin.x = bounds.size.width - asset1.frame.size.width
        
        timeline.add(Tween(target:asset1,
                           duration:1.0,
                           ease:Ease.outQuad,
                           keys:[\UIView.frame:newFrame,
                                 \UIView.alpha:0.25]
        ))

        //TWEEN 2
        
        //set inital value
        newFrame = asset2.frame
        
        //set start value
        newFrame.origin.x = bounds.size.width - asset2.frame.size.width
        
        //add tween to timeline, pass target, parameters and key paths
        timeline.add(Tween(target:asset2,
                           duration:1.0,
                           ease:Ease.inOutBounce,
                           keys:[\UIView.frame:newFrame]
        ))
        
        //TWEEN
        //Add tween to timeline.
        timeline.add(Tween(target:self,
                           duration:1.0,
                           ease:Ease.outQuad,
                           keys:[\TimelineBasic.rotationAngle:360]
        ))
        
        //TWEEN 4
        //Update destination frame
        newFrame = CGRect(x:asset4.frame.origin.x,
                          y:asset4.frame.origin.y,
                          width:100.0,
                          height:100.0)
        
        //Add tween to timeline.
        timeline.add(Tween(target:asset4,
                           duration:1.0,
                           ease:Ease.outElastic,
                           delay:1.0,
                           keys:[\UIView.frame:newFrame]
        ))
        
        //Link timeline to inspector
        inspector.timeline = timeline
        addSubview(inspector)
        
        //Freeze
        freeze()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func makePolygon(divisions:Int, radius:CGFloat, origin:CGPoint) -> CGPath
    {
        var divisions = divisions
        if divisions < 3 {divisions = 3}
        let path = CGMutablePath()
        
        let fragment:CGFloat = 360.0 / CGFloat(divisions)
        
        for indexDivision in 0 ... divisions
        {
            let point = BasicMath.arcRotationPoint(angle: BasicMath.toRadians(degree: fragment * CGFloat(indexDivision)),
                                                 radius: radius)
            if indexDivision == 0{path.move(to: CGPoint(x:origin.x + point.x, y:origin.y + point.y))}
            else{path.addLine(to: CGPoint(x:origin.x + point.x, y:origin.y + point.y))}
        }

        path.closeSubpath()
        
        return path
    }
    
    func freeze()
    {
        timeline.pause()
    }
    
    func warm()
    {
        timeline.play()
    }
    
}
