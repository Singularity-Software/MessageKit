//
//  DocumentMessageCell.swift
//  MessageKit
//
//  Created by kelvin lee wei sern on 10/07/2020.
//  Copyright © 2020 MessageKit. All rights reserved.
//

import UIKit

open class DocumentMessageCell: MessageContentCell {
    
    public lazy var documentIcon: UIImageView = {
        let iv = UIImageView()
        
        if #available(iOS 13.0, *) {
			let config: UIImage.SymbolConfiguration = .init(font: .systemFont(ofSize: 20))
			iv.image = UIImage(systemName: "doc.fill", withConfiguration: config)
        }
        
        iv.tintColor = .labelColor
        iv.contentMode = .center
        iv.backgroundColor = .backgroundColor
        
        return iv
    }()
    
    /// The label that display file name
    public lazy var nameLabel: UILabel = {
        let nameLabel = UILabel(frame: CGRect.zero)
        nameLabel.numberOfLines = 0
        return nameLabel
    }()
    
    public lazy var sizeLabel: UILabel = {
        let sizeLabel = UILabel(frame: CGRect.zero)
        sizeLabel.numberOfLines = 1
        return sizeLabel
    }()
    
    // MARK: - Methods
    open override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)
        guard let attributes = layoutAttributes as? MessagesCollectionViewLayoutAttributes else {
            return
        }
        
        nameLabel.font = attributes.messageLabelFont
        sizeLabel.font = UIFont.preferredFont(forTextStyle: .footnote)
    }
    
    open override func setupSubviews() {
        super.setupSubviews()
        messageContainerView.addSubview(documentIcon)
        messageContainerView.addSubview(nameLabel)
        messageContainerView.addSubview(sizeLabel)
        setupConstraints()
    }
    
    open override func prepareForReuse() {
        super.prepareForReuse()
        nameLabel.text = ""
        sizeLabel.text = ""
    }
    
    open func setupConstraints() {
        documentIcon.constraint(equalTo: CGSize(width: 35, height: 35))
        
        documentIcon.addConstraints(messageContainerView.topAnchor,
                                    left: messageContainerView.leftAnchor,
                                    topConstant: 7,
                                    leftConstant: 14)
        
        documentIcon.layer.cornerRadius = 35 / 2
    
        nameLabel.addConstraints(messageContainerView.topAnchor,
                                 left: documentIcon.rightAnchor,
                                 bottom: sizeLabel.topAnchor,
                                 right: messageContainerView.rightAnchor,
                                 topConstant: 7,
                                 leftConstant: 10,
                                 bottomConstant: 4,
                                 rightConstant: 14)
        
        sizeLabel.addConstraints(left: documentIcon.rightAnchor,
                                 bottom: messageContainerView.bottomAnchor,
                                 right: messageContainerView.rightAnchor,
                                 leftConstant: 10,
                                 bottomConstant: 7,
                                 rightConstant: 14)
    }
    
    open override func configure(with message: MessageType, at indexPath: IndexPath, and messagesCollectionView: MessagesCollectionView) {
        super.configure(with: message, at: indexPath, and: messagesCollectionView)

        guard case let .document(documentItem) = message.kind else { fatalError("Failed decorate document cell") }
        
        nameLabel.text = documentItem.name
        sizeLabel.text = documentItem.info
        
        guard let displayDelegate = messagesCollectionView.messagesDisplayDelegate else {
            fatalError(MessageKitError.nilMessagesDisplayDelegate)
        }
        
        let textColor = displayDelegate.textColor(for: message, at: indexPath, in: messagesCollectionView)
        let subtitleTextColor = displayDelegate.subtitleTextColor(for: message, at: indexPath, in: messagesCollectionView)

        nameLabel.textColor = textColor
        sizeLabel.textColor = subtitleTextColor
		
		displayDelegate.configureDocumentMessageIcon(documentIcon, for: message, at: indexPath, in: messagesCollectionView)
    }
}
