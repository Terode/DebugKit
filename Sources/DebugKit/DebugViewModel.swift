
import UIKit

public enum TimeField: String, CaseIterable {
    case timeLife
    case timeLifeAdsServer
    case timeActiveFeedback
    case timerBackgroundFeedback
    case timeForceCancelWait
    case timeForcePositiveWait
    case timeDay

    @MainActor
    public var currentValue: TimeInterval {
        get {
            switch self {
            case .timeLife:
                return Preferences.timeLife
            case .timeLifeAdsServer:
                return Preferences.timeLifeAdsServer
            case .timeActiveFeedback:
                return Preferences.timeForActiveWaitingFeedback
            case .timerBackgroundFeedback:
                return Preferences.timeForBackgroundWaitingFeedback
            case .timeForceCancelWait:
                return Preferences.timeForceCancelWait
            case .timeForcePositiveWait:
                return Preferences.timeForcePositiveWait
            case .timeDay:
                return Preferences.timeDay
            }
        }
        set {
            switch self {
            case .timeLife:
                Preferences.timeLife = newValue
            case .timeLifeAdsServer:
                Preferences.timeLifeAdsServer = newValue
            case .timeActiveFeedback:
                Preferences.timeForActiveWaitingFeedback = newValue
            case .timerBackgroundFeedback:
                Preferences.timeForBackgroundWaitingFeedback = newValue
            case .timeForceCancelWait:
                Preferences.timeForceCancelWait = newValue
            case .timeForcePositiveWait:
                Preferences.timeForcePositiveWait = newValue
            case .timeDay:
                Preferences.timeDay = newValue
            }
        }
    }
}

public enum DebugItem {
    case server
    case telegraph
    case nodes
    case popup
    case timing(TimeField)
    case interstitialPerDay
    case interstitialInterval
    case adsInspectorTestMode
    case testAdsMode
    case app

    public var title: String {
        switch self {
        case .server:
            return "Server"
        case .telegraph:
            return "Telegraph"
        case .nodes:
            return "Load servers from nodes"
        case .popup:
            return "Show popup"
        case .timing(let field):
            return field.rawValue
        case .interstitialPerDay:
            return "Interstitial per day"
        case .interstitialInterval:
            return "Interstitial interval"
        case .adsInspectorTestMode:
            return "Ads inspector"
        case .testAdsMode:
            return "Test ads mode"
        case .app:
            return "Version"
        }
    }
}

public enum DebugControl {
    case segment(options: [String], selectedIndex: Int)
    case toggle(isOn: Bool)
    case textField(text: String)
    case button(text: String)
}

public enum AdsInspectorTestMode: String, CaseIterable {
    case noTest
    case yandex
    case adMob
}

public enum TestAdsMode: String, CaseIterable {
    case noTest
    case adMob
    case yandex
    case yandexBigo
    case yandexMintegral
    case yandexUnity
    case yandexLiftoff
    case yandexIronSource
    case yandexCharboost

    public var isYandex: Bool {
        switch self {
        case .noTest, .adMob:
            return false
        default:
            return true
        }
    }
}

@MainActor
public struct DebugViewModel {
    private let itemsBySection: [[DebugItem]] = [
        [.server, .telegraph, .nodes],
        [.popup],
        TimeField.allCases.map { DebugItem.timing($0) },
        [.interstitialPerDay, .interstitialInterval, .adsInspectorTestMode, .testAdsMode],
        [.app]
    ]

    public init() { }

    public var numberOfSections: Int {
        itemsBySection.count
    }

    public func numberOfRows(in section: Int) -> Int {
        itemsBySection[section].count
    }

    public func titleForSection(_ section: Int) -> String {
        switch section {
        case 0: return "General"
        case 1: return "Popups"
        case 2: return "Timings"
        case 3: return "Ads"
        case 4: return "App"
        default: return ""
        }
    }

    public func settingItem(at indexPath: IndexPath) -> DebugItem {
        itemsBySection[indexPath.section][indexPath.row]
    }

