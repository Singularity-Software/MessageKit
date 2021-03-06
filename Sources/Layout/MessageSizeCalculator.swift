/*
 MIT License

 Copyright (c) 2017-2019 MessageKit

 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:

 The above copyright notice and this permission notice shall be included in all
 copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 SOFTWARE.
 */

import Foundation

open class MessageSizeCalculator: CellSizeCalculator {

    public init(layout: MessagesCollectionViewFlowLayout? = nil) {
        super.init()
        
        self.layout = layout
    }

	public var forwardedMessageIndicatorAlignment = LabelAlignment(textAlignment: .left, textInsets: UIEdgeInsets(top: 7, left: 14, bottom: 0, right: 14))
	public var forwardedMessageIndicatorSize = CGSize.zero
	
	public var supplementalMessagePadding: CGFloat = 2
	public var supplementalIndicatorWidth: CGFloat = 5
	public var supplementalIndicatorDistanceToMessage: CGFloat = 4
	public var supplementalMessageInsets = UIEdgeInsets(top: 7, left: 14, bottom: 0, right: 14)
	
    public var incomingAvatarSize = CGSize(width: 30, height: 30)
    public var outgoingAvatarSize = CGSize(width: 30, height: 30)

    public var incomingAvatarPosition = AvatarPosition(vertical: .cellBottom)
    public var outgoingAvatarPosition = AvatarPosition(vertical: .cellBottom)

    public var avatarLeadingPadding: CGFloat = 0
	public var avatarTrailingPadding: CGFloat = 0

