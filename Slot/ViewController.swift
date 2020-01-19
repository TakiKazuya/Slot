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

    //設定画面
    @IBOutlet weak var settingView: UIView!
    
    //リールの画像
    @IBOutlet weak var leftImageView: UIImageView!
    @IBOutlet weak var centerImageView: UIImageView!
    @IBOutlet weak var rightImageView: UIImageView!
    
    //ボタン
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var centerButton: UIButton!
    @IBOutlet weak var rightButton: UIButton!
    
    //スタートボタン
    @IBOutlet weak var startButton: UIButton!
    
    //スライダー
    @IBOutlet weak var slider: UISlider!
    
    //セグメント
    @IBOutlet weak var segment: UISegmentedControl!
    
    //画像を入れる配列
    var leftImageArray = [UIImage]()
    var centerImageArray = [UIImage]()
    var rightImageArray = [UIImage]()
    
    //タイマー
    var leftTimer:Timer!
    var centerTimer:Timer!
    var rightTimer:Timer!
    
    //カウント
    var leftCount = 0
    var centerCount = 0
    var rightCount = 0
    
    //ボタンが押されているか判別する
    var tappedLeftButton = false
    var tappedCenterButton = false
    var tappedRightButton = false
    
    //7が押せているか判別する
    var successLeft = false
    var successCenter = false
    var successRight = false
    
    //リールの速さ
    var speed = Double()
    
    //アニメーションビュー
    var animationView:AnimationView! = AnimationView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //スピード設定
        speed = 0.1
        slider.addTarget(self, action: #selector(self.speedSetSlider(_:)), for: .valueChanged)
        slider.setValue(Float(speed), animated: true)
        slider.minimumValue = 0.01
        slider.maximumValue = 1
        
        //効果音
        let soundFilePath = Bundle.main.path(forResource: "7", ofType: "mp3")!
        let sound:URL = URL(fileURLWithPath: soundFilePath)
        do {
            audioPlayerInstance = try AVAudioPlayer(contentsOf: sound, fileTypeHint:nil)
        } catch {
            print("AVAudioPlayerインスタンス作成でエラー")
        }
        
        // 再生準備
        audioPlayerInstance.prepareToPlay()
        startButton.layer.cornerRadius = 30
        
        
        //配列の準備
        for i in 0...9 {
            
            let image = UIImage(named: "\(i)")
            leftImageArray.append(image!)
            centerImageArray.append(image!)
            rightImageArray.append(image!)
            
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
        
        tappedLeftButton = false
        tappedCenterButton = false
        tappedRightButton = false
        
        successLeft = false
        successCenter = false
        successRight = false
        
        settingView.isHidden = true
        
    }
    
    //スタートタイマー
    
    func leftStartTimer(){
        
        leftTimer = Timer.scheduledTimer(timeInterval: TimeInterval(speed), target: self, selector: #selector(leftTimerUpdate), userInfo: nil, repeats: true)
        
    }
    
    func centerStartTimer(){
        
        centerTimer = Timer.scheduledTimer(timeInterval: TimeInterval(speed), target: self, selector: #selector(centerTimerUpdate), userInfo: nil, repeats: true)
        
    }
    
    func rightStartTimer(){
        
        rightTimer = Timer.scheduledTimer(timeInterval: TimeInterval(speed), target: self, selector: #selector(rightTimerUpdate), userInfo: nil, repeats: true)
        
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
    
    //左ボタン
    @IBAction func left(_ sender: Any) {
        leftTimer.invalidate()
        leftButton.isEnabled = false
        leftButton.setTitle("🔴", for: [])
        leftTimer = nil
        
        tappedLeftButton = true
        print(leftCount)
        
        //7成功時
        if leftCount == 7 {
            
            successLeft = true
            check()
            print(successLeft)
            
        //目押し失敗時
        }else if leftCount != 7{
            
            successLeft = false
            check()
            print(successLeft)
            
        }

    }
    
    //中ボタン
    @IBAction func center(_ sender: Any) {
        centerTimer.invalidate()
        centerButton.isEnabled = false
        centerButton.setTitle("🔴", for: [])
        centerTimer = nil
        
        tappedCenterButton = true
        print(centerCount)
        
        //7成功時
        if centerCount == 7 {
            
            successCenter = true
            check()
            print(successCenter)
            
        //目押し失敗時
        }else if centerCount != 7{
            
            successCenter = false
            check()
            print(successCenter)
            
        }
    }
    
    //右ボタン
    @IBAction func right(_ sender: Any) {
        rightTimer.invalidate()
        rightButton.isEnabled = false
        rightButton.setTitle("🔴", for: [])
        rightTimer = nil
        
        tappedRightButton = true
        print(rightCount)
        
        //7成功時
        if rightCount == 7{
            
            successRight = true
            check()
            print(successRight)
            
        //目押し失敗時
        }else if rightCount != 7{
            
            successRight = false
            check()
            print(successRight)
            
        }
    }
    
    //終わったかどうか判別
    
    func check(){
        
        //すべてのボタンを押し終わったか判定
        if leftButton.isEnabled == false && leftButton.isEnabled == false && rightButton.isEnabled == false {
            
            startButton.isEnabled = true
            
            //７揃いしたか判別
            if successLeft == true && successCenter == true && successRight == true{
                
                startSuccessAnimation()
                
                settingView.isHidden = false
                
            //7揃い失敗時
            }else{
                
                startFalseAnimation()
                
                settingView.isHidden = false
                
            }
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
    
    //スライダーの最小単位を0.05にする
    let step: Float = 0.05
       @IBAction func speedSetSlider(_ sender: UISlider) {
           let roudedValue = round(sender.value / step ) * step
           sender.value = roudedValue
           speed = Double(sender.value)
           print(sender.value)
       }
}





