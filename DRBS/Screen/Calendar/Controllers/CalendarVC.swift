
import UIKit
import SideMenu
import FSCalendar
import FirebaseDatabase
import Then
import SnapKit

class CalendarVC: UIViewController {
    //MARK: - Properties
    private let calendar = FSCalendar().then {
        $0.locale = Locale(identifier: "ko_KR")
        $0.backgroundColor = .systemBackground
        $0.scrollEnabled = true
        $0.scrollDirection = .horizontal
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.appearance.caseOptions = .weekdayUsesSingleUpperCase
        $0.appearance.headerTitleColor = .black
        $0.appearance.weekdayTextColor = .darkGray
        $0.appearance.headerTitleAlignment = .left
        $0.calendarHeaderView.translatesAutoresizingMaskIntoConstraints = false
        $0.appearance.titleSelectionColor = UIColor(red: 0.43, green: 0.19, blue: 0.92, alpha: 1.00)
        $0.appearance.todayColor = .clear
        $0.appearance.titleTodayColor = UIColor(red: 0.43, green: 0.19, blue: 0.92, alpha: 1.00)
        $0.appearance.borderSelectionColor = .clear
        $0.appearance.borderDefaultColor = .clear
        $0.appearance.borderRadius = 1
        $0.headerHeight = 0
        $0.appearance.headerTitleFont = UIFont.boldSystemFont(ofSize: 0)
        $0.appearance.headerMinimumDissolvedAlpha = 0.0
        $0.appearance.eventSelectionColor = .blue
        $0.placeholderType = .none}
    
