

import UIKit

enum ProfileSection {
    case profileImage([ProfileImageModel])
    case loginRoute([LoginRouteModel])
    case name([NameModel])
    case nickName([NickNameModel])
    case phoneNumber([PhoneNumberModel])
    case address([AddressModel])
}

struct ProfileImageModel {
    var image: UIImage?
}

struct LoginRouteModel {
    var loginIcon: UIImage?
    var email: String?
}

struct NameModel {
    var name: String?
}

struct NickNameModel {
    var nickName: String?
}

struct PhoneNumberModel {
    var phoneNumber: String?
}

struct AddressModel {
    var address: String?
}
