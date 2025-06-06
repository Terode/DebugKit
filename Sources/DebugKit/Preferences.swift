
import Foundation

@MainActor
public struct Preferences {
    private static let defaults = UserDefaults.standard

    public static var isUsePreProdServerApi: Bool {
        get { defaults.bool(forKey: #function) }
        set { defaults.set(newValue, forKey: #function) }
    }

    public static var isUseTelegraph: Bool {
        get { defaults.bool(forKey: #function) }
        set { defaults.set(newValue, forKey: #function) }
    }

    public static var loadServersFromNodes: Bool {
        get { defaults.bool(forKey: #function) }
        set { defaults.set(newValue, forKey: #function) }
    }

    public static var testShowPopup: Bool {
        get { defaults.bool(forKey: #function) }
        set { defaults.set(newValue, forKey: #function) }
    }

    public static var timeLife: TimeInterval {
        get { defaults.value(forKey: #function) as? Double ?? 60 * 60 * 2 }
        set { defaults.set(newValue, forKey: #function) }
    }

    public static var timeLifeAdsServer: TimeInterval {
        get { defaults.value(forKey: #function) as? Double ?? 15 * 60 }
        set { defaults.set(newValue, forKey: #function) }
    }

    public static var timeForActiveWaitingFeedback: TimeInterval {
        get { defaults.value(forKey: #function) as? Double ?? 20 * 60 }
        set { defaults.set(newValue, forKey: #function) }
    }

    public static var timeForBackgroundWaitingFeedback: TimeInterval {
        get { defaults.value(forKey: #function) as? Double ?? 120 * 60 }
        set { defaults.set(newValue, forKey: #function) }
    }

    public static var timeForceCancelWait: TimeInterval {
        get { defaults.value(forKey: #function) as? Double ?? 60 * 60 * 24 * 2 }
        set { defaults.set(newValue, forKey: #function) }
    }

    public static var timeForcePositiveWait: TimeInterval {
        get { defaults.value(forKey: #function) as? Double ?? 60 * 60 * 24 * 90 }
        set { defaults.set(newValue, forKey: #function) }
    }

    public static var timeDay: TimeInterval {
        get { defaults.value(forKey: #function) as? Double ?? 60 * 60 * 24 }
        set { defaults.set(newValue, forKey: #function) }
    }

    public static var interstitialPerDay: Int {
        get { defaults.value(forKey: #function) as? Int ?? 100 }
        set { defaults.set(newValue, forKey: #function) }
    }

    public static var interstitialInterval: TimeInterval {
        get { defaults.value(forKey: #function) as? Double ?? 0 }
        set { defaults.set(newValue, forKey: #function) }
    }

    public static var adsInspectorTestModeRawValue: String? {
        get { defaults.string(forKey: #function) }
        set { defaults.set(newValue, forKey: #function) }
    }

    public static var testAdsModeRawValue: String? {
        get { defaults.string(forKey: #function) }
        set { defaults.set(newValue, forKey: #function) }
    }

    public static var overrideAppVersion: String? {
        get { defaults.string(forKey: #function) }
        set { defaults.set(newValue, forKey: #function) }
    }
}
