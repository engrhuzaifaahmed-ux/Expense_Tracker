//
//  Homeview.swift
//  expanise tracker
//
//  Created by Huzaifa Ahmed on 22/06/2026.
//
//

import SwiftUI
import SwiftData

struct HomeView: View {

    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Expense.date, order: .reverse) private var expenses: [Expense]

    @State private var showingAddExpense = false
    @State private var showingEditExpense = false
    @State private var selectedExpense: Expense?

    @State private var editTitle = ""
    @State private var editAmount = ""
    @State private var editNote = ""
    @State private var editCategory = ""
    @State private var editIsIncome = false

    var totalIncome: Double {
        expenses
            .filter { $0.isIncome }
            .compactMap { Double($0.amount) }
            .reduce(0, +)
    }

    var totalExpense: Double {
        expenses
            .filter { !$0.isIncome }
            .compactMap { Double($0.amount) }
            .reduce(0, +)
    }

    var totalBalance: Double {
        totalIncome - totalExpense
    }

    var recentExpenses: [Expense] {
        Array(expenses.prefix(2))
    }

    var body: some View {

        NavigationStack {

            ScrollView {

                VStack(spacing: 20) {

                    balanceCard

                    HStack(spacing: 12) {
                        summaryCard(
                            title: "Income",
                            amount: totalIncome,
                            color: .green,
                            systemImage: "arrow.down.circle.fill"
                        )

                        summaryCard(
                            title: "Expenses",
                            amount: totalExpense,
                            color: .red,
                            systemImage: "arrow.up.circle.fill"
                        )
                    }
                    .padding(.horizontal)

                    recentExpensesSection
                }
                .padding(.top, 8)
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Dashboard")
            .navigationBarTitleDisplayMode(.inline)

            .toolbar {

                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        // Hook up to a settings screen
                    } label: {
                        Image(systemName: "gearshape")
                            .foregroundColor(.primary)
                    }
                }

                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showingAddExpense = true
                    } label: {
                        Image(systemName: "plus")
                            .foregroundColor(.primary)
                    }
                }
            }

            .sheet(isPresented: $showingAddExpense) {
                AddExpenseView()
            }

            .sheet(isPresented: $showingEditExpense) {
                editExpenseSheet
            }
        }
    }

    private var balanceCard: some View {
        VStack(alignment: .leading, spacing: 12) {

            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text("Total Balance")
                        .font(.subheadline)
                    Text("This Month")
                        .font(.caption2)
                        .opacity(0.8)
                }

                Spacer()

                Menu {
                    Button("This Month") {}
                    Button("This Year") {}
                    Button("All Time") {}
                } label: {
                    HStack(spacing: 4) {
                        Text("Monthly")
                            .font(.caption)
                        Image(systemName: "chevron.down")
                            .font(.caption2)
                    }
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(Color.white.opacity(0.2))
                    .cornerRadius(8)
                }
            }
            .foregroundColor(.white)

            Text("Rs \(formatted(totalBalance))")
                .font(.system(size: 30, weight: .bold))
                .foregroundColor(.white)
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            LinearGradient(
                colors: [Color.green.opacity(0.9), Color.green.opacity(0.7)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .cornerRadius(16)
        .padding(.horizontal)
    }

    private func summaryCard(title: String, amount: Double, color: Color, systemImage: String) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.caption)
                .foregroundColor(.gray)

            Text("Rs \(formatted(amount))")
                .font(.headline)
                .foregroundColor(.primary)

            HStack(spacing: 4) {
                Text("This Month")
                    .font(.caption2)
                    .foregroundColor(.gray)
                Image(systemName: systemImage)
                    .font(.caption2)
                    .foregroundColor(color)
            }
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.secondarySystemGroupedBackground))
        .cornerRadius(14)
    }

    private var recentExpensesSection: some View {
        VStack(spacing: 10) {

            HStack {
                Text("Recent Expenses")
                    .font(.headline)

                Spacer()

                NavigationLink("View all") {
                    AllExpensesView(expenses: expenses)
                }
                .font(.subheadline)
            }
            .padding(.horizontal)

            if expenses.isEmpty {
                Text("No expenses yet")
                    .foregroundColor(.gray)
                    .padding(.top, 24)
            } else {
                VStack(spacing: 8) {
                    ForEach(recentExpenses) { expense in
                        expenseRow(expense)
                    }
                }
                .padding(.horizontal)
            }
        }
    }

    private func expenseRow(_ expense: Expense) -> some View {
        HStack(spacing: 12) {

            ZStack {
                Circle()
                    .fill((expense.isIncome ? Color.green : Color.blue).opacity(0.15))
                    .frame(width: 38, height: 38)

                Image(systemName: expense.isIncome ? "arrow.down" : "cart.fill")
                    .foregroundColor(expense.isIncome ? .green : .blue)
                    .font(.system(size: 15, weight: .semibold))
            }

            VStack(alignment: .leading, spacing: 2) {
                Text(expense.title)
                    .font(.subheadline)
                    .fontWeight(.medium)

                Text("\(expense.category) , \(formattedDate(expense.date))")
                    .font(.caption2)
                    .foregroundColor(.gray)
            }

            Spacer()

            Text("\(expense.isIncome ? "+" : "-")Rs \(formatted(Double(expense.amount) ?? 0))")
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(expense.isIncome ? .green : .red)
        }
        .padding(12)
        .background(Color(.secondarySystemGroupedBackground))
        .cornerRadius(12)
        .contentShape(Rectangle())
        .onTapGesture {
            selectedExpense = expense
            editTitle = expense.title
            editAmount = expense.amount
            editNote = expense.note
            editCategory = expense.category
            editIsIncome = expense.isIncome
            showingEditExpense = true
        }
        .swipeActions {
            Button("Delete", role: .destructive) {
                deleteExpense(expense)
            }
        }
    }

    private var editExpenseSheet: some View {
        NavigationStack {
            Form {
                TextField("Title", text: $editTitle)
                TextField("Amount", text: $editAmount)
                    .keyboardType(.decimalPad)

                Picker("Category", selection: $editCategory) {
                    Text("Food").tag("Food")
                    Text("Chicken").tag("Chicken")
                    Text("Garments").tag("Garments")
                    Text("Toys").tag("Toys")
                    Text("Other").tag("Other")
                }
                .pickerStyle(.menu)

                TextField("Note", text: $editNote)
                Toggle("Is Income", isOn: $editIsIncome)

                Button("Update Expense") {
                    if let expense = selectedExpense {
                        expense.title = editTitle
                        expense.amount = editAmount
                        expense.note = editNote
                        expense.category = editCategory
                        expense.isIncome = editIsIncome
                        // SwiftData autosaves on context changes.
                    }
                    showingEditExpense = false
                }
            }
            .navigationTitle("Edit Expense")
        }
    }

    private func formatted(_ value: Double) -> String {
        String(format: "%.2f", value)
    }

    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MMM-yyyy 'at' h:mm a"
        return formatter.string(from: date)
    }

    func deleteExpense(_ expense: Expense) {
        modelContext.delete(expense)
    }
}

