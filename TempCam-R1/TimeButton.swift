//
//  TimeButton.swift
//  Temp Cam
//
//  Created by Krithik Rao on 6/12/15.
//  Copyright (c) 2015 Krithik Rao. All rights reserved.
//

import Foundation
import UIKit

class TimeButton: UIButton{
    
    //Properties of the Button Itself
    static var bCount: Int = 1
    let bID: String
    var time: Time
    
    //Variables for the Defaults and Data Loading
    //Default Timings
    fileprivate let defaultTimes = [
        Time(amount: 20, unit: .Minute),
        Time(amount: 1, unit: .Hour),
        Time(amount: 1, unit: .Day),
        Time(amount: 3, unit: .Day),
        Time(amount: 1, unit: .Week),
        Time(amount: 1, unit: .Month)
    ]
    //Default Button IDS
    fileprivate let defaultButtonIDs = [
        "B1",
        "B2",
        "B3",
        "B4",
        "B5",
        "B6"
    ]
    //Just a Shortform for standardUserDefaults()
    let usrDefaults = UserDefaults.standard
    //The key to indicate wether buttons have been loaded ... NOT IN USE
    // private let defaultsLoadedKey = "buttonDefaultsLoaded"
    fileprivate static let wobbleAngle = 0.1
    fileprivate static let shakeAnimation : CAAnimation = {
        let animation = CAKeyframeAnimation(keyPath: "transform")
        let valLeft = NSValue(caTransform3D: CATransform3DMakeRotation(CGFloat(wobbleAngle) , 0, 0, 1))
        let valRight = NSValue(caTransform3D: CATransform3DMakeRotation(CGFloat(-wobbleAngle) , 0, 0, 1))
        animation.values = [valLeft , valRight ]
        animation.autoreverses = true
        animation.duration = 0.2
        animation.repeatCount = Float.infinity
        return animation
    }()
    static var isEditable: Bool = false
    static var currentOrientation: UIInterfaceOrientation = UIInterfaceOrientation.portrait
    
    
    /*
     static let WiggleBounceY = 4
     static let WiggeBounceDuration = 0.12
     static let WiggleBounceDurationVariance = 0.025
     static let WiggleRotationAngle = 0.06
     static let WiggleRotationDuration = 0.1
     static let WiggleRotationDurationVariance = 0.025
     static let rotationAnimation : CAAnimation = {
     let animation = CAKeyframeAnimation(keyPath: "transform.rotation.z")
     animation.values = [-WiggleRotationAngle, WiggleRotationAngle]
     animation.autoreverses = true
     animation.duration = []
     return animation
     }()
     private static let bounceAnimation: CAAnimation = {
     let animation = CAKeyframeAnimation(keyPath: "transform.translation.y")
     
     return animation
     }()
     private static func randomizeInterval(interval: NSTimeInterval, variance: Double){
     var random : Double =(arc4random() as? Int - 500)
     random = random / 500
     return variance * random;
     }
     */
    
    
    override init(frame: CGRect){
        bID = "B"+String(TimeButton.bCount)
        time = Time(amount: 0, unit: .Minute)
        super.init(frame: frame)
        TimeButton.bCount += 1
        self.updateTime()
        
    }
    
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
    func updateTime(){
        time = getButtonData(bID)
        self.setTitle(time.description, for: .normal)
    }
    
    
    func getButtonData(_ bID: String) -> Time{
        if((usrDefaults.value(forKey: bID+"AMT")) != nil){
            let amount = usrDefaults.value(forKey: bID+"AMT") as! Int
            let unit = usrDefaults.value(forKey: bID+"UNIT") as! String
            return Time(amount: amount, unit: unit)
        }else{
            loadButtonDefaults()
            return getButtonData(bID)
        }
        
        
    }
    
    fileprivate func loadButtonDefaults(){
        for index in 0..<(ViewController.howManyButtons){
            setButtonData(defaultButtonIDs[index], time: defaultTimes[index])
        }
    }
    func setButtonData(_ bID: String, time: Time){
        let amountKey: String = bID + "AMT"
        let unitKey: String = bID + "UNIT"
        usrDefaults.set(time.amount, forKey: amountKey)
        usrDefaults.set(time.unit.rawValue as AnyObject, forKey: unitKey)
        // usrDefaults.setObject(time as? AnyObject, forKey: bID)
        //print(usrDefaults.objectForKey(bID))
    }
    
    
    
    static func toggleEditMode(_ buttons : [TimeButton]){
        if(!TimeButton.isEditable){
            TimeButton.isEditable = true
            for btn in buttons{
                btn.layer.add(TimeButton.shakeAnimation, forKey: "Shake")
            }
        }else{
            for btn in buttons{
                btn.layer.removeAnimation(forKey: "Shake")
            }
            TimeButton.isEditable = false
        }
        
    }
    
    
}
