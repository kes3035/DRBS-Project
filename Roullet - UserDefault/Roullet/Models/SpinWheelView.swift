//
//  SpinWheelView.swift
//  Roullet
//
//  Created by 김성호 on 2023/03/08.
//
import UIKit

protocol SpinWheelViewDelegate: AnyObject {
    func spinWheelWillStart(_ spinWheelView: SpinWheelView)
    func spinWheelDidEnd(_ spinWheelView: SpinWheelView, at item: SpinWheelItemModel)
}

// MARK: SpinWheelView
class SpinWheelView: UIView {
    override class var layerClass: AnyClass {
        return SpinWheelLayer.self
    }
    weak var delegate: SpinWheelViewDelegate?
    var spinWheelLayer: SpinWheelLayer? {
        return layer as? SpinWheelLayer
    }
    var ringImage: UIImage? {
        get {
            spinWheelLayer?.ringImage
        }
        
        set {
            spinWheelLayer?.ringImage = newValue
            spinWheelLayer?.setNeedsDisplay()
        }
    }
    var ringLineWidth: CGFloat {
        get {
            spinWheelLayer?.ringLineWidth ?? 0
        }
        
        set {
            spinWheelLayer?.ringLineWidth = newValue
            spinWheelLayer?.setNeedsDisplay()
        }
    }
    var items: [SpinWheelItemModel] {
        get {
            spinWheelLayer?.items ?? []
        }
        set {
            spinWheelLayer?.items = newValue
            spinWheelLayer?.setNeedsDisplay()
        }
    }
    private var willEndIndex: Int?
    
    //MARK: 메서드를 통해 룰렛을 시작할 수 있다.
    func spinWheel(_ index: Int) {
        guard !items.isEmpty else { return }
            delegate?.spinWheelWillStart(self)
            willEndIndex = Int.random(in: 0..<items.count)
            spinWheelLayer?.add(spinAnimation(endIndex: willEndIndex!), forKey: "spin")
    }
    
    //MARK: 룰렛이 회전하여 endIndex에 해당하는 sliceLayer에 위치하도록 하는 애니메이션을 반환한다.
    private func spinAnimation(endIndex: Int) -> CAAnimationGroup {
        let group = CAAnimationGroup()
        let begin = beginAnimation()
        let turn = turnAnimation(begin: begin.duration)
        
        let degressOfSlice: Degree = 360 / CGFloat(items.count)
        let beginAngle: Degree = 0
        let endAngle: Degree = (beginAngle + degressOfSlice * CGFloat(items.count - endIndex))
        
        let end = endAnimation(begin: begin.duration + turn.duration, endAngle: endAngle)
        group.animations = [begin, turn, end]
        group.beginTime = CACurrentMediaTime()
        group.duration = (begin.duration) + (turn.duration) + (end.duration)
        group.delegate = self
        group.isRemovedOnCompletion = false
        group.fillMode = .forwards
        return group
    }
    
    //MARK: 룰렛 전체 애니메이션 중 easeln 타이밍으로 도입부 애니메이션을 반환한다.
    private func beginAnimation() -> CABasicAnimation {
        let animation = CABasicAnimation(keyPath: "transform.rotation")
        animation.fromValue = 0
        animation.toValue = Degree(360).toRadian()
        animation.duration = 1.5
        animation.beginTime = 0
        animation.timingFunction = CAMediaTimingFunction(name: .easeIn)
        return animation
    }
    
    //MARK: linear 타이밍으로 중간부분 애니메이션을 반환한다.
    private func turnAnimation(begin: Double) -> CABasicAnimation {
        let animation = CABasicAnimation(keyPath: "transform.rotation")
        animation.fromValue = 0
        animation.toValue = Degree(720).toRadian()
        animation.duration = 2
        animation.timingFunction = CAMediaTimingFunction(name: .linear)
        animation.beginTime = begin
        return animation
    }
    
    //MARK: eseOut 타이밍으로 마지막 endIndex까지 도달하는 애니메이션을 반환한다.
    private func endAnimation(begin: Double, endAngle: Degree) -> CABasicAnimation {
        let animation = CABasicAnimation(keyPath: "transform.rotation")
        animation.fromValue = 0
        animation.toValue = endAngle.toRadian()
        animation.duration = 1.2
        animation.timingFunction = CAMediaTimingFunction(name: .easeOut)
        animation.isRemovedOnCompletion = false
        animation.beginTime = begin
        animation.fillMode = .forwards
        return animation
    }
    
}
extension SpinWheelView: CAAnimationDelegate {
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if flag, let index = willEndIndex, items.count > index {
            delegate?.spinWheelDidEnd(self, at: items[index])
        }
    }
}

// MARK: SpinWheel Layer
class SpinWheelLayer: CALayer {
    fileprivate(set) var items: [SpinWheelItemModel] = []
    fileprivate(set) var ringImage: UIImage?
    fileprivate(set) var ringLineWidth: CGFloat = 0
    
    override func draw(in ctx: CGContext) {
        initializeLayer()
        setMask()
        setSlicesIfNeeded()
        setRingImageIfNeeded()
    }
    
