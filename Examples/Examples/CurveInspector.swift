//
//  CurveInspector.swift
//  Examples
//
//  Created by Alejandro Ramirez Varela on 6/5/19.
//  Copyright © 2019 Alejandro Ramirez Varela. All rights reserved.
//

import UIKit
import Tweener

class CurveInspector: UIControl
{
    
    public var _ease:Ease = .none
    public let label:UILabel = UILabel()
    let border:UIView = UIView()
    let curve:UIView = UIView()
    let asset:UIView = UIView()
    let linex:UIView = UIView()
    let liney:UIView = UIView()
    let playIcon:PDFImageView = PDFImageView()
    
    override init(frame:CGRect)
    {
        super.init(frame:frame)
        
        backgroundColor = UIColor.clear
        
        //Label
        label.frame = CGRect(x:0.0,
                                  y:0.0,
                                  width:self.frame.size.width,
                                  height:40.0)
        label.textColor = UIColor.black
        label.font = UIFont.systemFont(ofSize: 24.0)
        label.text = "EaseType"
        addSubview(label)
        
        let graphFrame:CGRect = CGRect(x:0.0,
                                   y:40.0,
                                   width:self.frame.size.width,
                                   height:self.frame.size.height - 110.0)
        
        //Border
        border.frame = graphFrame
        border.isUserInteractionEnabled = false
        border.layer.borderColor = UIColor.black.cgColor
        border.layer.borderWidth = 1.0
        addSubview(border)
        
        //Curve
        curve.frame = graphFrame
        curve.isUserInteractionEnabled = false
        addSubview(curve)
        
        //Asset
        asset.frame = CGRect(x:0.0,
                                  y:frame.size.height - 50.0,
                                  width:50.0,
                                  height:50.0)
        
        asset.isUserInteractionEnabled = false
        asset.layer.cornerRadius = 50.0/2.0
        asset.backgroundColor = UIColor(red:1.0, green:48.0 / 255.0, blue:130 / 255.0, alpha:1.0)
        addSubview(asset)
        
        //Line x
        linex.frame = CGRect(x:0.0,
                                  y:graphFrame.origin.y,
                                  width:1.0,
                                  height:graphFrame.size.height)
        linex.isUserInteractionEnabled = false
        linex.backgroundColor = UIColor(red:0.0, green:0.0, blue:0.0, alpha:0.1)
        addSubview(linex)
        
        //Line y
        liney.frame = CGRect(x:0.0,
                                  y:graphFrame.origin.y,
                                  width:graphFrame.size.width,
                                  height:1.0)
        liney.isUserInteractionEnabled = false
        liney.backgroundColor = UIColor(red:0.0,
                                             green:202.0 / 255.0,
                                             blue:255.0 / 255.0,
                                             alpha:1.0)
        addSubview(liney)
        
        //TOD:Play icon
        
        //Add play action
        addTarget(self, action:#selector(play), for: .touchUpInside)
        
        playIcon.loadFromBundle("moon")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //setter/getter var
    var ease:Ease
    {
        set{
            _ease = newValue
            //Remove old layer
            curve.layer.sublayers = nil
            
            let path:UIBezierPath = UIBezierPath()
            path.move(to: CGPoint(x:0.0, y:curve.frame.size.height))
            
            let segments:Int = 200
            
            let b:Double = Double(curve.frame.size.height)
            let c:Double = 0.0 - b
            
            for i:Int in 0 ... segments
            {
                let interpolation:Double  = (1.0 / Double(segments)) * Double(i)
                let x:CGFloat = curve.frame.size.width * CGFloat(interpolation)
                let y:CGFloat = CGFloat(_ease.equation(interpolation, b, c, 1.0))
                path.addLine(to: CGPoint(x:x, y:y))
            }
            
            //Add end point
            path.addLine(to: CGPoint(x:curve.frame.size.width, y:0.0))
            
            //add sublayer
            curve.layer.addSublayer(makeStrokedLayer(path:path))
        }
        get{return _ease}
    }
    
    func makeStrokedLayer(path:UIBezierPath) -> CAShapeLayer
    {
        let shapeLayer:CAShapeLayer = CAShapeLayer()
        
        shapeLayer.fillColor = nil
        shapeLayer.strokeColor = UIColor(red:1.0, green:48.0 / 255.0, blue:130 / 255.0, alpha:1.0).cgColor
        shapeLayer.lineWidth = 2.0
        shapeLayer.path = path.cgPath
        
        return shapeLayer
    }
    
    @objc func play()
    {
        //Asset
        //TODO:
        Tweener.removeTweens(target:asset)
        var assetFrame:CGRect = asset.frame
        assetFrame.origin.x = 0.0
        
        asset.frame = assetFrame
        assetFrame.origin.x = frame.size.width - asset.frame.size.width
        Tween(asset,
              duration: 1.0,
              ease:ease,
              to:[.key(\.frame, assetFrame)]).play()
    
        //Line x
    
        //Initial state
        var lineFrame:CGRect = linex.frame
        lineFrame.origin.x = 0.0
        linex.frame = lineFrame
        
        //Change
        lineFrame.origin.x = frame.size.width - 1.0
       
        Tween(target:linex,
              duration: 1.0,
              ease:Ease.none,
              to:[.key(\.frame, lineFrame)]).play()
        
        //Initial state
        lineFrame = liney.frame
        lineFrame.origin.y = curve.frame.origin.y + curve.frame.size.height
        liney.frame = lineFrame
        //Change
        lineFrame.origin.y = curve.frame.origin.y
        
        Tween(target:liney,
              duration: 1.0,
              ease:ease,
              to:[.key(\.frame, lineFrame)]).play()
    }
}
