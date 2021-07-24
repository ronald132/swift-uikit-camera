//
//  ViewController.swift
//  MacPlayUIKit
//
//  Created by Ronald on 25/7/21.
//

import Cocoa
import AVFoundation

class ViewController: NSViewController {

    @IBOutlet weak var pickerController: NSPopUpButton!
        
    private let availableCameras = AVCaptureDevice.devices(for: .video)
    private var cameraSesion = AVCaptureSession()
    private var selectedDevice: AVCaptureDevice!
    private var previewView: NSView!
    
    var videoDataOutput: AVCaptureVideoDataOutput!
    var videoDataOutputQueue: DispatchQueue!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        for device in self.availableCameras {
            pickerController.addItem(withTitle: device.localizedName)
        }
        
        previewView = NSView(frame: CGRect(x: 0, y: 0, width: NSScreen.main!.frame.width, height: NSScreen.main!.frame.height))

        view.addSubview(previewView)
                
    }
    
    
    private func prepareSessionAndShowPreview() {
        for device in self.availableCameras {
            if device.localizedName == self.pickerController.selectedItem?.title {
                selectedDevice = device
            }
        }
        
        
        do {
            try cameraSesion.addInput(AVCaptureDeviceInput(device: selectedDevice))
        } catch let error {
            print(error.localizedDescription)
        }
        
        videoDataOutput = AVCaptureVideoDataOutput()
        videoDataOutput.alwaysDiscardsLateVideoFrames=true
       
       if cameraSesion.canAddOutput(self.videoDataOutput){
        cameraSesion.addOutput(self.videoDataOutput)
       }

       videoDataOutput.connection(with: .video)?.isEnabled = true

        
        let preview = AVCaptureVideoPreviewLayer(session: cameraSesion)
        preview.videoGravity = .resizeAspectFill
        preview.connection?.automaticallyAdjustsVideoMirroring = false
        preview.connection?.isVideoMirrored = true
        
        previewView.layer = preview
        
        
        if cameraSesion.canSetSessionPreset(.vga640x480) {
            cameraSesion.sessionPreset = .vga640x480
        }
                
        
        cameraSesion.startRunning()
        
    }

    @IBAction func startCameraPressed(_ sender: Any) {
        self.prepareSessionAndShowPreview()
    }
    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