    private let expenseTV = UITableView(frame: CGRect(), style: .plain).then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = .white
        $0.estimatedRowHeight = 160}
    
    private let monthTotalLabel = UILabel().then {
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
        $0.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        $0.backgroundColor = .white
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.systemGray.cgColor
        $0.layer.cornerRadius = 15
        $0.setTitleColor(UIColor.systemGray, for: .normal)
        $0.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)}
    
    private lazy var foodExpensesButton = UIButton().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.setTitle("식비", for: .normal)
        $0.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        $0.backgroundColor = .white
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.systemGray.cgColor
        $0.layer.cornerRadius = 15
        $0.setTitleColor(UIColor.systemGray, for: .normal)
        $0.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)}
    
    private lazy var etcExpensesButton = UIButton().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.setTitle("기타", for: .normal)
        $0.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        $0.backgroundColor = .white
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.systemGray.cgColor
        $0.layer.cornerRadius = 15
        $0.setTitleColor(UIColor.systemGray, for: .normal)
        $0.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)}
    
    private lazy var buttonStack = UIStackView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.axis = .horizontal
        $0.alignment = .fill
        $0.distribution = .fillEqually
        $0.spacing = 5}
    
    private var dateLabelWithButtonSV = UIView().then {
        $0.backgroundColor = .systemBackground
        $0.translatesAutoresizingMaskIntoConstraints = false}
    
    lazy var calendarHeight = calendar.heightAnchor.constraint(equalToConstant: view.frame.height)
    let memoFetcher = MemoFetcher.shared
    
    //속성감시자
    var isCalendarWeek: Bool? { didSet { calendarTop() } }
    var currentCategory: Category? { didSet { filteringCategory(with: currentCategory, date: selectedDate) } }
    var dateString: String? { didSet { dateLabel.text = dateString } }
    var monthString: String? { didSet { monthTotalLabel.text = monthString!.lastString + "월 총 소비 금액"
        totalSpentLabel.text = calculateTotalExpense(date: monthString)
    } }
    
    var selectedDate: Date? {
        didSet {
            filteringMemo(date: selectedDate)
            resetCategory()
        }
    }
    
    var totalSpentString: String? { didSet { totalSpentLabel.text = totalSpentString } }
    
    lazy var memo: [Expense] = [] {
        didSet {
            self.calendar.reloadData()
            self.expenseTV.reloadData()
        }
    }
    var expenseSnapshot: [Expense] = [] {
        didSet {
            guard selectedDate != nil else { return }
            filteringMemo(date: selectedDate)
        }
    }
    
    lazy var memoo = self.expenseSnapshot

    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureNav()
        configureCalendar()
        configureTableView()
        configureSwipeGuesture()
    }

    
    
    //MARK: - Helpers
    func configureUI() {
        view.backgroundColor = .white
        view.addSubviews(calendar, monthTotalLabel, totalSpentLabel, dateLabelWithButtonSV)
        buttonStack.addArrangedSubview(utilityBillButton)
        buttonStack.addArrangedSubview(foodExpensesButton)
        buttonStack.addArrangedSubview(etcExpensesButton)
        dateLabelWithButtonSV.addSubviews(dateLabel, buttonStack)
        calendar.backgroundColor = .white
        
        monthTotalLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(100)
            $0.left.equalToSuperview().offset(10)
            $0.right.equalToSuperview().offset(-10)
            $0.height.equalTo(30)
        }
        
        totalSpentLabel.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.right.equalToSuperview().offset(-10)
            $0.top.equalTo(monthTotalLabel.snp.bottom).offset(0)
            $0.height.equalTo(60)
        }
        
        calendar.snp.makeConstraints {
            $0.top.equalTo(totalSpentLabel.snp.bottom).offset(0)
            $0.height.equalTo(view.frame.height/1.2)
            $0.left.right.equalToSuperview()
        }
        
        dateLabelWithButtonSV.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.height.equalTo(60)
            $0.top.equalTo(calendar.snp.bottom).offset(0)
        }
        
        dateLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(15)
            $0.centerY.equalToSuperview()
            $0.height.equalTo(40)}
        
        buttonStack.snp.makeConstraints {
            $0.centerY.equalTo(dateLabelWithButtonSV)
            $0.width.equalTo(view.frame.width/2)
            $0.trailing.equalToSuperview().offset(-15)}}
    
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
    
    func configureCalendar() {
        calendar.dataSource = self
        calendar.delegate = self
        let myFormatter = DateFormatter()
        myFormatter.dateFormat = "yyyy-MM"
        let currentDate = myFormatter.string(from: Date())
        monthString = currentDate}
    
    func configureTableView() {
        expenseTV.register(ExpenseCell.self, forCellReuseIdentifier: "ExpenseCell")
        view.addSubview(expenseTV)
        expenseTV.delegate = self
        expenseTV.rowHeight = 60
        expenseTV.dataSource = self
        expenseTV.snp.makeConstraints {
            $0.top.equalTo(dateLabelWithButtonSV.snp.bottom).offset(0)
            $0.left.right.bottom.equalToSuperview()
        }
    }
    
    
    
    func calculateTotalExpense(date: String?) -> String {
        guard let date = date else {return ""}
        var total = 0
        for expense in expenseSnapshot { if expense.date.contains(date) { total += Int(expense.cost) ?? 0 }}
        guard total != 0 else { return "0원"}
        return commaAdder(price:String(total)) + "원"}

    func filteringMemo(date: Date?) {
        let myFormatter = DateFormatter()
        myFormatter.dateFormat = "yyyy-MM-dd"
        guard let unwrappedData = date else { return }
        memo = expenseSnapshot.filter{$0.date == myFormatter.string(from: unwrappedData)}
        expenseTV.reloadData()}
    
    func filteringCategory(with category: Category?, date: Date?) {
        let myFormatter = DateFormatter()
        myFormatter.dateFormat = "yyyy-MM-dd"
        guard let unwrappedData = date else { return }
        let dateFiltered = expenseSnapshot.filter{$0.date == myFormatter.string(from: unwrappedData)}
        guard let category = category else { return }
        switch category.rawValue {
        case "전체":
            memo = dateFiltered
            self.expenseTV.reloadData()
        case "공과금":
            memo = dateFiltered.filter{$0.category == category.rawValue}
            self.expenseTV.reloadData()
        case "식비":
            memo = dateFiltered.filter{$0.category == category.rawValue}
            self.expenseTV.reloadData()
        case "기타":
            memo = dateFiltered.filter{$0.category == category.rawValue}
            self.expenseTV.reloadData()
        default:
            return
        }
    }
    
    func calendarTop() {
        if isCalendarWeek ?? false {
            let addExpenseButton = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(addExpenseButtonTapped))
            self.navigationItem.rightBarButtonItem = addExpenseButton
//            print("콜렉션뷰 프레임 높이는\(self.calendar.collectionView.frame.height)")
//            print("콘텐츠뷰 프레임 높이는\(self.calendar.contentView.frame.height)")
//            print("인풋뷰 프레임 높이는\(self.calendar.inputView?.frame.height)")

            DispatchQueue.main.async {
                self.calendar.setScope(.week, animated: true)
                self.calendar.snp.updateConstraints {
                    $0.height.equalTo(150)
                }
                self.monthTotalLabel.snp.updateConstraints {
                    $0.top.equalToSuperview().offset(10)
                }
                self.dateLabelWithButtonSV.snp.updateConstraints {
                    $0.top.equalTo(self.calendar.snp.bottom).offset(0)
                }
                self.expenseTV.snp.updateConstraints {
                    $0.top.equalTo(self.dateLabelWithButtonSV.snp.bottom).offset(0)
                }

                UIView.animate(withDuration: 0.5) { self.view.layoutIfNeeded() }
                
            }
        } else {
            DispatchQueue.main.async {
                self.calendar.setScope(.month, animated: true)
                self.calendar.snp.updateConstraints {
                    $0.height.equalTo(self.view.frame.height/1.2)
                }
                self.navigationItem.rightBarButtonItem = .none
                self.monthTotalLabel.snp.updateConstraints {
                    $0.top.equalToSuperview().offset(100)
                }
                self.dateLabelWithButtonSV.snp.updateConstraints {
                    $0.top.equalTo(self.calendar.snp.bottom).offset(0)
                }
                self.expenseTV.snp.updateConstraints {
                    $0.top.equalTo(self.dateLabelWithButtonSV.snp.bottom).offset(0)
                }
                UIView.animate(withDuration: 0.5) { self.view.layoutIfNeeded()}
        }}}
    
    func configureSwipeGuesture() {
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(swipeEvent(_:)))
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(swipeEvent(_:)))
        swipeUp.direction = .up
        swipeDown.direction = .down
        self.view.addGestureRecognizer(swipeUp)
        self.view.addGestureRecognizer(swipeDown)}
    
    func commaAdder(price: String?) -> String {
        let integerPrice = Int(price ?? "0") ?? 0
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        let formattedNumber = numberFormatter.string(from: NSNumber(value: integerPrice)) ?? "0"
        return formattedNumber}
    
    func resetCategory() {
        self.currentCategory = .all
        utilityBillButton.backgroundColor = .white
        utilityBillButton.setTitleColor(UIColor.systemGray, for: .normal)
        foodExpensesButton.backgroundColor = .white
        foodExpensesButton.setTitleColor(UIColor.systemGray, for: .normal)
        etcExpensesButton.backgroundColor = .white
        etcExpensesButton.setTitleColor(UIColor.systemGray, for: .normal)
    }
    
    
    //MARK: - Actions
    @objc func swipeEvent(_ swipe: UISwipeGestureRecognizer) {
        if swipe.direction == .up {
            calendar.setScope(.week, animated: true)
            isCalendarWeek = true
        } else if swipe.direction == .down {
            calendar.setScope(.month, animated: true)
            isCalendarWeek = false
        }
    }
    
    @objc func buttonTapped(_ sender: UIButton) {
        switch sender.currentTitle {
        case "공과금":
            if sender.backgroundColor == .white {
                sender.backgroundColor = MyColor.conceptColor.backgroundColor
                sender.setTitleColor(.white, for: .normal)
                self.etcExpensesButton.backgroundColor = .white
                self.etcExpensesButton.setTitleColor(UIColor.systemGray, for: .normal)
                self.foodExpensesButton.backgroundColor = .white
                self.foodExpensesButton.setTitleColor(UIColor.systemGray, for: .normal)
                self.currentCategory = .utilityBill
            } else {
                sender.backgroundColor = .white
                sender.setTitleColor(UIColor.systemGray, for: .normal)
                self.currentCategory = .all
            }
        case "식비":
            if sender.backgroundColor == .white {
                sender.backgroundColor = MyColor.conceptColor.backgroundColor
                sender.setTitleColor(.white, for: .normal)
                self.etcExpensesButton.backgroundColor = .white
                self.etcExpensesButton.setTitleColor(UIColor.systemGray, for: .normal)
                self.utilityBillButton.backgroundColor = .white
                self.utilityBillButton.setTitleColor(UIColor.systemGray, for: .normal)
                self.currentCategory = .food
            } else {
                sender.backgroundColor = .white
                sender.setTitleColor(UIColor.systemGray, for: .normal)
                self.currentCategory = .all
            }
        case "기타":
            if sender.backgroundColor == .white {
                sender.backgroundColor = MyColor.conceptColor.backgroundColor
                sender.setTitleColor(.white, for: .normal)
                self.foodExpensesButton.backgroundColor = .white
                self.foodExpensesButton.setTitleColor(UIColor.systemGray, for: .normal)
                self.utilityBillButton.backgroundColor = .white
                self.utilityBillButton.setTitleColor(UIColor.systemGray, for: .normal)
                self.currentCategory = .etc
            } else {
                sender.backgroundColor = .white
                sender.setTitleColor(MyColor.etc.backgroundColor, for: .normal)
                sender.setTitleColor(UIColor.systemGray, for: .normal)
                self.currentCategory = .all
            }
        default:
            break}}
    

    @objc func addExpenseButtonTapped() {
        let addVC = AddVC()
        let myFormatter = DateFormatter()
        myFormatter.dateFormat = "yyyy-MM-dd"
        guard let date = self.selectedDate else { return }
        addVC.memoDate = myFormatter.string(from: date)
        self.present(addVC, animated: true)
    }
}

