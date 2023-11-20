
import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {
  //MARK: IBOutlet
  @IBOutlet var tableView: UITableView!
  @IBOutlet var indicator: UIActivityIndicatorView!
  //MARK: Variables
  var cryptoList = [Crypto]()
  let cryptoVM = CryptoViewModel()
  let disposeBag = DisposeBag()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.delegate = self
    tableView.dataSource = self
    setupBindigs()
    cryptoVM.requestData()
  }
  
  func setupBindigs() {
    
    cryptoVM.loading.bind(to: self.indicator.rx.isAnimating).disposed(by: disposeBag)
    cryptoVM.error.observe(on: MainScheduler.asyncInstance).subscribe { errorString in
      print(errorString)
    }.disposed(by: disposeBag)
    
    cryptoVM.cryptos.observe(on: MainScheduler.asyncInstance).subscribe { cryptos in
      self.cryptoList = cryptos
      self.tableView.reloadData()
    }.disposed(by: disposeBag)
  }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = UITableViewCell()
    var content = cell.defaultContentConfiguration()
    content.text = cryptoList[indexPath.row].currency
    content.secondaryText = cryptoList[indexPath.row].price
    cell.contentConfiguration = content
    return cell
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return cryptoList.count
  }
}

