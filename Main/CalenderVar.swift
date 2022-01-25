//  CalenderVar.swift
//  FinalProject

import Foundation
let date = Date()
let calender = Calendar.current

let day = calender.component(.day, from: date)
let weekday = calender.component(.weekday, from: date)
var month = calender.component(.month, from: date) - 1
var year = calender.component(.year, from: date)