//MARK: - FSCalendarDelegateAppearance
extension CalendarVC: FSCalendarDelegateAppearance {
    
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
            return "-" + commaAdder(price: String(total))
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
    
   
    
}

//MARK: - FSCalendarDelegate
extension CalendarVC: FSCalendarDelegate {
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        self.selectedDate = date
        self.currentCategory = .all
        isCalendarWeek = true
        calendar.setScope(.week, animated: true)
        let myFormatter = DateFormatter()
        myFormatter.dateFormat = "M월dd일"
        let selectedDate = myFormatter.string(from: date)
        self.dateString = selectedDate
    }
    
}

//MARK: - FSCalendarDataSource
extension CalendarVC: FSCalendarDataSource {
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        self.calendarHeight.constant = bounds.height
        
    }
    
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
    }
}

extension CalendarVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memo.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ExpenseCell", for: indexPath) as! ExpenseCell
        cell.selectionStyle = .none
        guard !memo.isEmpty else { return cell }
        cell.expense = memo[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let alert = UIAlertController(title: "삭제", message: "삭제하시겠습니까?", preferredStyle: .alert)
            let cancel = UIAlertAction(title: "취소", style: .cancel) { cancel in }
            let success = UIAlertAction(title: "확인", style: .destructive) { success in
                let deleteKey = tableView.cellForRow(at: indexPath) as? ExpenseCell
                MemoFetcher.shared.ref.child("\(deleteKey?.expense?.id ?? "")").removeValue()// 여기에 들어갈 키 값을 어떻게 얻지..?
                self.expenseTV.reloadData()
                self.expenseTV.deleteRows(at: [indexPath], with: .fade)
                self.calendar.reloadData()
            }
            alert.addAction(cancel)
            alert.addAction(success)
            self.present(alert, animated: true)
        }
    }
    

    
    
}

