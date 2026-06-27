//
//  expense.swift
//  expanise tracker
//
//  Created by Huzaifa Ahmed on 25/06/2026.
//
import Foundation
import SwiftData
import SwiftUI

@Model
final class Expense {
    var title: String
    var amount: String
    var note: String
    var category: String
    var date: Date
    var isIncome: Bool

    init(
        title: String,
        amount: String,
        note: String = "",
        category: String = "Other",
        date: Date = .now,
        isIncome: Bool = false
    ) {
        self.title = title
        self.amount = amount
        self.note = note
        self.category = category
        self.date = date
        self.isIncome = isIncome
    }
}
