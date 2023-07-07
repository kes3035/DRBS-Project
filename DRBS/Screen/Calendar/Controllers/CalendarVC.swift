
import UIKit
import SideMenu
import FSCalendar
import FirebaseDatabase
import Then
import SnapKit

class CalendarVC: UIViewController {
    //MARK: - Properties
    private let myCalendar = FSCalendar().then {
        $0.locale = Locale(identifier: "ko_KR")
        $0.backgroundColor = .systemBackground
        $0.scrollEnabled = true
        $0.scrollDirection = .horizontal
        $0.translatesAutoresizingMaskIntoConstraints = false
//        $0.appearance.headerDateFormat = "M" + "월 총 소비 금액"
        $0.appearance.caseOptions = .weekdayUsesSingleUpperCase
        $0.appearance.headerTitleColor = .black
        $0.appearance.weekdayTextColor = .darkGray
        $0.appearance.headerTitleAlignment = .left
        $0.calendarHeaderView.translatesAutoresizingMaskIntoConstraints = false
        $0.appearance.titleSelectionColor = UIColor(red: 0.43, green: 0.19, blue: 0.92, alpha: 1.00)
        $0.appearance.todayColor = .white
        $0.appearance.titleTodayColor = .black
        $0.appearance.borderRadius = 0
        $0.headerHeight = 0
        $0.appearance.headerTitleFont = UIFont.boldSystemFont(ofSize: 0)
        $0.appearance.headerMinimumDissolvedAlpha = 0.0
        $0.appearance.eventSelectionColor = .blue
        $0.placeholderType = .none}
    