#Preview {
    HomeView()
        .modelContainer(for: Expense.self, inMemory: true)
}

struct AddExpenseView: View {

    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) private var modelContext

    @State private var title = ""
    @State private var amount = ""
    @State private var note = ""
    @State private var category = ""
    @State private var isIncome = false

    @State private var showAlert = false

    var body: some View {

        NavigationStack {

            Form {
                TextField("Title", text: $title)

                TextField("Amount", text: $amount)
                    .keyboardType(.decimalPad)

                TextField("Category (e.g. Food, Salary)", text: $category)

                TextField("Note", text: $note)

                Toggle("Is Income", isOn: $isIncome)

                Button("Save Expense") {

                    guard !title.isEmpty, let amountValue = Double(amount), amountValue > 0 else {
                        showAlert = true
                        return
                    }

                    let newExpense = Expense(
                        title: title,
                        amount: amount,
                        note: note,
                        category: category.isEmpty ? "Other" : category,
                        date: .now,
                        isIncome: isIncome
                    )

                    modelContext.insert(newExpense)
                    dismiss()
                }
            }
            .navigationTitle(isIncome ? "Add Income" : "Add Expense")

            .alert("Missing or Invalid Fields", isPresented: $showAlert) {
                Button("OK") {}
            } message: {
                Text("Please enter a Title and a valid Amount.")
            }
        }
    }
}

struct AllExpensesView: View {

    let expenses: [Expense]

    var body: some View {
        List(expenses) { expense in
            HStack {
                VStack(alignment: .leading) {
                    Text(expense.title)
                        .font(.headline)
                    Text(expense.category)
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                Spacer()
                Text("\(expense.isIncome ? "+" : "-")Rs \(expense.amount)")
                    .foregroundColor(expense.isIncome ? .green : .red)
            }
        }
        .navigationTitle("All Expenses")
    }
}
