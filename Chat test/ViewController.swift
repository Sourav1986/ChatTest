//
//  ViewController.swift
//  Chat test
//
//  Created by Sourav@Beas on 28/08/17.
//  Copyright © 2017 beas. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    
    @IBOutlet weak var txtInputField: UITextField!
    @IBOutlet weak var btnSendMessage: UIButton!
    @IBOutlet weak var tblChat: UITableView!
    @IBOutlet weak var inputFieldView: UIView!
    @IBOutlet weak var inputViewButtom: NSLayoutConstraint!
    var chatArray = [Messages]()
    var selfUser:Users?
    var otherUser:Users?
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tblChat.estimatedRowHeight = 69.0
        tblChat.rowHeight = UITableViewAutomaticDimension
 
        do {
            try CheckAndCreateUsers()
        } catch  {
            print(error.localizedDescription)
        }
        
       // chatArray = [["type":"1","msg":"Hi,how are you?"],["type":"0","msg":"Fine!"]]
        do {
            try fetchMessage()
        } catch  {
            print(error.localizedDescription)
        }
        
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
                    if self.chatArray.count > 0 {
                        let lastItem = self.chatArray.count - 1
                        let indexPath = IndexPath(item: lastItem, section: 0)
                        self.tblChat.scrollToRow(at: indexPath, at: .bottom, animated: true)
                    }
                   
                }
            })

        }
    }
    
    func CheckAndCreateUsers() throws {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return  }
        let manageedObjectContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequestforself = NSFetchRequest<NSFetchRequestResult>(entityName: "Users")
        fetchRequestforself.predicate = NSPredicate(format: "username == %@", "me@chat")
        
        let users = try manageedObjectContext.fetch(fetchRequestforself) as! [Users]
        
        if users.count == 0 {
            let entity = NSEntityDescription.entity(forEntityName: "Users", in: manageedObjectContext)
            let newRecord = Users(entity: entity!, insertInto: manageedObjectContext)
            newRecord.name = "Sourav"
            newRecord.password = "abcd"
            newRecord.username = "me@chat"
            try manageedObjectContext.save()
            
        }
        else{
            selfUser = users.last
        }
        
        let fetchRequestforothers = NSFetchRequest<NSFetchRequestResult>(entityName: "Users")
        fetchRequestforothers.predicate = NSPredicate(format: "username == %@", "other@chat")
        
        let others = try manageedObjectContext.fetch(fetchRequestforself) as! [Users]
        
        if others.count == 0 {
            let entity = NSEntityDescription.entity(forEntityName: "Users", in: manageedObjectContext)
            let newRecord = Users(entity: entity!, insertInto: manageedObjectContext)
            newRecord.name = "Anna"
            newRecord.password = "abcd"
            newRecord.username = "other@chat"
            try manageedObjectContext.save()
            
        }
        else{
            otherUser = others.last
        }


    }
    
    
    @IBAction func sendMsg(_ sender: Any) {
        guard let message = txtInputField.text,message.characters.count > 0 else {
            shakeAnimation(view: txtInputField)
            return
        }
        
        do {
            try SaveMessage(msgString: message)
        } catch  {
            print(error.localizedDescription)
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func SaveMessage(msgString:String) throws {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return  }
        let manageedObjectContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Messages")
        
        let messages = try manageedObjectContext.fetch(fetchRequest) as! [Messages]
        
        let entity = NSEntityDescription.entity(forEntityName: "Messages", in: manageedObjectContext)
        let newRecord = Messages(entity: entity!, insertInto: manageedObjectContext)
        
        var messageid = "msg\(1)"
        if messages.count > 0 {
            if let lastobject = messages.last {
                if let index = messages.index(of: lastobject) {
                    messageid = "msg\(index + 1)"
                }
                
            }

        }
        newRecord.msgid = messageid
        newRecord.msg = msgString
        if let me = selfUser {
            newRecord.message = me
        }
        newRecord.type = 0
        try manageedObjectContext.save()
        try fetchMessage()
    }
    
    func fetchMessage() throws {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return  }
        let manageContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Messages")
        
        let messages = try manageContext.fetch(fetchRequest) as! [Messages]
        if messages.count > 0 {
            chatArray = messages
        }
        tblChat.reloadData()
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
        let chatType = chatData.type
        if chatType == 1 {
            let cellType1 = tableView.dequeueReusableCell(withIdentifier: "fromcell", for: indexPath) as! FromChatTableViewCell
            let chatString = chatData.msg ?? ""
            
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
            let chatString = chatData.msg ?? ""
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