    private let expenseTableView = UITableView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = .white
        $0.estimatedRowHeight = 160}
    
    private let mainLabel = UILabel().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = UIFont.boldSystemFont(ofSize: 20)
        $0.textAlignment = .left
        $0.backgroundColor = .clear}
    
    private let totalSpentLabel = UILabel().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = UIFont.boldSystemFont(ofSize: 30)
        $0.text = ""
        $0.textColor = UIColor(red: 0.43, green: 0.19, blue: 0.92, alpha: 1.00)}
    
    private lazy var dateLabel = UILabel().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = UIFont.boldSystemFont(ofSize: 25)
        $0.textAlignment = .center}
    
    private lazy var utilityBillButton = UIButton().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.setTitle("공과금", for: .normal)
        $0.backgroundColor = .white
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor(red: 0.88, green: 0.07, blue: 0.60, alpha: 1.00).cgColor
        $0.layer.cornerRadius = 5
        $0.setTitleColor(UIColor(red: 0.88, green: 0.07, blue: 0.60, alpha: 1.00), for: .normal)
        $0.addTarget(self, action: #selector(utilityButtonTapped), for: .touchUpInside)}
    
    private lazy var foodExpensesButton = UIButton().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.setTitle("식비", for: .normal)
        $0.backgroundColor = .white
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor(red: 0.95, green: 0.40, blue: 0.67, alpha: 1.00).cgColor
        $0.layer.cornerRadius = 5
        $0.setTitleColor(UIColor(red: 0.95, green: 0.40, blue: 0.67, alpha: 1.00), for: .normal)
        $0.addTarget(self, action: #selector(foodButtonTapped), for: .touchUpInside)}
    
    private lazy var etcExpensesButton = UIButton().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.setTitle("기타지출", for: .normal)
        $0.backgroundColor = .white
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor(red: 0.64, green: 0.35, blue: 0.82, alpha: 1.00).cgColor
        $0.layer.cornerRadius = 5
        $0.setTitleColor(UIColor(red: 0.64, green: 0.35, blue: 0.82, alpha: 1.00), for: .normal)
        $0.addTarget(self, action: #selector(etcButtonTapped), for: .touchUpInside)}
    
    private lazy var buttonStack = UIStackView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.axis = .horizontal
        $0.alignment = .fill
        $0.distribution = .fillEqually
        $0.spacing = 5}
    
    private var labelButtonView = UIView().then {
        $0.backgroundColor = .systemBackground
        $0.translatesAutoresizingMaskIntoConstraints = false}
    
    //높이조절용 변수
    lazy var calendarTopConstraints =  myCalendar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100)
    lazy var tableViewTopConstraints = expenseTableView.topAnchor.constraint(equalTo: labelButtonView.bottomAnchor, constant: 10)
    lazy var calendarHeight = myCalendar.heightAnchor.constraint(equalToConstant: 570)
    lazy var mainLabelHeight = mainLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0)
    lazy var totalSpentHeight = totalSpentLabel.topAnchor.constraint(equalTo: mainLabel.bottomAnchor, constant: 0)
    lazy var labelButtonHeight = labelButtonView.topAnchor.constraint(equalTo: myCalendar.bottomAnchor, constant: 100)
    //lazy var buttonStackHeight = buttonStack.topAnchor.constraint(equalTo: myCalendar.bottomAnchor, constant: 10)
    //lazy var dateLabelHeight = dateLabel.topAnchor.constraint(equalTo: myCalendar.bottomAnchor, constant: 0)
    let memoFetcher = MemoFetcher()
    
    
    //속성감시자
    var isCalendarWeek: Bool? {
        didSet {
            scope(bool: isCalendarWeek)
            calendarTop()
        }
    }
    var dateString: String? { didSet { dateLabel.text = dateString } }
    var monthString: String? { didSet { mainLabel.text = monthString!.lastString + "월 총 소비 금액"
        totalSpentLabel.text = calculateTotalExpense(date: monthString)
    } }
    var selectedDate: Date? { didSet { filteringMemo(date: selectedDate) } }
    var totalSpentString: String? {
        didSet {
            totalSpentLabel.text = totalSpentString
        }
    }
    
 
    private var ref = Database.database().reference()
    
    lazy var memo: [Expense] = [] {
        didSet {
            myCalendar.reloadData()
            expenseTableView.reloadData()
        }
    }
    
    var expenseSnapshot: [Expense] = []
    lazy var memoo = self.expenseSnapshot

    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        getDataFromFireBase()
        configureUI()
        configureNav()
        configureCalendar()
        configureTableView()
        configureSwipeGuesture()
        childAdded()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        memoFetcher.memoAdded(completion: { memo in
            self.expenseSnapshot = memo
        })
    }
    
    //MARK: - Helpers
    
    func scope(bool: Bool?) {
        guard let bool = bool else { return }
        if bool {
            myCalendar.setScope(.week, animated: true)
        } else {
            myCalendar.setScope(.month, animated: true)
        }
    }
    
    func calculateTotalExpense(date: String?) -> String {
        guard let date = date else {return ""}
        var total = 0
        for expense in expenseSnapshot {
            if expense.date.contains(date) {
                total += Int(expense.cost) ?? 0
            }
        }
        if total == 0 {
            return "0원"
        } else {
            return commaAdder(price:String(total)) + "원"
        }
    }
    
    func childAdded() {
        ref.child("메모").observe(.childAdded) { snapshot in
            guard let addedData = snapshot.value as? [String:[String:String]] else { return }
            self.addingChildToArray(with: addedData)
        }
    }
    
    func addingChildToArray(with: [String:[String:String]]) {
        let data = with["\(Expense.id)"] ?? [:]
        expenseSnapshot.append(Expense(cost: data["비용"] ?? "",
                              category: data["카테고리"] ?? "",
                              expenseText: data["지출내역"] ?? "",
                              memo: data["메모"] ?? "",
                              date: data["날짜"] ?? ""))
        memo = expenseSnapshot
        myCalendar.reloadData()
        expenseTableView.reloadData()
        print(expenseSnapshot)
        
    }
    
    func getDataFromFireBase() {
        memoFetcher.memoFetcher { expense in
            self.expenseSnapshot = expense
        }
    }
    
    func filteringMemo(date: Date?) {
        let myFormatter = DateFormatter()
        myFormatter.dateFormat = "yyyy-MM-dd"
        guard let unwrappedData = date else {
            memo = []
            return }
        memo = expenseSnapshot.filter{$0.date == myFormatter.string(from: unwrappedData)}
        expenseTableView.reloadData()
    }
    
    
    
    func calendarTop() {
        if isCalendarWeek ?? false {
            //myCalendar.setScope(.week, animated: true)
            let addExpenseButton = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(addExpenseButtonTapped))
            self.navigationItem.rightBarButtonItem = addExpenseButton
            calendarTopConstraints.constant = 0
            labelButtonHeight.constant = 0
            tableViewTopConstraints.constant = 0
            mainLabelHeight.constant = -50
            totalSpentHeight.constant = -40
            UIView.animate(withDuration: 0.5) { self.view.layoutIfNeeded() }
        } else {
            myCalendar.setScope(.month, animated: true)
            self.navigationItem.rightBarButtonItem = .none
            calendarTopConstraints.constant = 100
            mainLabelHeight.constant = 0
            //tableViewTopConstraints.constant = 0
            totalSpentHeight.constant = 0
            labelButtonHeight.constant = 100
            UIView.animate(withDuration: 0.5) { self.view.layoutIfNeeded() }

        }
    }
    
    func configureTableView() {
        expenseTableView.register(ExpenseCell.self, forCellReuseIdentifier: "ExpenseCell")
        view.addSubview(expenseTableView)
        expenseTableView.delegate = self
        expenseTableView.dataSource = self
        expenseTableView.separatorStyle = .none
        NSLayoutConstraint.activate([
            tableViewTopConstraints,
            expenseTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            expenseTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            expenseTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
    }
    
    func configureSwipeGuesture() {
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(swipeEvent(_:)))
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(swipeEvent(_:)))
        swipeUp.direction = .up
        swipeDown.direction = .down
        self.view.addGestureRecognizer(swipeUp)
        self.view.addGestureRecognizer(swipeDown)}
    
    func configureCalendar() {
        myCalendar.dataSource = self
        myCalendar.delegate = self
        let myFormatter = DateFormatter()
        myFormatter.dateFormat = "yyyy-MM"
        let currentDate = myFormatter.string(from: Date())
        monthString = currentDate
    }
    
    func configureUI() {
        view.backgroundColor = .white
        view.addSubviews(myCalendar, mainLabel, totalSpentLabel, labelButtonView)
        buttonStack.addArrangedSubview(utilityBillButton)
        buttonStack.addArrangedSubview(foodExpensesButton)
        buttonStack.addArrangedSubview(etcExpensesButton)
        labelButtonView.addSubviews(dateLabel, buttonStack)
        myCalendar.backgroundColor = .white
        
        NSLayoutConstraint.activate([
            calendarTopConstraints,
            myCalendar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            myCalendar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            calendarHeight,
        
            mainLabelHeight,
            mainLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            mainLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 10),
            mainLabel.heightAnchor.constraint(equalToConstant: 30),
        
            labelButtonHeight,
            labelButtonView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            labelButtonView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            labelButtonView.heightAnchor.constraint(equalToConstant: 60),
        
            totalSpentHeight,
            totalSpentLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10),
            totalSpentLabel.heightAnchor.constraint(equalToConstant: 60),
        
            dateLabel.leadingAnchor.constraint(equalTo: labelButtonView.leadingAnchor, constant: 15),
            dateLabel.centerYAnchor.constraint(equalTo: labelButtonView.centerYAnchor),
            dateLabel.heightAnchor.constraint(equalToConstant: 40),
            
            buttonStack.trailingAnchor.constraint(equalTo: labelButtonView.trailingAnchor, constant: -15),
            buttonStack.centerYAnchor.constraint(equalTo: labelButtonView.centerYAnchor),
            buttonStack.heightAnchor.constraint(equalToConstant: 40)])}
  
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
    
    func commaAdder(price: String?) -> String {
        let integerPrice = Int(price ?? "0") ?? 0
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        let formattedNumber = numberFormatter.string(from: NSNumber(value: integerPrice)) ?? "0"
        return formattedNumber
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
        self.present(addVC, animated: true)
    }
    
    @objc func utilityButtonTapped() {
        if self.utilityBillButton.backgroundColor == .white {
            self.utilityBillButton.backgroundColor = UIColor(red: 0.88, green: 0.07, blue: 0.60, alpha: 1.00)
            self.utilityBillButton.setTitleColor(.white, for: .normal)
            self.etcExpensesButton.backgroundColor = .white
            self.etcExpensesButton.setTitleColor(UIColor(red: 0.64, green: 0.35, blue: 0.82, alpha: 1.00), for: .normal)
            self.foodExpensesButton.backgroundColor = .white
            self.foodExpensesButton.setTitleColor(UIColor(red: 0.95, green: 0.40, blue: 0.67, alpha: 1.00), for: .normal)
            //self.currentCategory = .utilityBill
        } else {
            self.utilityBillButton.backgroundColor = .white
            self.utilityBillButton.setTitleColor(UIColor(red: 0.88, green: 0.07, blue: 0.60, alpha: 1.00), for: .normal)
            //self.currentCategory = .all
        }
    }
    
    @objc func foodButtonTapped() {
        if self.foodExpensesButton.backgroundColor == .white {
            self.foodExpensesButton.backgroundColor = UIColor(red: 0.95, green: 0.40, blue: 0.67, alpha: 1.00)
            self.foodExpensesButton.setTitleColor(.white, for: .normal)
            self.etcExpensesButton.backgroundColor = .white
            self.etcExpensesButton.setTitleColor(UIColor(red: 0.64, green: 0.35, blue: 0.82, alpha: 1.00), for: .normal)
            self.utilityBillButton.backgroundColor = .white
            self.utilityBillButton.setTitleColor(UIColor(red: 0.88, green: 0.07, blue: 0.60, alpha: 1.00), for: .normal)
            //self.currentCategory = .food
        } else {
            self.foodExpensesButton.backgroundColor = .white
            self.foodExpensesButton.setTitleColor(UIColor(red: 0.95, green: 0.40, blue: 0.67, alpha: 1.00), for: .normal)
            //self.currentCategory = .all
        }
    }
    
    @objc func etcButtonTapped() {
        if self.etcExpensesButton.backgroundColor == .white {
            self.etcExpensesButton.backgroundColor = UIColor(red: 0.64, green: 0.35, blue: 0.82, alpha: 1.00)
            self.etcExpensesButton.setTitleColor(.white, for: .normal)
            self.foodExpensesButton.backgroundColor = .white
            self.foodExpensesButton.setTitleColor(UIColor(red: 0.95, green: 0.40, blue: 0.67, alpha: 1.00), for: .normal)
            self.utilityBillButton.backgroundColor = .white
            self.utilityBillButton.setTitleColor(UIColor(red: 0.88, green: 0.07, blue: 0.60, alpha: 1.00), for: .normal)
            //self.currentCategory = .etc
        } else {
            self.etcExpensesButton.backgroundColor = .white
            self.etcExpensesButton.setTitleColor(UIColor(red: 0.64, green: 0.35, blue: 0.82, alpha: 1.00), for: .normal)
            //self.currentCategory = .all
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
    
    func calendar(_ calendar: FSCalendar, subtitleFor date: Date) -> String? {
        let myFormatter = DateFormatter()
        myFormatter.dateFormat = "yyyy-MM-dd"
        var total = 0
        for expense in expenseSnapshot {
            let stringDate = myFormatter.string(from: date)
            if expense.date == stringDate {
                total += Int(expense.cost) ?? 0
            }
        }
        if total == 0 {
            return ""
        } else {
            return "-"+String(total)
        }
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, subtitleOffsetFor date: Date) -> CGPoint {
        return CGPoint(x: 1, y: 5)
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, subtitleDefaultColorFor date: Date) -> UIColor? {
        return UIColor(red: 0.40, green: 0.15, blue: 0.75, alpha: 1.00)
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, subtitleSelectionColorFor date: Date) -> UIColor? {
        return UIColor(red: 0.40, green: 0.15, blue: 0.75, alpha: 1.00).withAlphaComponent(0.8)
    }
    
    
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
        isCalendarWeek = true
        myCalendar.setScope(.week, animated: true)
    
//        if isCalendarWeek == nil || isCalendarWeek == false {
//            myCalendar.setScope(.week, animated: true)
//            isCalendarWeek = true
//        }
        let myFormatter = DateFormatter()
        myFormatter.dateFormat = "M월dd일"
        let selectedDate = myFormatter.string(from: date)
        self.dateString = selectedDate
    }
    
}

//MARK: - FSCalendarDataSource
extension CalendarVC: FSCalendarDataSource {
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        calendarHeight.constant = bounds.height}
    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        let myFormatter = DateFormatter()
        myFormatter.dateFormat = "yyyy-MM"
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
//        for memos in expenses {
//            if myFormatter.string(from: date) == memos.cost {
//                labelMy1.text = "-" + memos.cost
//                cell.addSubview(labelMy1)
//            }
//        }
    }
}

extension CalendarVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memo.count
        //return self.categoryExpenses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ExpenseCell", for: indexPath) as! ExpenseCell
        cell.selectionStyle = .none
        guard !memo.isEmpty else { return cell }
        cell.expense = memo[indexPath.row]
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

