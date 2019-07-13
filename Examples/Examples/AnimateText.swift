//
//  AnimateText.swift
//  Examples
//
//  Created by Alejandro Ramirez Varela on 6/29/19.
//  Copyright © 2019 Alejandro Ramirez Varela. All rights reserved.
//

import UIKit
import Tweener

class AnimateText:UIView
{
    let label:UILabel = UILabel()
    let words:Array<String> = ["Hello", "Hola", "Bonjour", "Ciao", "Olá", "Hallo", "Ohayo", "Konnichiwa", "Ni hau", "Hej", "Guten tag", "Namaste", "Salaam", "Merhaba", "Szia"]
    let aim:StringAim = StringAim()
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        let purpleColor = UIColor(red:65.0/255.0,
                                  green:50.0/255.0,
                                  blue:160.0/255,
                                  alpha:1.0)
        
        backgroundColor = purpleColor
        
        //Set initial string
        let randomText = getRandomText()
        
        //Set initial strings
        label.frame = CGRect(x:20.0,
                             y:center.y - 60.0,
                             width:self.frame.size.width - 40.0,
                             height:60.0)
        label.font = UIFont.systemFont(ofSize: 58.0, weight: .light)
        label.textColor = UIColor.white
        label.text = randomText
        addSubview(label)
        
        aim.from = randomText
        aim.to = changeText(oldText:randomText)
        aim.target = label
        
        //Create buttons
        let buttonLabels = ["lenght", "linear", "random"]
        let buttonSelectors = [#selector(lenght), #selector(linear), #selector(random)]
        let w:CGFloat = (self.frame.size.width -  20.0 * CGFloat(buttonLabels.count + 1) ) / CGFloat(buttonLabels.count)

        for (index, label) in buttonLabels.enumerated()
        {
            let x = (20.0 + w) * CGFloat(index)
            
            let button = UIButton(frame: CGRect(x:20.0 + x,
                                                y:self.frame.size.height -  70.0,
                                                width:w,
                                                height:50.0))
            addSubview(button)
            button.setTitle(label, for:.normal)
            button.addTarget(self, action:buttonSelectors[index], for:.touchUpInside)
            button.setTitleColor(purpleColor, for:.normal)
            button.backgroundColor = UIColor.white
            button.layer.cornerRadius = 7.0
            addSubview(button)
        }
        
        //Start animating
        swapText()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func swapText()
    {
        aim.from = aim.to
        aim.to = changeText(oldText:aim.to)
        aim.interpolation = 0.0
    
        Tweener.removeTweens(target: aim)
        
        Tween(target: aim,
              duration: 0.5,
              ease: Ease.none,
              delay: 0.0,
              keys: [\StringAim.interpolation : 1.0],
              completion: {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                self.swapText()
            })
        }).play()
    }
    
    func changeText(oldText:String) -> String
    {
        var newString = oldText
        
        while newString  == oldText
        {
            newString = getRandomText()
        }
        
        return newString
    }

    func getRandomText() -> String
    {
        let rand = BasicMath.randomInt(max: words.count - 1)
        return words[rand]
    }
    
    @objc func lenght(){aim.transitionType = .lenght}
    @objc func linear(){aim.transitionType = .linear}
    @objc func random(){aim.transitionType = .random}
}
