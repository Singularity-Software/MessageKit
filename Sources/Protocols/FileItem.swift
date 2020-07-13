//
//  FileItem.swift
//  MessageKit
//
//  Created by kelvin lee wei sern on 10/07/2020.
//  Copyright © 2020 MessageKit. All rights reserved.
//

import Foundation

/// A protocol used to represent the data for a document message.
public protocol FileItem {
    
    /// The url where the file is located.
    var url: URL { get }
    
    /// The size of the document item.
    var bytes: Int { get }
    
    /// The name of the file.
    var name: String? { get }
	
	/// The document info to be displayed
	var info: String { get }

}
