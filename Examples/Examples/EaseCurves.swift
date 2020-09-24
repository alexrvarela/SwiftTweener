//
//  EaseCurves.swift
//  Examples
//
//  Created by Alejandro Ramirez Varela on 6/5/19.
//  Copyright © 2019 Alejandro Ramirez Varela. All rights reserved.
//

import UIKit
import Tweener

class EaseCurves: UIView
{    
    let scrollview:UIScrollView = UIScrollView()
    let easeSelector:UIScrollView = UIScrollView()
    let selectorContainer:UIView = UIView()
    let selectorButton:UIButton = UIButton()
    var easeList:Array<Dictionary<String, Any>> = []
    var buttons:Array<UIButton> = []
    var inspectors:Array<CurveInspector> = []
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        clipsToBounds = true
        easeList = [
            ["equations":[Ease.inQuad, Ease.outQuad, Ease.inOutQuad, Ease.outInQuad],
             "name":"Quad"],
            ["equations":[Ease.inCubic, Ease.outCubic, Ease.inOutCubic, Ease.outInCubic],
             "name":"Cubic"],
            ["equations":[Ease.inQuart, Ease.outQuart, Ease.inOutQuart, Ease.outInQuart],
             "name":"Quart"],
            ["equations":[Ease.inQuint, Ease.outQuint, Ease.inOutQuint, Ease.outInQuint],
             "name":"Quint"],
            ["equations":[Ease.inSine, Ease.outSine, Ease.inOutSine, Ease.outInSine],
             "name":"Sine"],
            ["equations":[Ease.inExpo, Ease.outExpo, Ease.inOutExpo, Ease.outInExpo],
             "name":"Expo"],
            ["equations":[Ease.inCirc, Ease.outCirc, Ease.inOutCirc, Ease.outInCirc],
             "name":"Circ"],
            ["equations":[Ease.inElastic, Ease.outElastic, Ease.inOutElastic, Ease.outInElastic],
             "name":"Elastic"],
            ["equations":[Ease.inBack, Ease.outBack, Ease.inOutBack, Ease.outInBack],
             "name":"Back"],
            ["equations":[Ease.inBounce, Ease.outBounce, Ease.inOutBounce, Ease.outInBounce],
             "name":"Bounce"]
        ]
        
        var scrollBounds:CGRect  = bounds
        scrollBounds.size.height = scrollBounds.size.height - 48.0
        scrollview.frame = scrollBounds
        addSubview(scrollview)
        
        var selBounds:CGRect = bounds
        selBounds.origin.y = bounds.size.height - 48.0
        selectorContainer.frame = selBounds
        addSubview(selectorContainer)
        
        //Button
        selectorButton.frame = CGRect(x:0.0,
                                           y:0.0,
                                           width:self.frame.size.width,
                                           height:48.0)
        selectorButton.addTarget(self, action:#selector(showHide), for:.touchUpInside)
        selectorButton.setTitleColor(UIColor.black, for: .normal)
        selectorButton.backgroundColor = UIColor(red: 84.0 / 255.0, green: 255 / 255.0, blue: 194 / 255.0, alpha: 1.0)

        selectorContainer.addSubview(self.selectorButton)
        
        easeSelector.frame = CGRect(x:0.0,
                                         y:48.0,
                                         width:self.frame.size.width,
                                         height:self.frame.size.height - 48.0)
        
        selectorContainer.addSubview(self.easeSelector)
        
        
        for (index, dict) in easeList.enumerated()
        {
            //Create selector button
            let item:UIButton = UIButton(frame:CGRect(x:0.0,
                                                      y:48.0 * CGFloat(index),
                                                      width:self.frame.size.width,
                                                      height:48.0))
            item.setTitleColor(UIColor.black, for: .normal)
            let name:String = dict["name"] as! String
            item.setTitle(name, for:.normal)
            item.addTarget(self, action: #selector(selectButton), for: .touchUpInside)
            item.backgroundColor = UIColor.white
            easeSelector.addSubview(item)
            
            //Add separator
            let separator:UIView = UIView(frame:CGRect(x:0.0,
                                                       y:47.0,
                                                       width:self.frame.size.width,
                                                       height:1.0))
            separator.backgroundColor = UIColor.black
            item.addSubview(separator)
            
            easeSelector.contentSize = CGSize(width:self.frame.size.width,
                                                   height:item.frame.origin.y + item.frame.size.height)
            //Add to button list
            buttons.append(item)
        }
        
        let equations:Array<Ease> = easeList[0]["equations"] as! Array<Ease>
        let name:String = easeList[0]["name"] as! String

        self.selectorButton.setTitle("Ease:\(name)", for:.normal)
        
//        self.inspectors = [[NSMutableArray alloc] init]
        
//        var i:Int = 0
//        let size:CGFloat = 250.0
        let spacing:CGFloat = 20.0
        let extraSpace:CGFloat = 110.0
        let totalHeigth:CGFloat = 250.0 + extraSpace
        
        let types:Array<String> = ["In", "Out", "InOut", "OutIn"]
        
        for (index, equation ) in equations.enumerated()
        {
            let inspector:CurveInspector = CurveInspector(frame:CGRect(x:spacing,
                                                                       y:spacing + CGFloat(index) * (totalHeigth + spacing),
                                                                       width:self.frame.size.width - 40.0,
                                                                       height:totalHeigth))
            scrollview.addSubview(inspector)
            scrollview.contentSize = CGSize(width:self.frame.size.width,
                                                 height:inspector.frame.origin.y + inspector.frame.size.height + spacing)
            
            inspector.ease = equation
            inspector.label.text = types[index]
            inspectors.append(inspector)
            
        }
        
        //Select first
        selectIndex(0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc func showHide()
    {
        //Animate
        let newFrame = CGRect(x:0.0,
                             y:(selectorContainer.frame.origin.y == 0.0) ?
                                selectorContainer.frame.size.height - 48.0 : 0.0,
                             width:selectorContainer.frame.size.width, height:selectorContainer.frame.size.height)
        
        let tween:Tween = Tween(target:selectorContainer,
                                duration:0.25,
                                ease:Ease.outQuart,
                                to:[\UIView.frame : newFrame])
        tween.play()
    }
    
    @objc func selectButton()
    {
        for (index, button) in buttons.enumerated()
        {
            if (button.isHighlighted == true)
            {
                selectIndex(index)
                break
            }
        }
    }
    
    func selectIndex(_ index:Int)
    {
        let equations:Array<Ease> = easeList[index]["equations"] as! Array<Ease>
        let name:String = easeList[index]["name"] as! String
        selectorButton.setTitle("Ease: \(name)", for: .normal)

        for (index, equation) in equations.enumerated()
        {
            let inspector:CurveInspector = inspectors[index]
            inspector.ease = equation
        }
        
        showHide()
    }
}
