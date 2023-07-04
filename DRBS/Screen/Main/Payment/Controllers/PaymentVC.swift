
import UIKit
import SnapKit
import Then

class PaymentVC: UIViewController, UISheetPresentationControllerDelegate {
    
    //MARK: - Properties
    let titleLabel = UILabel().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.text = "더치페이"
        $0.font = UIFont.systemFont(ofSize: 30, weight: .bold)
    }
    
    let amountStackView = UIStackView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.axis = .horizontal
        $0.spacing = 28
    }
    
    let amountLabel = UILabel().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.text = "금액"
        $0.font = UIFont.systemFont(ofSize: 20, weight: .bold)
    }
    
    let amountTextField = UITextField().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.textAlignment = .right
        $0.placeholder = "금액을 입력하세요"
        $0.keyboardType = .numberPad
    }
    
    let personStackView = UIStackView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.axis = .horizontal
        $0.spacing = 10
    }
    
    let payCut = UILabel().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.text = "절사"
        $0.font = UIFont.systemFont(ofSize: 20, weight: .bold)
    }
    
    let payCutAmountsText = ["없음", "백원", "천원", "만원"]
    
    var payCutCheckBoxes = [UIButton]()
    
    let shareStackView = UIStackView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.axis = .horizontal
        $0.spacing = 10
    }
    
    let shareLabel = UILabel().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.text = "인원수"
        $0.font = UIFont.systemFont(ofSize: 20, weight: .bold)
    }
    
    let shareTextField = UITextField().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.placeholder = "인원수를 입력하세요"
        $0.keyboardType = .numberPad
        $0.textAlignment = .right
    }
    
    let confirmButton = UIButton().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.setTitle("확인", for: .normal)
        $0.layer.cornerRadius = 10
        $0.isEnabled = false
        $0.backgroundColor = .gray
