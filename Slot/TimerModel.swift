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
    
    var speed = Double()
    var imageView = UIImageView()
    var imageArray = [UIImage]()
    var count = Int()
    var timer:Timer!
    
    
    init(speed:Double,imageView:UIImageView,imageArray:[UIImage],count:Int,timer:Timer) {
        self.speed = speed
        self.imageView = imageView
        self.imageArray = imageArray
        self.count = count
        self.timer = timer
    }
    
    
    func startTimer(){
        timer = Timer.scheduledTimer(timeInterval: TimeInterval(speed),
                                     target: self,
                                     selector: #selector(timerUpdate),
                                     userInfo: nil,
                                     repeats: true)
    }
    
    func stopTimer(){
        timer.invalidate()
        timer = nil
    }
    
    func getCount()->Int{
        return count
    }
    
    @objc func timerUpdate() {
        count += 1
        if count >= 9{
            count = 0
        }
        imageView.image = imageArray[count]
    }
}
