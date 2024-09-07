//
//  PrimaryButtonModel.swift
//  MyAssetBook
//
//  Created by Ruska Keldishvili on 26.08.24.
//

import Combine

public struct PrimaryButtonModel {
    let titleModel: LocalLabelModel
    let action: (() -> Void)
    
    public init(titleModel: LocalLabelModel,
                action: @escaping (() -> Void)) {
        self.titleModel = titleModel
        self.action = action
    }
}
