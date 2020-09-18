//
//  ReplyMessageView.swift
//  InputBarAccessoryView
//
//  Created by kelvin lee wei sern on 02/07/2020.
//

import UIKit

open class SupplementalMessageInfoView: UIView {
	open var title: InsetLabel = {
		let lb = InsetLabel()
		lb.numberOfLines = 1
		return lb
	}()
    
    open var desc: InsetLabel = {
        let lb = InsetLabel()
        lb.numberOfLines = 1
        return lb
    }()
    
    open var indicator = UIView()
	
	public override init(frame: CGRect) {
		super.init(frame: frame)
		setupSubviews()
	}
	
	required public init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		setupSubviews()
	}
	
	open func setupSubviews() {
		addSubview(indicator)
		addSubview(title)
		addSubview(desc)
		
		clipsToBounds = true
	}
}
