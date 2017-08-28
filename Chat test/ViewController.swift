//
//  ViewController.swift
//  Chat test
//
//  Created by Sourav@Beas on 28/08/17.
//  Copyright © 2017 beas. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    
    @IBOutlet weak var txtInputField: UITextField!
    @IBOutlet weak var btnSendMessage: UIButton!
    @IBOutlet weak var tblChat: UITableView!
    @IBOutlet weak var inputFieldView: UIView!
    @IBOutlet weak var inputViewButtom: NSLayoutConstraint!
    
    var chatArray = [[AnyHashable:Any]]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tblChat.estimatedRowHeight = 69.0
        tblChat.rowHeight = UITableViewAutomaticDimension
        
        chatArray = [["type":"1","msg":"Hi,how are you?"],["type":"0","msg":"Fine!"]]
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboard(sender:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboard(sender:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func handleKeyboard(sender:NSNotification) {
        if let userInfo = sender.userInfo {
            let keyboardFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as AnyObject).cgRectValue
            let isKeybaordShowing = sender.name == NSNotification.Name.UIKeyboardWillShow
            inputViewButtom.constant = isKeybaordShowing ?  (keyboardFrame?.height)! : 0
            UIView.animate(withDuration: 0, delay: 0, options: .curveEaseOut, animations: {
                self.view.layoutIfNeeded()
            }, completion: { (completed) in
                if (isKeybaordShowing){
                    let lastItem = self.chatArray.count - 1
                    let indexPath = IndexPath(item: lastItem, section: 0)
                    self.tblChat.selectRow(at: indexPath, animated: true, scrollPosition: .bottom)
                }
            })

        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

extension ViewController:UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return chatArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let chatData = chatArray[indexPath.row]
        let chatType = chatData["type"] as? String ?? ""
        if chatType == "1" {
            let cellType1 = tableView.dequeueReusableCell(withIdentifier: "fromcell", for: indexPath) as! FromChatTableViewCell
            let chatString = chatData["msg"] as? String ?? ""
            
            let size = CGSize(width: 250, height: 1000)
            let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
            let estimatedFrame = NSString(string: chatString).boundingRect(with: size, options: options, attributes: [NSFontAttributeName:UIFont.systemFont(ofSize: 18)], context: nil)
            cellType1.txtChat.text = chatString
            cellType1.chatTxtWidth.constant = estimatedFrame.width + 16
            cellType1.chatTxtHeight.constant = estimatedFrame.height + 20
            cellType1.bubbleheight.constant = estimatedFrame.height + 26
            cellType1.bubblewidth.constant = estimatedFrame.width + 40
            cellType1.imgProfile.image = #imageLiteral(resourceName: "User1")
            return cellType1
        }
        else{
            let cellType2 = tableView.dequeueReusableCell(withIdentifier: "tocell", for: indexPath) as! ToChatTableViewCell
            let chatString = chatData["msg"] as? String ?? ""
            let size = CGSize(width: 250, height: 1000)
            let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
            let estimatedFrame = NSString(string: chatString).boundingRect(with: size, options: options, attributes: [NSFontAttributeName:UIFont.systemFont(ofSize: 18)], context: nil)
            cellType2.txtChat.text = chatString
            cellType2.chatTxtWidth.constant = estimatedFrame.width + 16
            cellType2.chatTxtHeight.constant = estimatedFrame.height + 20
            cellType2.chatbubbleHeight.constant = estimatedFrame.height + 26
            cellType2.chatbubbleWidth.constant = estimatedFrame.width + 40
            cellType2.imgProfile.image = #imageLiteral(resourceName: "User2")
            
            return cellType2

        }
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
}

