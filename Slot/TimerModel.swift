//
//  TimerModel.swift
//  Slot
//
//  Created by 国分和弥 on 2020/01/22.
//  Copyright © 2020 Kazuya Kokubun. All rights reserved.
//

import Foundation
import UIKit

class TimerModel{
    
    var speed = Int()
    var imageView = UIImageView()
    var imageArray = [UIImage]()
    var count = Int()
    var timer:Timer!
    var target:Any
    
    init(speed:Int,imageView:UIImageView,imageArray:[UIImage],count:Int,target:Any) {
        self.speed = speed
        self.imageView = imageView
        self.imageArray = imageArray
        self.count = count
        self.target = target
    }
    
    
    func startTimer(){
        timer = Timer.scheduledTimer(timeInterval: TimeInterval(speed), target: target, selector: #selector(timerUpdate), userInfo: nil, repeats: true)
    }
    
    @objc func timerUpdate() {
        count += 1
        if count >= 9{
            count = 0
        }
        imageView.image = imageArray[count]
    }
}
