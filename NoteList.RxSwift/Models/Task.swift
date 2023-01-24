//
//  Task.swift
//  NoteList.RxSwift
//
//  Created by Вадим Гамзаев on 22.01.2023.
//

import Foundation

enum Priority: Int {
    case hight
    case medium
    case low
}

struct Task {
    var title: String
    var priority: Priority
}
