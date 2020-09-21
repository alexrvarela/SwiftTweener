//
//  PathAim.swift
//  Tweener
//
//  Created by Alejandro Ramirez Varela on 5/28/19.
//  Copyright © 2019 Alejandro Ramirez Varela. All rights reserved.
//

#if os(iOS) || os(tvOS)
import UIKit
#elseif os(macOS)
import AppKit
#endif

#if os(macOS)

extension NSBezierPath{
    /// Gets the CGPath from NSBezierPath.
    public func cgPath()->CGPath {
       
        let path = CGMutablePath()
        
        if self.elementCount > 0 {
            
            let points = NSPointArray.allocate(capacity: 3)
            
            for i in 0 ..< self.elementCount {
                
               switch self.element(at: i, associatedPoints: points)
               {
                   case .moveTo:
                       path.move(to: points[0])
                       break

                   case .lineTo:
                       path.addLine(to: points[0])
                       break
                
                   case .curveTo:
                       path.addCurve(to: points[2], control1: points[0], control2: points[1])
                       break

                   case .closePath:
                       path.closeSubpath()
                       break
               
               @unknown default:
                   break
               }
           }
       }   
        return path
    }
}

#endif

internal class InfoArray {var points = Array<Array<CGPoint>>()}
#if os(macOS)
internal class InfoNSPath {var path = NSBezierPath()}
#endif

extension CGPath {
    /// Converts CGPath to point array.
    func getPoints() -> Array<Array<CGPoint>>{
        
        var info = InfoArray()
        
        self.apply(info:&info) { info, unsafeElement in
            
            let infoPointer = UnsafeMutablePointer<InfoArray>(OpaquePointer(info))
            
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
            @unknown default:
                break
            }
        }
        
        return info.points
    }

    
#if os(macOS)
    ///Gets the NSBezierPath
    func nsBezierPath() -> NSBezierPath{
        
        var info = InfoNSPath()
        
        self.apply(info:&info) { info, unsafeElement in
            
            let infoPointer = UnsafeMutablePointer<InfoNSPath>(OpaquePointer(info))
            
            let element = unsafeElement.pointee
            
            switch element.type {
            case .moveToPoint:
                infoPointer?.pointee.path.move(to: element.points[0])
            case .addLineToPoint:
                infoPointer?.pointee.path.line(to: element.points[0])
            case .addQuadCurveToPoint:
                //Convert, this feature isn't available on macOs 10.
                break
            case .addCurveToPoint:
                infoPointer?.pointee.path.curve(to: element.points[2], controlPoint1: element.points[0], controlPoint2: element.points[1])
            case .closeSubpath:
                infoPointer?.pointee.path.close()
                break
            @unknown default:
                break
            }
        }
        
        return info.path
    }
#endif
}

/// Controls view's position over path.
public class PathAim : RotationAim{
    
    private var _cgPath:CGPath?//Optional

    #if os(iOS) || os(tvOS)
    private var _path:UIBezierPath?//Optional
    #elseif os(macOS)
    private var _path:NSBezierPath?//Optional
    #endif
    
    private var _lenghts:Array<CGFloat> = Array()
    private var _ratios:Array<CGFloat> = Array()
    private var _points:Array<Array<CGPoint>> = Array()
    //TODO:use origin or center?
    private var _lenght:CGFloat = 0.0
    private var _interpolation:CGFloat = 0.0
    private var _orientToPath:Bool = false
    //TODO:onUpdate handler
    
    /** Initializes with a CGpath
     - Parameter cgPath: A CGPath.
     */
    public convenience init(cgPath:CGPath)
    {
        self.init()
        self.cgPath = cgPath
    }
    
    #if os(iOS) || os(tvOS)
    /** Initializes with a UIBezierPath
     - Parameter path: A UIBezierPath.
    */
    public convenience init(path:UIBezierPath)
    {
        self.init()
        self.path = path
    }
    
    #elseif os(macOS)
    /** Initializes with a NSBezierPath
     - Parameter path: A NSBezierPath.
    */
    public convenience init(path:NSBezierPath)
    {
        self.init()
        self.path = path
    }
    #endif
    
