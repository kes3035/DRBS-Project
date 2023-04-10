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
    let colors = [UIColor.blue, UIColor.red, UIColor.systemGreen, UIColor.brown, UIColor.black, UIColor.darkGray, UIColor.orange, UIColor.purple]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        view.backgroundColor = UIColor(red: 0.43, green: 0.19, blue: 0.92, alpha: 1.00)
        view.backgroundColor = UIColor.white
        spinWheelView.delegate = self
        spinWheelView.items = randomItems()
        spinWheelView.ringImage = testRingImage()
        spinWheelView.ringLineWidth = 10
        
        indexPickerView.delegate = self
        indexPickerView.dataSource = self
    }

    //MARK: spin버튼
    @IBAction func spin(_ sender: Any) {
        let index = indexPickerView.selectedRow(inComponent: 0)
        print("spin wheel \(spinWheelView.items[index].text)")
        spinWheelView.spinWheel(index)
    }
        
    // MARK: 네비게이션 바 버튼
    @IBAction func addButtonTapped(_ sender: UIBarButtonItem) {

        performSegue(withIdentifier: "toSettingViewController", sender: self)
    }
    
    
    //MARK: 아이템을 랜덤으로 섞어주는 함수
    func randomItems() -> [SpinWheelItemModel] {
        let shuffledColor = colors.shuffled()
        return shuffledColor.compactMap({ color in
            SpinWheelItemModel(text: color.toText(), backgroundColor: color, value: 1000)
        })
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
        case .blue:
            return "치킨"
        case .red:
            return "떡볶이"
        case .systemGreen:
            return "피자"
        case .brown:
            return "파스타"
        case .black:
            return "라면"
        case .darkGray:
            return "만두"
        case .orange:
            return "마라탕"
        case .purple:
            return "닭가슴살"
        default:
            return ""
        }
    }
}

