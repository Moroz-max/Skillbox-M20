//
//  AddArtistViewController.swift
//  Skillbox-M20
//
//  Created by Максим Морозов on 29.12.2023.
//

import UIKit
import SnapKit

class AddArtistViewController: UIViewController {

    
    var Artist: Artist?
    
    private lazy var nameTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.placeholder = "Имя исполнителя"
        return textField
    }()
    
    private lazy var lastNameTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.placeholder = "Фамилия исполнителя"
        return textField
    }()
    
    private lazy var dateOfBirthLabel: UILabel = {
        let label = UILabel()
        label.text = "ДД-ММ-ГГГГ"
        label.textAlignment = .center
        return label
    }()
    
    private lazy var setDateOfBirthdButon: UIButton = {
        let button = UIButton()
        button.setTitle("Выбрать", for: .normal)
        button.tintColor = .white
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(setDateOfBithd), for: .touchUpInside)
        return button
    }()
    
    private lazy var countryLabel: UILabel = {
        let label = UILabel()
        label.text = "Страна"
        label.textAlignment = .center
        return label
    }()
    
    private lazy var setCountryButton: UIButton = {
        let button = UIButton()
        button.setTitle("Изменить", for: .normal)
        button.tintColor = .white
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(setCountry), for: .touchUpInside)
        return button
    }()
    
    private lazy var saveButton: UIButton = {
        let button = UIButton()
        button.setTitle("Сохранить", for: .normal)
        button.tintColor = .white
        button.backgroundColor = .systemGreen
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(save), for: .touchUpInside)
        return button
    }()
    
    
    
    @objc func tapView() {
        view.endEditing(true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapView))
        view.addGestureRecognizer(tap)
        
        setupViews()
        setupConstraints()
        
        countryLabel.text = Countries().countries.first
    }
    
    @objc private func setCountry() {
        let vc = UIViewController()
        vc.preferredContentSize = CGSize(width: 250,height: 200)
        let pickerView = UIPickerView(frame: CGRect(x: 0, y: 0, width: 250, height: 200))
        pickerView.delegate = self
        pickerView.dataSource = self
        vc.view.addSubview(pickerView)
        let CountryAlert = UIAlertController(title: "Укажите страну", message: "", preferredStyle: .alert)
        CountryAlert.setValue(vc, forKey: "contentViewController")
        CountryAlert.addAction(UIAlertAction(title: "Готово", style: .default, handler: nil))
        present(CountryAlert, animated: true)
    }
    
    @objc func setDateOfBithd() {
        let vc = UIViewController()
        vc.preferredContentSize = CGSize(width: 250,height: 50)
        let pickerView = UIDatePicker(frame: CGRect(x: 0, y: 0, width: 250, height: 50))
        pickerView.datePickerMode = .date
        vc.view.addSubview(pickerView)
        pickerView.snp.makeConstraints { make in
            make.center.equalTo(vc.view.snp.center)
        }
        pickerView.addTarget(self, action: #selector(updateDateOfBithd(sender: )), for: .valueChanged)
        let DateAlert = UIAlertController(title: "Укажите дату рождения", message: "", preferredStyle: .alert)
        DateAlert.setValue(vc, forKey: "contentViewController")
        DateAlert.addAction(UIAlertAction(title: "Готово", style: .default, handler: nil))
        countryLabel.text = Countries().countries.first
        updateDateOfBithd(sender: pickerView)
        present(DateAlert, animated: true)
    }
    
    @objc func updateDateOfBithd(sender: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        dateOfBirthLabel.text = formatter.string(from: sender.date)
    }
    
    @objc func save() {
        if nameTextField.hasText && lastNameTextField.hasText && dateOfBirthLabel.text != "ДД-ММ-ГГГГ" {
            let formatter = DateFormatter()
            formatter.dateFormat = "dd-MM-yyyy"
            Artist?.country = countryLabel.text
            Artist?.dateOfBith = formatter.date(from: dateOfBirthLabel.text ?? "")
            Artist?.name = nameTextField.text
            Artist?.lastName = lastNameTextField.text
            
            try? Artist?.managedObjectContext?.save()
            dismiss(animated: true)
        } else {
            let errorAlert = UIAlertController(title: "Ошибка", message: "Укажите все данные", preferredStyle: .alert)
            errorAlert.addAction(UIAlertAction(title: "ок", style: .default))
            present(errorAlert, animated: true)
        }
    }
    

    private func setupConstraints() {
        nameTextField.snp.makeConstraints { make in
            make.left.equalTo(view.snp.leftMargin).offset(20)
            make.right.equalTo(view.snp.rightMargin).offset(-20)
            make.top.equalTo(view.snp.topMargin).offset(20)
        }
        lastNameTextField.snp.makeConstraints { make in
            make.left.equalTo(view.snp.leftMargin).offset(20)
            make.right.equalTo(view.snp.rightMargin).offset(-20)
            make.top.equalTo(nameTextField.snp.bottom).offset(20)
        }
        dateOfBirthLabel.snp.makeConstraints { make in
            make.left.equalTo(view.snp.leftMargin).offset(20)
            make.top.equalTo(lastNameTextField.snp.bottom).offset(20)
            make.right.equalTo(view.snp.centerX)
            make.centerY.equalTo(setDateOfBirthdButon.snp.centerY)
        }
        setDateOfBirthdButon.snp.makeConstraints { make in
            make.left.equalTo(view.snp.centerX)
            make.right.equalTo(view.snp.rightMargin).offset(-20)
            make.top.equalTo(lastNameTextField.snp.bottom).offset(20)
        }
        countryLabel.snp.makeConstraints { make in
            make.left.equalTo(view.snp.leftMargin).offset(20)
            make.top.equalTo(dateOfBirthLabel.snp.bottom).offset(20)
            make.right.equalTo(view.snp.centerX)
            make.centerY.equalTo(setCountryButton.snp.centerY)
        }
        setCountryButton.snp.makeConstraints { make in
            make.left.equalTo(view.snp.centerX)
            make.right.equalTo(view.snp.rightMargin).offset(-20)
            make.top.equalTo(setDateOfBirthdButon.snp.bottom).offset(20)
        }
        saveButton.snp.makeConstraints { make in
            make.center.equalTo(view.snp.center)
            make.left.equalTo(view.snp.leftMargin).offset(20)
            make.right.equalTo(view.snp.rightMargin).offset(-20)
        }
    }
    
    private func setupViews() {
        view.addSubview(nameTextField)
        view.addSubview(lastNameTextField)
        view.addSubview(dateOfBirthLabel)
        view.addSubview(setDateOfBirthdButon)
        view.addSubview(countryLabel)
        view.addSubview(setCountryButton)
        view.addSubview(saveButton)
    }

}

extension AddArtistViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        let countries = Countries().countries
        return countries.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let countries = Countries().countries
        return countries[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let countries = Countries().countries
        self.countryLabel.text = countries[row]
    }
    
}
