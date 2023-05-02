//
//  CalendarVC.swift
//  DRBS
//
//  Created by 김은상 on 2023/03/11.
//

import UIKit
import SideMenu
import FSCalendar

class CalendarVC: UIViewController {
    //MARK: - Properties
    private let myCalendar: FSCalendar = {
       let calendar = FSCalendar()
        calendar.locale = Locale(identifier: "ko_KR")
        calendar.backgroundColor = .systemBackground
        calendar.scrollEnabled = true
        calendar.scrollDirection = .horizontal
        calendar.translatesAutoresizingMaskIntoConstraints = false
        calendar.appearance.headerDateFormat = "M" + "월 총 소비 금액"
        calendar.appearance.caseOptions = .weekdayUsesSingleUpperCase
        calendar.appearance.headerTitleColor = .black
        calendar.appearance.weekdayTextColor = .darkGray
        calendar.appearance.headerTitleAlignment = .left
        calendar.calendarHeaderView.translatesAutoresizingMaskIntoConstraints = false
        
        calendar.headerHeight = 0
        calendar.appearance.headerTitleFont = UIFont.boldSystemFont(ofSize: 0)
//        calendar.appearance.weekdayFont = UIFont(name: "NanumJungHagSaeng", size: 28)
//        calendar.appearance.titleFont = UIFont(name: "NanumJungHagSaeng", size: 28)
        calendar.appearance.headerMinimumDissolvedAlpha = 0.0
        calendar.appearance.eventSelectionColor = .blue
        calendar.placeholderType = .none

        return calendar
    }()
    
    private let expenseTableView: UITableView = {
       let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.estimatedRowHeight = 160
        tableView.separatorStyle = .none
        return tableView
    }()
    
    private let mainLabel: UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textAlignment = .left
        label.backgroundColor = .clear
//        label.text = "3월 총 소비 금액"
        
