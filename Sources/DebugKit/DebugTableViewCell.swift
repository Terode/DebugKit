
import UIKit

public final class DebugTableViewCell: UITableViewCell {
    public static let reuseID = "DebugTableViewCell"

    private let titleLabel      = UILabel()
    private let segmentControl  = UISegmentedControl()
    private let toggleSwitch    = UISwitch()
    private let textFieldView   = UITextField()
    private let selectButton    = UIButton(type: .system)

    public var onSegmentChanged: ((Int) -> Void)?
    public var onSwitchChanged:  ((Bool) -> Void)?
    public var onTextChanged:    ((String) -> Void)?
    public var onButtonTapped:   (() -> Void)?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }

    private func setupViews() {
        selectionStyle = .none

        textFieldView.keyboardType = .decimalPad
        textFieldView.delegate = self

        [titleLabel, segmentControl, toggleSwitch, textFieldView, selectButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
            $0.isHidden = true
        }

        segmentControl.addTarget(self, action: #selector(segChanged), for: .valueChanged)
        toggleSwitch.addTarget(self, action: #selector(swChanged), for: .valueChanged)
        textFieldView.addTarget(self, action: #selector(tfChanged), for: .editingChanged)
        selectButton.addTarget(self, action: #selector(btnTapped), for: .touchUpInside)

        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),

            segmentControl.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            segmentControl.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),

            toggleSwitch.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            toggleSwitch.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),

            textFieldView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            textFieldView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            textFieldView.widthAnchor.constraint(equalToConstant: 80),

            selectButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            selectButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        ])
    }

    public func configure(
        title: String,
        showSegment: Bool = false,
        segmentOptions: [String] = [],
        selectedSegmentIndex: Int = 0,
        showSwitch: Bool = false,
        isSwitchOn: Bool = false,
        showTextField: Bool = false,
        text: String = "",
        showButton: Bool = false,
        buttonTitle: String = ""
    ) {
        titleLabel.text = title

        segmentControl.isHidden = !showSegment
        if showSegment {
            segmentControl.removeAllSegments()
            for (index, option) in segmentOptions.enumerated() {
                segmentControl.insertSegment(withTitle: option, at: index, animated: false)
            }
            segmentControl.selectedSegmentIndex = selectedSegmentIndex
        }

        toggleSwitch.isHidden = !showSwitch
        if showSwitch {
            toggleSwitch.isOn = isSwitchOn
        }

        textFieldView.isHidden = !showTextField
        if showTextField {
            textFieldView.text = text
        }

        selectButton.isHidden = !showButton
        if showButton {
            selectButton.setTitle(buttonTitle, for: .normal)
        }
    }

    @objc private func segChanged() {
        onSegmentChanged?(segmentControl.selectedSegmentIndex)
    }

    @objc private func swChanged() {
        onSwitchChanged?(toggleSwitch.isOn)
    }

    @objc private func tfChanged() {
        onTextChanged?(textFieldView.text ?? "")
    }

    @objc private func btnTapped() {
        onButtonTapped?()
    }
}

extension DebugTableViewCell: UITextFieldDelegate {
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string == "," {
            let current = textField.text ?? ""
            if let textRange = Range(range, in: current) {
                let newText = current.replacingCharacters(in: textRange, with: ".")
                textField.text = newText
            }
            return false
        }
        return true
    }
}
