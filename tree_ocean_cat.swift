import UIKit 

// Initialize Storyboard
let storyboard = UIstoryBoard(name: "Main", bundle:nil)

class StoreViewController: UIViewController {
    
    // Outlets
    @IBOutlet weak var itemsTableView: UITableView!
    @IBOutlet weak var itemNameTextField: UITextField!
    @IBOutlet weak var itemPriceTextField: UITextField!
    @IBOutlet weak var itemQuantityTextField: UITextField!
    
    // Properties
    var items = [Item]()
    var totalPrice = 0.00
    
    // View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configure navigation
        configureNavigation()
        
        // Setup TableView
        setupTableView()
    }
    
    // MARK: - Configure Navigation
    func configureNavigation() {
        title = "Art & Craft Supply Store"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Checkout", style: .plain, target: self, action: #selector(didTapCheckout))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Clear All", style: .plain, target: self, action: #selector(didTapClearAll))
    }
    
    // MARK: - Setup TableView
    func setupTableView() {
        itemsTableView.dataSource = self
        itemsTableView.delegate = self
    }
    
    // MARK: - Actions
    @IBAction func didTapAddItem(_ sender: Any) {
        guard let name = itemNameTextField.text, let quantityString = itemQuantityTextField.text, let priceString = itemPriceTextField.text else { return }
        let quantity = Int(quantityString) ?? 0
        let price = Double(priceString) ?? 0.00
        let item = Item(name: name, quantity: quantity, price: price)
        items.append(item)
        itemsTableView.reloadData()
        totalPrice += price * Double(quantity)
    }
    
    @objc func didTapCheckout() {
        let alert = UIAlertController(title: "Checkout", message: "Your Total is: $\(totalPrice)", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default) { _ in
            self.totalPrice = 0.00
            self.itemNameTextField.text = ""
            self.itemPriceTextField.text = ""
            self.itemQuantityTextField.text = ""
            self.items.removeAll()
            self.itemsTableView.reloadData()
        }
        
        alert.addAction(action)
        present(alert, animated: true)
    }
    
    @objc func didTapClearAll() {
        totalPrice = 0.00
        itemNameTextField.text = ""
        itemPriceTextField.text = ""
        itemQuantityTextField.text = ""
        items.removeAll()
        itemsTableView.reloadData()
    }
    
}

// MARK: - TableView Delegate & DataSource
extension StoreViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell", for: indexPath) as! ItemTableViewCell
        let item = items[indexPath.row]
        cell.configure(withItem: item)
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let item = items[indexPath.row]
            totalPrice -= item.price * Double(item.quantity)
            items.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
}