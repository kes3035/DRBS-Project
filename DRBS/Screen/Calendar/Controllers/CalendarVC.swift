
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
    
    private let expenseTV = UITableView().then {
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
        $0.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        $0.backgroundColor = .white
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor(red: 0.88, green: 0.07, blue: 0.60, alpha: 1.00).cgColor
        $0.layer.cornerRadius = 5
        $0.setTitleColor(UIColor(red: 0.88, green: 0.07, blue: 0.60, alpha: 1.00), for: .normal)
        $0.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)}
    
    private lazy var foodExpensesButton = UIButton().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.setTitle("식비", for: .normal)
        $0.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        $0.backgroundColor = .white
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor(red: 0.95, green: 0.40, blue: 0.67, alpha: 1.00).cgColor
        $0.layer.cornerRadius = 5
        $0.setTitleColor(UIColor(red: 0.95, green: 0.40, blue: 0.67, alpha: 1.00), for: .normal)
        $0.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)}
    
    private lazy var etcExpensesButton = UIButton().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.setTitle("기타", for: .normal)
        $0.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        $0.backgroundColor = .white
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor(red: 0.64, green: 0.35, blue: 0.82, alpha: 1.00).cgColor
        $0.layer.cornerRadius = 5
        $0.setTitleColor(UIColor(red: 0.64, green: 0.35, blue: 0.82, alpha: 1.00), for: .normal)
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
    
    //높이조절용 변수
    lazy var calendarTopConstraint =  calendar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100)
    lazy var tvTopConstraint = expenseTV.topAnchor.constraint(equalTo: dateLabelWithButtonSV.bottomAnchor, constant: 50)
    lazy var calendarHeight = calendar.heightAnchor.constraint(equalToConstant: view.frame.height)
    lazy var mainLabelHeight = monthTotalLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0)
    lazy var totalSpentHeight = totalSpentLabel.topAnchor.constraint(equalTo: monthTotalLabel.bottomAnchor, constant: 0)
    lazy var labelButtonHeight = dateLabelWithButtonSV.topAnchor.constraint(equalTo: calendar.bottomAnchor, constant: 150)
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
        
        calendar.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
        }
        
        monthTotalLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(10)
            make.height.equalTo(30)
        }
        
        dateLabelWithButtonSV.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.height.equalTo(60)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.leading.equalTo(dateLabelWithButtonSV).offset(15)
            make.centerY.equalTo(dateLabelWithButtonSV)
            make.height.equalTo(40)}
        
        buttonStack.snp.makeConstraints { make in
            make.centerY.equalTo(dateLabelWithButtonSV)
            make.leading.equalTo(dateLabel).offset(150)
            make.trailing.equalTo(dateLabelWithButtonSV).offset(-15)}
        NSLayoutConstraint.activate([
            calendarTopConstraint,
            calendarHeight,
            mainLabelHeight,
            labelButtonHeight,
            totalSpentHeight,
            totalSpentLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10),
            totalSpentLabel.heightAnchor.constraint(equalToConstant: 60)])}
    
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
        NSLayoutConstraint.activate([
            tvTopConstraint,
            expenseTV.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            expenseTV.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            expenseTV.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    
    
    func calculateTotalExpense(date: String?) -> String {
        guard let date = date else {return ""}
        var total = 0
        for expense in expenseSnapshot {
            if expense.date.contains(date) { total += Int(expense.cost) ?? 0 }
        }
        guard total != 0 else { return "0원"}
        return commaAdder(price:String(total)) + "원"
    }

    func filteringMemo(date: Date?) {
        let myFormatter = DateFormatter()
        myFormatter.dateFormat = "yyyy-MM-dd"
        guard let unwrappedData = date else {
            print("디버깅: filteringMemo(date:_)에러")
            return }
        memo = expenseSnapshot.filter{$0.date == myFormatter.string(from: unwrappedData)}
        expenseTV.reloadData()
    }
    
    func filteringCategory(with category: Category?, date: Date?) {
        let myFormatter = DateFormatter()
        myFormatter.dateFormat = "yyyy-MM-dd"
        guard let unwrappedData = date else {
            print("디버깅: filteringCategory(with:_,date:_)에러")
            return }
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
            DispatchQueue.main.async {
                self.calendar.setScope(.week, animated: true)
                self.calendarTopConstraint.constant = 0
                self.labelButtonHeight.constant = 0
                self.tvTopConstraint.constant = 10
                self.mainLabelHeight.constant = -50
                self.totalSpentHeight.constant = -40
                UIView.animate(withDuration: 0.6) { self.view.layoutIfNeeded() }}
        } else {
            DispatchQueue.main.async {
                self.calendar.setScope(.month, animated: true)
                self.navigationItem.rightBarButtonItem = .none
                self.calendarTopConstraint.constant = 100
                self.tvTopConstraint.constant = 50
                self.mainLabelHeight.constant = 0
                self.totalSpentHeight.constant = 0
                self.labelButtonHeight.constant = 150
                UIView.animate(withDuration: 0.6) { self.view.layoutIfNeeded() }}}}
    
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
        utilityBillButton.setTitleColor(MyColor.utilityBill.backgroundColor, for: .normal)
        foodExpensesButton.backgroundColor = .white
        foodExpensesButton.setTitleColor(MyColor.utilityBill.backgroundColor, for: .normal)
        etcExpensesButton.backgroundColor = .white
        etcExpensesButton.setTitleColor(MyColor.utilityBill.backgroundColor, for: .normal)
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
                sender.backgroundColor = MyColor.utilityBill.backgroundColor
                sender.setTitleColor(.white, for: .normal)
                self.etcExpensesButton.backgroundColor = .white
                self.etcExpensesButton.setTitleColor(MyColor.etc.backgroundColor, for: .normal)
                self.foodExpensesButton.backgroundColor = .white
                self.foodExpensesButton.setTitleColor(MyColor.food.backgroundColor, for: .normal)
                self.currentCategory = .utilityBill
            } else {
                sender.backgroundColor = .white
                sender.setTitleColor(MyColor.utilityBill.backgroundColor, for: .normal)
                self.currentCategory = .all
            }
        case "식비":
            if sender.backgroundColor == .white {
                sender.backgroundColor = MyColor.food.backgroundColor
                sender.setTitleColor(.white, for: .normal)
                self.etcExpensesButton.backgroundColor = .white
                self.etcExpensesButton.setTitleColor(MyColor.etc.backgroundColor, for: .normal)
                self.utilityBillButton.backgroundColor = .white
                self.utilityBillButton.setTitleColor(MyColor.utilityBill.backgroundColor, for: .normal)
                self.currentCategory = .food
            } else {
                sender.backgroundColor = .white
                sender.setTitleColor(MyColor.food.backgroundColor, for: .normal)
                self.currentCategory = .all
            }
        case "기타":
            if sender.backgroundColor == .white {
                sender.backgroundColor = MyColor.etc.backgroundColor
                sender.setTitleColor(.white, for: .normal)
                self.foodExpensesButton.backgroundColor = .white
                self.foodExpensesButton.setTitleColor(MyColor.food.backgroundColor, for: .normal)
                self.utilityBillButton.backgroundColor = .white
                self.utilityBillButton.setTitleColor(MyColor.utilityBill.backgroundColor, for: .normal)
                self.currentCategory = .etc
            } else {
                sender.backgroundColor = .white
                sender.setTitleColor(MyColor.etc.backgroundColor, for: .normal)
                self.currentCategory = .all
            }
        default:
            break
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
//    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
//        return UITableView.automaticDimension
//    }
    
    //오웬님이 보셔야할 곳!
    //테이블뷰 셀을 터치했을 때, 기존에 데이터를 넘겨주면서 화면을 띄우는 코드!
    /*
     구현해야할 내용
      AddVC에서 올라온 데이터의 변화가 생길 시, 서버에 있는 데이터를 변화시켜야함
      그러기 위해서는 내가 지금 사용하고 있는 셀이 서버의 어떤 경로로 저장되어있는지를 알아야함
      현재 데이터가 저장될 때 childByAutoId()로 자동으로 키를 생성해서 저장하는데
      Expense 구조체에서 id를 기존 방식말고 이 childByAutoId()로 생성된 키를 저장해야할 것 같고,
      그 키로 접근해서 ref.observe(.childChanged) 를 이용해서 데이터 변화를 업데이트 해줘야 함!!
     아
     
     아직 구현안된 부분은
     AddVC에서 하나라도 빠져있으면 버튼이 비활성화 된다던가 텍스트필드에서 숫자만 입력 가능하게 한다던가
     이런 부분은 미구현상태!
     */
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let addVC = AddVC()
        self.present(addVC, animated: true)
        addVC.expenses = memo[indexPath.row]
    }
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .normal, title: "", handler: { action, view, completionHaldler in
            let alert = UIAlertController(title: "삭제", message: "삭제하시겠습니까?", preferredStyle: .alert)
            let cancel = UIAlertAction(title: "취소", style: .cancel) { cancel in }
            let success = UIAlertAction(title: "확인", style: .destructive) { success in
                let deleteKey = tableView.cellForRow(at: indexPath) as? ExpenseCell
                MemoFetcher.shared.ref.child("\(deleteKey?.expense?.id ?? "")").removeValue()// 여기에 들어갈 키 값을 어떻게 얻지..?
                self.expenseTV.reloadData()
                self.expenseTV.deleteRows(at: [indexPath], with: .left)
                self.calendar.reloadData()
            }
            alert.addAction(cancel)
            alert.addAction(success)
            self.present(alert, animated: true)
            completionHaldler(true)
        })
        action.backgroundColor = UIColor.init(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 0.0)
        action.image = UIImage(systemName: "trash.fill")?.withTintColor(UIColor(red: 0.53, green: 0.78, blue: 0.74, alpha: 1.00), renderingMode: .alwaysOriginal)
        return UISwipeActionsConfiguration(actions: [action])
    }
}