        return label
    }()
    
    private let totalSpentLabel: UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 30)
        label.textColor = UIColor(red: 0.43, green: 0.19, blue: 0.92, alpha: 1.00)
        label.text = "400,000 원"
        return label
    }()
    
    private lazy var dateLabel: UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 25)
        label.textAlignment = .center
        return label
    }()
    
    private lazy var utilityBillButton: UIButton = {
       let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("공과금", for: .normal)
        button.backgroundColor = .white
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.blue.cgColor
        button.layer.cornerRadius = 5
        button.setTitleColor(.blue, for: .normal)
        button.addTarget(self, action: #selector(utilityButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var foodExpensesButton: UIButton = {
       let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("식비", for: .normal)
        button.backgroundColor = .white
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.red.cgColor
        button.layer.cornerRadius = 5
        button.setTitleColor(.red, for: .normal)
        button.addTarget(self, action: #selector(foodButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var etcExpensesButton: UIButton = {
       let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("기타지출", for: .normal)
        button.backgroundColor = .white
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.green.cgColor
        button.layer.cornerRadius = 5
        button.setTitleColor(.green, for: .normal)
        button.addTarget(self, action: #selector(etcButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var buttonStack: UIStackView = {
       let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.alignment = .fill
        stack.distribution = .fillEqually
        stack.spacing = 5
        return stack
    }()
    
    lazy var calendarTopConstraints =  myCalendar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100)
    lazy var tableViewTopConstraints = expenseTableView.topAnchor.constraint(equalTo: myCalendar.bottomAnchor, constant: 50)
    lazy var calendarHeight = myCalendar.heightAnchor.constraint(equalToConstant: 570)
    var isCalendarWeek: Bool? { didSet { calendarTop() } }
    
    var dateString: String? { didSet { dateLabel.text = dateString } }
    
    var monthString: String? { didSet { mainLabel.text = monthString } }
    
    var currentCategory: Category? { didSet {
        switch currentCategory {
        case .utilityBill:
            self.categoryExpenses = expenses.filter{($0).category == .utilityBill}
            expenseTableView.reloadData()
        case .food:
            self.categoryExpenses = expenses.filter{($0).category == .food}
            expenseTableView.reloadData()
        case .etc:
            self.categoryExpenses = expenses.filter{($0).category == .etc}
            expenseTableView.reloadData()
        case .all:
            self.categoryExpenses = expenses
            expenseTableView.reloadData()
        default:
            break
        }
    } }
    
    let expenses: [Expense] = [
        Expense(cost: "100000", category: .utilityBill, background: .blue, expenseText: "월세", memo: "월세 너무 많죠;;"),
        Expense(cost: "28000", category: .food, background: .red, expenseText: "치킨", memo: "bhc치킨"),
        Expense(cost: "2500", category: .etc, background: .green, expenseText: "샤프", memo: "알파에서 샤프 구매하고 더 둘러보다가 오예스~")]
    
    lazy var categoryExpenses: [Expense] = expenses
    
    
    
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureUI()
        configureNav()
        swipeGuesture()
        setupCalendar()
        setupTabelView()
    }
    
    
    //MARK: - Helpers
    
    func calendarTop() {
        if isCalendarWeek ?? false {
//            myCalendar.setScope(.week, animated: true)
            let addExpenseButton = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(addExpenseButtonTapped))
            self.navigationItem.rightBarButtonItem = addExpenseButton
            calendarTopConstraints.constant = 0
            mainLabel.isHidden = true
            totalSpentLabel.isHidden = true
            dateLabel.isHidden = false
            buttonStack.isHidden = false
            UIView.animate(withDuration: 0.5) {
                self.view.layoutIfNeeded()
            }
        } else {
//            myCalendar.setScope(.month, animated: true)
            self.navigationItem.rightBarButtonItem = .none
            calendarTopConstraints.constant = 100
            mainLabel.isHidden = false
            totalSpentLabel.isHidden = false
            dateLabel.isHidden = true
            buttonStack.isHidden = true
            UIView.animate(withDuration: 0.5) {
                self.view.layoutIfNeeded()
            }
        }
    }
    
    func configureTopConstraints() {
        if isCalendarWeek ?? false {
            
            
            UIView.animate(withDuration: 0.5) {
                self.view.layoutIfNeeded()
            }
        } else {
            
            
            UIView.animate(withDuration: 0.5) {
                self.view.layoutIfNeeded()
            }
        }
        
    }
    
    func setupTabelView() {
        expenseTableView.register(ExpenseCell.self, forCellReuseIdentifier: "ExpenseCell")
        view.addSubview(expenseTableView)
        expenseTableView.delegate = self
        expenseTableView.dataSource = self
        NSLayoutConstraint.activate([
            tableViewTopConstraints,
            expenseTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            expenseTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            expenseTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
    }
    
    func swipeGuesture() {
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(swipeEvent(_:)))
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(swipeEvent(_:)))
        swipeUp.direction = .up
        swipeDown.direction = .down
        self.view.addGestureRecognizer(swipeUp)
        self.view.addGestureRecognizer(swipeDown)
        
    }
    func setupCalendar() {
        myCalendar.dataSource = self
        myCalendar.delegate = self
        let myFormatter = DateFormatter()
        myFormatter.dateFormat = "M월 총 소비 금액"
        let currentDate = myFormatter.string(from: Date())
        monthString = currentDate
    }
    
    func configureUI() {
        view.addSubview(myCalendar)
        view.addSubview(mainLabel)
        view.addSubview(totalSpentLabel)
        view.addSubview(dateLabel)
        buttonStack.addArrangedSubview(utilityBillButton)
        buttonStack.addArrangedSubview(foodExpensesButton)
        buttonStack.addArrangedSubview(etcExpensesButton)
        view.addSubview(buttonStack)
        myCalendar.backgroundColor = .white
        NSLayoutConstraint.activate([
            calendarTopConstraints,
            myCalendar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            myCalendar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            calendarHeight])
        
        NSLayoutConstraint.activate([
            mainLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mainLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            mainLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 10),
            mainLabel.heightAnchor.constraint(equalToConstant: 30)])
        
        NSLayoutConstraint.activate([
            totalSpentLabel.topAnchor.constraint(equalTo: mainLabel.bottomAnchor),
            totalSpentLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            totalSpentLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 10),
            totalSpentLabel.heightAnchor.constraint(equalToConstant: 60)])
        
        NSLayoutConstraint.activate([
            dateLabel.topAnchor.constraint(equalTo: myCalendar.bottomAnchor, constant: 0),
            dateLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            dateLabel.heightAnchor.constraint(equalToConstant: 50)])
        
        NSLayoutConstraint.activate([
            buttonStack.topAnchor.constraint(equalTo: myCalendar.bottomAnchor, constant: 10),
            buttonStack.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20),
            buttonStack.heightAnchor.constraint(equalToConstant: 30)])}
    
    func configureNav() {
        navigationItem.title = "DRBS"
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(red: 0.43, green: 0.19, blue: 0.92, alpha: 1.00)
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationController?.navigationBar.backgroundColor = .clear
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance}

    //MARK: - Actions
    
    @objc func swipeEvent(_ swipe: UISwipeGestureRecognizer) {
        if swipe.direction == .up {
            myCalendar.setScope(.week, animated: true)
            isCalendarWeek = true
        } else if swipe.direction == .down {
            myCalendar.setScope(.month, animated: true)
            isCalendarWeek = false
        }
    }
    
    @objc func addExpenseButtonTapped() {
        let addVC = AddVC()
//        addVC.modalPresentationStyle = .fullScreen
        self.present(addVC, animated: true)
    }
    
    @objc func utilityButtonTapped() {
        if self.utilityBillButton.backgroundColor == .white {
            self.utilityBillButton.backgroundColor = .blue
            self.utilityBillButton.setTitleColor(.white, for: .normal)
            self.etcExpensesButton.backgroundColor = .white
            self.etcExpensesButton.setTitleColor(.green, for: .normal)
            self.foodExpensesButton.backgroundColor = .white
            self.foodExpensesButton.setTitleColor(.red, for: .normal)
            self.currentCategory = .utilityBill
        } else {
            self.utilityBillButton.backgroundColor = .white
            self.utilityBillButton.setTitleColor(.blue, for: .normal)
            self.currentCategory = .all
        }
    }
    
    @objc func foodButtonTapped() {
        if self.foodExpensesButton.backgroundColor == .white {
            self.foodExpensesButton.backgroundColor = .red
            self.foodExpensesButton.setTitleColor(.white, for: .normal)
            self.etcExpensesButton.backgroundColor = .white
            self.etcExpensesButton.setTitleColor(.green, for: .normal)
            self.utilityBillButton.backgroundColor = .white
            self.utilityBillButton.setTitleColor(.blue, for: .normal)
            self.currentCategory = .food
        } else {
            self.foodExpensesButton.backgroundColor = .white
            self.foodExpensesButton.setTitleColor(.red, for: .normal)
            self.currentCategory = .all
        }
    }
    
    @objc func etcButtonTapped() {
        if self.etcExpensesButton.backgroundColor == .white {
            self.etcExpensesButton.backgroundColor = .green
            self.etcExpensesButton.setTitleColor(.white, for: .normal)
            self.foodExpensesButton.backgroundColor = .white
            self.foodExpensesButton.setTitleColor(.red, for: .normal)
            self.utilityBillButton.backgroundColor = .white
            self.utilityBillButton.setTitleColor(.blue, for: .normal)
            self.currentCategory = .etc
        } else {
            self.etcExpensesButton.backgroundColor = .white
            self.etcExpensesButton.setTitleColor(.green, for: .normal)
            self.currentCategory = .all
        }
    }
}

//MARK: - FSCalendarDelegateAppearance
extension CalendarVC: FSCalendarDelegateAppearance {
    
    
}

//MARK: - FSCalendarDelegate
extension CalendarVC: FSCalendarDelegate {
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        if isCalendarWeek == nil || isCalendarWeek == false {
            myCalendar.setScope(.week, animated: true)
            isCalendarWeek = true
        }
        let myFormatter = DateFormatter()
        myFormatter.dateFormat = "M월dd일"
        let selectedDate = myFormatter.string(from: date)
        self.dateString = selectedDate
    }
}

//MARK: - FSCalendarDataSource
extension CalendarVC: FSCalendarDataSource {
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
            calendarHeight.constant = bounds.height
    }
    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        let myFormatter = DateFormatter()
        myFormatter.dateFormat = "M월 총 소비 금액"
        let currentPageMonth = myFormatter.string(from: calendar.currentPage)
        self.monthString = currentPageMonth
    }
}

extension CalendarVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryExpenses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ExpenseCell", for: indexPath) as! ExpenseCell
        cell.selectionStyle = .none
        cell.expense = self.categoryExpenses[indexPath.row]
        
        return cell
        
    }
}

extension CalendarVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
