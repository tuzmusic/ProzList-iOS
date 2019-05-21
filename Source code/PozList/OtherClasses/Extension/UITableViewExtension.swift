//
//  UITableViewExtension.swift
//  EducationApp
//
//  Created on 1/2/18.
//  Copyright © 2018. All rights reserved.
//

import Foundation

extension UITableView {
    func scrollToBottom(animated: Bool) {
        let y = contentSize.height - frame.size.height
        setContentOffset(CGPoint(x: 0, y: (y<0) ? 0 : y), animated: animated)
    }
    
    func scrollToBottomFirst(section: Int,animated: Bool) {
        let row = self.numberOfRows(inSection: section)
        if row > 0 {
            let indexPath = IndexPath(row: row - 1, section: section)
            self.scrollToRow(at: indexPath, at: .bottom, animated: animated)
        }
    }
    
    func scrollToTop(animated: Bool = true) {
        let indexPath = IndexPath(row: 0, section: 0)
        self.scrollToRow(at: indexPath, at: .top, animated: animated)
    }
}