//      $0.addTarget(self, action: #selector(confirmButtonTapped), for: .touchUpInside)
    }
    
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        //configureNav()
        
        //
        self.amountTextField.addTarget(self, action: #selector(self.checkInputElements), for: .editingChanged)
        self.shareTextField.addTarget(self, action: #selector(self.checkInputElements), for: .editingChanged)
        // button addTarget은 checkboxButtonTapped에 기술.
        
        // 확인 버튼 감시
        self.confirmButton.addTarget(self, action: #selector(confirmButtonTapped), for: .touchUpInside)
    }
    
    //MARK: - Helpers
    func configureUI() {
        // view
        view.backgroundColor = .white
        view.addSubview(titleLabel)
        view.addSubview(amountStackView)
        view.addSubview(personStackView)
        view.addSubview(shareStackView)
        view.addSubview(confirmButton)

        // title
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(50)
            $0.leading.equalTo(20)
            $0.trailing.equalTo(-20)
        }
        
        // amountStackView
        amountStackView.addArrangedSubview(amountLabel)
        amountStackView.addArrangedSubview(amountTextField)
        
        amountStackView.snp.makeConstraints {
            $0.top.equalTo(titleLabel).offset(50)
            $0.leading.equalTo(20)
            $0.trailing.equalTo(-20)
        }

        // personStackView
        personStackView.addArrangedSubview(payCut)
//        payCut.snp.makeConstraints{
//            $0.edges.equalTo(UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 0))
//        }
        for i in 0..<payCutAmountsText.count {
            let checkboxButton = UIButton().then {
                $0.translatesAutoresizingMaskIntoConstraints = false
                $0.setImage(UIImage(systemName: "square"), for: .normal)
                $0.setTitle(payCutAmountsText[i], for: .normal)
                $0.setTitleColor(.black, for: .normal)
                $0.addTarget(self, action: #selector(checkboxButtonTapped(_:)), for: .touchUpInside)
                $0.contentHorizontalAlignment = .left
            }
            
            payCutCheckBoxes.append(checkboxButton)
            personStackView.addArrangedSubview(checkboxButton)
        }
        
        personStackView.snp.makeConstraints {
            $0.top.equalTo(amountStackView).offset(50)
            $0.leading.equalTo(20)
            $0.trailing.equalTo(-20)
        }

        // shareStackView
        shareStackView.addArrangedSubview(shareLabel)
        shareStackView.addArrangedSubview(shareTextField)
        
        shareLabel.snp.makeConstraints{
            $0.edges.equalTo(UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
        }
        shareTextField.snp.makeConstraints{
            $0.edges.equalTo(UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
        }
        
        shareStackView.snp.makeConstraints {
            $0.top.equalTo(personStackView).offset(50)
            $0.leading.equalTo(20)
            $0.trailing.equalTo(-20)
        }
        
        // confirmButton
        confirmButton.snp.makeConstraints{
            $0.height.equalTo(50)
            $0.leading.equalTo(20)
            $0.trailing.equalTo(-20)
            $0.bottom.equalTo(shareStackView).offset(100)
        }
    }


    
    //MARK: - Actions
    @objc func checkboxButtonTapped(_ sender: UIButton) {
        for i in 0..<payCutCheckBoxes.count {
            payCutCheckBoxes[i].setImage(UIImage(systemName: "square"), for: .normal)
        }
        sender.setImage(UIImage(systemName: "checkmark.square"), for: .normal)
        self.checkInputElements()
    }
    
    @objc func checkInputElements(){
        var checkBoxesFlag: Bool = false
        
        for i in 0..<payCutCheckBoxes.count {
            if payCutCheckBoxes[i].imageView?.image == UIImage(systemName: "checkmark.square") {
                checkBoxesFlag = true
            }
        }
        
        if !(self.amountTextField.text?.isEmpty ?? true)
            && !(self.shareTextField.text?.isEmpty ?? true)
            && (checkBoxesFlag){
            updateConfirmButton(willActive: true)
        } else {
            updateConfirmButton(willActive: false)
        }
    }
    
    func updateConfirmButton(willActive: Bool) {
        if(willActive == true) {
            self.confirmButton.backgroundColor = UIColor(red: 0.43, green: 0.19, blue: 0.92, alpha: 1.00)
            self.confirmButton.isEnabled = true
        } else {
            self.confirmButton.backgroundColor = .gray
            self.confirmButton.isEnabled = false
        }
    }
    
    @objc private func confirmButtonTapped() {
        guard let amountText = amountTextField.text,
              let amount = Double(amountText),
              let shareText = shareTextField.text,
              let share = Int(shareText),
              share > 0 else {
            // amountTextField 또는 shareTextField의 입력값이 유효하지 않을 때 처리할 로직 => 차후 구현
              return
        }
        
        var CutAmount: Double = 0
        
        for i in 0..<payCutCheckBoxes.count {
            if payCutCheckBoxes[i].imageView?.image == UIImage(systemName: "checkmark.square") {
                switch i {
                case 0: CutAmount = 1
                case 1: CutAmount = 1000
                case 2: CutAmount = 10000
                case 3: CutAmount = 100000
                default: break
                }
            }
        }
        
        let PayCutRemainder = amount.truncatingRemainder(dividingBy: CutAmount)
        let totalAmount = amount - PayCutRemainder
        let shareAmount = totalAmount / Double(share)
        
        
        let vc = UIViewController()
        vc.view.backgroundColor = .systemBackground
        vc.modalPresentationStyle = .pageSheet
        
        if let sheet = vc.sheetPresentationController {
            sheet.detents = [.medium()] // 지원할 크기 지정
            sheet.delegate = self // 크기 변하는 것 감지
            sheet.prefersGrabberVisible = true // 시트 상단에 그래버 표시 (기본 값은 false)
            // sheet.selectedDetentIdentifier = .large //처음 크기 지정 (기본 값은 가장 작은 크기)
            sheet.preferredCornerRadius = 30
            
            // 레이블 1 추가
            let label1 = UILabel()
            label1.text = "금액"
            vc.view.addSubview(label1)
            
            // 스택뷰 생성
            let stackView = UIStackView()
            stackView.axis = .vertical
            stackView.spacing = 8
            vc.view.addSubview(stackView)
            
            // 레이블 2, 3, 4 추가
            let label2 = UILabel()
            label2.text = "총 \(Int(totalAmount))원 중"
            
//            // 수평 스택뷰 생성
//            let teststack2 = UIStackView()
//            teststack2.axis = .horizontal
//            teststack2.spacing = 8
//            stackView.addArrangedSubview(teststack2)
//
            let label3 = UILabel()
            label3.text = "인당"
            
            let label4 = UILabel()
            label4.text = "\(Int(shareAmount))원"
            
            stackView.addArrangedSubview(label2)
            stackView.addArrangedSubview(label3)
            stackView.addArrangedSubview(label4)
//            teststack2.addArrangedSubview(label3)
//            teststack2.addArrangedSubview(label4)
            
            // 오토레이아웃 설정
            label1.translatesAutoresizingMaskIntoConstraints = false
            stackView.translatesAutoresizingMaskIntoConstraints = false
//            teststack2.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                label1.leadingAnchor.constraint(equalTo: vc.view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
                label1.topAnchor.constraint(equalTo: vc.view.safeAreaLayoutGuide.topAnchor, constant: 16),
                
                stackView.leadingAnchor.constraint(equalTo: vc.view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
                stackView.topAnchor.constraint(equalTo: label1.bottomAnchor, constant: 40),
                stackView.trailingAnchor.constraint(equalTo: vc.view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
                
                label2.heightAnchor.constraint(equalToConstant: 24),
                            
//                teststack2.heightAnchor.constraint(equalToConstant: 24),
//                teststack2.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
//                teststack2.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
               
                label3.heightAnchor.constraint(equalToConstant: 24),
                label4.heightAnchor.constraint(equalToConstant: 24)
            ])
        }
        
        present(vc, animated: true, completion: nil)
        
        // 계산 결과를 표시 => 차후 모달창으로 띄워주기
        print("금액: \(amount), 절사 금액: \(CutAmount / 10), 총 금액: \(totalAmount), 인원수: \(share), 1인당 금액: \(shareAmount), 대표자 금액: \(shareAmount + PayCutRemainder)")
    }
}
