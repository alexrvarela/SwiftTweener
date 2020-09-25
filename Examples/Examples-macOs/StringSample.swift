//
//  StringSample.swift
//  Examples-macOs
//
//  Created by Alejandro Ramirez Varela on 14/09/20.
//  Copyright © 2020 Alejandro Ramirez Varela. All rights reserved.
//

import Cocoa
import Tweener

class StringSample: NSView {

    let textView:NSTextView = {
        let txtView = NSTextView()
        txtView.font = NSFont.userFont(ofSize: 150)
        txtView.backgroundColor = .clear
        txtView.textColor = .white
        txtView.isEditable = false
        txtView.isSelectable = false
        return txtView
    }()
    
    let stringAim = StringAim()
    
    let words:Array<String> = ["Hello", "Hola", "Bonjour", "Ciao", "Olá", "Hallo", "Ohayo", "Konnichiwa", "Ni hau", "Hej", "Guten tag", "Namaste", "Salaam", "Merhaba", "Szia"]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.wantsLayer = true
        self.layer!.backgroundColor = NSColor.magenta.cgColor
        addSubview(textView)

        //Set initial string
        let randomText = getRandomText()
        
        //Set initial text
        textView.string =  randomText
        //Fits to text size
        textView.sizeToFit()
        //Set full width
        textView.frame.size.width = frame.size.width
        //Center
        textView.center(CGPoint(x:frame.size.width * 0.5, y:frame.size.height * 0.5))
        
        //Link StringAim to target and 'String' KeyPath
        stringAim.bind(target:textView, keyPath: \NSTextView.string)
        //Set initial text
        stringAim.from = randomText
        //Set 'to 'text
        stringAim.to = changeText(oldText:randomText)
        
        //Start animation loop
        swapText()
        
        //Use timeline to repeat forever.
        Timeline(
            //Create tween with StringAim target and animate interpolation.
            Tween(target:stringAim)
            .delay(0.5)
            .duration(0.5)
            .ease(.none)
            .keys(to:[\StringAim.interpolation : 1.0])
            .onComplete { self.swapText() }
        )
        .mode(.loop)
        .play()
    }

    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    func swapText()
    {
           stringAim.from = stringAim.to
           stringAim.to = changeText(oldText:stringAim.to)
           stringAim.interpolation = 0.0
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
        let rand = Int.random(in:0...words.count - 1)
        return words[rand]
    }
    
}
