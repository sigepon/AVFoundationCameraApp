//
//  ViewController.swift
//  cameraApp
//
//  Created by Kikuchi Shigeo on 2016/01/16.
//  Copyright © 2016年 sigepon. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    var myImageOutput: AVCaptureStillImageOutput!       //画像のアウトプット

    override func viewDidLoad() {
        super.viewDidLoad()
        makeCamera()
    }
    
    func makeCamera(){
        let mySession = AVCaptureSession()                          //セッションの作成
        mySession.sessionPreset = AVCaptureSessionPresetHigh        //解像度の指定
        let myCamera = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)    //デフォルトのカメラを選択
        
        do {
            //入力元
            let videoInput = try AVCaptureDeviceInput(device: myCamera) as AVCaptureDeviceInput
            mySession.addInput(videoInput)
            //出力元
            myImageOutput = AVCaptureStillImageOutput()
            mySession.addOutput(myImageOutput)
            
            //画面を表示するプレビューレイヤを作る
            let myVideoLayer = AVCaptureVideoPreviewLayer(session: mySession)
            myVideoLayer.frame = view.bounds
            myVideoLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
            view.layer.insertSublayer(myVideoLayer, atIndex: 0)  //最背面になるようにプレビューレイヤーを挿入する
            mySession.startRunning()            //セッションを開始
            
        }catch let error as NSError {
            
            print("カメラは使えません。\(error)")
        }
    }
    @IBAction func takePhoto(sender: UIButton) {
        let myAvconnection = myImageOutput.connectionWithMediaType(AVMediaTypeVideo)        //ビデオ出力に接続する
        
        myImageOutput.captureStillImageAsynchronouslyFromConnection(myAvconnection) { (imageDataBuffer, erro) -> Void in
            
            let myImageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(imageDataBuffer)
            let stillImage = UIImage(data: myImageData)
            
            UIImageWriteToSavedPhotosAlbum(stillImage!, self, nil, nil)

        }
    }
}

