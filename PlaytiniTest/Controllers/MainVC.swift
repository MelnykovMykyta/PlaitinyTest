//
//  MainVC.swift
//  PlaytiniTest
//
//  Created by Nikita Melnikov on 21.12.2023.
//

import Foundation
import UIKit
import SnapKit

class MainVC: UIViewController {
    
    private var minusButton: UIButton!
    private var plusButton: UIButton!
    private var circle: UIView!
    private var scoreLabel: UILabel!
    private var lineUp: UIView!
    private var lineDown: UIView!
    
    private let impactFeedbackGenerator = UIImpactFeedbackGenerator(style: .heavy)
    
    private var scoreValue = 5 {
        didSet {
            scoreLabel.text = "Score: \(scoreValue)"
            
            if scoreValue == 0 {
                [lineUp, lineDown, circle].forEach {
                    $0.layer.removeAllAnimations()
                    $0.isHidden = true
                }
                
                Alert.showAlert(title: "Oops!", message: "You lose. Try again?") {
                    VCChanger.changeVC(vc: MainVC())
                }
            }
        }
    }
    
    private var circleSize: CGFloat = 100
    
    var intersectionTimer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        
        minusButton.addTarget(self, action: #selector(tapMinus), for: .touchUpInside)
        plusButton.addTarget(self, action: #selector(tapPlus), for: .touchUpInside)
        
        intersectionTimer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(checkIntersection), userInfo: nil, repeats: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        startSpinning()
        startMovingUpLine()
        startMovingDownLine()
    }
}

private extension MainVC {
    
    @objc func tapMinus() {
        guard circleSize > 20 else { return }
        circleSize -= 20
        changeSize()
    }
    
    @objc func tapPlus() {
        guard circleSize < view.frame.width - circle.layer.borderWidth else { return }
        circleSize += 20
        changeSize()
    }
    
    func changeSize() {
        UIView.animate(withDuration: 0.2) {
            self.circle.snp.updateConstraints { $0.size.equalTo(self.circleSize) }
            self.circle.layoutIfNeeded()
            self.circle.layer.borderWidth = self.circleSize / 24
            self.circle.layer.cornerRadius = self.circleSize / 2
        }
    }
    
    func startSpinning() {
        UIView.animate(withDuration: 1.0, delay: 0.0, options: [.repeat, .curveLinear]) {
            self.circle.transform = CGAffineTransform(rotationAngle: .pi)
        }
    }
    
    func startMovingUpLine() {
        if scoreValue > 0 {
            UIView.animate(withDuration: 6.0, delay: TimeInterval(Int.random(in: 0...3)), options: [.curveLinear], animations: {
                self.lineUp.frame.origin.x = -self.view.bounds.width
            }, completion: {_ in
                self.lineUp.frame.origin.x = self.view.frame.width
                self.lineUp.frame.origin.y = CGFloat.random(in: 250...(self.view.frame.height / 2) - 20)
                self.startMovingUpLine()
            })
        }
    }
    
    func startMovingDownLine() {
        if scoreValue > 0 {
            UIView.animate(withDuration: 6.0, delay: TimeInterval(Int.random(in: 0...3)), options: [.curveLinear], animations: {
                self.lineDown.frame.origin.x = -self.view.bounds.width
            }, completion: { _ in
                self.lineDown.frame.origin.x = self.view.bounds.width
                self.lineDown.frame.origin.y = CGFloat.random(in: (self.view.frame.height / 2) + 20...self.view.frame.height - 250)
                self.startMovingDownLine()
            })
        }
    }
    
    @objc func checkIntersection() {
        guard let currentLineUpFrame = lineUp.layer.presentation()?.frame,
              let currentLineDownFrame = lineDown.layer.presentation()?.frame,
              let currentCircle = circle else {
            return
        }
        
        let circleCenter = currentCircle.center
        let circleRadius = currentCircle.bounds.width / 2.0
        let circleFrame = CGRect(x: circleCenter.x - circleRadius, y: circleCenter.y - circleRadius, width: circleRadius * 2, height: circleRadius * 2)
        
        if currentLineUpFrame.intersects(circleFrame) {
            lineUp.layer.removeAllAnimations()
            scoreValue -= 1
            impactFeedbackGenerator.impactOccurred()
        }
        
        if currentLineDownFrame.intersects(circleFrame) {
            lineDown.layer.removeAllAnimations()
            scoreValue -= 1
            impactFeedbackGenerator.impactOccurred()
        }
    }
}

private extension MainVC {
    
    func setupView() {
        
        view.backgroundColor = .black
        
        scoreLabel = UILabel()
        scoreLabel.text = "Score: \(scoreValue)"
        scoreLabel.textColor = .white
        scoreLabel.font = UIFont(name: "PressStart2P-Regular", size: 36)
        view.addSubview(scoreLabel)
        
        circle = UIView()
        circle.backgroundColor = .black
        circle.layer.borderWidth = circleSize / 24
        circle.layer.borderColor = UIColor.white.cgColor
        circle.layer.cornerRadius = circleSize / 2
        circle.layer.masksToBounds = true
        view.addSubview(circle)
        
        let cirleLines = UIImageView()
        cirleLines.image = UIImage(systemName: "plus")
        cirleLines.tintColor = .white
        circle.addSubview(cirleLines)
        
        let buttonsSV = UIStackView()
        buttonsSV.distribution = .fillEqually
        buttonsSV.spacing = 20
        view.addSubview(buttonsSV)
        
        minusButton = UIButton(type: .system)
        minusButton.setImage(UIImage(systemName: "minus"), for: .normal)
        
        plusButton = UIButton(type: .system)
        plusButton.setImage(UIImage(systemName: "plus"), for: .normal)
        
        [minusButton, plusButton].forEach {
            $0.tintColor = .white
            $0.layer.cornerRadius = 10
            $0.layer.masksToBounds = true
            $0.layer.borderWidth = 1
            $0.layer.borderColor = UIColor.white.cgColor
            buttonsSV.addArrangedSubview($0)
        }
        
        lineUp = UIView()
        lineUp.backgroundColor = .white
        lineUp.frame = CGRect(x: view.frame.width, y: CGFloat.random(in: 250...(view.frame.height / 2) - 20), width: view.frame.width, height: 40)
        view.addSubview(lineUp)
        
        lineDown = UIView()
        lineDown.backgroundColor = .white
        lineDown.frame = CGRect(x: view.frame.width, y: CGFloat.random(in: (view.frame.height / 2) + 20...view.frame.height - 250), width: view.frame.width, height: 40)
        view.addSubview(lineDown)
        
        scoreLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(20)
        }
        
        circle.snp.makeConstraints {
            $0.size.equalTo(circleSize)
            $0.center.equalToSuperview()
        }
        
        cirleLines.snp.makeConstraints {
            $0.size.equalToSuperview().multipliedBy(0.6)
            $0.center.equalToSuperview()
        }
        
        buttonsSV.snp.makeConstraints {
            $0.height.equalTo(60)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(20)
        }
    }
}
