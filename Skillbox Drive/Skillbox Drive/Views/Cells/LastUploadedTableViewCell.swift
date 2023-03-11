//
//  MessageTableViewCell.swift
//  TestMyKnowledge-19(Self-Sizing Table View Cell In Code)
//
//  Created by Mikhail Ustyantsev on 03.08.2022.
//

import UIKit

class LastUploadedTableViewCell: UITableViewCell {

    private var viewModel: LastUploadedCellViewModel?
    
    let nameLabel: UILabel = {
       let label = UILabel()
        label.font = UIFont(name: "Inter-Regular", size: 16)
        label.textAlignment = .center
        label.textColor = .label
        label.backgroundColor = .systemBackground
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let dateLabel: UILabel = {
       let label = UILabel()
        label.font = UIFont(name: "Inter-Regular", size: 14)
        label.textAlignment = .left
        label.backgroundColor = .systemBackground
        label.textColor = .label.withAlphaComponent(0.6)
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    let sizeLabel: UILabel = {
       let label = UILabel()
        label.font = UIFont(name: "Inter-SemiBold", size: 14)
        label.textAlignment = .left
        label.backgroundColor = .systemBackground
        label.textColor = .label.withAlphaComponent(0.6)
        label.numberOfLines = 1
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
        setupViews()
        setupHierarchy()
        setupLayout()
    }
     
       required init?(coder aDecoder: NSCoder) {
         super.init(coder: aDecoder)
    }

    func update(with viewModel: LastUploadedCellViewModel) {
        self.viewModel = viewModel
        nameLabel.text = viewModel.name
        dateLabel.text = viewModel.formattedDate
        sizeLabel.text = viewModel.sizeInMegaBytes
        self.cellImageView.loadImageWithUrl(viewModel.imageURL, viewModel.token)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        cellImageView.image = nil
        nameLabel.text = nil
        dateLabel.text = nil
    }
    
    private func setupViews() {
        contentView.backgroundColor = .systemBackground
       
        cellImageView.layer.masksToBounds = true
        cellImageView.layer.cornerRadius = 5
    }
    
    private func setupHierarchy() {
        contentView.addSubviews(cellImageView, nameLabel, dateLabel, sizeLabel)
    }
    
    private func setupLayout() {
        let margins = contentView.readableContentGuide
        
        NSLayoutConstraint.activate([
            cellImageView.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
            cellImageView.centerYAnchor.constraint(equalTo: margins.centerYAnchor),
            cellImageView.heightAnchor.constraint(equalToConstant: 50),
            cellImageView.widthAnchor.constraint(equalToConstant: 50),
            
            nameLabel.topAnchor.constraint(equalTo: margins.topAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: cellImageView.trailingAnchor, constant: 16),
            
            dateLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor),
            dateLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            
            sizeLabel.trailingAnchor.constraint(equalTo: margins.trailingAnchor, constant: -24),
            sizeLabel.bottomAnchor.constraint(equalTo: margins.bottomAnchor)
        ])
    }
    
    
    
}
