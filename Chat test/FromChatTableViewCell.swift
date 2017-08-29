//
//  FromChatTableViewCell.swift
//  Chat test
//
//  Created by Sourav@Beas on 28/08/17.
//  Copyright © 2017 beas. All rights reserved.
//

import UIKit

class FromChatTableViewCell: UITableViewCell {

    @IBOutlet weak var imgChatBubble: UIImageView!
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var txtChat: UITextView!
    @IBOutlet weak var bubblewidth: NSLayoutConstraint!
    @IBOutlet weak var bubbleheight: NSLayoutConstraint!
    @IBOutlet weak var chatTxtHeight: NSLayoutConstraint!
    @IBOutlet weak var chatTxtWidth: NSLayoutConstraint!
    let leftChatBubbleimage = #imageLiteral(resourceName: "ChatIn").resizableImage(withCapInsets: UIEdgeInsetsMake(22, 26, 22, 26)).withRenderingMode(.alwaysTemplate)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imgChatBubble.image = leftChatBubbleimage
        imgChatBubble.tintColor = UIColor.blue
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }

}
