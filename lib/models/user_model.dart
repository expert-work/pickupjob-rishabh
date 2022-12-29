//User Model
class UserModel {
  final String uid;
  String email;
  String name;
  String firstName;
  String lastName;
  String photoUrl;
  String userType;
  bool isProfileCompleted;
  bool isIndividual;

  String? driverLicNumber;
  String? driverLicBack;
  String? driverLicFront;

  String? companyName;
  String? incorporationState;
  String? usdotLicNum;
  String? einTaxIdNum;

  String? fullAddress;
  String? suitAptNumber;

  String? city;
  String? zipCode;
  String? state;
  String? phoneNumber;
  String? otherPhoneNumber;
  String? websiteLink;
  String? deviceToken;
  int numberOfVehicle;
  String? geohash;
  String? lat;
  String? lng;

  UserModel({
    required this.uid,
    required this.email,
    required this.name,
    required this.firstName,
    required this.lastName,
    required this.photoUrl,
    required this.userType,
    required this.isProfileCompleted,
    required this.isIndividual,
    this.driverLicNumber,
    this.driverLicBack,
    this.driverLicFront,
    this.companyName,
    this.incorporationState,
    this.usdotLicNum,
    this.einTaxIdNum,
    this.fullAddress,
    this.suitAptNumber,
    this.city,
    this.zipCode,
    this.state,
    this.phoneNumber,
    required this.deviceToken,
    required this.numberOfVehicle,
    this.geohash,
    this.lat,
    this.lng,
  });

  factory UserModel.fromMap(Map data) {
    return UserModel(
      uid: data['uid'],
      email: data['email'] ?? '',
      name: data['name'] ?? '',
      firstName: data['firstName'] ?? '',
      lastName: data['lastName'] ?? '',
      photoUrl: data['photoUrl'] ?? '',
      userType: data['userType'] ?? '',
      isIndividual: data['isIndividual'] ?? true,
      isProfileCompleted: data['isProfileCompleted'] ?? '',
      driverLicNumber: data['driverLicNumber'],
      driverLicBack: data['driverLicBack'],
      driverLicFront: data['driverLicFront'],
      companyName: data['companyName'],
      incorporationState: data['incorporationState'],
      usdotLicNum: data['usdotLicNum'],
      einTaxIdNum: data['einTaxIdNum'],
      fullAddress: data['fullAddress'],
      suitAptNumber: data['suitAptNumber'],
      city: data['city'],
      zipCode: data['zipCode'],
      state: data['state'],
      phoneNumber: data['phoneNumber'],
      deviceToken: data['deviceToken'],
      numberOfVehicle:
          (data['numberOfVehicle'] == null) ? 0 : data['numberOfVehicle'],
      geohash: data['geohash'],
      lat: data['lat'],
      lng: data['lng'],
    );
  }

  Map<String, dynamic> toJson() => {
        "uid": uid,
        "email": email,
        "name": name,
        "firstName": firstName,
        "lastName": lastName,
        "photoUrl": photoUrl,
        "userType": userType,
        "isProfileCompleted": isProfileCompleted,
        "isIndividual": isIndividual,
        "driverLicNumber": driverLicNumber,
        "driverLicBack": driverLicBack,
        "driverLicFront": driverLicFront,
        "companyName": companyName,
        "incorporationState": incorporationState,
        "usdotLicNum": usdotLicNum,
        "einTaxIdNum": einTaxIdNum,
        "fullAddress": fullAddress,
        "suitAptNumber": suitAptNumber,
        "city": city,
        "zipCode": zipCode,
        "state": state,
        "phoneNumber": phoneNumber,
        "deviceToken": deviceToken,
        "numberOfVehicle": numberOfVehicle,
        "geohash": geohash,
        "lat": lat,
        "lng": lng
      };
}
