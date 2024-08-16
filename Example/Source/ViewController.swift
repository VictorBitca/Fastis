//
//  ViewController.swift
//  Example
//
//  Created by Ilya Kharlamov on 14.04.2020.
//  Copyright © 2020 DIGITAL RETAIL TECHNOLOGIES, S.L. All rights reserved.
//

import Fastis
import UIKit

class ViewController: UIViewController {

    // MARK: - Outlets

    private lazy var containerView: UIStackView = {
        let view = UIStackView()
        view.backgroundColor = .clear
        view.axis = .vertical
        view.distribution = .fill
        view.alignment = .center
        view.spacing = 16
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var currentDateLabel = UILabel()

    private lazy var chooseRangeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Choose range of dates", for: .normal)
        button.addTarget(self, action: #selector(self.chooseRange), for: .touchUpInside)
        return button
    }()

    private lazy var chooseSingleButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Choose single date", for: .normal)
        button.addTarget(self, action: #selector(self.chooseSingleDate), for: .touchUpInside)
        return button
    }()

    private lazy var chooseRangeButtonWithCustomCalendar: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Choose range of dates with custom calendar", for: .normal)
        button.addTarget(self, action: #selector(self.chooseRangeWithCustomCalendar), for: .touchUpInside)
        return button
    }()

    private lazy var chooseWithSwiftUI: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Choose with SwiftUI", for: .normal)
        button.addTarget(self, action: #selector(self.swiftUIPresentation), for: .touchUpInside)
        return button
    }()

    private lazy var embeddedViewController: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Embedded view controller demo", for: .normal)
        button.addTarget(self, action: #selector(self.embeddedViewControllerPresentation), for: .touchUpInside)
        return button
    }()

    // MARK: - Variables

    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter
    }()

    private var currentValue: FastisValue? {
        didSet {
            if let rangeValue = self.currentValue as? FastisRange {
                self.currentDateLabel.text = self.dateFormatter.string(from: rangeValue.fromDate) + " - " + self.dateFormatter
                    .string(from: rangeValue.toDate)
            } else if let date = self.currentValue as? Date {
                self.currentDateLabel.text = self.dateFormatter.string(from: date)
            } else {
                self.currentDateLabel.text = "Choose a date"
            }
        }
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureUI()
        self.configureSubviews()
        self.configureConstraints()
    }

    // MARK: - Configuration

    private func configureUI() {
        self.view.backgroundColor = .systemBackground
        self.navigationItem.title = "Fastis demo"
        self.navigationItem.largeTitleDisplayMode = .always
        self.currentValue = nil
    }

    private func configureSubviews() {
        self.containerView.addArrangedSubview(self.currentDateLabel)
        self.containerView.setCustomSpacing(32, after: self.currentDateLabel)
        self.containerView.addArrangedSubview(self.chooseRangeButton)
        self.containerView.addArrangedSubview(self.chooseSingleButton)
        self.containerView.addArrangedSubview(self.chooseRangeButtonWithCustomCalendar)
        self.containerView.addArrangedSubview(self.chooseWithSwiftUI)
        self.containerView.addArrangedSubview(self.embeddedViewController)
        self.view.addSubview(self.containerView)
    }

    private func configureConstraints() {
        NSLayoutConstraint.activate([
            self.containerView.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor),
            self.containerView.centerYAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerYAnchor),
            self.containerView.leftAnchor.constraint(greaterThanOrEqualTo: self.view.safeAreaLayoutGuide.leftAnchor),
            self.containerView.topAnchor.constraint(greaterThanOrEqualTo: self.view.safeAreaLayoutGuide.topAnchor),
            self.containerView.rightAnchor.constraint(lessThanOrEqualTo: self.view.safeAreaLayoutGuide.rightAnchor),
            self.containerView.bottomAnchor.constraint(lessThanOrEqualTo: self.view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    // MARK: - Actions

    @objc
    private func chooseRange() {
        self.dateFormatter.calendar = .current
        let fastisController = FastisController(mode: .range)
        fastisController.title = "Choose range"
        fastisController.initialValue = self.currentValue as? FastisRange
        fastisController.minimumDate = Calendar.current.date(byAdding: .month, value: -2, to: Date())
        fastisController.maximumDate = Calendar.current.date(byAdding: .month, value: 3, to: Date())
        fastisController.shortcuts = [.today, .lastWeek, .lastMonth]
        fastisController.shouldShowDateSelectionHeader = false
        fastisController.dismissHandler = { [weak self] action in
            switch action {
            case .done(let newValue):
                self?.currentValue = newValue
            case .cancel:
                print("any actions")
            }
        }
        fastisController.dateRangeSelectionHandler = { range in
            print("date range:", range)
        }
        fastisController.present(above: self)
    }

    @objc
    private func chooseSingleDate() {
        self.dateFormatter.calendar = .current
        let fastisController = FastisController(mode: .single)
        fastisController.title = "Choose date"
        fastisController.initialValue = self.currentValue as? Date
        fastisController.maximumDate = Date()
        fastisController.shortcuts = [.today, .yesterday, .tomorrow]
        fastisController.dismissHandler = { [weak self] action in
            switch action {
            case .done(let newValue):
                self?.currentValue = newValue
            case .cancel:
                print("any actions")
            }
        }
        fastisController.dateSelectionHandler = { date in
            print("date: ", date)
        }
        fastisController.present(above: self)
    }

    @objc
    private func chooseRangeWithCustomCalendar() {
        var customConfig: FastisConfig = .default
        var calendar: Calendar = .init(identifier: .islamicUmmAlQura)
        calendar.locale = .autoupdatingCurrent
        customConfig.calendar = calendar

        self.dateFormatter.calendar = calendar

        let fastisController = FastisController(mode: .range, config: customConfig)
        fastisController.title = "Choose range"
        fastisController.initialValue = self.currentValue as? FastisRange
        fastisController.minimumDate = calendar.date(byAdding: .month, value: -2, to: Date())
        fastisController.maximumDate = calendar.date(byAdding: .month, value: 3, to: Date())
        fastisController.allowToChooseNilDate = true
        fastisController.shortcuts = [.today, .lastWeek, .lastMonth]
        fastisController.dateRangeSelectionHandler = { range in
            print("date range: ", range)
        }
        fastisController.present(above: self)


        DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
            let one = calendar.date(byAdding: .day, value: -1, to: Date())!
            let two = calendar.date(byAdding: .day, value: 3, to: Date())!
            fastisController.selectValue(.init(from: one, to: two))
        })
    }

    @objc
    private func swiftUIPresentation() {
        let hostingController = HostingController()
        hostingController.modalPresentationStyle = .custom
        let navVC = self.parent as? UINavigationController
        navVC?.pushViewController(hostingController, animated: true)
    }


    @objc
    private func embeddedViewControllerPresentation() {
        let viewController = EmbeddedCalendarViewController()
        viewController.modalPresentationStyle = .custom
        let navVC = self.parent as? UINavigationController
        navVC?.pushViewController(viewController, animated: true)
    }
}
