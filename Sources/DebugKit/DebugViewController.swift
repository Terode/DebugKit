
import UIKit

public final class DebugViewController: UIViewController {
    private let viewModel = DebugViewModel()
    private let tableView = UITableView(frame: .zero, style: .insetGrouped)

    public init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Debug"
        view.backgroundColor = .systemBackground

        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Apply",
            style: .done,
            target: self,
            action: #selector(applyTapped)
        )

        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(
            DebugTableViewCell.self,
            forCellReuseIdentifier: DebugTableViewCell.reuseID
        )
        
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }

    @objc private func applyTapped() {
        let alert = UIAlertController(
            title: nil,
            message: "Applied! Restart app to see changes.",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

extension DebugViewController: UITableViewDataSource {
    public func numberOfSections(in tableView: UITableView) -> Int {
        viewModel.numberOfSections
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfRows(in: section)
    }
    
    public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        viewModel.titleForSection(section)
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DebugTableViewCell.reuseID, for: indexPath) as! DebugTableViewCell

        viewModel.configure(cell, at: indexPath)

        switch viewModel.settingItem(at: indexPath) {
        case .adsInspectorTestMode:
            let index = cell.onSegmentChanged
            cell.onSegmentChanged = { idx in
                index?(idx)
                tableView.reloadData()
            }
        case .testAdsMode:
            cell.onButtonTapped = { [weak self] in
                guard let self = self else { return }
                let sheet = UIAlertController(
                    title: "Choose Test Ads Mode",
                    message: nil,
                    preferredStyle: .actionSheet
                )
                for mode in TestAdsMode.allCases {
                    sheet.addAction(
                        UIAlertAction(title: mode.rawValue, style: .default) { _ in
                            self.viewModel.updateTestAdsMode(at: indexPath, to: mode)
                            tableView.reloadData()
                        }
                    )
                }
                sheet.addAction(UIAlertAction(title: "Cancel", style: .cancel))
                self.present(sheet, animated: true)
            }
        default:
            break
        }

        return cell
    }
}

extension DebugViewController: UITableViewDelegate {}
