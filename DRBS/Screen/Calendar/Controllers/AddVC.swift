
import UIKit
import FirebaseDatabase
import FirebaseCore
import FirebaseAnalytics
import Then
import SnapKit

class AddVC: UIViewController {
    //MARK: - Properties
    private let mainLabel = UILabel().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.text = "지출"
        $0.font = UIFont.systemFont(ofSize: 30)
        $0.textColor = .black
        $0.textAlignment = .left
    }
    
    private lazy var expenseTextField = UITextField().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.placeholder = "지출 금액을 입력하세요."
    }
    
    private lazy var categoryView = UIView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = .clear
    }
    
    private let categoryLabel = UILabel().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.text = "카테고리"
        $0.font = UIFont.systemFont(ofSize: 25)
        $0.textColor = UIColor.darkGray
    }
    
    private let categoryCaseLabel = UILabel().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.text = "미분류"
        $0.textColor = UIColor.darkGray
    }
    
    private lazy var categoryButton = UIButton().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.setImage(UIImage(systemName: "chevron.right"), for: .normal)
        $0.tintColor = .darkGray
        $0.addTarget(self, action: #selector(categoryButtonTapped), for: .touchUpInside)
    }
    
    private lazy var expenseView = UIView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = .clear
    }
    
    private let expenseLabel = UILabel().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.text = "지출내역"
        $0.font = UIFont.systemFont(ofSize: 25)
        $0.textColor = .darkGray
    }
    
    
    private lazy var textView = UITextView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.textColor = .black
    }
    
    private lazy var memoView = UIView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = .clear
    }
    
    private let memoLabel = UILabel().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.text = "메모"
        $0.font = UIFont.systemFont(ofSize: 25)
        $0.textColor = .darkGray
    }
    
    
    private lazy var memoTextView = UITextView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.textColor = .black
    }
    
    private lazy var saveButton = UIButton().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.setTitle("저장", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.titleLabel?.font = UIFont.boldSystemFont(ofSize: 25)
        $0.backgroundColor = UIColor(red: 0.43, green: 0.19, blue: 0.92, alpha: 1.00)
        $0.layer.cornerRadius = 8
        $0.clipsToBounds = true
        $0.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
    }
    
    var expenses: Expense? {
        didSet {
//            self.categoryLabel.text = expenses?.category
//            self.expenseTextField.text = expenses?.cost
//            self.memoTextView.text = expenses?.memo
//            self.textView.text = expenses?.expenseText
            print("현재 expenses는 \(self.expenses)")
            configureUIWithData()
        }
    }
    var memoDate: String?
    var ref = Database.database().reference()

    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureUI()
        setupConstraints()
        setupTextView()}
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        expenseTextField.addBottomBorder()
        categoryView.addTopBorder()
        expenseView.addTopBorder()
        memoView.addTopBorder()}
    
    
    //MARK: - Helpers
    
    func configureUI() {
        
        view.addSubview(mainLabel)
        view.addSubview(expenseTextField)
        expenseTextField.delegate = self
        view.addSubview(categoryView)
        view.addSubview(expenseView)
        view.addSubview(memoView)
        view.addSubview(saveButton)
        categoryView.addSubview(categoryLabel)
        categoryView.addSubview(categoryCaseLabel)
        categoryView.addSubview(categoryButton)
        expenseView.addSubview(expenseLabel)
        expenseView.addSubview(textView)
        memoView.addSubview(memoLabel)
        memoView.addSubview(memoTextView)}
    
    func configureUIWithData() {
        guard let expenses = expenses else {
            categoryLabel.text = "미분류"
            expenseTextField.text = ""
            memoTextView.text = ""
            return}
        //        categoryLabel.text = "\(expenses.category)"
        //        expenseTextField.text = expenses.cost
        //        memoTextView.text = expenses.memo}
        self.categoryLabel.text = "\(expenses.category)"
        self.expenseTextField.text = expenses.cost
        self.memoTextView.text = expenses.memo
        self.textView.text = expenses.expenseText
    }
    
    func setupDatabase() {
        
    }
    
    func setupTextView() { textView.delegate = self }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            mainLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 30),
            mainLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 15),
            mainLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -15),
            mainLabel.heightAnchor.constraint(equalToConstant: 30),
        
            expenseTextField.topAnchor.constraint(equalTo: mainLabel.bottomAnchor, constant: 10),
            expenseTextField.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 25),
            expenseTextField.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -25),
            expenseTextField.heightAnchor.constraint(equalToConstant: 50),
            
            categoryView.topAnchor.constraint(equalTo: expenseTextField.bottomAnchor, constant: 30),
            categoryView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 15),
            categoryView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -15),
            categoryView.heightAnchor.constraint(equalToConstant: 80),
            
            categoryLabel.centerYAnchor.constraint(equalTo: categoryView.centerYAnchor),
            categoryLabel.leadingAnchor.constraint(equalTo: categoryView.leadingAnchor, constant: 15),
            categoryLabel.widthAnchor.constraint(equalToConstant: 100),
            
            categoryCaseLabel.centerYAnchor.constraint(equalTo: categoryView.centerYAnchor),
            categoryCaseLabel.leadingAnchor.constraint(equalTo: categoryLabel.trailingAnchor, constant: 30),
            categoryCaseLabel.widthAnchor.constraint(equalToConstant: 100),
            
            categoryButton.centerYAnchor.constraint(equalTo: categoryView.centerYAnchor),
            categoryButton.trailingAnchor.constraint(equalTo: categoryView.trailingAnchor, constant: -15),
            categoryView.widthAnchor.constraint(equalToConstant: 50),
            
            expenseView.topAnchor.constraint(equalTo: categoryView.bottomAnchor, constant: 0),
            expenseView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 15),
            expenseView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -15),
            expenseView.heightAnchor.constraint(equalToConstant: 80),
            
            expenseLabel.centerYAnchor.constraint(equalTo: expenseView.centerYAnchor),
            expenseLabel.leadingAnchor.constraint(equalTo: expenseView.leadingAnchor, constant: 15),
            expenseLabel.widthAnchor.constraint(equalToConstant: 100),
            
            textView.topAnchor.constraint(equalTo: expenseView.topAnchor, constant: 10),
            textView.trailingAnchor.constraint(equalTo: expenseView.trailingAnchor, constant: -15),
            textView.leadingAnchor.constraint(equalTo: expenseLabel.trailingAnchor, constant: 15),
            textView.bottomAnchor.constraint(equalTo: expenseView.bottomAnchor, constant: -10),
            
            memoView.topAnchor.constraint(equalTo: expenseView.bottomAnchor, constant: 0),
            memoView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 15),
            memoView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -15),
            memoView.heightAnchor.constraint(equalToConstant: 80),
            
            memoLabel.centerYAnchor.constraint(equalTo: memoView.centerYAnchor),
            memoLabel.leadingAnchor.constraint(equalTo: memoView.leadingAnchor, constant: 15),
            memoLabel.widthAnchor.constraint(equalToConstant: 100),
            
            memoTextView.topAnchor.constraint(equalTo: memoView.topAnchor, constant: 10),
            memoTextView.trailingAnchor.constraint(equalTo: memoView.trailingAnchor, constant: -15),
            memoTextView.leadingAnchor.constraint(equalTo: memoLabel.trailingAnchor, constant: 15),
            memoTextView.bottomAnchor.constraint(equalTo: memoView.bottomAnchor, constant: -10),
            
            saveButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 15),
            saveButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -15),
            saveButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -150),
            saveButton.heightAnchor.constraint(equalToConstant: 50)])}

    
    
    
    //MARK: - Actions
    @objc func categoryButtonTapped() {
        let alert = UIAlertController(title: "카테고리를 선택하세요.", message: "", preferredStyle: .actionSheet)
        let utility = UIAlertAction(title: "공과금", style: .default) { success in
            self.categoryCaseLabel.text = "공과금"}
        let food = UIAlertAction(title: "식비", style: .default) { success in
            self.categoryCaseLabel.text = "식비"}
        let etc = UIAlertAction(title: "기타", style: .default) { success in
            self.categoryCaseLabel.text = "기타"}
        let cancel = UIAlertAction(title: "취소", style: .cancel) { cancel in }
        alert.addAction(utility)
        alert.addAction(food)
        alert.addAction(etc)
        alert.addAction(cancel)
        self.present(alert, animated: true)}
    
    @objc func saveButtonTapped() {
        
        guard let unwrappedExpenses = self.expenses else {
            let autoId = MemoFetcher.shared.ref.childByAutoId()
            let key = autoId.key ?? ""
            let saveData = Expense(cost: self.expenseTextField.text ?? "",
                                   category: categoryCaseLabel.text ?? "",
                                   expenseText: self.textView.text ?? "지출내역이 없습니다.",
                                   memo: self.memoTextView.text ?? "메모가 없습니다.",
                                   date: memoDate ?? "",
                                   id: key)
            do {
                let encoder = JSONEncoder()
                let jsonData = try encoder.encode(saveData)
                print(jsonData)
                guard let jsonObject = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String:Any] else {
                    return
                }
                print(jsonObject)
                MemoFetcher.shared.ref.child(key).setValue(jsonObject)
            } catch let error { print("\(error.localizedDescription)") }
            self.dismiss(animated: true, completion: nil)
            return
        }
        let saveData = Expense(cost: self.expenseTextField.text ?? "",
                               category: categoryCaseLabel.text ?? "",
                               expenseText: self.textView.text ?? "지출내역이 없습니다.",
                               memo: self.memoTextView.text ?? "메모가 없습니다.",
                               date: self.expenses?.date ?? "",
                               id: self.expenses?.id ?? "")
        do {
            let encoder = JSONEncoder()
            let jsonData = try encoder.encode(saveData)
            print(jsonData)
            guard let jsonObject = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String:Any] else {
                return
            }
            print(jsonObject)
            MemoFetcher.shared.ref.child("\(self.expenses?.id ?? "")").setValue(jsonObject)

        } catch let error { print("\(error.localizedDescription)") }

        self.dismiss(animated: true, completion: nil)
        
        
        
        
    }
    
}



//MARK: - Extensions
extension AddVC: UITextViewDelegate {
    
}

extension AddVC: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if Int(string) != nil || string == "" {
            return true
        }
        return false
    }
}




