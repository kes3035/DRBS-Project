//
//  ViewController.swift
//  DRBS
//
//  Created by 김은상 on 2023/03/11.
//

import UIKit
import SideMenu

class MainVC: UIViewController {
    //MARK: - Properties
    private let mainTableView = UITableView()
    

    
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureNav()
        configureTV()
        
    }

    
    //MARK: - Helpers
    func configureNav() {
        navigationItem.title = "DRBS"
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]

        appearance.backgroundColor = UIColor(red: 0.43, green: 0.19, blue: 0.92, alpha: 1.00)
        navigationController?.navigationBar.backgroundColor = .clear
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
    
    func configureTV() {
        view.addSubview(mainTableView)
        mainTableView.rowHeight = 200
        mainTableView.translatesAutoresizingMaskIntoConstraints = false
        
        self.mainTableView.register(MainCell.self, forCellReuseIdentifier: "MainCell")
        self.mainTableView.separatorStyle = .none
        self.mainTableView.dataSource = self
        self.mainTableView.delegate = self
        
        NSLayoutConstraint.activate([
            mainTableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            mainTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            mainTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            mainTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
        ])
    }
    
    
    //MARK: - Actions


}


extension MainVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MainCell", for: indexPath) as! MainCell

        return cell
    }
    
    
    
}

extension MainVC: UITableViewDelegate {
    
}

