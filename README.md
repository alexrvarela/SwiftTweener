# SwiftTweener

Easy to use animation engine for iOs, make more powerful and creative Apps.

![Logo](https://raw.githubusercontent.com/alexrvarela/SwiftTweener/master/Gifs/tweener.gif)

### Prerequisites

* Xcode with IOs 10.0+ and swift 4.2

## Installation

### Install using Cocoapods

To integrate install [Cocoa Pods](http://cocoapods.org/) using this gem:
```
$ gem install cocoapods
```

Now, add Tweener to your Podfile
```
pod 'Tweener', '~> 1.0.1'
```

To install dependencies run this command
```
pod install
```

### Install using Carthage

To integrate install [Carthage](https://github.com/Carthage/Carthage) with brew:
```
$ brew update
$ brew install carthage
```

Now, add Tweener to your Cartfile
```
github "alexrvarela/Tweener" ~> 1.0.0
```

To install dependencies run this command
```
$ carthage update
```
Finally, drag & drop Tweener.framework to your Xcode Project

### Install manually

Download, build and copy Tweener.framework to your Xcode project.

## Usage

Import Tweener engine to your project:

```swift
import Tweener
```

Animate any of these kinds of properties:
Int, Float, Double, CGFloat, CGPoint, CGRect, UIColor, CGAffineTransform, CATransform3D

First set initial state:
```swift
myView.alpha = 0.25
myView.frame = CGRect(x:20.0, y:20.0, width:100.0, height:100.0)
myView.backgroundColor = UIColor.red
```

Create and add simple Tween:

```swift

let myTween = Tween(target:square,
    duration:1.0,
    ease:Ease.outQuad
    keys:[\UIView.alpha:1.0,
        \UIView.frame:CGRect(x:20.0, y:20.0, width:280.0, height:280.0),
        \UIView.backgroundColor!:UIColor.blue
])

myTween.play()
```

![Simple tween](https://raw.githubusercontent.com/alexrvarela/SwiftTweener/master/Gifs/simple-tween.gif)


Interact with your code using block handlers:

```swift
myTween.onStart = {
    self.backgroundColor = UIColor.green
}

myTween.onUpdate = {
    doAnything()
}

myTween.onComplete = {
    myView.backgroundColor = UIColor.red
}

myTween.onOverwrite = {
    self.backgroundColor = UIColor.blue
}
```

![Handlers](https://raw.githubusercontent.com/alexrvarela/SwiftTweener/master/Gifs/handlers.gif)


You can pause, resume and remove tweens:

For all existing tweens:
```swift
Tweener.pauseAllTweens()
Tweener.resumeAllTweens()
Tweener.removeAllTweens()
```

By target:
```swift
Tweener.pauseTweens(target:myView)
Tweener.resumeTweens(target:myView)
Tweener.removeTweens(target:myView)
```

By specific properties of a target:
```swift
Tweener.pauseTweens(target:myView, keys:[\UIView.backgroundColor, \UIView.alpha])
Tweener.resumeTweens(target:myView, keys:[\UIView.backgroundColor, \UIView.alpha])
Tweener.removeTweens(target:myView, keys:[\UIView.backgroundColor, \UIView.alpha])
```

Unleash your creativity!

Touch point sample:

![Touch](https://raw.githubusercontent.com/alexrvarela/SwiftTweener/master/Gifs/touch.gif)

Drag views sample:

![Drag ](https://raw.githubusercontent.com/alexrvarela/SwiftTweener/master/Gifs/drag.gif)

Pause tweens sample:

![Background animations](https://raw.githubusercontent.com/alexrvarela/SwiftTweener/master/Gifs/clouds.gif)


### Easing

This engine is based on Robert Penner's [Easing equations](http://robertpenner.com/easing/)

![Easing curves](https://raw.githubusercontent.com/alexrvarela/SwiftTweener/master/Gifs/ease-curves.gif)

To create a custom easing equation:
```swift
extension Ease{
    public static let custom : Equation = { (t, b, c, d) in
        //Play with code here!
        if t < d/2 {return Ease.inBack(t*2, b, c/2, d)}
        return Ease.outElastic((t*2)-d, b+c/2, c/2, d)
        }
}
```

And use it:
```swift
Tween(target:square,
    duration:1.0,
    ease:Ease.custom
    keys:[\UIView.frame:CGRect(x:20.0, y:20.0, width:280.0, height:280.0)]
    ).play()
```

For further information about custom equations:
[Easig function generator](http://www.timotheegroleau.com/Flash/experiments/easing_function_generator.htm)

### Timeline

Add a Tween or animate with Timeline?

It depends on what do you want, a Tween only animates “to” desired value taking the current value of the property as origin, that allows your App to be more dynamic, each Tween is destroyed immediately after completing the animation.

Timeline stores “from” and “to” values of each Tween, contains a collection of reusable Tweens, to create Timeline and add Tweens use this code:

```swift
let myTimeline:Timeline = Timeline()
myTimeline.add(myTween)
myTimeline.play()
```

You can interact with Timeline play modes, the default value is Play once, it stops when finished, to change Tmeline play mode:

Loop, repeat forever
```swift
myTimeline.playMode = .loop
```
![Loop](https://raw.githubusercontent.com/alexrvarela/SwiftTweener/master/Gifs/timeline-play.gif)

Ping Pong, forward and reverse
```swift
myTimeline.playMode = .pingPong
```

![Ping Pong](https://raw.githubusercontent.com/alexrvarela/SwiftTweener/master/Gifs/timeline-ping-pong.gif)

Perform parallax scrolling effects controlling your timeline with UIScrollView:

![Timeline scroll](https://raw.githubusercontent.com/alexrvarela/SwiftTweener/master/Gifs/tmeline-scroll.gif)


### TimelineInspector
You can use the Timeline inspector to debug  and edit Tweens

Visualize Tweens in real time:

![Visualize Tweens in real time!](https://raw.githubusercontent.com/alexrvarela/SwiftTweener/master/Gifs/tmeline-inspector.gif)

Edit Tweens:

![Edit Tweens](https://raw.githubusercontent.com/alexrvarela/SwiftTweener/master/Gifs/timeline-editor.gif)

![Scale timeline editor](https://raw.githubusercontent.com/alexrvarela/SwiftTweener/master/Gifs/timeline-zoom.gif)

To create Timeline inspector:
```swift
let myInspector = TimelineInspector(timeline:myTimeline)
addSubview(myInspector)
```

### PDFImageView

Cut with the image dependency and easily import your vector assets using PDFImageView, forget to export to SVG and other formats iOs offers native support for PDF with CoreGraphics, this class simply renders one pdf inside a UIImageView.

To load your asset named "bee.pdf" from App bundle:

```swift
let myAsset = PDFImageView(bundlename:"bee")
addSubview(myAsset)
```

You can increase or reduce the size of your assets with a simple property:

```swift
myAsset.scale = 1.5
```

### Aims
Create more complex and impressive animations using Aims

![Aims](https://raw.githubusercontent.com/alexrvarela/SwiftTweener/master/Gifs/eye.gif)


### PathAim
Control motion with paths:

![Path aim](https://raw.githubusercontent.com/alexrvarela/SwiftTweener/master/Gifs/path.gif)

```swift
let myPathAim = PathAim(target:myAsset)
myPathAim.path = myBezierPath
```

To change location at path change this property value:

```swift
myPathAim.interpolation = 0.5
```

And simply animate path interpolation:

```swift
myPathAim.interpolation = 0.0

Tween(target: myPathAim, 
    duration: 2.0, 
    ease: Ease.none, 
    delay: 0.0, 
    keys: [\PathAim.interpolation : 1.0]).play()
```

You can export your paths to code from illustrator with this simple Script:
https://github.com/alexrvarela/generatePathCode


### RotationAim

Animate rotation of any view

![Rotation aim](https://raw.githubusercontent.com/alexrvarela/SwiftTweener/master/Gifs/rotation-aim.gif)

```swift
let myRotationAim = RotationAim(target:myView)

myRotationAim.angle = 90.0

Tween(target: myRotationAim,
    duration: 1.5,
        keys: [\RotationAim.angle : 360.0]).play()
```

### ArcAim
Create Arc animations

![Arc aims](https://raw.githubusercontent.com/alexrvarela/SwiftTweener/master/Gifs/orbits.gif)

```swift
let myArcAim = ArcAim(target:myView)

//Set desired radius
myArcAim.radius = 100.0

//Set initial arc angle
myArcAim.arcAngle = 0.0

//Animate arc angle
Tween(target: myArcAim,
    duration: 1.5,
    keys: [\RotationAim.arcAngle : 360.0]).play()
```

### StringAim
Animate text transitions

![String aims](https://raw.githubusercontent.com/alexrvarela/SwiftTweener/master/Gifs/text.gif)

```swift
//Create string aim
let myStringAim = StringAim(target:myUILabel, keyPath:\UILabel.text)
myStringAim.from = "hello"
myStringAim.to = "hola"

//Set initial interpolation
myStringAim.interpolation = 0.0

//Animate interpolation
Tween(target: myStringAim, duration: 0.5, keys: [\StringAim.interpolation : 1.0]).play()
```

Play with everything, combine different types of Aim:

![Mix different aims](https://raw.githubusercontent.com/alexrvarela/SwiftTweener/master/Gifs/bb8.gif)

This library was created to give dynamism to UI elements, if you are looking to make more complex animations I recommend you implement them with [Lottie](https://airbnb.design/lottie/).

## Contributions

This project has being migrated to Swift 5

## Authors

* **Alejandro Ramírez Varela** - *Initial work* - [alexrvarela](https://github.com/alexrvarela)

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details

## Acknowledgments

* Based on [Robert Penner](http://robertpenner.com)  [Easing functions](http://robertpenner.com/easing/)
* Based on [Tweener](https://github.com/zeh/tweener), AS3 Library by [Zeh Fernando](https://github.com/zeh), Nate Chatellier, Arthur Debert and Francis Turmel
Ported by Alejandro Ramirez Varela on 2012 and released as open source in 2018
