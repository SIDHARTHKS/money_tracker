import 'dart:convert';

ProfileRequest profileRequestFromJson(String str) =>
    ProfileRequest.fromJson(json.decode(str));

String profileRequestToJson(ProfileRequest data) => json.encode(data.toJson());

class ProfileRequest {
  ProfileRequestDetails? request;
  int? pageMode;

  ProfileRequest({
    this.request,
    this.pageMode,
  });

  factory ProfileRequest.fromJson(Map<String, dynamic> json) => ProfileRequest(
        request: json["Request"] == null
            ? null
            : ProfileRequestDetails.fromJson(json["Request"]),
        pageMode: json["PageMode"],
      );

  Map<String, dynamic> toJson() => {
        "Request": request?.toJson(),
        "PageMode": pageMode,
      };
}

class ProfileRequestDetails {
  // Renamed Request
  int? employeeId;

  ProfileRequestDetails({
    this.employeeId,
  });

  factory ProfileRequestDetails.fromJson(Map<String, dynamic> json) =>
      ProfileRequestDetails(
        employeeId: json["EmployeeID"],
      );

  Map<String, dynamic> toJson() => {
        "EmployeeID": employeeId,
      };
}

ProfileResponse profileResponseFromJson(String str) =>
    ProfileResponse.fromJson(json.decode(str));

String profileResponseToJson(ProfileResponse data) =>
    json.encode(data.toJson());

class ProfileResponse {
  int? employeeId;
  String? employeeCode;
  String? employeeName;
  String? designation;
  String? email;
  String? mobileNumber;
  String? emergencyMobNumber;
  String? dob;
  String? permanentAddress;
  String? presentAddress;
  String? empImagePath;
  String? team;
  String? offDesignation;
  String? joiningDate;
  String? offEmail;
  String? companyAddress;
  String? reportingHead;
  String? reportingperson;
  String? bankName;
  String? branch;
  String? ifscCode;
  String? accountNumber;
  String? pfUanNumber;
  String? pfJoiningDate;
  String? pfNominee;
  String? esiNumber;
  String? esiJoiningDate;
  String? esiNominee;

  ProfileResponse({
    this.employeeId,
    this.employeeCode,
    this.employeeName,
    this.designation,
    this.email,
    this.mobileNumber,
    this.emergencyMobNumber,
    this.dob,
    this.permanentAddress,
    this.presentAddress,
    this.empImagePath,
    this.team,
    this.offDesignation,
    this.joiningDate,
    this.offEmail,
    this.companyAddress,
    this.reportingHead,
    this.reportingperson,
    this.bankName,
    this.branch,
    this.ifscCode,
    this.accountNumber,
    this.pfUanNumber,
    this.pfJoiningDate,
    this.pfNominee,
    this.esiNumber,
    this.esiJoiningDate,
    this.esiNominee,
  });

  factory ProfileResponse.fromJson(Map<String, dynamic> json) =>
      ProfileResponse(
        employeeId: json["EmployeeID"],
        employeeCode: json["EmployeeCode"],
        employeeName: json["EmployeeName"],
        designation: json["Designation"],
        email: json["Email"],
        mobileNumber: json["MobileNumber"],
        emergencyMobNumber: json["EmergencyMobNumber"],
        dob: json["Dob"],
        permanentAddress: json["permanentAddress"],
        presentAddress: json["PresentAddress"],
        empImagePath: json["EmpImagePath"],
        team: json["Team"],
        offDesignation: json["OffDesignation"],
        joiningDate: json["JoiningDate"],
        offEmail: json["OffEmail"],
        companyAddress: json["CompanyAddress"],
        reportingHead: json["ReportingHead"],
        reportingperson: json["Reportingperson"],
        bankName: json["BankName"],
        branch: json["Branch"],
        ifscCode: json["IFSCCode"],
        accountNumber: json["AccountNumber"],
        pfUanNumber: json["PFUanNumber"],
        pfJoiningDate: json["PFJoiningDate"],
        pfNominee: json["PFNominee"],
        esiNumber: json["ESINumber"],
        esiJoiningDate: json["ESIJoiningDate"],
        esiNominee: json["ESINominee"],
      );

  Map<String, dynamic> toJson() => {
        "EmployeeID": employeeId,
        "EmployeeCode": employeeCode,
        "EmployeeName": employeeName,
        "Designation": designation,
        "Email": email,
        "MobileNumber": mobileNumber,
        "EmergencyMobNumber": emergencyMobNumber,
        "Dob": dob,
        "permanentAddress": permanentAddress,
        "PresentAddress": presentAddress,
        "EmpImagePath": empImagePath,
        "Team": team,
        "OffDesignation": offDesignation,
        "JoiningDate": joiningDate,
        "OffEmail": offEmail,
        "CompanyAddress": companyAddress,
        "ReportingHead": reportingHead,
        "Reportingperson": reportingperson,
        "BankName": bankName,
        "Branch": branch,
        "IFSCCode": ifscCode,
        "AccountNumber": accountNumber,
        "PFUanNumber": pfUanNumber,
        "PFJoiningDate": pfJoiningDate,
        "PFNominee": pfNominee,
        "ESINumber": esiNumber,
        "ESIJoiningDate": esiJoiningDate,
        "ESINominee": esiNominee,
      };
}
