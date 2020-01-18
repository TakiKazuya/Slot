//
//  ViewController.swift
//  Slot
//
//  Created by 国分和弥 on 2020/01/18.
//  Copyright © 2020 Kazuya Kokubun. All rights reserved.
//

import UIKit
import Lottie
import AVFoundation

class ViewController: UIViewController {
    
    var audioPlayerInstance : AVAudioPlayer! = nil
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var leftImageView: UIImageView!
    @IBOutlet weak var centerImageView: UIImageView!
    @IBOutlet weak var rightImageView: UIImageView!
    
    
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var centerButton: UIButton!
    @IBOutlet weak var rightButton: UIButton!
    
    @IBOutlet weak var startButton: UIButton!
    
    var leftImageArray = [UIImage]()
    var centerImageArray = [UIImage]()
    var rightImageArray = [UIImage]()
    
    var leftTimer:Timer!
    var centerTimer:Timer!
    var rightTimer:Timer!
    
    var leftCount = 0
    var centerCount = 0
    var rightCount = 0
    
    var leftCheck = false
    var centerCheck = false
    var rightCheck = false
    
    var animationView:AnimationView! = AnimationView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let soundFilePath = Bundle.main.path(forResource: "7", ofType: "mp3")!
        let sound:URL = URL(fileURLWithPath: soundFilePath)
        
        do {
            audioPlayerInstance = try AVAudioPlayer(contentsOf: sound, fileTypeHint:nil)
        } catch {
            print("AVAudioPlayerインスタンス作成でエラー")
        }
        // 再生準備
        audioPlayerInstance.prepareToPlay()
        
        imageView.alpha = 0
        
        startButton.layer.cornerRadius = 30
        
        for i in 0...9 {
            
            let image = UIImage(named: "\(i)")
            leftImageArray.append(image!)
            centerImageArray.append(image!)
            rightImageArray.append(image!)
            
        }
        
        if leftButton.isEnabled == false && leftButton.isEnabled == false && rightButton.isEnabled == false {
            
            startButton.isEnabled = true
            
        }
        
    }
    
    //スタートボタンが押された時の処理
    
    @IBAction func start(_ sender: Any) {
        
        leftStartTimer()
        centerStartTimer()
        rightStartTimer()
        
        startButton.isEnabled = false
        
        leftButton.setTitle("🔵", for: [])
        centerButton.setTitle("🔵", for: [])
        rightButton.setTitle("🔵", for: [])
        
        leftButton.isEnabled = true
        centerButton.isEnabled = true
        rightButton.isEnabled = true
        
        leftCheck = false
        centerCheck = false
        rightCheck = false
        
        imageView.alpha = 0
        
    }
    
    //スタートタイマー
    
    func leftStartTimer(){
        
        leftTimer = Timer.scheduledTimer(timeInterval: TimeInterval(0.5), target: self, selector: #selector(leftTimerUpdate), userInfo: nil, repeats: true)
        
    }
    
    func centerStartTimer(){
        
        centerTimer = Timer.scheduledTimer(timeInterval: TimeInterval(0.5), target: self, selector: #selector(centerTimerUpdate), userInfo: nil, repeats: true)
        
    }
    
    func rightStartTimer(){
        
        rightTimer = Timer.scheduledTimer(timeInterval: TimeInterval(0.5), target: self, selector: #selector(rightTimerUpdate), userInfo: nil, repeats: true)
        
    }
    
    //タイマーアップデート
    
    @objc func leftTimerUpdate() {
        leftCount += 1
        if leftCount >= 9{
            leftCount = 0
        }
        
        leftImageView.image = leftImageArray[leftCount]
        
        
    }
    @objc func centerTimerUpdate() {
        centerCount += 1
        if centerCount >= 9{
            centerCount = 0
        }
        
        centerImageView.image = centerImageArray[centerCount]
        
    }
    
    @objc func rightTimerUpdate() {
        rightCount += 1
        if rightCount >= 9{
            rightCount = 0
        }
        
        rightImageView.image = rightImageArray[rightCount]
        
    }
    
    
    //ボタンが押された時の処理
    
    @IBAction func left(_ sender: Any) {
        leftTimer.invalidate()
        leftButton.isEnabled = false
        leftButton.setTitle("🔴", for: [])
        leftTimer = nil
        check()
        
        if leftCount == 7 {
            
            leftCheck = true
            //7揃い成功時
            if centerCheck == true && rightCheck == true {

                startSuccessAnimation()
            }
            
        }
        
    }
    @IBAction func center(_ sender: Any) {
        centerTimer.invalidate()
        centerButton.isEnabled = false
        centerButton.setTitle("🔴", for: [])
        centerTimer = nil
        check()
        
        if centerCount == 7{
            
            centerCheck = true
            //7揃い成功時
            if leftCheck == true && rightCheck == true {
                
                 startSuccessAnimation()
                
            }
            
        }
        
    }
    @IBAction func right(_ sender: Any) {
        rightTimer.invalidate()
        rightButton.isEnabled = false
        rightButton.setTitle("🔴", for: [])
        rightTimer = nil
        check()
        
        if rightCount == 7{
            
            rightCheck = true
            //7揃い成功時
            if leftCheck == true && centerCheck == true {
                
                startSuccessAnimation()
                
            }
            
        }
        
    }
    
    //終わったかどうか判別
    
    func check(){
        
        if leftButton.isEnabled == false && leftButton.isEnabled == false && rightButton.isEnabled == false {
            
            startButton.isEnabled = true
            
        }
        
    }
    
    //効果音を鳴らす
    
    func playSound(){
        
        audioPlayerInstance.currentTime = 0         // 再生箇所を頭に移す
        audioPlayerInstance.play()                  // 再生する

    }
    
    //アニメーション
    func startSuccessAnimation(){
        
        //jsonファイルを読み込んで作動させる
        let animation = Animation.named("success")
        animationView.animation = animation
        animationView.contentMode = .scaleAspectFit
        animationView.frame = CGRect(x: 0, y: 0,
                                     width:view.bounds.width, height:view.bounds.height)
        animationView.loopMode = .playOnce
        animationView.backgroundColor = .clear
        view.addSubview(animationView)
        animationView.play()
        
        //２秒後にアニメーションを消す
        DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
            //2秒後に行いたい処理
            self.animationView.removeFromSuperview()
        }
    }
    
    func startFalseAnimation(){
        
        //jsonファイルを読み込んで作動させる
        let animation = Animation.named("false")
        animationView.animation = animation
        animationView.contentMode = .scaleAspectFit
        animationView.frame = CGRect(x: 0, y: 0,
                                     width:view.bounds.width, height:view.bounds.height)
        animationView.loopMode = .playOnce
        animationView.backgroundColor = .clear
        view.addSubview(animationView)
        animationView.play()
        
        //２秒後にアニメーションを消す
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            //2秒後に行いたい処理
            self.animationView.removeFromSuperview()
        }
    }
}