    //MARK: layer에 포함되어있던 애니메이션과 sublayer를 모두 제거하여 초기화 하는 작업
    private func initializeLayer() {
        self.contentsScale = UIScreen.main.scale
        
        removeAllAnimations()
        self.sublayers?.forEach({
            $0.removeFromSuperlayer()
        })

    }
    
    //MARK: layer에 원형 마스크를 씌운다
    private func setMask() {
        let maskLayer = CAShapeLayer()
        maskLayer.path = UIBezierPath(arcCenter: CGPoint(x: bounds.width / 2, y: bounds.height / 2), radius: min(bounds.width / 2, bounds.height / 2), startAngle: 0, endAngle: .pi * 2, clockwise: false).cgPath
        mask = maskLayer
        
    }
    
    //MARK: items 배열에 들어있는 수 만큼 SlceLayer들을 추가해 룰렛을 그린다.
    private func setSlicesIfNeeded() {
        guard !items.isEmpty else { return }
        let degreeOfSlice: Degree = 360 / CGFloat(items.count)
        
        let beginAngle: Degree = (-90) - (degreeOfSlice / 2)
        var startAngle: Degree = beginAngle
        var endAngle: Degree = startAngle + degreeOfSlice
        
        for index in 0 ..< items.count {
            let slice = SliceLayer(model: items[index], index: index, frame: bounds, radius: min(bounds.width / 2, bounds.height / 2), startAngle: startAngle, endAngle: endAngle, totalCount: items.count)
            startAngle += degreeOfSlice
            endAngle += degreeOfSlice
            self.addSublayer(slice)
            slice.position = CGPoint(x: bounds.width / 2, y: bounds.height / 2)
            slice.setNeedsDisplay()
        }
    }
    
    //MARK: 룰렛의 ring에 해당하는 image를 추가한다.
    private func setRingImageIfNeeded() {
        guard let ringImage = ringImage else {
            return
        }

        let ringImageLayer = CALayer()
        ringImageLayer.frame = CGRect(x: 0, y: 0, width: self.bounds.width - ringLineWidth, height: self.bounds.height - ringLineWidth)
        ringImageLayer.contentsScale = self.contentsScale
        ringImageLayer.contents = ringImage.cgImage
        ringImageLayer.contentsGravity = .center
        self.addSublayer(ringImageLayer)
        
        ringImageLayer.position = CGPoint(x: bounds.width / 2, y: bounds.height / 2)
    }
}

// MARK: CGContext를 이용해 Slice모양을 그린다.
class SliceLayer: CALayer {
    let model: SpinWheelItemModel
    let startAngle: Degree
    let endAngle: Degree
    let radius: CGFloat
    let index: Int
    let totalCount: Int
    
    init(model: SpinWheelItemModel, index: Int, frame: CGRect, radius: CGFloat, startAngle: Degree, endAngle: Degree, totalCount: Int) {
        self.model = model
        self.index = index
        self.startAngle = startAngle
        self.endAngle = endAngle
        self.radius = radius
        self.totalCount = totalCount
        super.init()
        self.frame = frame
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(in ctx: CGContext) {
        self.contentsScale = UIScreen.main.scale
        drawSlice(in: ctx)
        addTextLayer()
    }
    
    private func drawSlice(in ctx: CGContext) {
        let center: CGPoint = self.position
        ctx.move(to: center)
        ctx.addArc(center: center, radius: radius, startAngle: startAngle.toRadian(), endAngle: endAngle.toRadian(), clockwise: false)
        ctx.setFillColor(model.backgroundColor?.cgColor ?? UIColor.white.cgColor)
        ctx.fillPath()
    }
    
    //MARK: 각 slce가 보여주어야할 text를 포함하는 subLayer를 추가한다.
    private func addTextLayer() {
        let center: CGPoint = self.position
        
        let textLayer = CATextLayer()
        textLayer.frame = CGRect(x: center.x, y: 0, width: frame.width / 2, height: 15)
        textLayer.anchorPoint = CGPoint(x: 0, y: 0.5)
        textLayer.position = CGPoint(x: center.x, y: center.y)
        
        textLayer.foregroundColor = UIColor.white.cgColor
        textLayer.string = model.text
        textLayer.fontSize = 15
        textLayer.alignmentMode = .center
        addSublayer(textLayer)
        
        let degreeOfSlice: Degree = 360 / CGFloat(totalCount)
        textLayer.transform = CATransform3DMakeAffineTransform(CGAffineTransform(rotationAngle: (endAngle - degreeOfSlice / 2).toRadian()))
    }
}

struct SpinWheelItemModel {
    //MARK: slice별로 보여줄 텍스트
    let text: String
    //MARK: slice의 배경색
    let backgroundColor: UIColor?
    //MARK: slice별로 대응하는 값
    let value: Int
}

// MARK: Degree
typealias Radian = CGFloat
typealias Degree = CGFloat
extension Degree {
    func toRadian() -> Radian {
        return self * .pi / 180
    }
}
extension Radian {
    func toDegree() -> Degree {
        return self * 180 / .pi
    }
}
