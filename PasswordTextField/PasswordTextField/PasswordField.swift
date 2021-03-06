//
//  PasswordField.swift
//  PasswordTextField
//
//  Created by Ben Gohlke on 6/26/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import UIKit

enum PasswordStrength: String {
    case weak = "WEAK"
    case medium = "MEDIUM"
    case strong = "STRONG"
}

class PasswordField: UIControl {
    
    // Public API - these properties are used to fetch the final password and strength values
    private (set) var password: String = ""
    private (set) var strength: PasswordStrength = .weak
    
    private let standardMargin: CGFloat = 8.0
    private let textFieldContainerHeight: CGFloat = 50.0
    private let textFieldMargin: CGFloat = 6.0
    private let colorViewSize: CGSize = CGSize(width: 60.0, height: 5.0)
    
    private let labelTextColor = UIColor(hue: 233.0/360.0, saturation: 16/100.0, brightness: 41/100.0, alpha: 1)
    private let labelFont = UIFont.systemFont(ofSize: 14.0, weight: .semibold)
    
    private let textFieldBorderColor = UIColor(hue: 208/360.0, saturation: 80/100.0, brightness: 94/100.0, alpha: 1)
    private let bgColor = UIColor(hue: 0, saturation: 0, brightness: 97/100.0, alpha: 1)
    
    // States of the password strength indicators
    private let unusedColor = UIColor(hue: 210/360.0, saturation: 5/100.0, brightness: 86/100.0, alpha: 1)
    private let weakColor = UIColor(hue: 0/360, saturation: 60/100.0, brightness: 90/100.0, alpha: 1)
    private let mediumColor = UIColor(hue: 39/360.0, saturation: 60/100.0, brightness: 90/100.0, alpha: 1)
    private let strongColor = UIColor(hue: 132/360.0, saturation: 60/100.0, brightness: 75/100.0, alpha: 1)
    
    private var titleLabel: UILabel = UILabel()
    private var textField: UITextField = UITextField()
    private var showHideButton: UIButton = UIButton()
    private var weakView: UIView = UIView()
    private var mediumView: UIView = UIView()
    private var strongView: UIView = UIView()
    private var strengthDescriptionLabel: UILabel = UILabel()
    
