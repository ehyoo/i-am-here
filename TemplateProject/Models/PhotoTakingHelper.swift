//
//  PhotoTakingHelper.swift
//  i_am_here
//
//  Created by Edward Yoo on 7/29/15.
//  Copyright (c) 2015 Make School. All rights reserved.
//

import Foundation
import UIKit

typealias PhotoTakingHelperCallback = UIImage? -> Void

class PhotoTakingHelper: NSObject {
    weak var viewController: UIViewController!
    var callback: PhotoTakingHelperCallback
    var imagePickerController: UIImagePickerController?
    
    init (viewController: UIViewController, callback: PhotoTakingHelperCallback) {
        self.viewController = viewController
        self.callback = callback
        
        super.init()
        
        showPhotoSourceSelection()
    }
    
    func showPhotoSourceSelection() {
        let alertController = UIAlertController(title: nil, message: "Select a photo from the following:", preferredStyle: .ActionSheet)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        //picks photo from taking picture from Camera
        if UIImagePickerController.isCameraDeviceAvailable(.Rear) {
            let cameraAction = UIAlertAction(title: "From Camera", style: .Default) { (action) in
                self.showImagePickerController(.Camera)
            }
            alertController.addAction(cameraAction)
        }
        
        //picks photo from Gallery
        let photoLibraryAction = UIAlertAction(title: "From Gallery", style: .Default) { (action) in
            self.showImagePickerController(.PhotoLibrary)
        }
        
        alertController.addAction(photoLibraryAction)
        
        viewController.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func showImagePickerController(sourceType: UIImagePickerControllerSourceType) {
        imagePickerController = UIImagePickerController()
        imagePickerController!.sourceType = sourceType
        imagePickerController!.delegate = self
        
        self.viewController.presentViewController(imagePickerController!, animated: true, completion: nil)
    }
    
}

extension PhotoTakingHelper: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        viewController.dismissViewControllerAnimated(false, completion: nil)
        
        callback(image)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        viewController.dismissViewControllerAnimated(true, completion: nil)
    }
    
}