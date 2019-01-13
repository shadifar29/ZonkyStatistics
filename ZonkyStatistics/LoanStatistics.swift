//
//  LoanStatistics.swift
//  ZonkyStatistics
//
//  Created by Sadi on 12/01/2019.
//  Copyright © 2019 Sadi. All rights reserved.
//

import Foundation

struct LoanStatistics {
    
    init(_ loans:[Loan]) {
        self.loans = loans
    }
    
    private let loans:[Loan]
    
    lazy var numOfCovered:Int={
        var count=0
        for loan in loans{
            if loan.covered{
                count = count + 1
            }
        }
        return count
    }()
    
    var numOfLoans:Int{
        get{
            return loans.count
        }
    }
}