    public func configure(_ cell: DebugTableViewCell, at indexPath: IndexPath) {
        let item = settingItem(at: indexPath)

        switch item {
        case .server:
            let value = Preferences.isUsePreProdServerApi
            cell.configure(
                title: item.title,
                showSegment: true,
                segmentOptions: ["preprod", "prod"],
                selectedSegmentIndex: value ? 0 : 1
            )
            cell.onSegmentChanged = { newIndex in
                Preferences.isUsePreProdServerApi = (newIndex == 0)
            }

        case .telegraph:
            let value = Preferences.isUseTelegraph
            cell.configure(
                title: item.title,
                showSwitch: true,
                isSwitchOn: value
            )
            cell.onSwitchChanged = { newValue in
                Preferences.isUseTelegraph = newValue
            }

        case .nodes:
            let value = Preferences.loadServersFromNodes
            cell.configure(
                title: item.title,
                showSwitch: true,
                isSwitchOn: value
            )
            cell.onSwitchChanged = { newValue in
                Preferences.loadServersFromNodes = newValue
            }

        case .popup:
            let value = Preferences.testShowPopup
            cell.configure(
                title: item.title,
                showSwitch: true,
                isSwitchOn: value
            )
            cell.onSwitchChanged = { newValue in
                Preferences.testShowPopup = newValue
            }

        case .timing(var field):
            let value = field.currentValue
            cell.configure(
                title: item.title,
                showTextField: true,
                text: String(Int(value))
            )
            cell.onTextChanged = { newText in
                if let interval = TimeInterval(newText) {
                    field.currentValue = interval
                }
            }

        case .interstitialPerDay:
            let value = Preferences.interstitialPerDay
            cell.configure(
                title: item.title,
                showTextField: true,
                text: String(value)
            )
            cell.onTextChanged = { newText in
                if let intValue = Int(newText) {
                    Preferences.interstitialPerDay = intValue
                }
            }

        case .interstitialInterval:
            let value = Preferences.interstitialInterval
            cell.configure(
                title: item.title,
                showTextField: true,
                text: String(Int(value))
            )
            cell.onTextChanged = { newText in
                if let dblValue = TimeInterval(newText) {
                    Preferences.interstitialInterval = dblValue
                }
            }

        case .adsInspectorTestMode:
            let raw = Preferences.adsInspectorTestModeRawValue ?? AdsInspectorTestMode.noTest.rawValue
            let current = AdsInspectorTestMode(rawValue: raw) ?? .noTest
            let options = AdsInspectorTestMode.allCases.map { $0.rawValue }
            let selected = options.firstIndex(of: current.rawValue) ?? 0

            cell.configure(
                title: item.title,
                showSegment: true,
                segmentOptions: options,
                selectedSegmentIndex: selected
            )
            cell.onSegmentChanged = { newIndex in
                let chosen = AdsInspectorTestMode.allCases[newIndex]
                Preferences.adsInspectorTestModeRawValue = chosen.rawValue

                // синхронизируем testAdsMode
                switch chosen {
                case .noTest:
                    Preferences.testAdsModeRawValue = TestAdsMode.noTest.rawValue
                case .yandex:
                    Preferences.testAdsModeRawValue = TestAdsMode.yandex.rawValue
                case .adMob:
                    Preferences.testAdsModeRawValue = TestAdsMode.adMob.rawValue
                }
            }

        case .testAdsMode:
            let raw = Preferences.testAdsModeRawValue ?? TestAdsMode.noTest.rawValue
            let current = TestAdsMode(rawValue: raw) ?? .noTest
            let buttonTitle = current.rawValue

            cell.configure(
                title: item.title,
                showButton: true,
                buttonTitle: buttonTitle
            )
            cell.onButtonTapped = { }
            // Обработчик показа ActionSheet’а расположен в DebugViewController

        case .app:
            let value = Preferences.overrideAppVersion
                ?? Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
                ?? "0"
            cell.configure(
                title: item.title,
                showTextField: true,
                text: value
            )
            cell.onTextChanged = { newText in
                Preferences.overrideAppVersion = newText
            }
        }
    }

    public func updateTestAdsMode(at indexPath: IndexPath, to newMode: TestAdsMode) {
        Preferences.testAdsModeRawValue = newMode.rawValue

        let inspectorMode: AdsInspectorTestMode = {
            switch newMode {
            case .noTest:
                return .noTest
            case .adMob:
                return .adMob
            default:
                return .yandex
            }
        }()

        Preferences.adsInspectorTestModeRawValue = inspectorMode.rawValue
    }
}
