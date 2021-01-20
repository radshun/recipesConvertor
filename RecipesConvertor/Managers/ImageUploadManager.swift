//
//  ImageUploadManager.swift
//  RecipesConvertor
//
//  Created by Daniel Radshun on 18/01/2021.
//

import UIKit
import AVFoundation

protocol ImageUploadManagerDelegate {
    func imageWasPicked(image: UIImage?)
}

class ImageUploadManager: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var imagePicker: UIImagePickerController!
    var delegate: ImageUploadManagerDelegate?
    
    init(delegate: ImageUploadManagerDelegate) {
        super.init()
        self.delegate = delegate
        self.imagePicker = UIImagePickerController()
        self.imagePicker.delegate = self
    }
    
    private func checkForCameraPermissions(comepltion: @escaping (Bool) -> ()) {
        AVCaptureDevice.requestAccess(for: AVMediaType.video) { accessGranted in
            DispatchQueue.main.async {
                if !accessGranted {
                    (UIApplication.topViewController() as? BaseViewController)?.displayAlert(with: "אין הרשאה", message: "בכדי לצלם תמונה יש לאשר את ההרשאות למצלמה", okayTitle: "הגדרות", completion: { isSettings in
                        if isSettings {
                            DispatchQueue.main.async {
                                guard let settingsUrl = URL(string: UIApplication.openSettingsURLString),
                                      UIApplication.shared.canOpenURL(settingsUrl) else {return}
                                UIApplication.shared.open(settingsUrl)
                            }
                        }
                    })
                    comepltion(false)
                } else {
                    comepltion(true)
                }
            }
        }
    }
    
    internal func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imagePicker.dismiss(animated: true, completion: nil)
        let cameraImage = (info[UIImagePickerController.InfoKey.originalImage] as? UIImage)?.fixOrientation()
        self.delegate?.imageWasPicked(image: cameraImage)
    }
    
    func openCamera() {
        self.checkForCameraPermissions { [unowned self] isGranted in
            if isGranted {
                imagePicker.sourceType = .camera
                UIApplication.topViewController()?.present(imagePicker, animated: true, completion: nil)
            } else {
                self.delegate?.imageWasPicked(image: nil)
            }
        }
    }
    
    func openGallery() {
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
            imagePicker.sourceType = .savedPhotosAlbum
            imagePicker.allowsEditing = false
            UIApplication.topViewController()?.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func showOptions() {
        let cameraAction = UIAlertAction(title: "מצלמה", style: .default) { _ in
            self.openCamera()
        }
        let galeryAction = UIAlertAction(title: "גלריה", style: .default) { _ in
            self.openGallery()
        }
        (UIApplication.topViewController() as? BaseViewController)?.displaySheetAlert(with: "", message: "בחרו מאיפה להוסיף את התמונה", customActions: [cameraAction, galeryAction], completion: { _ in
            self.delegate?.imageWasPicked(image: nil)
        })
    }
}

fileprivate extension UIImage {
    func fixOrientation() -> UIImage {
        if (self.imageOrientation == .up) {
            return self
        }
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        let rect = CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height)
        self.draw(in: rect)
        let normalizedImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return normalizedImage
    }
}
