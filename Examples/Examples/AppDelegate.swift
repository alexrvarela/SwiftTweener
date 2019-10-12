//
//  AppDelegate.swift
//  Examples
//
//  Created by Alejandro Ramirez Varela on 9/7/18.
//  Copyright © 2018 Alejandro Ramirez Varela. All rights reserved.
//

import UIKit
import Tweener

//Declare FrozenProtocol to pause or remove tweens fro samples.

protocol FreezeProtocol {
    func freeze()
    func warm()
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    let window: UIWindow = UIWindow(frame:UIScreen.main.bounds)
    let container: UIView = UIView(frame:UIScreen.main.bounds)
    let viewController: ViewController = ViewController()
    var timeline: Timeline = Timeline()
    var _pageIndex:Int = 0

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool
    {
        viewController.view = UIView(frame: UIScreen.main.bounds)
        viewController.view.backgroundColor = UIColor.white
        viewController.view.addSubview(container)

        window.rootViewController = viewController
        window.makeKeyAndVisible()
        
        //Create tween vizualizer
        let visualizer = TweenVisualizer()
        visualizer.center = viewController.view.center
        Tweener.addVisualizer(visualizer)
        viewController.view.addSubview(visualizer)
        
        let buttonWidth = UIScreen.main.bounds.size.width / 2.0 - 1.0
        //Create next button
        let prevButton:UIButton = UIButton(frame:CGRect(x:0.0,
                                                        y:UIScreen.main.bounds.size.height - 40.0,
                                                        width:buttonWidth,
                                                        height:40.0))
            
        prevButton.setTitle("PREV", for: .normal)
        prevButton.addTarget(self, action: #selector(prevSample), for: .touchUpInside)
        prevButton.backgroundColor = UIColor.black
        viewController.view.addSubview(prevButton)
        
        //Create prev button
        let nextButton:UIButton = UIButton(frame:CGRect(x:UIScreen.main.bounds.size.width - buttonWidth,
                                                        y:UIScreen.main.bounds.size.height - 40.0,
                                                        width:buttonWidth,
                                                        height:40.0))
        nextButton.setTitle("NEXT", for: .normal)
        nextButton.addTarget(self, action: #selector(nextSample), for: .touchUpInside)
        nextButton.backgroundColor = UIColor.black
        viewController.view.addSubview(nextButton)
        
        
        let contentFrame:CGRect = CGRect(x:0.0,
                                         y:0.0,
                                         width:UIScreen.main.bounds.size.width,
                                         height:UIScreen.main.bounds.size.height - 40.0)
        //Add samples
        self.container.addSubview(SimpleTween(frame:contentFrame))
        self.container.addSubview(TweenHandlers(frame:contentFrame))
        self.container.addSubview(EaseCurves(frame:contentFrame))
        self.container.addSubview(CustomEasing(frame:contentFrame))
        self.container.addSubview(TouchPoint(frame:contentFrame))
        self.container.addSubview(DragView(frame:contentFrame))
        self.container.addSubview(Transform3d(frame:contentFrame))
        self.container.addSubview(PauseTweens(frame:contentFrame))
        self.container.addSubview(SimpleTimeline(frame:contentFrame))
        self.container.addSubview(ScrollTimeline(frame:contentFrame))
        self.container.addSubview(TimelineBasic(frame:contentFrame))
        self.container.addSubview(AnimateArcRadius(frame:contentFrame))
        self.container.addSubview(PathLoop(frame:contentFrame))
        self.container.addSubview(WindBlow(frame:contentFrame))
        self.container.addSubview(ArcOrbits(frame:contentFrame))
        self.container.addSubview(AnimateText(frame:contentFrame))
        self.container.addSubview(ScrollAims(frame:contentFrame))
        
        var x:CGFloat = 0.0
        
        for view:UIView in self.container.subviews
        {
            view.frame = CGRect(x:x,
                                y:view.frame.origin.y,
                                width:view.frame.size.width,
                                height:view.frame.size.height)
            x = x + UIScreen.main.bounds.size.width
        }
        
        self.container.frame = CGRect(x:self.container.frame.origin.x,
                                      y:self.container.frame.origin.y,
                                      width:x,
                                      height:self.container.frame.size.height)

        return true
    }
    
    var pageIndex:Int
    {
        set {
            let w = UIScreen.main.bounds.size.width
            var nFrame = self.container.frame
            nFrame.origin.x = -(CGFloat(newValue) * w)
            
            //Freeze page
            if let pageCurrent = container.subviews[_pageIndex] as? FreezeProtocol{ pageCurrent.freeze() }
            
            //Warm page
            if let pageNext = container.subviews[newValue] as? FreezeProtocol{ pageNext.warm() }
            
            //Animate container x position
            Tween(target:self.container,
                  duration:0.5,
                  ease:Ease.outCubic,
                  keys:[\UIView.frame:nFrame]).play()
            
            //Update page index
            _pageIndex = newValue
            
        }
        get {return _pageIndex}
    }
    
    @objc func nextSample()
    {
        if (self.pageIndex < self.container.subviews.count - 1){self.pageIndex += 1}
        else {self.pageIndex = 0}
    }
    
    @objc func prevSample()
    {
        if (self.pageIndex > 0){self.pageIndex -= 1}
        else {self.pageIndex = self.container.subviews.count - 1}
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
}