    var isSecureEntry: Bool = true {
        didSet {
            textField.isSecureTextEntry = isSecureEntry
            if isSecureEntry {
                showHideButton.setImage(UIImage(named: "eyes-closed"), for: .normal)
            } else {
               showHideButton.setImage(UIImage(named: "eyes-open"), for: .normal)
            }
        }
    }
    
    
    func setup() {
        // Lay out your subviews here
        backgroundColor = bgColor
        configureTitleLabel()
        configureTextField()
        configureStrengthViews()
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    // MARK: - View Confgiurations
    
    private func configureTitleLabel() {
        addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = "ENTER PASSWORD"
        titleLabel.textColor = labelTextColor
        titleLabel.font = labelFont
        titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: standardMargin).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: standardMargin).isActive = true
        
    }
    
    private func configureTextField() {
        addSubview(textField)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.layer.borderColor = textFieldBorderColor.cgColor
        textField.layer.borderWidth = 2
        textField.layer.cornerRadius = 4
        textField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: standardMargin).isActive = true
        textField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: standardMargin).isActive =  true
        textField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -standardMargin).isActive = true
        textField.heightAnchor.constraint(equalToConstant: textFieldContainerHeight).isActive = true
        
        textField.backgroundColor = .clear
        textField.isSecureTextEntry = true
        textField.delegate = self
        
        showHideButton.setImage(UIImage(named: "eyes-closed"), for: .normal)
        showHideButton.addTarget(self, action: #selector(showPasswordTapped), for: .touchUpInside)
        textField.rightViewMode = .always
        textField.rightView = showHideButton
        
    }
    
    private func configureStrengthViews() {
        weakView.backgroundColor = weakColor
        mediumView.backgroundColor = unusedColor
        strongView.backgroundColor = unusedColor
        
        weakView.layer.cornerRadius = 2
        mediumView.layer.cornerRadius = 2
        strongView.layer.cornerRadius = 2
        
        addSubview(strengthDescriptionLabel)
        addSubview(weakView)
        addSubview(mediumView)
        addSubview(strongView)

        weakView.translatesAutoresizingMaskIntoConstraints = false
        weakView.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: standardMargin).isActive = true
        weakView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: standardMargin).isActive = true
        weakView.heightAnchor.constraint(equalToConstant: colorViewSize.height).isActive = true
        weakView.widthAnchor.constraint(equalToConstant: colorViewSize.width).isActive = true
        weakView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8).isActive = true
        
        mediumView.translatesAutoresizingMaskIntoConstraints = false
        mediumView.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: standardMargin).isActive = true
        mediumView.leadingAnchor.constraint(equalTo: weakView.trailingAnchor, constant: standardMargin).isActive = true
        mediumView.heightAnchor.constraint(equalToConstant: colorViewSize.height).isActive = true
        mediumView.widthAnchor.constraint(equalToConstant: colorViewSize.width).isActive = true
        
        strongView.translatesAutoresizingMaskIntoConstraints = false
        strongView.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: standardMargin).isActive = true
        strongView.leadingAnchor.constraint(equalTo: mediumView.trailingAnchor, constant: standardMargin).isActive = true
        strongView.heightAnchor.constraint(equalToConstant: colorViewSize.height).isActive = true
        strongView.widthAnchor.constraint(equalToConstant: colorViewSize.width).isActive = true
        
        strengthDescriptionLabel.textColor = labelTextColor
        strengthDescriptionLabel.text = "Too weak"
        strengthDescriptionLabel.font = labelFont
        strengthDescriptionLabel.adjustsFontSizeToFitWidth = true
        strengthDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        strengthDescriptionLabel.leadingAnchor.constraint(equalTo: strongView.trailingAnchor, constant: standardMargin).isActive = true
        strengthDescriptionLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -standardMargin).isActive = true
        strengthDescriptionLabel.centerYAnchor.constraint(equalTo: strongView.centerYAnchor).isActive = true
        
    }
    
    // MARK: - Private Methods
    
    private func indicatePasswordStrength(password: String) {
        switch password.count {
            case ..<10:
                updateForStatus(status: .weak)
            case 10...19:
                updateForStatus(status: .medium)
            default:
                updateForStatus(status: .strong)
                
        }
    }
    
    private func updateForStatus(status: PasswordStrength) {
        let currentStatus = strength
        switch status {
            case .weak:
                mediumView.backgroundColor = unusedColor
                strongView.backgroundColor = unusedColor
                strengthDescriptionLabel.text = "Too Weak"
                if currentStatus != .weak {
                    UIView.animate(withDuration: 0.1, animations: {
                        self.weakView.layer.backgroundColor = self.weakColor.cgColor
                        self.weakView.transform = CGAffineTransform(scaleX: 1.6, y: 1.6)
                        }) { (_) in
                            self.weakView.transform = .identity
                            self.strength = .weak
                    }
                } else {
                    self.weakView.layer.backgroundColor = self.weakColor.cgColor
                    self.strength = .weak
                }
            case .medium:
                weakView.backgroundColor = weakColor
                strongView.backgroundColor = unusedColor
                strengthDescriptionLabel.text = "Could be stronger"
                if currentStatus != .medium {
                    UIView.animate(withDuration: 0.1, animations: {
                        self.mediumView.layer.backgroundColor = self.mediumColor.cgColor
                        self.mediumView.transform = CGAffineTransform(scaleX: 1.6, y: 1.6)
                    }) { (_) in
                        self.mediumView.transform = .identity
                        self.strength = .medium
                    }
                } else {
                    self.mediumView.layer.backgroundColor = self.mediumColor.cgColor
                    self.strength = .medium
                }
            
            case .strong:
                weakView.backgroundColor = weakColor
                mediumView.backgroundColor = mediumColor
                strengthDescriptionLabel.text = "Strong password"
                if currentStatus != .strong {
                    UIView.animate(withDuration: 0.1, animations: {
                        self.strongView.layer.backgroundColor = self.strongColor.cgColor
                        self.strongView.transform = CGAffineTransform(scaleX: 1.6, y: 1.6)
                    }) { (_) in
                        self.strongView.transform = .identity
                        self.strength = .strong
                    }
                } else {
                   self.strongView.layer.backgroundColor = self.strongColor.cgColor
                }
        }
        
    }
    
    // MARK: - Actions
    
    @objc private func showPasswordTapped() {
        isSecureEntry.toggle()
    }
    
}

// MARK: - UITextFieldDelegate

extension PasswordField: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let oldText = textField.text!
        let stringRange = Range(range, in: oldText)!
        let newText = oldText.replacingCharacters(in: stringRange, with: string)
        // TODO: send new text to the determine strength method
        indicatePasswordStrength(password: newText)
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if let text = textField.text, !text.isEmpty {
            password = text
            sendActions(for: [.valueChanged])
        }
        return true
    }
}
