//
//  AppDelegate.swift
//  Examples
//
//  Created by Alejandro Ramirez Varela on 9/7/18.
//  Copyright © 2018 Alejandro Ramirez Varela. All rights reserved.
//

import UIKit
import Tweener

//Declare FrozenProtocol to pause or remove tweens from samples.
protocol FreezeProtocol {
    func freeze()
    func warm()
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    let window = UIWindow(frame:UIScreen.main.bounds)
    let viewController = UIViewController()
    let view = UIView(frame:UIScreen.main.bounds)
    var timeline: Timeline = Timeline()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool
    {
        viewController.view.frame = UIScreen.main.bounds
        viewController.view.backgroundColor = UIColor.white
        viewController.view.addSubview(view)
        window.rootViewController = viewController
        window.makeKeyAndVisible()
        
        //Create tween vizualizer
        let visualizer = TweenVisualizer()
        visualizer.center = CGPoint(x:UIScreen.main.bounds.size.width / 2.0,
                                    y:UIScreen.main.bounds.size.height - 170)
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
        view.addSubview(ViewExtensions(frame:contentFrame))
        view.addSubview(SimpleTween(frame:contentFrame))
        view.addSubview(ChainableTweens(frame:contentFrame))
        view.addSubview(EaseCurves(frame:contentFrame))
        view.addSubview(CustomEasing(frame:contentFrame))
        view.addSubview(CustomTypes(frame:contentFrame))
        view.addSubview(TweenHandlers(frame:contentFrame))
        view.addSubview(TouchPoint(frame:contentFrame))
        view.addSubview(DragView(frame:contentFrame))
        view.addSubview(Transform3d(frame:contentFrame))
        view.addSubview(PauseTweens(frame:contentFrame))
        view.addSubview(SimpleTimeline(frame:contentFrame))
        view.addSubview(ScrollTimeline(frame:contentFrame))
        view.addSubview(TimelineBasic(frame:contentFrame))
        view.addSubview(AnimateArcRadius(frame:contentFrame))
        view.addSubview(PathLoop(frame:contentFrame))
        view.addSubview(WindBlow(frame:contentFrame))
        view.addSubview(ArcOrbits(frame:contentFrame))
        view.addSubview(AnimateText(frame:contentFrame))
        view.addSubview(ScrollAims(frame:contentFrame))
        
        //Align views
        var x:CGFloat = 0.0
        for view:UIView in self.view.subviews{
            view.frame.origin.x = x
            x = x + UIScreen.main.bounds.size.width
        }
        self.view.frame.size.width = x
        
        return true
    }
    
    var pageIndex:Int = 0
    {
        willSet{
            //Freeze page
            if let pageCurrent = view.subviews[pageIndex] as? FreezeProtocol{ pageCurrent.freeze() }
        }
        
        didSet {
            
            //Set new frame
            var nFrame = self.view.frame
            nFrame.origin.x = -(CGFloat(pageIndex) * UIScreen.main.bounds.size.width)
            
            //Animate
            Tween(target:view)
                .duration(0.5)
                .ease(Ease.outCubic)
                .keys(to:[\UIView.frame:nFrame])
                .play()
            
            //Warm page
            if let pageNext = view.subviews[pageIndex] as? FreezeProtocol{ pageNext.warm() }
        }
    }
    
    @objc func nextSample()
    {
        if (self.pageIndex < self.view.subviews.count - 1){self.pageIndex += 1}
        else {self.pageIndex = 0}
    }
    
    @objc func prevSample()
    {
        if (self.pageIndex > 0){self.pageIndex -= 1}
        else {self.pageIndex = self.view.subviews.count - 1}
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

