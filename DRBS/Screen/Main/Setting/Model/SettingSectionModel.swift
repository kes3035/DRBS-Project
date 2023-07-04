

import UIKit

enum SettingSection {
    case notice([NoticeModel])
    case profile([ProfileModel])
    case option([OptionModel])
    case license([LicenseModel])
    case appVersion([AppVersionModel])
}

struct NoticeModel {
    let leftTitle: String?
}

struct ProfileModel {
    let leftTitle: String?
}

struct OptionModel {
    let leftTitle: String?
}

struct LicenseModel {
    let leftTitle: String?
}

struct AppVersionModel {
    let leftTitle: String?
    let rightTitle: String?
}
