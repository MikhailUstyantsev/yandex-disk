//
//  MessageTableViewCell.swift
//  TestMyKnowledge-19(Self-Sizing Table View Cell In Code)
//
//  Created by Mikhail Ustyantsev on 03.08.2022.
//

import UIKit

class LastLoadedTableViewCell: UITableViewCell {

    let headerLabel: UILabel = {
       let label = UILabel()
        label.font = UIFont(name: "Inter-SemiBold", size: 16)
        label.textAlignment = .center
        label.backgroundColor = .white
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let bodyLabel: UILabel = {
       let label = UILabel()
        label.font = UIFont(name: "Inter-Regular", size: 14)
        label.textAlignment = .left
        label.backgroundColor = .white
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let cellImageView: ImageLoader = {
       let imageView = ImageLoader()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()


    override init(style: UITableViewCell.CellStyle,
        reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier:
        reuseIdentifier)
        setupView()
    }
     
       required init?(coder aDecoder: NSCoder) {
         super.init(coder: aDecoder)
        setupView()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.contentView.layoutIfNeeded()
        cellImageView.clipsToBounds = true
        cellImageView.layer.cornerRadius = 5
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        cellImageView.image = nil
        headerLabel.text = nil
        bodyLabel.text = nil
    }
    
    private func setupView() {
        contentView.addSubview(cellImageView)
        contentView.addSubview(headerLabel)
        contentView.addSubview(bodyLabel)
        
        cellImageView.layer.masksToBounds = true
        cellImageView.layer.cornerRadius = 5
        
        
        let margins = contentView.readableContentGuide
        
        NSLayoutConstraint.activate([
            cellImageView.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
            cellImageView.topAnchor.constraint(equalTo: margins.topAnchor),
            cellImageView.heightAnchor.constraint(equalToConstant: 60),
            cellImageView.widthAnchor.constraint(equalToConstant: 60),
            headerLabel.topAnchor.constraint(equalTo: margins.topAnchor),
            headerLabel.leadingAnchor.constraint(equalTo: cellImageView.trailingAnchor, constant: 16),
            bodyLabel.topAnchor.constraint(equalTo: headerLabel.bottomAnchor),
            bodyLabel.leadingAnchor.constraint(equalTo: headerLabel.leadingAnchor),
            bodyLabel.trailingAnchor.constraint(equalTo: margins.trailingAnchor, constant: 24)
        ])
    }
    
    
    
    
    
    
}
