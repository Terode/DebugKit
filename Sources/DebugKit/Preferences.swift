
import Foundation

public typealias DebugPreferences = Preferences

public struct Preferences {

    public static var isUsePreProdServerApi: Bool {
        get { UserDefaults.standard.bool(forKey: #function) }
        set { UserDefaults.standard.set(newValue, forKey: #function) }
    }

    public static var isUseTelegraph: Bool {
        get {
            if UserDefaults.standard.object(forKey: #function) == nil {
                return true
            }
            return UserDefaults.standard.bool(forKey: #function)
        }
        set { UserDefaults.standard.set(newValue, forKey: #function) }
    }

    public static var loadServersFromNodes: Bool {
        get { UserDefaults.standard.bool(forKey: #function) }
        set { UserDefaults.standard.set(newValue, forKey: #function) }
    }

    public static var testShowPopup: Bool {
        get { UserDefaults.standard.bool(forKey: #function) }
        set { UserDefaults.standard.set(newValue, forKey: #function) }
    }

    public static var timeLife: TimeInterval {
        get { UserDefaults.standard.value(forKey: #function) as? Double ?? 60 * 60 * 2 }
        set { UserDefaults.standard.set(newValue, forKey: #function) }
    }

    public static var timeLifeAdsServer: TimeInterval {
        get { UserDefaults.standard.value(forKey: #function) as? Double ?? 15 * 60 }
        set { UserDefaults.standard.set(newValue, forKey: #function) }
    }

    public static var timeForActiveWaitingFeedback: TimeInterval {
        get { UserDefaults.standard.value(forKey: #function) as? Double ?? 20 * 60 }
        set { UserDefaults.standard.set(newValue, forKey: #function) }
    }

    public static var timeForBackgroundWaitingFeedback: TimeInterval {
        get { UserDefaults.standard.value(forKey: #function) as? Double ?? 120 * 60 }
        set { UserDefaults.standard.set(newValue, forKey: #function) }
    }

    public static var timeForceCancelWait: TimeInterval {
        get { UserDefaults.standard.value(forKey: #function) as? Double ?? 60 * 60 * 24 * 2 }
        set { UserDefaults.standard.set(newValue, forKey: #function) }
    }

    public static var timeForcePositiveWait: TimeInterval {
        get { UserDefaults.standard.value(forKey: #function) as? Double ?? 60 * 60 * 24 * 90 }
        set { UserDefaults.standard.set(newValue, forKey: #function) }
    }

    public static var timeDay: TimeInterval {
        get { UserDefaults.standard.value(forKey: #function) as? Double ?? 60 * 60 * 24 }
        set { UserDefaults.standard.set(newValue, forKey: #function) }
    }

    public static var interstitialPerDay: Int {
        get { UserDefaults.standard.value(forKey: #function) as? Int ?? 100 }
        set { UserDefaults.standard.set(newValue, forKey: #function) }
    }

    public static var interstitialInterval: TimeInterval {
        get { UserDefaults.standard.value(forKey: #function) as? Double ?? 0 }
        set { UserDefaults.standard.set(newValue, forKey: #function) }
    }

    public static var adsInspectorTestModeRawValue: String? {
        get { UserDefaults.standard.string(forKey: #function) }
        set { UserDefaults.standard.set(newValue, forKey: #function) }
    }

    public static var testAdsModeRawValue: String? {
        get { UserDefaults.standard.string(forKey: #function) }
        set { UserDefaults.standard.set(newValue, forKey: #function) }
    }

    public static var overrideAppVersion: String? {
        get { UserDefaults.standard.string(forKey: #function) }
        set { UserDefaults.standard.set(newValue, forKey: #function) }
    }
}
