//
//  NoteViewController.swift
//  Demo
//
//  Created by 黄人煌 on 15/12/28.
//  Copyright © 2015年 Fjnu. All rights reserved.
//

import UIKit

class NoteViewController: BaseViewController {

    @IBOutlet weak var selectButton: UIButton!
    @IBOutlet weak var placeHolderLabel: UILabel!
    @IBOutlet weak var numLabel: UILabel!
    @IBOutlet weak var textView: UITextView!
    
    var delegate: HRHDataPickViewDelegate!
    var noteString: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.delegate = self
        textView.returnKeyType = UIReturnKeyType.Done
        placeHolderLabel.hidden = !textView.text.isEmpty
        if noteString != nil {
            textView.text = noteString
        }
        self.title = "填写备注"
        selectButton.layer.masksToBounds = true
        selectButton.layer.cornerRadius = 8
    }
}


extension NoteViewController: UITextViewDelegate{
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if(range.location >= 50){
            return false
        }
        return true
    }
    func textViewDidChange(textView: UITextView) {
        placeHolderLabel.hidden = !textView.text.isEmpty
        numLabel.text = "\(textView.text.characters.count)/50"
    }
    @IBAction func addNoteButtonAction(sender: AnyObject) {
        delegate.selectButtonClick(textView.text, DataType: 2)
        self.navigationController?.popViewControllerAnimated(true)
    }
}