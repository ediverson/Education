import UIKit

class InfoViewController: UIViewController {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
// An empty value
    var name = ""
    var text = ""
    var pic: URL?
    var selectorText: [String] = []
    var selectorItems: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
// Default value
        nameLabel.text = name
        textLabel.text = text
        updateView()
        
    }
    func updateView() {
        guard pic != nil else { return }
        imageView.af.setImage(withURL: pic!, placeholderImage: .none)
    }
    
 //MARK: -SegmentControl
    func createSegment() {
        let items = selectorItems
        let segmentControl = UISegmentedControl(items: items)
        segmentControl.addTarget(self, action: #selector(valueDidChange(_:)), for: .valueChanged)
        segmentControl.translatesAutoresizingMaskIntoConstraints = false
        segmentControl.backgroundColor = .orange
        segmentControl.selectedSegmentTintColor = .white
        
        view.addSubview(segmentControl)
        
        NSLayoutConstraint.activate([
            segmentControl.topAnchor.constraint(equalTo: textLabel.bottomAnchor, constant: 16),
            segmentControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            segmentControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50)
        ])
    }

    @objc func valueDidChange(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            textLabel.text = selectorText[0]
        case 1:
            textLabel.text = selectorText[1]
        case 2:
            textLabel.text = selectorText[2]
        default:
            textLabel.text = ""
        }
    }
}

