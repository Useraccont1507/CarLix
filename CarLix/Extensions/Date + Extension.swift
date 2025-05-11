//
//  Date + Extension.swift
//  IdeaCapsule
//
//  Created by Illia Verezei on 02.05.2025.
//

import Foundation

extension Date {
    func getDateString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.calendar = .current
        dateFormatter.dateFormat = "dd.MM.yyyy"
        return dateFormatter.string(from: self)
    }
}
