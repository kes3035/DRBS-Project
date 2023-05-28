//
//  AddVC.swift
//  DRBS
//
//  Created by 김은상 on 2023/04/08.
//

import UIKit
import FirebaseDatabase
import FirebaseCore
import FirebaseAnalytics

class AddVC: UIViewController {
    //MARK: - Properties
    private let mainLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "지출"
        label.font = UIFont.systemFont(ofSize: 30)
        label.textColor = .black
        label.textAlignment = .left
        return label
    }()
    
    private lazy var expenseTextField: UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.placeholder = "지출 금액을 입력하세요."
        //        tf.addBottomBorder()
        
        return tf
    }()
    
    private lazy var categoryView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    
    private let categoryLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "카테고리"
        label.font = UIFont.systemFont(ofSize: 25)
        label.textColor = UIColor.darkGray
        return label
    }()
    
    private let categoryCaseLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "미분류"
        label.textColor = UIColor.darkGray
        return label
    }()
    
    private lazy var categoryButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "chevron.right"), for: .normal)
        button.tintColor = .darkGray
        button.addTarget(self, action: #selector(categoryButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var expenseView: UIView = {
       let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    
    private let expenseLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "지출내역"
        label.font = UIFont.systemFont(ofSize: 25)
        label.textColor = .darkGray
        return label
    }()
    
    
    private lazy var textView: UITextView = {
       let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.textColor = .black
        return textView
    }()
    
    private lazy var memoView: UIView = {
       let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    
    private let memoLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "메모"
        label.font = UIFont.systemFont(ofSize: 25)
        label.textColor = .darkGray
        return label
    }()
    
    
    private lazy var memoTextView: UITextView = {
       let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.textColor = .black
        return textView
    }()
    
    private lazy var saveButton: UIButton = {
       let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("저장", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 25)
        button.backgroundColor = UIColor(red: 0.43, green: 0.19, blue: 0.92, alpha: 1.00)
        button.layer.cornerRadius = 8
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        return button
    }()
    
    var expenses: Expense?
    var memoDate: String?
    var ref = Database.database().reference()
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureUI()
//        configureUIWithData()
        setupConstraints()
        setupTextView()
        //        setupTFBorder()
    }
    
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
        categoryLabel.text = "\(expenses.category)"
        expenseTextField.text = expenses.cost
        memoTextView.text = expenses.memo}
    

    
    func setupTextView() { textView.delegate = self }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            mainLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 30),
            mainLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 15),
            mainLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -15),
            mainLabel.heightAnchor.constraint(equalToConstant: 30)])
        
        NSLayoutConstraint.activate([
            expenseTextField.topAnchor.constraint(equalTo: mainLabel.bottomAnchor, constant: 10),
            expenseTextField.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 25),
            expenseTextField.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -25),
            expenseTextField.heightAnchor.constraint(equalToConstant: 50)])
        
        NSLayoutConstraint.activate([
            categoryView.topAnchor.constraint(equalTo: expenseTextField.bottomAnchor, constant: 30),
            categoryView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 15),
            categoryView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -15),
            categoryView.heightAnchor.constraint(equalToConstant: 80)])
        
        NSLayoutConstraint.activate([
            categoryLabel.centerYAnchor.constraint(equalTo: categoryView.centerYAnchor),
            categoryLabel.leadingAnchor.constraint(equalTo: categoryView.leadingAnchor, constant: 15),
            categoryLabel.widthAnchor.constraint(equalToConstant: 100)])
        
        NSLayoutConstraint.activate([
            categoryCaseLabel.centerYAnchor.constraint(equalTo: categoryView.centerYAnchor),
            categoryCaseLabel.leadingAnchor.constraint(equalTo: categoryLabel.trailingAnchor, constant: 30),
            categoryCaseLabel.widthAnchor.constraint(equalToConstant: 100)])
        
        NSLayoutConstraint.activate([
            categoryButton.centerYAnchor.constraint(equalTo: categoryView.centerYAnchor),
            categoryButton.trailingAnchor.constraint(equalTo: categoryView.trailingAnchor, constant: -15),
            categoryView.widthAnchor.constraint(equalToConstant: 50)])
        
        NSLayoutConstraint.activate([
            expenseView.topAnchor.constraint(equalTo: categoryView.bottomAnchor, constant: 0),
            expenseView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 15),
            expenseView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -15),
            expenseView.heightAnchor.constraint(equalToConstant: 80)])
        
        NSLayoutConstraint.activate([
            expenseLabel.centerYAnchor.constraint(equalTo: expenseView.centerYAnchor),
            expenseLabel.leadingAnchor.constraint(equalTo: expenseView.leadingAnchor, constant: 15),
            expenseLabel.widthAnchor.constraint(equalToConstant: 100)])
        
        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: expenseView.topAnchor, constant: 10),
            textView.trailingAnchor.constraint(equalTo: expenseView.trailingAnchor, constant: -15),
            textView.leadingAnchor.constraint(equalTo: expenseLabel.trailingAnchor, constant: 15),
            textView.bottomAnchor.constraint(equalTo: expenseView.bottomAnchor, constant: -10)])
        
        NSLayoutConstraint.activate([
            memoView.topAnchor.constraint(equalTo: expenseView.bottomAnchor, constant: 0),
            memoView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 15),
            memoView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -15),
            memoView.heightAnchor.constraint(equalToConstant: 80)])
        
        NSLayoutConstraint.activate([
            memoLabel.centerYAnchor.constraint(equalTo: memoView.centerYAnchor),
            memoLabel.leadingAnchor.constraint(equalTo: memoView.leadingAnchor, constant: 15),
            memoLabel.widthAnchor.constraint(equalToConstant: 100)])
        
        NSLayoutConstraint.activate([
            memoTextView.topAnchor.constraint(equalTo: memoView.topAnchor, constant: 10),
            memoTextView.trailingAnchor.constraint(equalTo: memoView.trailingAnchor, constant: -15),
            memoTextView.leadingAnchor.constraint(equalTo: memoLabel.trailingAnchor, constant: 15),
            memoTextView.bottomAnchor.constraint(equalTo: memoView.bottomAnchor, constant: -10)])
        
        NSLayoutConstraint.activate([
            saveButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 15),
            saveButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -15),
            saveButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -150),
            saveButton.heightAnchor.constraint(equalToConstant: 50)])}
    
  
    
    
    //MARK: - Actions
    @objc func categoryButtonTapped() {
        print("디버깅: 카테고리 버튼 눌림...")
        let alert = UIAlertController(title: "카테고리를 선택하세요.", message: "", preferredStyle: .actionSheet)
        let utility = UIAlertAction(title: "공과금", style: .default) { success in
            self.categoryCaseLabel.text = "공과금"}
        let food = UIAlertAction(title: "식비", style: .default) { success in
            self.categoryCaseLabel.text = "식비"}
        let etc = UIAlertAction(title: "기타소비", style: .default) { success in
            self.categoryCaseLabel.text = "기타소비"}
        let cancel = UIAlertAction(title: "취소", style: .cancel) { cancel in }
        alert.addAction(utility)
        alert.addAction(food)
        alert.addAction(etc)
        alert.addAction(cancel)
        self.present(alert, animated: true)}
    
    @objc func saveButtonTapped() {
        let saveData = Expense(cost: self.expenseTextField.text ?? "",
                               category: categoryCaseLabel.text ?? "",
                               expenseText: self.textView.text ?? "지출내역이 없습니다.",
                               memo: self.memoTextView.text ?? "메모가 없습니다.")
        ref.child("메모").child("날짜").setValue(memoDate)
        ref.child("메모").child("지출").setValue(saveData.doDictionary)
        self.dismiss(animated: true, completion: nil)}}



//MARK: - Extensions
extension AddVC: UITextViewDelegate {
    
}
