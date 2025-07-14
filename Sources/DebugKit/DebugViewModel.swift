
import UIKit

public enum TimeField: String, CaseIterable {
    case timeLife
    case timeLifeAdsServer
    case timeActiveFeedback
    case timerBackgroundFeedback
    case timeForceCancelWait
    case timeForcePositiveWait
    case timeDay

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
    case server, telegraph, nodes, popup, logs
    case timing(TimeField)
    case interstitialPerDay, interstitialInterval
    case adsInspectorTestMode, testAdsMode
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
        case .logs:
            return "Logs to console"
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

    public var identifier: String {
        switch self {
        case .server:               
            return "server"
        case .telegraph:            
            return "telegraph"
        case .nodes:                
            return "nodes"
        case .popup:                
            return "popup"
        case .logs:
            return "logs"
        case .timing(let field):
            return field.rawValue
        case .interstitialPerDay:   
            return "interstitialPerDay"
        case .interstitialInterval: 
            return "interstitialInterval"
        case .adsInspectorTestMode: 
            return "adsInspectorTestMode"
        case .testAdsMode:          
            return "testAdsMode"
        case .app:                  
            return "app"
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
    case noTest, yandex, adMob
}

public enum TestAdsMode: String, CaseIterable {
    case noTest, adMob, yandex, yandexBigo, yandexMintegral, yandexUnity, yandexLiftoff, yandexIronSource, yandexCharboost

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
    private struct Section {
        let title: String
        var settings: [DebugItem]
    }

    private let allSections: [Section] = [
        Section(title: "General", settings: [.server, .telegraph, .nodes, .logs]),
        Section(title: "Popups", settings: [.popup]),
        Section(title: "Timings", settings: TimeField.allCases.map(DebugItem.timing)),
        Section(title: "Ads", settings: [.interstitialPerDay, .interstitialInterval, .adsInspectorTestMode, .testAdsMode]),
        Section(title: "App", settings: [.app])
    ]

    private var visibleSections: [Section] = []

    public init() {
        let bundle = Bundle(for: DebugViewController.self)
        guard
            let url = bundle.url(forResource: "InfoDebugKit", withExtension: "plist"),
            let info = NSDictionary(contentsOf: url) as? [String:Any]
        else {
            visibleSections = allSections
            return
        }

        let sectionDict = info["DebugKitVisibleSections"] as? [String: Bool] ?? [:]
        let itemsDict = info["DebugKitVisibleItems"] as? [String: [String: Bool]] ?? [:]

        visibleSections = allSections.compactMap { section in
            if sectionDict[section.title] == false {
                return nil
            }
            
            let filtered = section.settings.filter { item in
                itemsDict[section.title]?[item.identifier] ?? true
            }
            
            guard !filtered.isEmpty else {
                return nil
            }
            
            return Section(title: section.title, settings: filtered)
        }
    }

    public var numberOfSections: Int {
        visibleSections.count
    }
    
    public func numberOfRows(in section: Int) -> Int {
        visibleSections[section].settings.count
    }
    
    public func titleForSection(_ section: Int) -> String {
        visibleSections[section].title
    }
    
    public func settingItem(at indexPath: IndexPath) -> DebugItem {
        visibleSections[indexPath.section].settings[indexPath.row]
    }

    public func configure(_ cell: DebugTableViewCell, at indexPath: IndexPath) {
        let item = settingItem(at: indexPath)
        switch item {
        case .server:
            let value = Preferences.isUsePreProdServerApi
            cell.configure(title: item.title, showSegment: true,
                           segmentOptions: ["preprod","prod"], selectedSegmentIndex: value ? 0 : 1)
            cell.onSegmentChanged = {
                Preferences.isUsePreProdServerApi = ($0 == 0)
            }

        case .telegraph:
            let value = Preferences.isUseTelegraph
            cell.configure(title: item.title, showSwitch: true, isSwitchOn: value)
            cell.onSwitchChanged = {
                Preferences.isUseTelegraph = $0
            }

        case .nodes:
            let value = Preferences.loadServersFromNodes
            cell.configure(title: item.title, showSwitch: true, isSwitchOn: value)
            cell.onSwitchChanged = {
                Preferences.loadServersFromNodes = $0
            }

        case .popup:
            let value = Preferences.testShowPopup
            cell.configure(title: item.title, showSwitch: true, isSwitchOn: value)
            cell.onSwitchChanged = {
                Preferences.testShowPopup = $0
            }
            
        case .logs:
            let value = Preferences.isShowLogs
            cell.configure(title: item.title, showSwitch: true, isSwitchOn: value)
            cell.onSwitchChanged = {
                Preferences.isShowLogs = $0
            }

        case .timing(var time):
            let value = time.currentValue
            cell.configure(title: item.title, showTextField: true, text: String(Int(value)))
            cell.onTextChanged = {
                if let interval = TimeInterval($0) {
                    time.currentValue = interval
                }
            }

        case .interstitialPerDay:
            let value = Preferences.interstitialPerDay
            cell.configure(title: item.title, showTextField: true, text: String(value))
            cell.onTextChanged = {
                if let int = Int($0) {
                    Preferences.interstitialPerDay = int
                }
            }

        case .interstitialInterval:
            let value = Preferences.interstitialInterval
            cell.configure(title: item.title, showTextField: true, text: String(Int(value)))
            cell.onTextChanged = {
                if let interval = TimeInterval($0) {
                    Preferences.interstitialInterval = interval
                }
            }

        case .adsInspectorTestMode:
            let rawValue = Preferences.adsInspectorTestModeRawValue ?? AdsInspectorTestMode.noTest.rawValue
            let currentValue = AdsInspectorTestMode(rawValue: rawValue) ?? .noTest
            let options = AdsInspectorTestMode.allCases.map(\.rawValue)
            let selectValue = options.firstIndex(of: currentValue.rawValue) ?? 0
            cell.configure(title: item.title, showSegment: true, segmentOptions: options, selectedSegmentIndex: selectValue)
            cell.onSegmentChanged = { index in
                let chosenIndex = AdsInspectorTestMode.allCases[index]
                Preferences.adsInspectorTestModeRawValue = chosenIndex.rawValue
                switch chosenIndex {
                case .noTest:
                    Preferences.testAdsModeRawValue = TestAdsMode.noTest.rawValue
                case .yandex:
                    Preferences.testAdsModeRawValue = TestAdsMode.yandex.rawValue
                case .adMob:
                    Preferences.testAdsModeRawValue = TestAdsMode.adMob.rawValue
                }
            }

        case .testAdsMode:
            let rawValue = Preferences.testAdsModeRawValue ?? TestAdsMode.noTest.rawValue
            let currentValue = TestAdsMode(rawValue: rawValue) ?? .noTest
            cell.configure(title: item.title, showButton: true, buttonTitle: currentValue.rawValue)
            cell.onButtonTapped = {
                
            }

        case .app:
            let value = Preferences.overrideAppVersion
                ?? Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "0"
            cell.configure(title: item.title, showTextField: true, text: value)
            cell.onTextChanged = {
                Preferences.overrideAppVersion = $0
            }
        }
    }

    public func updateTestAdsMode(at indexPath: IndexPath, to newMode: TestAdsMode) {
        Preferences.testAdsModeRawValue = newMode.rawValue
        let mode: AdsInspectorTestMode = {
            switch newMode {
            case .noTest:
                return .noTest
            case .adMob:
                return .adMob
            default:
                return .yandex
            }
        }()
        
        Preferences.adsInspectorTestModeRawValue = mode.rawValue
    }
}
