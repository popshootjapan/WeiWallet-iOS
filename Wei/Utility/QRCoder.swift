//
//  QRCoder.swift
//  Wei
//
//  Created by omatty198 on 2018/04/05.
//  Copyright © 2018年 popshoot All rights reserved.
//

import UIKit
import AVFoundation

protocol QRCoderDelegate: class {
    func qrCoder(_ qrCoder: QRCoder, didDetectQRCode url: String)
}

protocol QRCoderProtocol {
    func configure(on view: UIView)
    func startRunning()
    func stopRunning()
    func generate(from address: String) -> UIImage?
}

final class QRCoder: NSObject, QRCoderProtocol {
    
    private let captureSession = AVCaptureSession()
    private var videoPreviewLayer: AVCaptureVideoPreviewLayer? = nil
    private weak var delegate: QRCoderDelegate?
    
    init(delegate: QRCoderDelegate?) {
        self.delegate = delegate
    }
    
    static func requestAccess(handler: @escaping (Bool) -> Void) {
        AVCaptureDevice.requestAccess(for: .video, completionHandler: handler)
    }
    
    func configure(on view: UIView) {
        configureSession()
        addVideoPreviewLayer(on: view)
    }
    
    func startRunning() {
        guard !captureSession.isRunning else {
            return
        }
        captureSession.startRunning()
    }
    
    func stopRunning() {
        guard captureSession.isRunning else {
            return
        }
        captureSession.stopRunning()
    }
    
    func generate(from address: String) -> UIImage? {
        let parameters: [String : Any] = [
            "inputMessage": address.data(using: .utf8)!,
            "inputCorrectionLevel": "H"
        ]
        
        let filter = CIFilter(name: "CIQRCodeGenerator", parameters: parameters)
        guard let outputImage = filter?.outputImage else {
            return nil
        }
        
        let scaledImage = outputImage.transformed(by: CGAffineTransform(scaleX: 10, y: 10))
        guard let cgImage = CIContext().createCGImage(scaledImage, from: scaledImage.extent) else {
            return nil
        }
        
        return UIImage(cgImage: cgImage)
    }
}

private extension QRCoder {
    func configureSession() {
        for input in captureSession.inputs {
            captureSession.removeInput(input)
        }
        for output in captureSession.outputs {
            captureSession.removeOutput(output)
        }
        
        let deviceDiscoverySession = AVCaptureDevice
            .DiscoverySession(
                deviceTypes: [.builtInWideAngleCamera],
                mediaType: AVMediaType.video,
                position: .back
        )
        
        guard let captureDevice = deviceDiscoverySession.devices.first else {
            #if DEBUG
                return
            #else
                fatalError("Failed to get the camera device")
            #endif
        }
        
        let input: AVCaptureDeviceInput
        do {
            input = try AVCaptureDeviceInput(device: captureDevice)
        } catch let error {
            fatalError(error.localizedDescription)
        }
        
        captureSession.addInput(input)
        
        let captureMetadataOutput = AVCaptureMetadataOutput()
        captureSession.addOutput(captureMetadataOutput)
        
        captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        captureMetadataOutput.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
        
        videoPreviewLayer = AVCaptureVideoPreviewLayer.init(session: captureSession)
        videoPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
    }
    
    func addVideoPreviewLayer(on view: UIView) {
        videoPreviewLayer?.frame = view.layer.bounds
        #if !targetEnvironment(simulator)
            view.layer.addSublayer(videoPreviewLayer!)
        #endif
    }
}

extension QRCoder: AVCaptureMetadataOutputObjectsDelegate {
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        guard metadataObjects.count != 0 else {
            return
        }
        guard let metadataObject = metadataObjects.first as? AVMetadataMachineReadableCodeObject,
            metadataObject.type == AVMetadataObject.ObjectType.qr else {
            return
        }
        guard let address = (videoPreviewLayer?.transformedMetadataObject(for: metadataObject) as? AVMetadataMachineReadableCodeObject)?.stringValue else {
            return
        }
        delegate?.qrCoder(self, didDetectQRCode: address)
    }
}
