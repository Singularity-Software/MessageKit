//
//  DocumentMessageSizeCalculator.swift
//  MessageKit
//
//  Created by kelvin lee wei sern on 10/07/2020.
//  Copyright © 2020 MessageKit. All rights reserved.
//

import Foundation

open class DocumentMessageSizeCalculator: MessageSizeCalculator {
    
    public var nameLabelInsets = UIEdgeInsets(top: 7, left: 59, bottom: 7, right: 14)
    public var nameLabelFont = UIFont.preferredFont(forTextStyle: .body)
    public var fileSizeLabelFont = UIFont.preferredFont(forTextStyle: .footnote)

    open override func messageContainerMaxWidth(for message: MessageType) -> CGFloat {
        let maxWidth = super.messageContainerMaxWidth(for: message)
        return maxWidth - nameLabelInsets.horizontal
    }
    
    open override func messageContainerSize(for message: MessageType) -> CGSize {
        let maxWidth = messageContainerMaxWidth(for: message)
        
        var messageContainerSize: CGSize
        let attributedText: NSAttributedString
        let fileSizeAttributedText: NSAttributedString
        
        switch message.kind {
            case .document(let item):
                attributedText = NSAttributedString(string: item.name ?? "", attributes: [.font: nameLabelFont])
				fileSizeAttributedText = NSAttributedString(string: item.info, attributes: [.font: fileSizeLabelFont])
            
            default:
                fatalError("messageContainerSize received unhandled MessageDataType: \(message.kind)")
        }
        
        messageContainerSize = labelSize(for: attributedText, considering: maxWidth)
        let fileContainerSize = labelSize(for: fileSizeAttributedText, considering: maxWidth)
        
        messageContainerSize.width = max(messageContainerSize.width, fileContainerSize.width)
        messageContainerSize.width += nameLabelInsets.horizontal
        messageContainerSize.height += nameLabelInsets.vertical
        messageContainerSize.height += fileContainerSize.height
        messageContainerSize.height += 4
        
        return includeReplyMessageSize(for: message,
                                       forContainerSize: messageContainerSize)
        
    }
    
    open override func configure(attributes: UICollectionViewLayoutAttributes) {
        super.configure(attributes: attributes)
        guard let attributes = attributes as? MessagesCollectionViewLayoutAttributes else { return }
        attributes.messageLabelFont = nameLabelFont
    }
    
}
