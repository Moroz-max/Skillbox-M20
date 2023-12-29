//
//  ArtistCell.swift
//  Skillbox-M20
//
//  Created by Максим Морозов on 29.12.2023.
//

import Foundation
import UIKit
import SnapKit

class ArtistCell: UITableViewCell {
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Name"
        return label
    }()
    
    private lazy var lastName: UILabel = {
        let label = UILabel()
        label.text = "Last name"
        return label
    }()
    
    private lazy var countyLabel: UILabel = {
        let label = UILabel()
        label.text = "Country"
        return label
    }()
    
    private lazy var dateOfBithdLabel: UILabel = {
        let label = UILabel()
        label.text = "Date of Bithd"
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            
            contentView.addSubview(nameLabel)
            contentView.addSubview(lastName)
            contentView.addSubview(countyLabel)
            contentView.addSubview(dateOfBithdLabel)
            
            setupConstraints()
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    func configure(_ model: Artist) {
        nameLabel.text = model.name
        lastName.text = model.lastName
        countyLabel.text = model.country
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        dateOfBithdLabel.text = formatter.string(from: model.dateOfBith ?? Date())
    }
        
    private func setupConstraints() {
        nameLabel.snp.makeConstraints { make in
            make.left.equalTo(contentView.snp.leftMargin).offset(20)
            make.right.equalTo(contentView.snp.rightMargin).offset(-20)
            make.top.equalTo(contentView.snp.top).offset(20)
            make.height.equalTo(40)
        }
        lastName.snp.makeConstraints { make in
            make.left.equalTo(contentView.snp.leftMargin).offset(20)
            make.right.equalTo(contentView.snp.rightMargin).offset(-20)
            make.top.equalTo(nameLabel.snp.bottom).offset(10)
            make.height.equalTo(40)
        }
        countyLabel.snp.makeConstraints { make in
            make.left.equalTo(contentView.snp.leftMargin).offset(20)
            make.right.equalTo(contentView.snp.rightMargin).offset(-20)
            make.top.equalTo(lastName.snp.bottom).offset(10)
            make.height.equalTo(40)
        }
        dateOfBithdLabel.snp.makeConstraints { make in
            make.left.equalTo(contentView.snp.leftMargin).offset(20)
            make.right.equalTo(contentView.snp.rightMargin).offset(-20)
            make.top.equalTo(countyLabel.snp.bottom).offset(10)
            make.height.equalTo(40)
            make.bottom.equalTo(contentView.snp.bottom).offset(-20)
        }
    }
}
