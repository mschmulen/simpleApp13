//
//  CameraViewRepresentable.swift
//  SimpleApp
//
//  Created by Matthew Schmulen on 8/5/20.
//  Copyright © 2020 jumptack. All rights reserved.
//

import SwiftUI
import AVFoundation

struct CameraViewRepresentable : UIViewControllerRepresentable {
    
    @Binding var isShown: Bool
    @Binding var image: Image?
    
//    enum CameraControllerError: Swift.Error {
//       case captureSessionAlreadyRunning
//       case captureSessionIsMissing
//       case inputsAreInvalid
//       case invalidOperation
//       case noCamerasAvailable
//       case unknown
//    }
//
//    var captureSession: AVCaptureSession?
//    var frontCamera: AVCaptureDevice?
//    var frontCameraInput: AVCaptureDeviceInput?
//    var previewLayer: AVCaptureVideoPreviewLayer?
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<CameraViewRepresentable>) -> UIViewController {
        let controller = CameraViewController()
        
//        let captureSession = AVCaptureSession()
//        captureSession.sessionPreset = .photo
        
//        guard let captureDevice = AVCaptureDevice.default(for: .video) else { return view}
//        guard let input = try? AVCaptureDeviceInput(device: captureDevice) else { return view}
//        captureSession.addInput(input)
//
//        captureSession.startRunning()
//
//        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
//        view.layer.addSublayer(previewLayer)
//        previewLayer.frame = view.frame

        
        return controller
    }
    
    func updateUIViewController(_ uiViewController: CameraViewRepresentable.UIViewControllerType, context: UIViewControllerRepresentableContext<CameraViewRepresentable>) {
    }
}

class CameraViewController : UIViewController {
    
    private var avCaptureSession: AVCaptureSession?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCamera()
    }
    
    func loadCamera() {
        avCaptureSession = AVCaptureSession()
        
        guard let avCaptureSession = avCaptureSession else {
            print( "error avCaptureSession")
            return
        }
        guard let captureDevice = AVCaptureDevice.default(for: .video) else {
            print( "error captureDevice")
            return
        }
        guard let input = try? AVCaptureDeviceInput(device : captureDevice) else {
            print( "error input")
            return
        }
        
        //avCaptureSession.sessionPreset = .photo
        
        avCaptureSession.addInput(input)
        avCaptureSession.startRunning()
        
        let cameraPreview = AVCaptureVideoPreviewLayer(session: avCaptureSession)
        view.layer.addSublayer(cameraPreview)
        cameraPreview.frame = view.frame
    }
    
    
    //    init() {
    //        super.init(frame: .zero)
    //
    //        var allowedAccess = false
    //        let blocker = DispatchGroup()
    //        blocker.enter()
    //        AVCaptureDevice.requestAccess(for: .video) { flag in
    //            allowedAccess = flag
    //            blocker.leave()
    //        }
    //        blocker.wait()
    //
    //        if !allowedAccess {
    //            print("!!! NO ACCESS TO CAMERA")
    //            return
    //        }
    //
    //        // setup session
    //        let session = AVCaptureSession()
    //        session.beginConfiguration()
    //
    //        let videoDevice = AVCaptureDevice.default(.builtInWideAngleCamera,
    //            for: .video, position: .unspecified) //alternate AVCaptureDevice.default(for: .video)
    //        guard videoDevice != nil, let videoDeviceInput = try? AVCaptureDeviceInput(device: videoDevice!), session.canAddInput(videoDeviceInput) else {
    //            print("!!! NO CAMERA DETECTED")
    //            return
    //        }
    //        session.addInput(videoDeviceInput)
    //        session.commitConfiguration()
    //        self.captureSession = session
    //    }
    //
    //    override class var layerClass: AnyClass {
    //        AVCaptureVideoPreviewLayer.self
    //    }
    //
    //    required init?(coder: NSCoder) {
    //        fatalError("init(coder:) has not been implemented")
    //    }
    //
    //    var videoPreviewLayer: AVCaptureVideoPreviewLayer {
    //        return layer as! AVCaptureVideoPreviewLayer
    //    }
    //
    //    override func didMoveToSuperview() {
    //        super.didMoveToSuperview()
    //
    //        if nil != self.superview {
    //            self.videoPreviewLayer.session = self.captureSession
    //            self.videoPreviewLayer.videoGravity = .resizeAspect
    //            self.captureSession?.startRunning()
    //        } else {
    //            self.captureSession?.stopRunning()
    //        }
    //    }
}






// CaptureImageView
//struct CameraView {
//
//  /// MARK: - Properties
//  @Binding var isShown: Bool
//  @Binding var image: Image?
//
//  func makeCoordinator() -> CameraCoordinator {
//    return CameraCoordinator(isShown: $isShown, image: $image)
//  }
//}
//
//extension CameraView: UIViewControllerRepresentable {
//  func makeUIViewController(context: UIViewControllerRepresentableContext<CameraView>) -> UIImagePickerController {
//    let picker = UIImagePickerController()
//    picker.delegate = context.coordinator
//    /// Default is images gallery. Un-comment the next line of code if you would like to test camera
////    picker.sourceType = .camera
//    return picker
//  }
//
//  func updateUIViewController(_ uiViewController: UIImagePickerController,
//                              context: UIViewControllerRepresentableContext<CameraView>) {
//
//  }
//}
//
//class CameraCoordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
//
//    @Binding var isCoordinatorShown: Bool
//    @Binding var imageInCoordinator: Image?
//
//    init(isShown: Binding<Bool>, image: Binding<Image?>) {
//        _isCoordinatorShown = isShown
//        _imageInCoordinator = image
//    }
//
//    func imagePickerController(_ picker: UIImagePickerController,
//                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//        guard let unwrapImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
//        imageInCoordinator = Image(uiImage: unwrapImage)
//        isCoordinatorShown = false
//    }
//
//    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
//        isCoordinatorShown = false
//    }
//}

