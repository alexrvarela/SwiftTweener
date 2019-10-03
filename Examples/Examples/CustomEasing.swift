//
//  CustomEasing.swift
//  Examples
//
//  Created by Alejandro Ramirez Varela on 7/10/19.
//  Copyright © 2019 Alejandro Ramirez Varela. All rights reserved.
//

import UIKit
import Tweener

//Custom ease.
extension Ease{
    public static let custom : Equation = { (t, b, c, d) in
        //Play with code here!
        if t < d/2 {return Ease.inBack(t*2, b, c/2, d)}
        return Ease.outElastic((t*2)-d, b+c/2, c/2, d)
    }
}

class CustomEasing: UIView
{
    //Asset
    override init(frame: CGRect){
        super.init(frame: frame)
        
        let spacing:CGFloat = 20.0
        let inspector:CurveInspector = CurveInspector(frame:CGRect(x:spacing,
                                                                   y:spacing,
                                                                   width:self.frame.size.width - spacing * 2.0,
                                                                   height:360))
        inspector.ease = Ease.custom
        inspector.label.text = "Custom ease"
        addSubview(inspector)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
