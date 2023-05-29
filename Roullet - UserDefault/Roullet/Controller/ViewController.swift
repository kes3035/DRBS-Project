//
//  ViewController.swift
//  Roullet
//
//  Created by 김성호 on 2023/03/08.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var spinWheelView: SpinWheelView!
    @IBOutlet weak var indexPickerView: UIPickerView!
    @IBOutlet weak var imageView: UIImageView!
    
    // 유저디폴드에서 값을 가져와 배열 안에 넣는다.
    let texts = ["떡볶이", "치킨", "피자", "파스타", "라면", "만두", "마라탕", "닭가슴살"]
    let colors = [UIColor.color1!, UIColor.color2!, UIColor.color3!, UIColor.color4!, UIColor.color5!, UIColor.color6!, UIColor.color7!, UIColor.color8!]
    let nameText = [UserDefaults(suiteName: "text")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        setButton()
        spinWheelView.delegate = self
        spinWheelView.items = randomItems()
        spinWheelView.ringImage = testRingImage()
        spinWheelView.ringLineWidth = 10
        
        indexPickerView.delegate = self
        indexPickerView.dataSource = self
        
 
    }
        
    // MARK: 네비게이션 바 버튼
    @IBAction func addButtonTapped(_ sender: UIBarButtonItem) {

        performSegue(withIdentifier: "toSettingViewController", sender: self)
    }
    
    
    //MARK: 아이템을 랜덤으로 섞어주는 함수
    func randomItems() -> [SpinWheelItemModel] {
        let shuffledColor = colors.shuffled()
            return shuffledColor.compactMap({ color in
                let index = colors.firstIndex(of: color)!
                return SpinWheelItemModel(text: texts[index], backgroundColor: color, value: 1000)
        })
    }
    
    func setButton() {
        // 회전버튼 관련 설정
        let spinButton = UIButton(type: .system)
        spinButton.setTitle("Start", for: .normal)
        spinButton.setTitleColor(.white, for: .normal)
        spinButton.backgroundColor = UIColor(red: 0.43, green: 0.19, blue: 0.92, alpha: 1.00)
        spinButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        spinButton.addTarget(self, action: #selector(spinButtonTapped), for: .touchUpInside)
        view.addSubview(spinButton)
        
        // 버튼 오토레이아웃
        spinButton.layer.cornerRadius = 10
        spinButton.layer.masksToBounds = true
        spinButton.translatesAutoresizingMaskIntoConstraints = false
        spinButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        spinButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        spinButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -180).isActive = true
        spinButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    
    @objc func spinButtonTapped() {
        let index = indexPickerView.selectedRow(inComponent: 0)
        print("spin wheel \(spinWheelView.items[index].text)")
        spinWheelView.spinWheel(index)
    }
    
    func testRingImage() -> UIImage {
        let lineWidth: CGFloat = 2
        let width: CGFloat = 300
        let height: CGFloat = 300
        let center: CGPoint = CGPoint(x: width / 2, y: height / 2)
        let radius: CGFloat = min(width / 2, height / 2) - lineWidth / 2
        
        
        let ringLayer = CAShapeLayer()
        ringLayer.frame = CGRect(x: 0, y: 0, width: width, height: height)
        ringLayer.path = UIBezierPath(arcCenter: center, radius: radius, startAngle: 0, endAngle: .pi * 2, clockwise: false).cgPath
        ringLayer.lineWidth = lineWidth
        ringLayer.strokeColor = UIColor.white.cgColor
        ringLayer.fillColor = UIColor.clear.cgColor
        ringLayer.strokeStart = 0
        ringLayer.strokeEnd = 1
        ringLayer.setNeedsDisplay()
        
        let image = ringLayer.captureScreen()
        return image
    }
}
// MARK: SpinWheelViewDelegate
extension ViewController: SpinWheelViewDelegate {
    func spinWheelWillStart(_ spinWheelView: SpinWheelView) {
        print("will start")
    }
    
    func spinWheelDidEnd(_ spinWheelView: SpinWheelView, at item: SpinWheelItemModel) {
        print("did end at \(item.text)")
    }
}

extension ViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        spinWheelView.items.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        spinWheelView.items[row].text
//        texts[row]
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

// MARK: UIColor Text
extension UIColor {
    func toText() -> String {
        switch self {
        case .color1!:
            return "치킨"
        case .color2!:
            return "떡볶이"
        case .color3!:
            return "피자"
        case .color4!:
            return "파스타"
        case .color5!:
            return "라면"
        case .color6!:
            return "만두"
        case .color7!:
            return "마라탕"
        case .color8!:
            return "닭가슴살"
        default:
            return ""
        }
    }
}


extension UIColor {
    
    class var color1: UIColor? { return UIColor(named: "color1")}
    
    class var color2: UIColor? { return UIColor(named: "color2")}
    
    class var color3: UIColor? { return UIColor(named: "color3")}
    
    class var color4: UIColor? { return UIColor(named: "color4")}
    
    class var color5: UIColor? { return UIColor(named: "color5")}
    
    class var color6: UIColor? { return UIColor(named: "color6")}
    
    class var color7: UIColor? { return UIColor(named: "color7")}
    
    class var color8: UIColor? { return UIColor(named: "color8")}
}