    public var incomingMessagePadding = UIEdgeInsets(top: 0, left: 4, bottom: 0, right: 30)
    public var outgoingMessagePadding = UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 4)

    public var incomingCellTopLabelAlignment = LabelAlignment(textAlignment: .center, textInsets: .zero)
    public var outgoingCellTopLabelAlignment = LabelAlignment(textAlignment: .center, textInsets: .zero)
    
    public var incomingCellBottomLabelAlignment = LabelAlignment(textAlignment: .left, textInsets: UIEdgeInsets(left: 42))
    public var outgoingCellBottomLabelAlignment = LabelAlignment(textAlignment: .right, textInsets: UIEdgeInsets(right: 42))

    public var incomingMessageTopLabelAlignment = LabelAlignment(textAlignment: .left, textInsets: UIEdgeInsets(left: 42))
    public var outgoingMessageTopLabelAlignment = LabelAlignment(textAlignment: .right, textInsets: UIEdgeInsets(right: 42))

    public var incomingMessageBottomLabelAlignment = LabelAlignment(textAlignment: .left, textInsets: UIEdgeInsets(left: 42))
    public var outgoingMessageBottomLabelAlignment = LabelAlignment(textAlignment: .right, textInsets: UIEdgeInsets(right: 42))

    public var incomingAccessoryViewSize = CGSize.zero
    public var outgoingAccessoryViewSize = CGSize.zero

    public var incomingAccessoryViewPadding = HorizontalEdgeInsets.zero
    public var outgoingAccessoryViewPadding = HorizontalEdgeInsets.zero
    
    public var incomingAccessoryViewPosition: AccessoryPosition = .messageCenter
    public var outgoingAccessoryViewPosition: AccessoryPosition = .messageCenter

    open override func configure(attributes: UICollectionViewLayoutAttributes) {
        guard let attributes = attributes as? MessagesCollectionViewLayoutAttributes else { return }

        let dataSource = messagesLayout.messagesDataSource
        let indexPath = attributes.indexPath
        let message = dataSource.messageForItem(at: indexPath, in: messagesLayout.messagesCollectionView)
		let replySize = supplementalMessageViewSize(for: message)
		
		attributes.forwardedMessageIndicatorSize = forwardedMessageIndicatorViewSize(for: message)
		attributes.forwardedMessageIndicatorAlignment = forwardedMessageIndicatorAlignment
		
		attributes.replyMessageViewSize = replySize.2
		attributes.replyMessagePadding = supplementalMessagePadding
		attributes.replyMessageIndicatorWidth = supplementalIndicatorWidth
		attributes.replyMessageDistanceToIndicator = supplementalIndicatorDistanceToMessage
		attributes.replyMessageTitleHeight = replySize.0
		attributes.replyMessageDescHeight = replySize.1
		attributes.replyMessageInsets = supplementalMessageInsets

        attributes.avatarSize = avatarSize(for: message)
        attributes.avatarPosition = avatarPosition(for: message)
        attributes.avatarLeadingPadding = avatarLeadingPadding
		attributes.avatarTrailingPadding = avatarTrailingPadding

        attributes.messageContainerPadding = messageContainerPadding(for: message)
        attributes.messageContainerSize = messageContainerSize(for: message)
        attributes.cellTopLabelSize = cellTopLabelSize(for: message, at: indexPath)
        attributes.cellTopLabelAlignment = cellTopLabelAlignment(for: message)
        attributes.cellBottomLabelSize = cellBottomLabelSize(for: message, at: indexPath)
        attributes.cellBottomLabelAlignment = cellBottomLabelAlignment(for: message)
        attributes.messageTopLabelSize = messageTopLabelSize(for: message, at: indexPath)
        attributes.messageTopLabelAlignment = messageTopLabelAlignment(for: message)

        attributes.messageBottomLabelAlignment = messageBottomLabelAlignment(for: message)
        attributes.messageBottomLabelSize = messageBottomLabelSize(for: message, at: indexPath)

        attributes.accessoryViewSize = accessoryViewSize(for: message)
        attributes.accessoryViewPadding = accessoryViewPadding(for: message)
        attributes.accessoryViewPosition = accessoryViewPosition(for: message)
    }

    open override func sizeForItem(at indexPath: IndexPath) -> CGSize {
        let dataSource = messagesLayout.messagesDataSource
        let message = dataSource.messageForItem(at: indexPath, in: messagesLayout.messagesCollectionView)
        let itemHeight = cellContentHeight(for: message, at: indexPath)
        return CGSize(width: messagesLayout.itemWidth, height: itemHeight)
    }

    open func cellContentHeight(for message: MessageType, at indexPath: IndexPath) -> CGFloat {

        let messageContainerHeight = messageContainerSize(for: message).height
        let cellBottomLabelHeight = cellBottomLabelSize(for: message, at: indexPath).height
        let messageBottomLabelHeight = messageBottomLabelSize(for: message, at: indexPath).height
        let cellTopLabelHeight = cellTopLabelSize(for: message, at: indexPath).height
        let messageTopLabelHeight = messageTopLabelSize(for: message, at: indexPath).height
        let messageVerticalPadding = messageContainerPadding(for: message).vertical
        let avatarHeight = avatarSize(for: message).height
        let avatarVerticalPosition = avatarPosition(for: message).vertical
        let accessoryViewHeight = accessoryViewSize(for: message).height

        switch avatarVerticalPosition {
        case .messageCenter:
            let totalLabelHeight: CGFloat = cellTopLabelHeight + messageTopLabelHeight
                + messageContainerHeight + messageVerticalPadding + messageBottomLabelHeight + cellBottomLabelHeight
            let cellHeight = max(avatarHeight, totalLabelHeight)
            return max(cellHeight, accessoryViewHeight)
        case .messageBottom:
            var cellHeight: CGFloat = 0
            cellHeight += messageBottomLabelHeight
            cellHeight += cellBottomLabelHeight
            let labelsHeight = messageContainerHeight + messageVerticalPadding + cellTopLabelHeight + messageTopLabelHeight
            cellHeight += max(labelsHeight, avatarHeight)
            return max(cellHeight, accessoryViewHeight)
        case .messageTop:
            var cellHeight: CGFloat = 0
            cellHeight += cellTopLabelHeight
            cellHeight += messageTopLabelHeight
            let labelsHeight = messageContainerHeight + messageVerticalPadding + messageBottomLabelHeight + cellBottomLabelHeight
            cellHeight += max(labelsHeight, avatarHeight)
            return max(cellHeight, accessoryViewHeight)
        case .messageLabelTop:
            var cellHeight: CGFloat = 0
            cellHeight += cellTopLabelHeight
            let messageLabelsHeight = messageContainerHeight + messageBottomLabelHeight + messageVerticalPadding + messageTopLabelHeight + cellBottomLabelHeight
            cellHeight += max(messageLabelsHeight, avatarHeight)
            return max(cellHeight, accessoryViewHeight)
        case .cellTop, .cellBottom:
            let totalLabelHeight: CGFloat = cellTopLabelHeight + messageTopLabelHeight
                + messageContainerHeight + messageVerticalPadding + messageBottomLabelHeight + cellBottomLabelHeight
            let cellHeight = max(avatarHeight, totalLabelHeight)
            return max(cellHeight, accessoryViewHeight)
        }
    }

    // MARK: - Avatar

    open func avatarPosition(for message: MessageType) -> AvatarPosition {
        let dataSource = messagesLayout.messagesDataSource
        let isFromCurrentSender = dataSource.isFromCurrentSender(message: message)
        var position = isFromCurrentSender ? outgoingAvatarPosition : incomingAvatarPosition

        switch position.horizontal {
        case .cellTrailing, .cellLeading:
            break
        case .natural:
            position.horizontal = isFromCurrentSender ? .cellTrailing : .cellLeading
        }
        return position
    }

    open func avatarSize(for message: MessageType) -> CGSize {
        let dataSource = messagesLayout.messagesDataSource
        let isFromCurrentSender = dataSource.isFromCurrentSender(message: message)
        return isFromCurrentSender ? outgoingAvatarSize : incomingAvatarSize
    }

    // MARK: - Top cell Label

    open func cellTopLabelSize(for message: MessageType, at indexPath: IndexPath) -> CGSize {
        let layoutDelegate = messagesLayout.messagesLayoutDelegate
        let collectionView = messagesLayout.messagesCollectionView
        let height = layoutDelegate.cellTopLabelHeight(for: message, at: indexPath, in: collectionView)
        return CGSize(width: messagesLayout.itemWidth, height: height)
    }

    open func cellTopLabelAlignment(for message: MessageType) -> LabelAlignment {
        let dataSource = messagesLayout.messagesDataSource
        let isFromCurrentSender = dataSource.isFromCurrentSender(message: message)
        return isFromCurrentSender ? outgoingCellTopLabelAlignment : incomingCellTopLabelAlignment
    }
    
    // MARK: - Top message Label
    
    open func messageTopLabelSize(for message: MessageType, at indexPath: IndexPath) -> CGSize {
        let layoutDelegate = messagesLayout.messagesLayoutDelegate
        let collectionView = messagesLayout.messagesCollectionView
        let height = layoutDelegate.messageTopLabelHeight(for: message, at: indexPath, in: collectionView)
        return CGSize(width: messagesLayout.itemWidth, height: height)
    }
    
    open func messageTopLabelAlignment(for message: MessageType) -> LabelAlignment {
        let dataSource = messagesLayout.messagesDataSource
        let isFromCurrentSender = dataSource.isFromCurrentSender(message: message)
        return isFromCurrentSender ? outgoingMessageTopLabelAlignment : incomingMessageTopLabelAlignment
    }
    
    // MARK: - Bottom cell Label
    
    open func cellBottomLabelSize(for message: MessageType, at indexPath: IndexPath) -> CGSize {
        let layoutDelegate = messagesLayout.messagesLayoutDelegate
        let collectionView = messagesLayout.messagesCollectionView
        let height = layoutDelegate.cellBottomLabelHeight(for: message, at: indexPath, in: collectionView)
        return CGSize(width: messagesLayout.itemWidth, height: height)
    }
    
    open func cellBottomLabelAlignment(for message: MessageType) -> LabelAlignment {
        let dataSource = messagesLayout.messagesDataSource
        let isFromCurrentSender = dataSource.isFromCurrentSender(message: message)
        return isFromCurrentSender ? outgoingCellBottomLabelAlignment : incomingCellBottomLabelAlignment
    }

    // MARK: - Bottom Message Label

    open func messageBottomLabelSize(for message: MessageType, at indexPath: IndexPath) -> CGSize {
        let layoutDelegate = messagesLayout.messagesLayoutDelegate
        let collectionView = messagesLayout.messagesCollectionView
        let height = layoutDelegate.messageBottomLabelHeight(for: message, at: indexPath, in: collectionView)
        return CGSize(width: messagesLayout.itemWidth, height: height)
    }

    open func messageBottomLabelAlignment(for message: MessageType) -> LabelAlignment {
        let dataSource = messagesLayout.messagesDataSource
        let isFromCurrentSender = dataSource.isFromCurrentSender(message: message)
        return isFromCurrentSender ? outgoingMessageBottomLabelAlignment : incomingMessageBottomLabelAlignment
    }

    // MARK: - Accessory View

    public func accessoryViewSize(for message: MessageType) -> CGSize {
        let dataSource = messagesLayout.messagesDataSource
        let isFromCurrentSender = dataSource.isFromCurrentSender(message: message)
        return isFromCurrentSender ? outgoingAccessoryViewSize : incomingAccessoryViewSize
    }

    public func accessoryViewPadding(for message: MessageType) -> HorizontalEdgeInsets {
        let dataSource = messagesLayout.messagesDataSource
        let isFromCurrentSender = dataSource.isFromCurrentSender(message: message)
        return isFromCurrentSender ? outgoingAccessoryViewPadding : incomingAccessoryViewPadding
    }
    
    public func accessoryViewPosition(for message: MessageType) -> AccessoryPosition {
        let dataSource = messagesLayout.messagesDataSource
        let isFromCurrentSender = dataSource.isFromCurrentSender(message: message)
        return isFromCurrentSender ? outgoingAccessoryViewPosition : incomingAccessoryViewPosition
    }
	
	// MARK: - ForwardedMessageIndicator
	open func forwardedMessageIndicatorViewSize(for message: MessageType) -> CGSize {
		guard let forwardedMessage = message.forwardedMessageIndicator else {
			return .zero
		}
		
		var forwardedMessageViewSize: CGSize = .zero
		let maxWidth = messageContainerMaxWidth(for: message)
		
		if let font = forwardedMessage.attribute(.font, at: 0, effectiveRange: nil) as? UIFont {
			forwardedMessageViewSize = labelSize(for: forwardedMessage, considering: maxWidth, height: font.lineHeight)
		} else {
			return .zero
		}
		
		let messageInsets = forwardedMessageIndicatorAlignment.textInsets
		forwardedMessageViewSize.width += messageInsets.horizontal
		forwardedMessageViewSize.height += messageInsets.vertical
		
		return forwardedMessageViewSize
	}
	
	// MARK: - ReplyMessageView
	
	open func supplementalMessageViewSize(for message: MessageType) -> (CGFloat, CGFloat, CGSize) {
		let maxWidth = messageContainerMaxWidth(for: message)
			- supplementalIndicatorWidth
			- supplementalIndicatorDistanceToMessage
			- supplementalMessageInsets.horizontal
		
		var supplementalMessageViewSize: CGSize = .zero
		var supplementalMessageTitleHeight: CGFloat = 0
		var supplementalMessageDescHeight: CGFloat = 0
		
		if let title = message.supplementalMessageTitle {
			if !title.string.isEmpty,
				let font = title.attribute(.font, at: 0, effectiveRange: nil) as? UIFont {
				let titleSize = labelSize(for: title, considering: maxWidth, height: font.lineHeight)
				supplementalMessageViewSize = titleSize
				supplementalMessageTitleHeight = font.lineHeight
			}
		}
		
		if let desc = message.supplementalMessageDescription {
			
			if !desc.string.isEmpty,
				let font = desc.attribute(.font, at: 0, effectiveRange: nil) as? UIFont {
				let descSize = labelSize(for: desc, considering: maxWidth, height: font.lineHeight)

				supplementalMessageViewSize.height += font.lineHeight
				supplementalMessageViewSize.width = max(descSize.width, supplementalMessageViewSize.width)
				supplementalMessageDescHeight = font.lineHeight
			}
		}
				
		if supplementalMessageViewSize != .zero {
			supplementalMessageViewSize.height += supplementalMessagePadding * 3
			supplementalMessageViewSize.height += supplementalMessageInsets.vertical
			supplementalMessageViewSize.width = min(supplementalMessageViewSize.width
				+ supplementalIndicatorWidth
				+ supplementalMessageInsets.horizontal
				+ supplementalIndicatorDistanceToMessage, maxWidth)
		}
		
		return (supplementalMessageTitleHeight, supplementalMessageDescHeight, supplementalMessageViewSize)
	}

    // MARK: - MessageContainer

    open func messageContainerPadding(for message: MessageType) -> UIEdgeInsets {
        let dataSource = messagesLayout.messagesDataSource
        let isFromCurrentSender = dataSource.isFromCurrentSender(message: message)
        return isFromCurrentSender ? outgoingMessagePadding : incomingMessagePadding
    }

    open func messageContainerSize(for message: MessageType) -> CGSize {
        // Returns .zero by default
        return .zero
    }

    open func messageContainerMaxWidth(for message: MessageType) -> CGFloat {
		let dataSource = messagesLayout.messagesDataSource
		let isFromCurrentSender = dataSource.isFromCurrentSender(message: message)
        let avatarWidth = avatarSize(for: message).width
        let messagePadding = messageContainerPadding(for: message)
        let accessoryWidth = accessoryViewSize(for: message).width
        let accessoryPadding = accessoryViewPadding(for: message)
        return messagesLayout.itemWidth - avatarWidth - messagePadding.horizontal - accessoryWidth - accessoryPadding.horizontal - (isFromCurrentSender ? avatarTrailingPadding : avatarLeadingPadding)
    }

    // MARK: - Helpers

    public var messagesLayout: MessagesCollectionViewFlowLayout {
        guard let layout = layout as? MessagesCollectionViewFlowLayout else {
            fatalError("Layout object is missing or is not a MessagesCollectionViewFlowLayout")
        }
        return layout
    }

	internal func labelSize(for attributedText: NSAttributedString, considering maxWidth: CGFloat, height: CGFloat? = nil) -> CGSize {
        let constraintBox = CGSize(width: maxWidth, height: height ?? .greatestFiniteMagnitude)
        let rect = attributedText.boundingRect(with: constraintBox, options: [.usesLineFragmentOrigin, .usesFontLeading], context: nil).integral

        return rect.size
    }
	
	internal func includeReplyMessageSize(for message: MessageType, forContainerSize containerSize: CGSize) -> CGSize {
		let replySize = supplementalMessageViewSize(for: message)

		return .init(width: max(containerSize.width, replySize.2.width),
					 height: containerSize.height + replySize.2.height)
	}
	
	internal func includeForwardedMessageSize(for message: MessageType, forContainerSize containerSize: CGSize) -> CGSize {
		let forwardedMessageSize = forwardedMessageIndicatorViewSize(for: message)
		
		return .init(width: max(containerSize.width, forwardedMessageSize.width),
					 height: containerSize.height + forwardedMessageSize.height)
	}
}

fileprivate extension UIEdgeInsets {
    init(top: CGFloat = 0, bottom: CGFloat = 0, left: CGFloat = 0, right: CGFloat = 0) {
        self.init(top: top, left: left, bottom: bottom, right: right)
    }
}
