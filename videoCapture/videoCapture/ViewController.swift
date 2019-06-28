//
//  ViewController.swift
//  videoCapture
//
//  Created by liuwei on 2019/6/20.
//  Copyright © 2019 liuwei. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    private let session = AVCaptureSession()
    private var previewLayer : AVCaptureVideoPreviewLayer?
    private var videoInput : AVCaptureDeviceInput?
    private var fileOutput : AVCaptureMovieFileOutput?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupVideoInputOutput()
        
        setupAudioInputOutput()
        
        setupPreviewLayer()
    }
    
}

extension ViewController {
    
    private func setupVideoInputOutput() {
        let inputDevices = AVCaptureDevice.devices(for: .video)
        guard let inputDevice = inputDevices.filter({$0.position == .front}).first else { return }
        guard let input = try? AVCaptureDeviceInput(device: inputDevice) else { return }
        
        self.videoInput = input
        
        let output = AVCaptureVideoDataOutput()
        output.setSampleBufferDelegate(self, queue: DispatchQueue.global())
        
        addInputOutputToSession(input: input, output: output)
    }
    
    private func setupAudioInputOutput() {
        guard let inputDevice = AVCaptureDevice.default(for: .audio) else { return }
        guard let input = try? AVCaptureDeviceInput(device: inputDevice) else { return }
        
        let output = AVCaptureAudioDataOutput()
        output.setSampleBufferDelegate(self, queue: DispatchQueue.global())
        
        addInputOutputToSession(input: input, output: output)
    }
    
    private func setupMovieOutput() {
        let output = AVCaptureMovieFileOutput()
        
        session.beginConfiguration()
        
        if let fileOutput = fileOutput {
            session.removeOutput(fileOutput)
        }
        
        if session.canAddOutput(output) {
            session.addOutput(output)
        }
        session.commitConfiguration()
        
        self.fileOutput = output
        
        let connection = output.connection(with: .video)
        connection?.automaticallyAdjustsVideoMirroring = true
        
        guard let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first else {
            return
        }
        let url = URL(fileURLWithPath: path + "/abc.mp4")
        
        output.startRecording(to: url, recordingDelegate: self)
    }
    
    private func addInputOutputToSession(input : AVCaptureInput, output : AVCaptureOutput) {
        session.beginConfiguration()
        if session.canAddInput(input) {
            session.addInput(input)
        }
        if session.canAddOutput(output) {
            session.addOutput(output)
        }
        session.commitConfiguration()
    }
    
    private func setupPreviewLayer() {
        let previewLayer = AVCaptureVideoPreviewLayer(session: session)
        previewLayer.frame = view.bounds
        view.layer.insertSublayer(previewLayer, at: 0)
        self.previewLayer = previewLayer
    }

}

extension ViewController : AVCaptureAudioDataOutputSampleBufferDelegate, AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        if output.connection(with: .video) == connection {
            print("视频输入")
        }else {
            print("音频输出")
        }
    }
}

extension ViewController : AVCaptureFileOutputRecordingDelegate {
    
    func fileOutput(_ output: AVCaptureFileOutput, didStartRecordingTo fileURL: URL, from connections: [AVCaptureConnection]) {
        print("开始录制")
    }
    
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        print("结束录制")
    }
    
}

extension ViewController {
    
    @IBAction func startCapturing(_ sender: Any) {
        session.startRunning()
        setupMovieOutput()
    }
    
    @IBAction func endCapturing(_ sender: Any) {
        session.stopRunning()
        fileOutput?.stopRecording()
    }
    
    @IBAction func rotateCamera(_ sender: Any) {
        guard let oldVideoInput = videoInput else {
            return
        }
        
        let position : AVCaptureDevice.Position = oldVideoInput.device.position == .front ? .back : .front
        
        let inputDevices = AVCaptureDevice.devices(for: .video)
        guard let inputDevice = inputDevices.filter({$0.position == position}).first else {
            return
        }
        
        guard let input = try? AVCaptureDeviceInput(device: inputDevice) else {
            return
        }
        
        session.beginConfiguration()
        session.removeInput(oldVideoInput)
        if session.canAddInput(input) {
            session.addInput(input)
        }
        session.commitConfiguration()
        
        self.videoInput = input
    }
    
}

