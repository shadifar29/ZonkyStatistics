import UIKit
import Charts
import DLRadioButton
import Alamofire

class ViewController: UIViewController {
    
    @IBOutlet weak var chart: LineChartView!
    @IBOutlet weak var last12MonthsBtn: DLRadioButton!
    @IBOutlet weak var lastYearBtn: DLRadioButton!
    @IBOutlet weak var TwoYearsAgoBtn: DLRadioButton!
    
    let activityIndicator = UIActivityIndicatorView(style: .whiteLarge)
    var chartVm = LoanChartViewModel()

    // Mark: life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        chartVm.delegate = self
        setupView()
        last12MonthsBtn.isSelected = true
        chartVm.loanInterval = .last12Months
    }
    
    func setupView(){
        lastYearBtn.setTitle(chartVm.lastYearTxt, for: .normal)
        TwoYearsAgoBtn.setTitle(chartVm.twoYearsAgo, for: .normal)

        activityIndicator.color = UIColor.blue
        activityIndicator.center = view.center
        view.addSubview(activityIndicator)
        
        chart.setScaleEnabled(true)
        chart.noDataText = "Žádná data"
        let xAxis = chart.xAxis
        xAxis.labelPosition = .bottom
        xAxis.valueFormatter = MonthValueFormatter()
    }

    @IBAction func onLast12Months(_ sender: Any) {
        chartVm.loanInterval = .last12Months
    }
    @IBAction func onlastYear(_ sender: Any) {
        chartVm.loanInterval = .LastYear
    }
    @IBAction func on2YearsAgo(_ sender: Any) {
        chartVm.loanInterval = .TwoYearsAgo
    }
}

extension ViewController: LoanDataDelegate {
    func downloadStart(){
        activityIndicator.startAnimating()
    }

    func loanDataRecived(_ response: Result<[(month:Double, numOfLoans:Double)]>) {
        if let data = response.value {
            updateGraph(chartData:data)
        }
        else if let err = response.error{
            //set no data and print error
            chart.data = LineChartData()
            chart.chartDescription?.text = err.localizedDescription
        }
        activityIndicator.stopAnimating()
    }

    func updateGraph(chartData:[(month:Double, numOfLoans:Double)]){
        var loanChartData = [ChartDataEntry]()
        for i in 0..<chartData.count {
            let value = ChartDataEntry(x: chartData[i].month, y: chartData[i].numOfLoans)
            loanChartData.append(value)
        }
        let line = LineChartDataSet(values: loanChartData, label: "Úvěry")
        line.colors = [NSUIColor.blue]
        
        let data = LineChartData()
        data.addDataSet(line)
        
        //update chart
        chart.data = data
    }
}
