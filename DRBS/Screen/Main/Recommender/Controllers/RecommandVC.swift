//
//  RecommandVC.swift
//  DRBS
//
//  Created by 김은상 on 2023/03/18.
//

import UIKit
import SideMenu
import Then
import SnapKit

class RecommandVC: UIViewController {
    
 
    @IBOutlet var imageView: UIImageView!
//    @IBOutlet var spinWheelView: SpinWheelView!
    
    
    
    //Models와 소통하기위한 변수
    var roulletManager = RoulletModel()
    var colorSet = ColorSet()
    
    var allFoodButton: UIButton!
    var chineseFoodButton: UIButton!
    var japaneseFoodButton: UIButton!
    var koreanFoodButton: UIButton!
    var westernFoodButton: UIButton!
    var vietnamFoodButton: UIButton!
    var mexicoFoodButton: UIButton!
    var healthyFoodButton: UIButton!
    var nameIndex: Int = 0
    var indexPickerView: UIPickerView!
    
    
    private lazy var spinWheelView = SpinWheelView().then {
          $0.translatesAutoresizingMaskIntoConstraints = false
      }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureNav()
        
        setButton()
        pickerViewSetUp()
        spinWheelViewSetUp()

    }
    
    func spinWheelViewSetUp() {
        view.addSubview(spinWheelView)
        spinWheelView.delegate = self
        spinWheelView.items = randomItems()
        spinWheelView.ringImage = testRingImage()
        spinWheelView.ringLineWidth = 10
        
        spinWheelView.snp.makeConstraints { make in
            make.height.equalTo(300)
            make.width.equalTo(300)
            make.top.equalToSuperview().offset(310)
            make.centerX.equalToSuperview()
        }
    }
    
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
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }

    func setUpFood() -> [String] {
        switch nameIndex {
        case 0:
            return roulletManager.allFood
        case 1:
            return roulletManager.koreaFood
        case 2:
            return roulletManager.chineseFood
        case 3:
            return roulletManager.japaneseFood
        case 4:
            return roulletManager.westernFood
        default:
            return roulletManager.allFood
        }
    }
    
    
    //MARK: 아이템을 랜덤으로 섞어주는 함수
    func randomItems() -> [SpinWheelItemModel] {
        let shuffledColor = colorSet.colors.shuffled()
        return shuffledColor.compactMap({ color in
            let index = colorSet.colors.firstIndex(of: color)!
            return SpinWheelItemModel(text: roulletManager.texts[index], backgroundColor: color, value: 1000)
        })
    }
    
    // MARK: 추천버턴을 눌렀을 때, 룰렛의 text만 바뀌게 하는 코드
    func randomText() -> [SpinWheelItemModel] {
        let oneColor = colorSet.colors
        return oneColor.compactMap { color in
            let index = colorSet.colors.firstIndex(of: color)!
            return SpinWheelItemModel(text: roulletManager.texts[index], backgroundColor: color, value: 1000)
        }
    }
    func pickerViewSetUp() {
        indexPickerView = UIPickerView()
        indexPickerView.frame = CGRect(x: 44, y: 638.67, width: 0.1, height: 216)
        view.addSubview(indexPickerView)
        
        indexPickerView.delegate = self
        indexPickerView.dataSource = self
    }
    
    func setButton() {
        // MARK: Start버튼 관련 설정
        _ = UIButton(type: .system).then {
            $0.setTitle("Start", for: .normal)
            $0.setTitleColor(.white, for: .normal)
            $0.backgroundColor = UIColor.systemBlue
            $0.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
            $0.addTarget(self, action: #selector(spinButtonTapped), for: .touchUpInside)
            view.addSubview($0)
            $0.layer.cornerRadius = 7
            $0.layer.masksToBounds = true
            
            
            // 버튼 오토레이아웃
            $0.snp.makeConstraints { make in
                make.height.equalTo(30)
                make.width.equalTo(80)
                make.bottom.equalToSuperview().offset(-150)
                make.centerX.equalToSuperview()
            }
        }
        
        // MARK: 전체버튼
        allFoodButton = UIButton(type: .system).then {
            $0.setTitle("전체", for: .normal)
            $0.setTitleColor(.black, for: .normal)
            $0.backgroundColor = UIColor.systemGray4
            $0.titleLabel?.font = UIFont.systemFont(ofSize: 15)
            $0.addTarget(self, action: #selector(allButtonTapped), for: .touchUpInside)
            view.addSubview($0)
            $0.layer.cornerRadius = 10
            $0.layer.masksToBounds = true
            
            $0.snp.makeConstraints { make in
                make.height.equalTo(40)
                make.width.equalTo(70)
                make.top.equalToSuperview().offset(125)
                make.leading.equalToSuperview().offset(32)
            }
        }
        
        // MARK: 한식버튼
        koreanFoodButton = UIButton(type: .system).then {
            $0.setTitle("한식", for: .normal)
            $0.setTitleColor(.black, for: .normal)
            $0.backgroundColor = UIColor.systemGray4
            $0.titleLabel?.font = UIFont.systemFont(ofSize: 15)
            $0.addTarget(self, action: #selector(koreanFoodButtonTapped), for: .touchUpInside)
            view.addSubview($0)
            $0.layer.cornerRadius = 10
            $0.layer.masksToBounds = true
            
            $0.snp.makeConstraints { make in
                make.height.equalTo(40)
                make.width.equalTo(70)
                make.top.equalToSuperview().offset(125)
                make.leading.equalToSuperview().offset(117)
            }
        }
        
        // MARK: 중식버튼
        chineseFoodButton = UIButton(type: .system).then {
            $0.setTitle("중식", for: .normal)
            $0.setTitleColor(.black, for: .normal)
            $0.backgroundColor = UIColor.systemGray4
            $0.titleLabel?.font = UIFont.systemFont(ofSize: 15)
            $0.addTarget(self, action: #selector(chineseFoodButtonTapped), for: .touchUpInside)
            view.addSubview($0)
            $0.layer.cornerRadius = 10
            $0.layer.masksToBounds = true
            
            $0.snp.makeConstraints { make in
                make.height.equalTo(40)
                make.width.equalTo(70)
                make.top.equalToSuperview().offset(125)
                make.leading.equalToSuperview().offset(202)
            }
        }
        
        // MARK: 일식버튼
        japaneseFoodButton = UIButton(type: .system).then {
            $0.setTitle("일식", for: .normal)
            $0.setTitleColor(.black, for: .normal)
            $0.backgroundColor = UIColor.systemGray4
            $0.titleLabel?.font = UIFont.systemFont(ofSize: 15)
            $0.addTarget(self, action: #selector(japaneseFoodButtonTapped), for: .touchUpInside)
            view.addSubview($0)
            $0.layer.cornerRadius = 10
            $0.layer.masksToBounds = true
            
            $0.snp.makeConstraints { make in
                make.height.equalTo(40)
                make.width.equalTo(70)
                make.top.equalToSuperview().offset(125)
                make.leading.equalToSuperview().offset(287)
            }
        }
        
        // MARK: 양식버튼
        westernFoodButton = UIButton(type: .system).then {
            $0.setTitle("양식", for: .normal)
            $0.setTitleColor(.black, for: .normal)
            $0.backgroundColor = UIColor.systemGray4
            $0.titleLabel?.font = UIFont.systemFont(ofSize: 15)
            $0.addTarget(self, action: #selector(westernFoodButtonTapped), for: .touchUpInside)
            view.addSubview($0)
            $0.layer.cornerRadius = 10
            $0.layer.masksToBounds = true
            
            $0.snp.makeConstraints { make in
                make.height.equalTo(40)
                make.width.equalTo(70)
                make.top.equalToSuperview().offset(175)
                make.leading.equalToSuperview().offset(32)
            }
        }
        
        // MARK: 베트남 버튼
        vietnamFoodButton = UIButton(type: .system).then {
            $0.setTitle("베트남", for: .normal)
            $0.setTitleColor(.black, for: .normal)
            $0.backgroundColor = UIColor.systemGray4
            $0.titleLabel?.font = UIFont.systemFont(ofSize: 15)
            $0.addTarget(self, action: #selector(vetnamFoodButtonTapped), for: .touchUpInside)
            view.addSubview($0)
            $0.layer.cornerRadius = 10
            $0.layer.masksToBounds = true
            
            $0.snp.makeConstraints { make in
                make.height.equalTo(40)
                make.width.equalTo(70)
                make.top.equalToSuperview().offset(175)
                make.leading.equalToSuperview().offset(117)
            }
        }
        
        // MARK: 멕시코 버튼
        mexicoFoodButton = UIButton(type: .system).then {
            $0.setTitle("멕시코", for: .normal)
            $0.setTitleColor(.black, for: .normal)
            $0.backgroundColor = UIColor.systemGray4
            $0.titleLabel?.font = UIFont.systemFont(ofSize: 15)
            $0.addTarget(self, action: #selector(mexicoFoodButtonTapped), for: .touchUpInside)
            view.addSubview($0)
            $0.layer.cornerRadius = 10
            $0.layer.masksToBounds = true
            
            $0.snp.makeConstraints { make in
                make.height.equalTo(40)
                make.width.equalTo(70)
                make.top.equalToSuperview().offset(175)
                make.leading.equalToSuperview().offset(202)
            }
        }
        
        // MARK: 건강식 버튼
        healthyFoodButton = UIButton(type: .system).then {
            $0.setTitle("건강식", for: .normal)
            $0.setTitleColor(.black, for: .normal)
            $0.backgroundColor = UIColor.systemGray4
            $0.titleLabel?.font = UIFont.systemFont(ofSize: 15)
            $0.addTarget(self, action: #selector(healthyFoodButtonTapped), for: .touchUpInside)
            view.addSubview($0)
            $0.layer.cornerRadius = 10
            $0.layer.masksToBounds = true
            
            $0.snp.makeConstraints { make in
                make.height.equalTo(40)
                make.width.equalTo(70)
                make.top.equalToSuperview().offset(175)
                make.leading.equalToSuperview().offset(287)
            }
        }
        
        // MARK: 메뉴를 골라주는 버튼
        _ = UIButton(type: .system).then {
            $0.setTitle("메뉴를 골라줘", for: .normal)
            $0.setTitleColor(.white, for: .normal)
            //            $0.backgroundColor = UIColor(red: 0.43, green: 0.19, blue: 0.92, alpha: 1.00)
            $0.backgroundColor = UIColor.systemBlue
            $0.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
            $0.addTarget(self, action: #selector(recommendButtonTapped), for: .touchUpInside)
            view.addSubview($0)
            $0.layer.cornerRadius = 8
            $0.layer.masksToBounds = true
            
            $0.snp.makeConstraints { make in
                make.height.equalTo(45)
                make.width.equalTo(375)
                make.top.equalToSuperview().offset(225)
                make.centerX.equalToSuperview()
            }
        }
    }
    
    //MARK: 버튼기능 구현
    @objc func spinButtonTapped() {
        let index = indexPickerView.selectedRow(inComponent: 0)
        print("spin wheel \(spinWheelView.items[index].text)")
        spinWheelView.spinWheel(index)
        
    }
    
    @objc func allButtonTapped(sender: UIButton) {
        sender.backgroundColor = UIColor.darkGray
        sender.setTitleColor(.white, for: .normal)
        nameIndex = 1
        print("nameIndex: \(nameIndex)")
        
        chineseFoodButton.backgroundColor = UIColor.systemGray3
        chineseFoodButton.setTitleColor(.black, for: .normal)
        koreanFoodButton.backgroundColor = UIColor.systemGray3
        koreanFoodButton.setTitleColor(.black, for: .normal)
        japaneseFoodButton.backgroundColor = UIColor.systemGray3
        japaneseFoodButton.setTitleColor(.black, for: .normal)
        westernFoodButton.backgroundColor = UIColor.systemGray3
        westernFoodButton.setTitleColor(.black, for: .normal)
        vietnamFoodButton.backgroundColor = UIColor.systemGray3
        vietnamFoodButton.setTitleColor(.black, for: .normal)
        mexicoFoodButton.backgroundColor = UIColor.systemGray3
        mexicoFoodButton.setTitleColor(.black, for: .normal)
        healthyFoodButton.backgroundColor = UIColor.systemGray3
        healthyFoodButton.setTitleColor(.black, for: .normal)
    }
    
    @objc func koreanFoodButtonTapped(sender: UIButton) {
        sender.backgroundColor = UIColor.darkGray
        sender.setTitleColor(.white, for: .normal)
        nameIndex = 2
        print("nameIndex: \(nameIndex)")
        
        allFoodButton.backgroundColor = UIColor.systemGray3
        allFoodButton.setTitleColor(.black, for: .normal)
        chineseFoodButton.backgroundColor = UIColor.systemGray3
        chineseFoodButton.setTitleColor(.black, for: .normal)
        japaneseFoodButton.backgroundColor = UIColor.systemGray3
        japaneseFoodButton.setTitleColor(.black, for: .normal)
        westernFoodButton.backgroundColor = UIColor.systemGray3
        westernFoodButton.setTitleColor(.black, for: .normal)
        vietnamFoodButton.backgroundColor = UIColor.systemGray3
        vietnamFoodButton.setTitleColor(.black, for: .normal)
        mexicoFoodButton.backgroundColor = UIColor.systemGray3
        mexicoFoodButton.setTitleColor(.black, for: .normal)
        healthyFoodButton.backgroundColor = UIColor.systemGray3
        healthyFoodButton.setTitleColor(.black, for: .normal)
    }
    
    @objc func chineseFoodButtonTapped(sender: UIButton) {
        sender.backgroundColor = UIColor.darkGray
        sender.setTitleColor(.white, for: .normal)
        nameIndex = 3
        print("nameIndex: \(nameIndex)")
        
        allFoodButton.backgroundColor = UIColor.systemGray3
        allFoodButton.setTitleColor(.black, for: .normal)
        koreanFoodButton.backgroundColor = UIColor.systemGray3
        koreanFoodButton.setTitleColor(.black, for: .normal)
        japaneseFoodButton.backgroundColor = UIColor.systemGray3
        japaneseFoodButton.setTitleColor(.black, for: .normal)
        westernFoodButton.backgroundColor = UIColor.systemGray3
        westernFoodButton.setTitleColor(.black, for: .normal)
        vietnamFoodButton.backgroundColor = UIColor.systemGray3
        vietnamFoodButton.setTitleColor(.black, for: .normal)
        mexicoFoodButton.backgroundColor = UIColor.systemGray3
        mexicoFoodButton.setTitleColor(.black, for: .normal)
        healthyFoodButton.backgroundColor = UIColor.systemGray3
        healthyFoodButton.setTitleColor(.black, for: .normal)
    }
    
    @objc func japaneseFoodButtonTapped(sender: UIButton) {
        sender.backgroundColor = UIColor.darkGray
        sender.setTitleColor(.white, for: .normal)
        nameIndex = 4
        print("nameIndex: \(nameIndex)")
        
        chineseFoodButton.backgroundColor = UIColor.systemGray3
        chineseFoodButton.setTitleColor(.black, for: .normal)
        koreanFoodButton.backgroundColor = UIColor.systemGray3
        koreanFoodButton.setTitleColor(.black, for: .normal)
        allFoodButton.backgroundColor = UIColor.systemGray3
        allFoodButton.setTitleColor(.black, for: .normal)
        westernFoodButton.backgroundColor = UIColor.systemGray3
        westernFoodButton.setTitleColor(.black, for: .normal)
        vietnamFoodButton.backgroundColor = UIColor.systemGray3
        vietnamFoodButton.setTitleColor(.black, for: .normal)
        mexicoFoodButton.backgroundColor = UIColor.systemGray3
        mexicoFoodButton.setTitleColor(.black, for: .normal)
        healthyFoodButton.backgroundColor = UIColor.systemGray3
        healthyFoodButton.setTitleColor(.black, for: .normal)
    }
    
    @objc func westernFoodButtonTapped(sender: UIButton) {
        sender.backgroundColor = UIColor.darkGray
        sender.setTitleColor(.white, for: .normal)
        nameIndex = 5
        print("nameIndex: \(nameIndex)")
        
        chineseFoodButton.backgroundColor = UIColor.systemGray3
        chineseFoodButton.setTitleColor(.black, for: .normal)
        koreanFoodButton.backgroundColor = UIColor.systemGray3
        koreanFoodButton.setTitleColor(.black, for: .normal)
        japaneseFoodButton.backgroundColor = UIColor.systemGray3
        japaneseFoodButton.setTitleColor(.black, for: .normal)
        allFoodButton.backgroundColor = UIColor.systemGray3
        allFoodButton.setTitleColor(.black, for: .normal)
        vietnamFoodButton.backgroundColor = UIColor.systemGray3
        vietnamFoodButton.setTitleColor(.black, for: .normal)
        mexicoFoodButton.backgroundColor = UIColor.systemGray3
        mexicoFoodButton.setTitleColor(.black, for: .normal)
        healthyFoodButton.backgroundColor = UIColor.systemGray3
        healthyFoodButton.setTitleColor(.black, for: .normal)
    }
    
    @objc func vetnamFoodButtonTapped(sender: UIButton) {
        sender.backgroundColor = UIColor.darkGray
        sender.setTitleColor(.white, for: .normal)
        nameIndex = 6
        print("nameIndex: \(nameIndex)")
        
        mexicoFoodButton.backgroundColor = UIColor.systemGray3
        mexicoFoodButton.setTitleColor(.black, for: .normal)
        westernFoodButton.backgroundColor = UIColor.systemGray3
        westernFoodButton.setTitleColor(.black, for: .normal)
        chineseFoodButton.backgroundColor = UIColor.systemGray3
        chineseFoodButton.setTitleColor(.black, for: .normal)
        koreanFoodButton.backgroundColor = UIColor.systemGray3
        koreanFoodButton.setTitleColor(.black, for: .normal)
        japaneseFoodButton.backgroundColor = UIColor.systemGray3
        japaneseFoodButton.setTitleColor(.black, for: .normal)
        allFoodButton.backgroundColor = UIColor.systemGray3
        allFoodButton.setTitleColor(.black, for: .normal)
        healthyFoodButton.backgroundColor = UIColor.systemGray3
        healthyFoodButton.setTitleColor(.black, for: .normal)
    }
    
    @objc func mexicoFoodButtonTapped(sender: UIButton) {
        sender.backgroundColor = UIColor.darkGray
        sender.setTitleColor(.white, for: .normal)
        nameIndex = 7
        print("nameIndex: \(nameIndex)")
        
        vietnamFoodButton.backgroundColor = UIColor.systemGray3
        vietnamFoodButton.setTitleColor(.black, for: .normal)
        westernFoodButton.backgroundColor = UIColor.systemGray3
        westernFoodButton.setTitleColor(.black, for: .normal)
        chineseFoodButton.backgroundColor = UIColor.systemGray3
        chineseFoodButton.setTitleColor(.black, for: .normal)
        koreanFoodButton.backgroundColor = UIColor.systemGray3
        koreanFoodButton.setTitleColor(.black, for: .normal)
        japaneseFoodButton.backgroundColor = UIColor.systemGray3
        japaneseFoodButton.setTitleColor(.black, for: .normal)
        allFoodButton.backgroundColor = UIColor.systemGray3
        allFoodButton.setTitleColor(.black, for: .normal)
        healthyFoodButton.backgroundColor = UIColor.systemGray3
        healthyFoodButton.setTitleColor(.black, for: .normal)
    }
    
    @objc func healthyFoodButtonTapped(sender: UIButton) {
        sender.backgroundColor = UIColor.darkGray
        sender.setTitleColor(.white, for: .normal)
        nameIndex = 8
        print("nameIndex: \(nameIndex)")
        
        mexicoFoodButton.backgroundColor = UIColor.systemGray3
        mexicoFoodButton.setTitleColor(.black, for: .normal)
        vietnamFoodButton.backgroundColor = UIColor.systemGray3
        vietnamFoodButton.setTitleColor(.black, for: .normal)
        westernFoodButton.backgroundColor = UIColor.systemGray3
        westernFoodButton.setTitleColor(.black, for: .normal)
        chineseFoodButton.backgroundColor = UIColor.systemGray3
        chineseFoodButton.setTitleColor(.black, for: .normal)
        koreanFoodButton.backgroundColor = UIColor.systemGray3
        koreanFoodButton.setTitleColor(.black, for: .normal)
        japaneseFoodButton.backgroundColor = UIColor.systemGray3
        japaneseFoodButton.setTitleColor(.black, for: .normal)
        allFoodButton.backgroundColor = UIColor.systemGray3
        allFoodButton.setTitleColor(.black, for: .normal)
    }
    
    
    // MARK: 추천 버튼을 눌렀을 때
    // 배열을 섞고 앞에서부터 8개를 뽑아 texts에 넣는다
    @objc func recommendButtonTapped(sender: UIButton) {
        switch nameIndex {
        case 1:
            let shuffledFoods = roulletManager.allFood.shuffled()
            let selectedFoods = Array(shuffledFoods.prefix(8))
            roulletManager.texts = selectedFoods
            print("texts: \(roulletManager.texts)")
        case 2:
            let shuffledFoods = roulletManager.koreaFood.shuffled()
            let selectedFoods = Array(shuffledFoods.prefix(8))
            roulletManager.texts = selectedFoods
            print("texts: \(roulletManager.texts)")
        case 3:
            let shuffledFoods = roulletManager.chineseFood.shuffled()
            let selectedFoods = Array(shuffledFoods.prefix(8))
            roulletManager.texts = selectedFoods
            print("texts: \(roulletManager.texts)")
        case 4:
            let shuffledFoods = roulletManager.japaneseFood.shuffled()
            let selectedFoods = Array(shuffledFoods.prefix(8))
            roulletManager.texts = selectedFoods
            print("texts: \(roulletManager.texts)")
        case 5:
            let shuffledFoods = roulletManager.westernFood.shuffled()
            let selectedFoods = Array(shuffledFoods.prefix(8))
            roulletManager.texts = selectedFoods
            print("texts: \(roulletManager.texts)")
        case 6:
            let shuffledFoods = roulletManager.vietnamFood.shuffled()
            let selectedFoods = Array(shuffledFoods.prefix(8))
            roulletManager.texts = selectedFoods
            print("texts: \(roulletManager.texts)")
        case 7:
            let shuffledFoods = roulletManager.mexicoFood.shuffled()
            let selectedFoods = Array(shuffledFoods.prefix(8))
            roulletManager.texts = selectedFoods
            print("texts: \(roulletManager.texts)")
        case 8:
            let shuffledFoods = roulletManager.healthyFood.shuffled()
            let selectedFoods = Array(shuffledFoods.prefix(8))
            roulletManager.texts = selectedFoods
            print("texts: \(roulletManager.texts)")
        default:
            print("error")
        }
        spinWheelView.items = randomText()
    }
    
    
    func testRingImage() -> UIImage {
        let lineWidth: CGFloat = 2
        let width: CGFloat = 300
        let height: CGFloat = 300
        let center: CGPoint = CGPoint(x: width / 2, y: height / 2)
        let radius: CGFloat = min(width / 2, height / 2) - lineWidth / 2
        
        let ringLayer = CAShapeLayer().then {
            $0.frame = CGRect(x: 0, y: 0, width: width, height: height)
            $0.path = UIBezierPath(arcCenter: center, radius: radius, startAngle: 0, endAngle: .pi * 2, clockwise: false).cgPath
            $0.lineWidth = lineWidth
            $0.strokeColor = UIColor.white.cgColor
            $0.fillColor = UIColor.clear.cgColor
            $0.strokeStart = 0
            $0.strokeEnd = 1
            $0.setNeedsDisplay()
        }
        let image = ringLayer.captureScreen()
        return image
    }
}


// MARK: SpinWheelViewDelegate
extension RecommandVC: SpinWheelViewDelegate {
    func spinWheelWillStart(_ spinWheelView: SpinWheelView) {
        print("will start")
    }
    
    func spinWheelDidEnd(_ spinWheelView: SpinWheelView, at item: SpinWheelItemModel) {
        print("did end at \(item.text)")
        
    }
}

extension RecommandVC: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        spinWheelView.items.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        spinWheelView.items[row].text
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
    }
}

// MARK: image capture
extension CALayer {

    func captureScreen() -> UIImage
    {
        UIGraphicsBeginImageContextWithOptions(CGSize(width: 300, height: 300), false, UIScreen.main.scale)
        let ctx = UIGraphicsGetCurrentContext()!
        self.render(in: ctx)
        let outputImage = UIGraphicsGetImageFromCurrentImageContext()!

        UIGraphicsEndImageContext()
        let image = UIImage(cgImage: ctx.makeImage()!, scale: UIScreen.main.scale, orientation: outputImage.imageOrientation)
        return image
    }
}


    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
