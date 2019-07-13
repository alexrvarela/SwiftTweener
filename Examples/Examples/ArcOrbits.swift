//
//  ArcOrbits.swift
//  Examples
//
//  Created by Alejandro Ramirez Varela on 6/29/19.
//  Copyright © 2019 Alejandro Ramirez Varela. All rights reserved.
//

import UIKit
import Tweener

class ArcOrbits:UIView
{
    let background:PDFImageView = PDFImageView(bundlename: "orbits-background")
    let sunFire:PDFImageView = PDFImageView(bundlename: "little-sun-fire")
    let fireAim:RotationAim = RotationAim()
    let sun:PDFImageView = PDFImageView(bundlename:"little-sun")
    let earth:PDFImageView = PDFImageView(bundlename:"little-earth")
    let earthAim:ArcAim = ArcAim()
    let moon:UIView = UIView()
    let moonAim:ArcAim = ArcAim()
    let mars:UIView = UIView()
    let marsAim:ArcAim = ArcAim()
    let jupyter:PDFImageView = PDFImageView(bundlename: "little-jupyter")
    let jupyterAim:ArcAim = ArcAim()
    let saturn:PDFImageView = PDFImageView(bundlename: "little-saturn")
    let saturnAim:ArcAim = ArcAim()
    
    override init(frame: CGRect){
        super.init(frame: frame)
        
        backgroundColor = UIColor(red:52.0/255,
                                  green:52.0/255,
                                  blue:71.0/255,
                                  alpha:1.0)
        clipsToBounds = true
        
        addSubview(background)
        background.center = center
        
        addSubview(sunFire)
        sunFire.center = center
        fireAim.target = sunFire
        
        //fire timeline
        let timeline = Timeline()
        timeline.playMode = .loop
        timeline.add(Tween(target: fireAim, duration: 5.0, keys: [\RotationAim.angle : 360.0]))
        timeline.play()
        
        //sun
        addSubview(sun)
        sun.center = center
        
        //earth
        addSubview(earth)
        //earth aim
        earthAim.target = earth
        earthAim.radius = 100
        earthAim.center = center
        //earth timeline
        addTimeline(target:earthAim, duration:5.0)
        
        //moon
        moon.frame = CGRect(x:0.0, y:0.0, width:3.0, height:3.0)
        moon.backgroundColor = UIColor.white
        moon.layer.cornerRadius = 1.5
        earth.addSubview(moon)
        //moon aim
        moonAim.target = moon
        moonAim.radius = 11
        moonAim.center = CGPoint(x:earth.frame.size.width / 2.0, y:earth.frame.size.height / 2.0)
        //moon timeline
        addTimeline(target:moonAim, duration:1.0)

        //mars
        mars.frame = CGRect(x:0.0, y:0.0, width:10.0, height:10.0)
        mars.backgroundColor = UIColor(red:200.0/255.0, green:90.0/255.0, blue:60.0/255.0, alpha:1.0)
        mars.layer.cornerRadius = 5.0
        addSubview(mars)
        //mars aim
        marsAim.target = mars
        marsAim.radius = 150.0
        marsAim.center = center
        //mars timeline
        addTimeline(target:marsAim, duration:7.0)
        
        //jupyter
        addSubview(jupyter)
        //jupyter aim
        jupyterAim.target = jupyter
        jupyterAim.radius = 200
        jupyterAim.center = center
        //jupyter timeline
        addTimeline(target:jupyterAim, duration:9.0)
        
        //saturn
        addSubview(saturn)
        //saturn aim
        saturnAim.target = saturn
        saturnAim.radius = 250
        saturnAim.center = center
        //saturn timeline
        addTimeline(target:saturnAim, duration:11.0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addTimeline(target:ArcAim, duration:Double)
    {
        let timeline = Timeline()
        timeline.playMode = .loop
        timeline.add(Tween(target: target, duration: duration, keys: [\ArcAim.arcAngle : 360.0]))
        timeline.play()
    }
}