//MARK: - SideMenuVCDelegate
//extension MainVC: SideMenuVCDelegate {
//    func selectedCell(_ row: Int) {
//        switch row {
//        case 0:
//            //            let locationVC = LocationVC()
//            //
//            //            self.present(locationVC, animated: true)
//            print("지역설정 눌림")
//        case 1:
//            // 메뉴 추천
//            //                self.showViewController(viewController: UINavigationController.self, storyboardId: "MusicNavID")
//            print("메뉴추천 눌림")
//
//        case 2:
//            // 나눠 내기
//            //                self.showViewController(viewController: UINavigationController.self, storyboardId: "MoviesNavID")
//            print("나눠내기 눌림")
//
//        case 3:
//            // 설정
//            //                self.showViewController(viewController: BooksViewController.self, storyboardId: "BooksVCID")
//            print("설정 눌림")
//
//        default:
//            break
//        }
//
//        // Collapse side menu with animation
//        DispatchQueue.main.async { self.sideMenuState(expanded: false) }
//    }
//    func showViewController<T: UIViewController>(viewController: T.Type, storyboardId: String) -> () {
//        // Remove the previous View
//        for subview in view.subviews {
//            if subview.tag == 99 {
//                subview.removeFromSuperview()
//            }
//        }
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let vc = storyboard.instantiateViewController(withIdentifier: storyboardId) as! T
//        vc.view.tag = 99
//        view.insertSubview(vc.view, at: self.revealSideMenuOnTop ? 0 : 1)
//        addChild(vc)
//        DispatchQueue.main.async {
//            vc.view.translatesAutoresizingMaskIntoConstraints = false
//            NSLayoutConstraint.activate([
//                vc.view.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
//                vc.view.topAnchor.constraint(equalTo: self.view.topAnchor),
//                vc.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
//                vc.view.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
//            ])
//        }
//        if !self.revealSideMenuOnTop {
//            if isExpanded {
//                vc.view.frame.origin.x = self.sideMenuRevealWidth
//            }
//            if self.sideMenuShadowView != nil {
//                vc.view.addSubview(self.sideMenuShadowView)
//            }
//        }
//        vc.didMove(toParent: self)
//    }
//    
//    func sideMenuState(expanded: Bool) {
//        if expanded {
//            self.animateSideMenu(targetPosition: self.revealSideMenuOnTop ? 0 : self.sideMenuRevealWidth) { _ in
//                self.isExpanded = true
//            }
//            // Animate Shadow (Fade In)
//            UIView.animate(withDuration: 0.5) { self.sideMenuShadowView.alpha = 0.6 }
//        }
//        else {
//            self.animateSideMenu(targetPosition: self.revealSideMenuOnTop ? (-self.sideMenuRevealWidth - self.paddingForRotation) : 0) { _ in
//                self.isExpanded = false
//            }
//            // Animate Shadow (Fade Out)
//            UIView.animate(withDuration: 0.5) { self.sideMenuShadowView.alpha = 0.0 }
//        }
//    }
//    
//    func animateSideMenu(targetPosition: CGFloat, completion: @escaping (Bool) -> ()) {
//        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0, options: .layoutSubviews, animations: {
//            if self.revealSideMenuOnTop {
//                self.sideMenuTrailingConstraint.constant = targetPosition
//                self.view.layoutIfNeeded()
//            }
//            else {
//                self.view.subviews[1].frame.origin.x = targetPosition
//            }
//        }, completion: completion)
//    }
//    
//}
//extension MainVC: UIGestureRecognizerDelegate {
//    @objc func TapGestureRecognizer(sender: UITapGestureRecognizer) {
//        if sender.state == .ended {
//            if self.isExpanded {
//                self.sideMenuState(expanded: false)
//            }
//        }
//    }
//    
//    // Close side menu when you tap on the shadow background view
//    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
//        if (touch.view?.isDescendant(of: self.sideMenuVC.view))! {
//            return false
//        }
//        return true
//    }
//    @objc private func handlePanGesture(sender: UIPanGestureRecognizer) {
//        guard gestureEnabled == true else { return }
//        
//        // ...
//        
//        let position: CGFloat = sender.translation(in: self.view).x
//        let velocity: CGFloat = sender.velocity(in: self.view).x
//        
//        switch sender.state {
//        case .began:
//            
//            // If the user tries to expand the menu more than the reveal width, then cancel the pan gesture
//            if velocity > 0, self.isExpanded {
//                sender.state = .cancelled
//            }
//            
//            // If the user swipes right but the side menu hasn't expanded yet, enable dragging
//            if velocity > 0, !self.isExpanded {
//                self.draggingIsEnabled = true
//            }
//            // If user swipes left and the side menu is already expanded, enable dragging they collapsing the side menu)
//            else if velocity < 0, self.isExpanded {
//                self.draggingIsEnabled = true
//            }
//            
//            if self.draggingIsEnabled {
//                // If swipe is fast, Expand/Collapse the side menu with animation instead of dragging
//                let velocityThreshold: CGFloat = 550
//                if abs(velocity) > velocityThreshold {
//                    self.sideMenuState(expanded: self.isExpanded ? false : true)
//                    self.draggingIsEnabled = false
//                    return
//                }
//                
//                if self.revealSideMenuOnTop {
//                    self.panBaseLocation = 0.0
//                    if self.isExpanded {
//                        self.panBaseLocation = self.sideMenuRevealWidth
//                    }
//                }
//            }
//            
//        case .changed:
//            
//            // Expand/Collapse side menu while dragging
//            if self.draggingIsEnabled {
//                if self.revealSideMenuOnTop {
//                    // Show/Hide shadow background view while dragging
//                    let xLocation: CGFloat = self.panBaseLocation + position
//                    let percentage = (xLocation * 150 / self.sideMenuRevealWidth) / self.sideMenuRevealWidth
//                    
//                    let alpha = percentage >= 0.6 ? 0.6 : percentage
//                    self.sideMenuShadowView.alpha = alpha
//                    
//                    // Move side menu while dragging
//                    if xLocation <= self.sideMenuRevealWidth {
//                        self.sideMenuTrailingConstraint.constant = xLocation - self.sideMenuRevealWidth
//                    }
//                }
//                else {
//                    if let recogView = sender.view?.subviews[1] {
//                        // Show/Hide shadow background view while dragging
//                        let percentage = (recogView.frame.origin.x * 150 / self.sideMenuRevealWidth) / self.sideMenuRevealWidth
//                        
//                        let alpha = percentage >= 0.6 ? 0.6 : percentage
//                        self.sideMenuShadowView.alpha = alpha
//                        
//                        // Move side menu while dragging
//                        if recogView.frame.origin.x <= self.sideMenuRevealWidth, recogView.frame.origin.x >= 0 {
//                            recogView.frame.origin.x = recogView.frame.origin.x + position
//                            sender.setTranslation(CGPoint.zero, in: view)
//                        }
//                    }
//                }
//            }
//        case .ended:
//            self.draggingIsEnabled = false
//            // If the side menu is half Open/Close, then Expand/Collapse with animationse with animation
//            if self.revealSideMenuOnTop {
//                let movedMoreThanHalf = self.sideMenuTrailingConstraint.constant > -(self.sideMenuRevealWidth * 0.5)
//                self.sideMenuState(expanded: movedMoreThanHalf)
//            }
//            else {
//                if let recogView = sender.view?.subviews[1] {
//                    let movedMoreThanHalf = recogView.frame.origin.x > self.sideMenuRevealWidth * 0.5
//                    self.sideMenuState(expanded: movedMoreThanHalf)
//                }
//            }
//        default:
//            break
//        }
//    }
//}
//
