//
//  ChartViewModel.swift
//  ZonkyStatistics
//
//  Created by Sadi on 13/01/2019.
//  Copyright © 2019 Sadi. All rights reserved.
//

import Foundation
import Alamofire

protocol LoanDataDelegate: class {
    func loanDataRecived(_ response: Result<[(month:Double, numOfLoans:Double)]>)
    func downloadStart()
}

class LoanChartViewModel{
    
    enum LoanInterval {
        case last12Months
        case LastYear
        case TwoYearsAgo
        case None
    }

    var chartData = [(month:Double, numOfLoans:Double)](repeating: (month: 0, numOfLoans: 0), count: 12)

    var loanInterval: LoanInterval {
        didSet{
            self.delegate?.downloadStart()
            loadLoans(interval:loanInterval)
        }
    }
    
    lazy var lastYearTxt:String={
        return "rok " + Date().getYear(add:-1)
    }()

    lazy var twoYearsAgo:String={
        return "rok " + Date().getYear(add:-2)
    }()

    weak var delegate: LoanDataDelegate?

    func loadLoans(interval:LoanInterval){
        var from:Date, to:Date
        let today = Date()
        switch interval {
        case .last12Months:
            let TwelveMonthsAgo = Calendar.current.date(byAdding: .month, value: -12, to: today)!
            let start = TwelveMonthsAgo.getMonthStart()!
            from = start
            to = today
        case .LastYear:
            let lastYear = today.firstAndLastDayOfYear(offset: -1)
            from = lastYear.firstDay
            to = lastYear.lastDay
        case .TwoYearsAgo:
            let twoYearsAgo = today.firstAndLastDayOfYear(offset: -2)
            from = twoYearsAgo.firstDay
            to = twoYearsAgo.lastDay
        case .None:
            return
        }
        loadChartData(from, to)
    }

    func loadChartData(_ from:Date,_ to:Date){
        var requestCounter = 0
        let numOfMonths = abs(from.diffInMonths(from: to)) + 1
        self.chartData = [(month:Double, numOfLoans:Double)](repeating: (month: 1, numOfLoans: 0), count: numOfMonths)
        
        var monthStart = from.getMonthStart()!
        var monthEnd  = from.getMonthEnd()!
        
        let serivce = LoanServiceApi()
        
        for i in 0...(numOfMonths-1){
            
            self.chartData[i] = (month:monthStart.millisecondsSince1970, numOfLoans:0)
            
            serivce.getMarketplaceLoans(from:monthStart, to:monthEnd){ (response: Result<[Loan]>) in
                DispatchQueue.main.async {
                    
                    requestCounter = requestCounter + 1
                    if let loans = response.value {
                        let stats = LoanStatistics(loans)
                        self.chartData[i].numOfLoans = Double(stats.numOfLoans)
                        
                        if requestCounter == numOfMonths{
                            self.delegate?.loanDataRecived(Result.success(self.chartData))
                        }
                    }
                    else if let err = response.error{
                        self.delegate?.loanDataRecived(Result.failure(err))
                    }
                }
            }
            monthStart = monthEnd.getNextMonthStart()!
            monthEnd = monthStart.getMonthEnd()!
        }
    }

    init() {
        loanInterval = .None
    }
}
