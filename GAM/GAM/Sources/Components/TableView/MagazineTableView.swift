//
//  MagazineTableView.swift
//  GAM
//
//  Created by Jungbin on 2023/07/09.
//

import UIKit

final class MagazineTableView: UITableView {
    
    enum CellType {
        case normal
        case noScrap
    }
    
    enum Number {
        static let magazineCellHeight = 140.0
        static let magazineCellSpacing = 18.0
    }
    
    // MARK: Initializer
    
    init(cellType: CellType) {
        super.init(frame: .zero, style: .plain)
        
        self.setUI()
        self.setRegisterCell(cellType: cellType)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Methods
    
    private func setUI() {
        self.backgroundColor = .clear
        self.layoutMargins = .zero
        self.separatorStyle = .none
        self.rowHeight = Number.magazineCellHeight + Number.magazineCellSpacing
    }
    
    private func setRegisterCell(cellType: CellType) {
        switch cellType {
        case .normal:
            self.register(cell: MagazineTableViewCell.self)
        case .noScrap:
            // TODO: Search Magazine TableViewCell 개발 후 변경
            self.register(cell: MagazineTableViewCell.self)
        }
    }
}
