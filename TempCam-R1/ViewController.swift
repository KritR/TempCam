//
//  ViewController.swift
//  Temp Cam
//
//  Created by Krithik Rao on 6/12/15.
//  Copyright (c) 2015 Krithik Rao. All rights reserved.
//
import UIKit
import Photos

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    var photoDictionary: Dictionary<String, Date> = {
        
        if(UserDefaults.standard.object(forKey: "photoDict") != nil){
            return UserDefaults.standard.object(forKey: "photoDict") as! Dictionary<String, NSDate> as [String : Date]
        }else{
            return Dictionary<String,Date>()
        }
    }()
    
    
    static let howManyButtons: Int = 6
    var buttonSeries:[TimeButton] = []
    static let screenWidth = UIScreen.main.bounds.width
    static let screenHeight = UIScreen.main.bounds.height
    var orientation : UIInterfaceOrientation = UIInterfaceOrientation.portrait
    static let btnGridHeight: Int = Int(screenHeight) - 128
    static let btnGridWidth: Int = Int(screenWidth) - 40
    static let sizeModifier = 0.9
    
    static var gridBoxDimension: Int = {
        if((btnGridWidth/2)*(ViewController.howManyButtons/2) > btnGridHeight){
            return btnGridHeight / 3
        }else{
            return btnGridWidth/2
        }
        
    }()
    static let buttonDimension = Double(gridBoxDimension) * sizeModifier
    static let gridHGap: Double = ((Double(btnGridWidth)/2) - buttonDimension)/2
    
    static let gridVGap: Double = ((Double(btnGridHeight)/3) - buttonDimension)/2
    
    override func viewDidLoad() {
        
        
        
        for _ in 0..<ViewController.howManyButtons {
            //let originX = CGFloat(0.5 - ViewController.sizeModifier)/2
            let button = TimeButton(frame:CGRect(x: 0,y: 0, width: CGFloat(ViewController.buttonDimension), height: CGFloat(ViewController.buttonDimension)))
            //var row: Int = index
            
            
            button.backgroundColor = UIColor.white
            button.layer.shadowColor = UIColor.black.cgColor
            //button.layer.shadowOffset = CGSizeMake( 0, 0)
            button.layer.shadowRadius = 1
            button.layer.shadowOpacity = 0.3
            button.setTitleColor(UIColor.black, for: .normal)
            button.titleLabel?.font = UIFont(name: "Helvetica Neue", size: 14)
            button.setTitleColor(UIColor.gray, for: .highlighted)
            button.addTarget(self, action: #selector(ViewController.buttonAction(_:)), for: UIControlEvents.touchUpInside)
            
            buttonSeries.append(button)
        }
        updateButtonPositions()
        for btn in buttonSeries{
            view.addSubview(btn)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
        updateButtonPositions()
    }
    /*
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        updateButtonPositions()
    }
    */
    
    
    func updateButtonPositions(){
        orientation = UIApplication.shared.statusBarOrientation
        
        for btn in 0..<ViewController.howManyButtons {
            let btnX: CGFloat
            let btnY: CGFloat
            var column = 1
            var row = btn
            
            if(btn%2==1){
                row -= 1
                column = 0
            }
            if(btn>1){
                row = row / 2
            }
            let gridHIncrement = CGFloat(ViewController.btnGridWidth/2) * CGFloat(column) + CGFloat(ViewController.gridHGap)
            let gridYIncrement = CGFloat(ViewController.btnGridHeight/3) * CGFloat(row) + CGFloat(ViewController.gridVGap)
            
            btnX = CGFloat(gridHIncrement)+20
            
            btnY = CGFloat(gridYIncrement)+76
            
            switch orientation{
            case UIInterfaceOrientation.portrait, UIInterfaceOrientation.portraitUpsideDown:
                buttonSeries[btn].frame.origin.x = btnX
                buttonSeries[btn].frame.origin.y = btnY
            case UIInterfaceOrientation.landscapeLeft, UIInterfaceOrientation.landscapeRight:
                buttonSeries[btn].frame.origin.x = btnY
                buttonSeries[btn].frame.origin.y = btnX
            default:
                buttonSeries[btn].frame.origin.x = btnX
                buttonSeries[btn].frame.origin.y = btnY
            }
        }
    }
    
    func buttonAction(_ sender:TimeButton){
        if(TimeButton.isEditable){
            showEditDialogue(sender)
        }else{
            showCameraView(sender)
        }
    }
    
    @IBOutlet weak var UIEditButton: UIBarButtonItem!
    
    @IBAction func EditAction(_ sender: UIBarButtonItem) {
        if(sender.title == "Edit"){
            TimeButton.toggleEditMode(buttonSeries)
            sender.title = "Done"
        }else{
            TimeButton.toggleEditMode(buttonSeries)
            sender.title = "Edit"
        }
    }
    
    func showEditDialogue(_ sender: TimeButton){
    }
    
    var pictureTime : Date = Date()
    
    func showCameraView(_ sender: TimeButton){
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        if(UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)){
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera
        }else{
            imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        }
        
        pictureTime = sender.time.getTimeFromNow()
        self.present(imagePicker, animated: true, completion: nil)
        
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String: Any]) {
        self.dismiss(animated: true, completion: nil)
        saveImage(info[UIImagePickerControllerOriginalImage] as! UIImage)
        
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func saveImage(_ image: UIImage){
        
        var id : String!
        
        PHPhotoLibrary.shared().performChanges({
            
            let creationReq = PHAssetChangeRequest.creationRequestForAsset(from: image)
            
            let assetPlaceholder : PHObjectPlaceholder = creationReq.placeholderForCreatedAsset!
            
            id = assetPlaceholder.localIdentifier
            
        }, completionHandler: {
            success, error in
            NSLog("Finished creating Asset")
            print(id)
            self.photoDictionary.updateValue((self.pictureTime as NSDate) as Date, forKey: id)
            self.updatePDData()
        })
        
        
    }
    
    func updatePDData(){
        UserDefaults.standard.removeObject(forKey: "photoDict")
        UserDefaults.standard.set(photoDictionary as Dictionary<String,NSDate>, forKey: "photoDict")
        
    }
    
    
}

