import Fastis
import UIKit

class EmbeddedCalendarViewController: UIViewController {
    private lazy var containerView: UIStackView = {
        let view = UIStackView()
        view.backgroundColor = .clear
        view.axis = .vertical
        view.distribution = .fill
        view.alignment = .fill
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()

    private lazy var dateViewController: FastisController = {
        var customConfig: FastisConfig = .default
        let fastisController = FastisController(mode: .range, config: customConfig)
        fastisController.title = ""
        fastisController.allowToChooseNilDate = true
        fastisController.shortcuts = []
        fastisController.shouldShowDateSelectionHeader = false
        fastisController.dateRangeSelectionHandler = { [weak self] dateRange in
            let startDate = dateRange.startDate
            let endDate = dateRange.endDate

            print("Handle start date \(startDate), handle end date: \(endDate)")
        }
        fastisController.minimumDate = Date()

        return fastisController
    }()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureUI()
        self.configureSubviews()
        self.configureConstraints()
    }

    // MARK: - Configuration

    private func configureUI() {
        self.view.backgroundColor = .gray
        self.navigationItem.title = "Embedded view controller demo"
        self.navigationItem.largeTitleDisplayMode = .always
    }

    private func configureSubviews() {
        addChild(dateViewController)
        containerView.addArrangedSubview(dateViewController.view)
        dateViewController.didMove(toParent: self)
        view.addSubview(self.containerView)
    }

    private func configureConstraints() {
        NSLayoutConstraint.activate([
            self.containerView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            self.containerView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 200),
            self.containerView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            self.containerView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor,constant: -50)
        ])
    }
}
