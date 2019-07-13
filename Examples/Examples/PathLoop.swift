//
//  PathLoop.swift
//  Examples
//
//  Created by Alejandro Ramirez Varela on 6/28/19.
//  Copyright © 2019 Alejandro Ramirez Varela. All rights reserved.
//

import UIKit
import Tweener

class PathLoop:UIView
{
    let tweenPath:PathAim = PathAim()
    let pathView:UIView = UIView()
    let bee:PDFImageView = PDFImageView(bundlename: "bee")
    let flower:PDFImageView = PDFImageView(bundlename: "flower")
    let label:UILabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor(red:130.0/255.0,
                                       green:255.0/255.0,
                                       blue:170.0/255,
                                       alpha:1.0)
        //flower
        flower.frame = CGRect(x:center.x - flower.frame.size.width / 2.0,
                                   y:self.frame.size.height - flower.frame.size.height,
                                   width:flower.frame.size.width,
                                   height:flower.frame.size.height)
        
        addSubview(flower)
        
        //bee
        bee.scale = 1.5
        bee.center = center
        addSubview(bee)
        
        //Bezier path
        let myPath = UIBezierPath()
        let translate:CGPoint = center
        
        myPath.move(to: CGPoint(x:translate.x + 40.088, y:translate.y + 40.088))
        myPath.addCurve(to: CGPoint(x:translate.x + 120.2639, y:translate.y + 40.088),
                        controlPoint1: CGPoint(x:translate.x + 62.2279, y:translate.y + 62.2279),
                        controlPoint2: CGPoint(x:translate.x + 98.1239 , y:translate.y + 62.2279))
        myPath.addCurve(to: CGPoint(x:translate.x + 120.2639, y:translate.y + -40.0879),
                        controlPoint1: CGPoint(x:translate.x + 142.4038 , y:translate.y + 17.9481),
                        controlPoint2: CGPoint(x:translate.x + 142.4038 , y:translate.y + -17.948))
        myPath.addCurve(to: CGPoint(x:translate.x + 40.088, y:translate.y + -40.088), controlPoint1: CGPoint(x:translate.x + 98.1239 , y:translate.y + -62.2279), controlPoint2: CGPoint(x:translate.x + 62.2279 , y:translate.y + -62.2279))
        myPath.addLine(to: CGPoint(x:translate.x + -40.088, y:translate.y + 40.088))
        myPath.addCurve(to: CGPoint(x:translate.x + -120.2639, y:translate.y + 40.088), controlPoint1: CGPoint(x:translate.x + -62.2279 , y:translate.y + 62.2279), controlPoint2: CGPoint(x:translate.x + -98.1239 , y:translate.y + 62.2279))
        myPath.addCurve(to: CGPoint(x:translate.x + -120.2639, y:translate.y + -40.0879), controlPoint1: CGPoint(x:translate.x + -142.4038 , y:translate.y + 17.9481), controlPoint2: CGPoint(x:translate.x + -142.4038 , y:translate.y + -17.948))
        myPath.addCurve(to: CGPoint(x:translate.x + -40.088, y:translate.y + -40.088), controlPoint1: CGPoint(x:translate.x + -98.1239 , y:translate.y + -62.2279), controlPoint2: CGPoint(x:translate.x + -62.2279 , y:translate.y + -62.2279))
        myPath.addLine(to: CGPoint(x:translate.x + 40.088, y:translate.y + 40.088))
        
        //Path interpolator
        tweenPath.path = myPath
        tweenPath.target = bee
        tweenPath.orientToPath = true
        
        pathView.frame = bounds
        pathView.isUserInteractionEnabled = false
        pathView.isHidden = true
        addSubview(pathView)
        drawPath()
        
        
        label.frame = CGRect(x:20.0,
                              y:center.y - 60.0,
                              width:self.frame.size.width - 40.0,
                              height:60.0)
        
        label.textColor = UIColor.white
        label.font = UIFont.systemFont(ofSize: 22.0)
        label.text = "Tap to show path"
        label.textAlignment = .center
        label.center = CGPoint(x:self.frame.size.width / 2.0,
                               y:center.y - self.frame.size.height * 0.25)
        addSubview(label)
        
        let tapRecognizer:UITapGestureRecognizer  = UITapGestureRecognizer(target: self, action: #selector(tap))
        addGestureRecognizer(tapRecognizer)
        
        //TODO:enable handlers
        
        //play
        play()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func play()
    {
        tweenPath.interpolation = 0.0
    
        Tween(target: tweenPath, duration: 2.0, ease: Ease.none, delay: 0.0, keys: [\PathAim.interpolation : 1.0], completion: {
            self.play()//loop
        }).play()
    }
    
    @objc func tap(sender:UITapGestureRecognizer )
    {
        //show/hide path layer
        pathView.isHidden = !pathView.isHidden
        label.text = pathView.isHidden ? "Tap to show path" : "Tap to hide path"
    }
    
    func drawPath()
    {
        pathView.layer.addSublayer(makeStrokedLayer(path:tweenPath.path))
    
        //draw points
        for points in tweenPath.getPoints()
        {
            let origin = points[points.count - 1]
            let path = UIBezierPath.init(roundedRect:CGRect(x:origin.x - 4.0,
                                                            y:origin.y - 4.0,
                                                            width:8.0,
                                                            height:8.0),
                                         cornerRadius: 2.0)
            pathView.layer.addSublayer(makeFillLayer(path:path))
        }
    }
    
    func makeFillLayer(path:UIBezierPath) -> CAShapeLayer
    {
        let shapeLayer = CAShapeLayer()
        
        shapeLayer.fillColor = UIColor.white.cgColor
        shapeLayer.path = path.cgPath
        
        return shapeLayer
    }
    
    func makeStrokedLayer(path:UIBezierPath) -> CAShapeLayer
    {
        let shapeLayer = CAShapeLayer()
        
        shapeLayer.fillColor = nil
        shapeLayer.strokeColor = UIColor.white.cgColor
        shapeLayer.lineWidth = 2.0
        shapeLayer.path = path.cgPath
        
        return shapeLayer
    }
}