    //TODO:
    func append(points:Array<CGPoint>)
    {
        //TODO:Add points to _points and recalculate length
        update()
    }
    
    /// Gets the CGPath.
    public var cgPath:CGPath
    {
        set {
            _cgPath = newValue
            //TODO:Keep _points array, add "edit path" functionality, generate CGPath from pont array and return.
            _points = _cgPath!.getPoints()//replace
            update()
        }
        get {return _cgPath!}
    }
    
    #if os(iOS) || os(tvOS)
    /// Gets the UIBezierPath.
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
    #elseif os(macOS)
    /// Gets the NSBezierPath.
    public var path:NSBezierPath
    {
        set {
            self.cgPath = newValue.cgPath()
        }
        get {
        return self.cgPath.nsBezierPath()
        }
    }
    #endif
    
    /// Property that indicates if you want to orient the view along the path.
    public var orientToPath:Bool
    {
        set {
            _orientToPath = newValue
            update()
        }
        get {return _orientToPath}
    }

    /// Gets path's point array buffer.
    public func getPoints() -> Array<Array<CGPoint>>
    {
        return _points
    }
    
    /// Calculates path position over path..
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
    
    /// Control view's position using a value between 0 and 1.
    public var interpolation:CGFloat
    {
        set {setInterpolation(value:newValue)}
        get {return _interpolation}
    }
    
    /// Internal function which calculates view's position.
    private func setInterpolation(value:CGFloat)
    {
        //Out of bounds values causes program error.
        _interpolation = (value > 1.0) ? 1.0 : ( ( value < 0.0 ) ? 0.0 : value )
        
        if _points.count == 0 || self.target == nil {return}
        
        var pathIndex:Int = 0
        
        for (indexRatio, ratio) in _ratios.enumerated()
        {
            let location:CGFloat = ratio / _lenght
            pathIndex = indexRatio
            if value < location { break }
        }
        
        let difference:CGFloat = (pathIndex > 0) ? _ratios[pathIndex - 1] / _lenght : 0.0
        let pathInterpolation:CGFloat = (value - difference)  / (_lenghts[pathIndex] / _lenght)

        //Get real interpolation
        let pathPoints:Array<CGPoint> = _points[pathIndex + 1]
        let originPoint:CGPoint = _points[pathIndex].last!
        let endPoint:CGPoint = pathPoints.last!
        
        if (pathPoints.count == 1)//Linear
        {
            #if os(iOS) || os(tvOS)
                self.target!.center = (originPoint == endPoint) ? endPoint : BezierUtils.linearInterpolation(time:pathInterpolation, start:originPoint, end:endPoint)
            #elseif os(macOS)
                self.target!.center(  originPoint == endPoint ? endPoint : BezierUtils.linearInterpolation(time:pathInterpolation, start:originPoint, end:endPoint) )
            #endif
            
            if(_orientToPath){
                self.rotation =  BasicMath.angle(start:originPoint, end:endPoint)
            }
        }
        if (pathPoints.count == 2)//Quad
        {
            #if os(iOS) || os(tvOS)
                self.target!.center = BezierUtils.quadInterpolation(time:pathInterpolation,
                                                                    start:originPoint,
                                                                    control:pathPoints[0],
                                                                    end:endPoint)
            #elseif os(macOS)
                self.target!.center( BezierUtils.quadInterpolation(time:pathInterpolation,
                                                                   start:originPoint,
                                                                   control:pathPoints[0],
                                                                   end:endPoint) )
            #endif
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
            #if os(iOS) || os(tvOS)
            self.target!.center = BezierUtils.bezierCubicInterpolation(time:pathInterpolation,
                                                                      start:originPoint,
                                                                      controlStart:pathPoints[0],
                                                                      controlEnd:pathPoints[1],
                                                                      end:endPoint)
            #elseif os(macOS)
                self.target!.center( BezierUtils.bezierCubicInterpolation(time:pathInterpolation,
                                                                          start:originPoint,
                                                                          controlStart:pathPoints[0],
                                                                          controlEnd:pathPoints[1],
                                                                          end:endPoint) )
            #endif
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