extension CalendarVC: UITableViewDelegate {

    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let addVC = AddVC()
        self.present(addVC, animated: true)
        addVC.expenses = memo[indexPath.row]
    }
//    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
//        let action = UIContextualAction(style: .normal, title: "", handler: { action, view, completionHaldler in
//            let alert = UIAlertController(title: "삭제", message: "삭제하시겠습니까?", preferredStyle: .alert)
//            let cancel = UIAlertAction(title: "취소", style: .cancel) { cancel in }
//            let success = UIAlertAction(title: "확인", style: .destructive) { success in
//                let deleteKey = tableView.cellForRow(at: indexPath) as? ExpenseCell
//                MemoFetcher.shared.ref.child("\(deleteKey?.expense?.id ?? "")").removeValue()// 여기에 들어갈 키 값을 어떻게 얻지..?
//                self.expenseTV.reloadData()
//                self.expenseTV.deleteRows(at: [indexPath], with: .left)
//                self.calendar.reloadData()
//            }
//            alert.addAction(cancel)
//            alert.addAction(success)
//            self.present(alert, animated: true)
//            completionHaldler(true)
//        })
//        action.backgroundColor = UIColor.init(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 0.0)
//        action.image = UIImage(systemName: "trash.fill")?.withTintColor(UIColor(red: 0.53, green: 0.78, blue: 0.74, alpha: 1.00), renderingMode: .alwaysOriginal)
//        return UISwipeActionsConfiguration(actions: [action])
//    }
//    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
//        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completionHandler) in
//            let alert = UIAlertController(title: "삭제", message: "삭제하시겠습니까?", preferredStyle: .alert)
//            let cancel = UIAlertAction(title: "취소", style: .cancel) { cancel in
//                completionHandler(false) // Cancel the delete action
//            }
//            let success = UIAlertAction(title: "확인", style: .destructive) { success in
//                let deleteKey = tableView.cellForRow(at: indexPath) as? ExpenseCell
//                MemoFetcher.shared.ref.child("\(deleteKey?.expense?.id ?? "")").removeValue()
//                self.expenseTV.deleteRows(at: [indexPath], with: .fade)
//                self.expenseTV.reloadData()
//                self.calendar.reloadData()
//                completionHandler(true) // Confirm the delete action
//            }
//            alert.addAction(cancel)
//            alert.addAction(success)
//            self.present(alert, animated: true)
//        }
//
//        deleteAction.image = UIImage(systemName: "trash.fill")
//        deleteAction.backgroundColor = UIColor(red: 0.53, green: 0.78, blue: 0.74, alpha: 1.00)
//
//        return UISwipeActionsConfiguration(actions: [deleteAction])
//    }
    
}


