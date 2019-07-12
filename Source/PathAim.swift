//
//  PathAim.swift
//  Tweener
//
//  Created by Alejandro Ramirez Varela on 5/28/19.
//  Copyright © 2019 Alejandro Ramirez Varela. All rights reserved.
//

import Foundation

internal class Info {var points = Array<Array<CGPoint>>()}

extension CGPath {
    
    func getPoints() -> Array<Array<CGPoint>>{
        
        var info = Info()
        
        self.apply(info:&info) { info, unsafeElement in
            
            let infoPointer = UnsafeMutablePointer<Info>(OpaquePointer(info))
            
            let element = unsafeElement.pointee
            
            if infoPointer?.pointee.points.count == 0 && element.type != .moveToPoint{
                //Append start point zero
                infoPointer?.pointee.points.append([CGPoint.zero])
            }
            
            switch element.type {
            case .moveToPoint:
                infoPointer?.pointee.points.append([element.points[0]])
            case .addLineToPoint:
                infoPointer?.pointee.points.append([element.points[0]])
            case .addQuadCurveToPoint:
                infoPointer?.pointee.points.append([element.points[0], element.points[1]])
            case .addCurveToPoint:
                infoPointer?.pointee.points.append([element.points[0], element.points[1], element.points[2]])
            case .closeSubpath:
                break
                //print("close")
            }
        }
        
        return info.points
    }
}

public class PathAim : RotationAim{
    
    private var _cgPath:CGPath?//Optional
    private var _path:UIBezierPath?//Optional
    private var _lenghts:Array<CGFloat> = Array()
    private var _ratios:Array<CGFloat> = Array()
    private var _points:Array<Array<CGPoint>> = Array()
    //TODO:use origin or center?
    private var _lenght:CGFloat = 0.0
    private var _interpolation:CGFloat = 0.0
    private var _orientToPath:Bool = false
    //TODO:onUpdate handler

    //TODO:
//    public convenience init(cgPath:CGPath)
//    {
//        self.init()
//        self.cgPath = cgPath
//    }
    
    //TODO:
    func append(points:Array<CGPoint>)
    {
        //TODO:Add points to _points and recalculate length
        update()
    }

    public var cgPath:CGPath
    {
        set {
            _cgPath = newValue
            //TODO: Keep _points array, add adit path functionality, generate CGPath from pont array and return.
            _points = _cgPath!.getPoints()//replace
            update()
        }
        get {return _cgPath!}
    }
    
    
    public var path:UIBezierPath
    {
        set {
            self.cgPath = newValue.cgPath
        }
        get {
            
            let path = UIBezierPath()
            path.cgPath = self.cgPath
            return path
        }
    }
    
    public var orientToPath:Bool
    {
        set {
            _orientToPath = newValue
            update()
        }
        get {return _orientToPath}
    }

    public func getPoints() -> Array<Array<CGPoint>>
    {
        return _points
    }
    
    public func update()
    {
        if _points.count == 0 {return}
    
        //Reset
        _ratios = Array()
        _lenghts = Array()
        _lenght = 0.0

        //get first point
        var originPoint:CGPoint =  _points[0][0]
        
        for (index, pathPoints) in _points.enumerated()
        {
            if ( index > 0 )//ignore first element
            {
                var l:CGFloat = 0.0
                let endPoint:CGPoint = pathPoints.last!
                
                //Move to //Line to
                if (pathPoints.count == 1)//Linear
                {
                    l = BasicMath.length(start:originPoint, end:endPoint)
                }
                if (pathPoints.count == 2)//Quad
                {
                    l = BezierUtils.quadLength(start:originPoint,
                                               control:pathPoints[0],
                                               end:endPoint)
                }
                if (pathPoints.count == 3)//Bezier
                {
                    l = BezierUtils.bezierCubicLength(start:originPoint,
                                                      controlStart:pathPoints[0],
                                                      controlEnd:pathPoints[1],
                                                      end:endPoint)
                }
                
                originPoint = endPoint
                
                _lenght = _lenght + l
                _ratios.append(_lenght)
                _lenghts.append(l)
            }
        }
    }
    
    public var interpolation:CGFloat
    {
        set {setInterpolation(value:newValue)}
        get {return _interpolation}
    }
    
    private func setInterpolation(value:CGFloat)
    {
        _interpolation = value
        
        if _points.count == 0 || self.target == nil {return}
        
        //TODO:verify handler:
        
        var pathIndex:Int = 0
        
        for (indexRatio, ratio) in _ratios.enumerated()
        {
            let location:CGFloat = ratio / _lenght
            pathIndex = indexRatio
            if value < location {break}
        }
        
        let difference:CGFloat = (pathIndex > 0) ? _ratios[pathIndex - 1] / _lenght : 0.0
        let pathInterpolation:CGFloat = (value - difference)  / (_lenghts[pathIndex] / _lenght)

        //Get real interpolation
        let pathPoints:Array<CGPoint> = _points[pathIndex + 1]
        let originPoint:CGPoint = _points[pathIndex].last!
        let endPoint:CGPoint = pathPoints.last!
        
        if (pathPoints.count == 1)//Linear
        {
            self.target!.center = BezierUtils.linearInterpolation(time:pathInterpolation, start:originPoint, end:endPoint)
            
            if(_orientToPath){
                self.rotation =  BasicMath.angle(start:originPoint, end:endPoint)
            }
        }
        if (pathPoints.count == 2)//Quad
        {
            self.target!.center = BezierUtils.quadInterpolation(time:pathInterpolation,
                                                                start:originPoint,
                                                                control:pathPoints[0],
                                                                end:endPoint)
            if(_orientToPath)
            {
                self.rotation = BezierUtils.quadAngle(time:pathInterpolation,
                                                      start:originPoint,
                                                      control:pathPoints[0],
                                                      end:endPoint)
            }
        }
        if (pathPoints.count == 3)//Bezier
        {
            //trasnlate
            self.target!.center = BezierUtils.bezierCubicInterpolation(time:pathInterpolation,
                                                                      start:originPoint,
                                                                      controlStart:pathPoints[0],
                                                                      controlEnd:pathPoints[1],
                                                                      end:endPoint)
            //rotate
            if(self.orientToPath)
            {
                self.rotation = BezierUtils.bezierCubicAngle(time:pathInterpolation,
                                                             start:originPoint,
                                                             controlStart: pathPoints[0],
                                                             controlEnd:pathPoints[1], end: endPoint)
            }
        }
    }
}
