//
//  CalendarVC.swift
//  DRBS
//
//  Created by 김은상 on 2023/03/11.
//

import UIKit
import SideMenu
import FSCalendar
import FirebaseDatabase

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
        calendar.appearance.titleSelectionColor = UIColor(red: 0.43, green: 0.19, blue: 0.92, alpha: 1.00)
        calendar.appearance.todayColor = .white
        calendar.appearance.titleTodayColor = .black
        calendar.appearance.borderRadius = 0
        calendar.headerHeight = 0
        calendar.appearance.headerTitleFont = UIFont.boldSystemFont(ofSize: 0)
        calendar.appearance.headerMinimumDissolvedAlpha = 0.0
        calendar.appearance.eventSelectionColor = .blue
        calendar.placeholderType = .none
        return calendar
    }()
    
    private let expenseTableView: UITableView = {
       let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.estimatedRowHeight = 160
        return tableView
    }()
    
    private let mainLabel: UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textAlignment = .left
        label.backgroundColor = .clear
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
            self.categoryExpenses = expenses.filter{($0).category == Category.utilityBill.rawValue}
            expenseTableView.reloadData()
        case .food:
            self.categoryExpenses = expenses.filter{($0).category == Category.food.rawValue}
            expenseTableView.reloadData()
        case .etc:
            self.categoryExpenses = expenses.filter{($0).category == Category.etc.rawValue}
            expenseTableView.reloadData()
        case .all:
            self.categoryExpenses = expenses
            expenseTableView.reloadData()
        default:
            break
        }
    } }
    
    var expenses: [Expense] = [
        Expense(cost: "100000", category: Category.utilityBill.rawValue, expenseText: "월세", memo: "월세 너무 많죠;;"),
        Expense(cost: "28000", category: Category.food.rawValue, expenseText: "치킨", memo: "bhc치킨"),
        Expense(cost: "2500", category: Category.etc.rawValue, expenseText: "샤프", memo: "알파에서 샤프 구매하고 더 둘러보다가 오예스~")]
    
    lazy var categoryExpenses: [Expense] = expenses
    
    var selectedDate: Date?
    
    private var ref = Database.database().reference()
    
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
        expenseTableView.separatorStyle = .none
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

    func readDataFromFirebase() {
        ref.child("메모").observeSingleEvent(of: .value) { snapshot in
            //추가해야함
            let date = snapshot.value as? String ?? ""
            DispatchQueue.main.async {
                //하나 저장
                
                
            }
        }
    }
    
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
        let myFormatter = DateFormatter()
        myFormatter.dateFormat = "yyyy-MM-dd"
        guard let date = self.selectedDate else { return }
        addVC.memoDate = myFormatter.string(from: date)
        
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
//    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
//        //이벤트 돗 갯수 지정하기
//
//
//
//        return 3
//    }
    
//    func calendar(_ calendar: FSCalendar, subtitleFor date: Date) -> String? {
//        let myFormatter = DateFormatter()
//        myFormatter.dateFormat = "yyyy-MM-dd"
//        for memo in expenses {
//            let stringDate = myFormatter.string(from: date)
//            if memo.date == stringDate {
//                return memo.cost
//            }
//        }
//        return ""
//    }
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillSelectionColorFor date: Date) -> UIColor? {
        return UIColor.white
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, borderSelectionColorFor date: Date) -> UIColor? {
        return UIColor(red: 0.43, green: 0.19, blue: 0.92, alpha: 1.00)
    }
    
    
}

//MARK: - FSCalendarDelegate
extension CalendarVC: FSCalendarDelegate {
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        self.selectedDate = date
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
    
    func calendar(_ calendar: FSCalendar, willDisplay cell: FSCalendarCell, for date: Date, at monthPosition: FSCalendarMonthPosition) {
        let labelMy1 = UILabel(frame: CGRect(x: 0, y: 45, width: cell.bounds.width, height: 10))
        labelMy1.font = UIFont.systemFont(ofSize: 8)
        labelMy1.textColor = UIColor.darkGray
        labelMy1.textAlignment = .center
        labelMy1.layer.cornerRadius = cell.bounds.width/2
        let myFormatter = DateFormatter()
        myFormatter.dateFormat = "yyyy-MM-dd"
        for memos in expenses {
            if myFormatter.string(from: date) == memos.cost {
                labelMy1.text = "-" + memos.cost
                cell.addSubview(labelMy1)
            }
        }
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
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let addVC = AddVC()
//        addVC.modalPresentationStyle = .fullScreen
//        self.present(addVC, animated: true)
//        addVC.expenses = expenses[indexPath.row]
    }
}
