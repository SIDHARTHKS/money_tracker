// To parse this JSON data, do
//
//     final loginRequest = loginRequestFromJson(jsonString);

import 'dart:convert';

LoginRequest loginRequestFromJson(String str) =>
    LoginRequest.fromJson(json.decode(str));

String loginRequestToJson(LoginRequest data) => json.encode(data.toJson());

class LoginRequest {
  String? grantType;
  String? username;
  String? password;

  LoginRequest({
    this.grantType,
    this.username,
    this.password,
  });

  factory LoginRequest.fromJson(Map<String, dynamic> json) => LoginRequest(
        grantType: json["grant_type"],
        username: json["username"],
        password: json["password"],
      );

  Map<String, dynamic> toJson() => {
        "grant_type": grantType,
        "username": username,
        "password": password,
      };
}

//
//

RefreshRequest refreshRequestFromJson(String str) =>
    RefreshRequest.fromJson(json.decode(str));

String refreshRequestToJson(RefreshRequest data) => json.encode(data.toJson());

class RefreshRequest {
  String? grantType;
  String? refershToken;

  RefreshRequest({
    this.grantType,
    this.refershToken,
  });

  factory RefreshRequest.fromJson(Map<String, dynamic> json) => RefreshRequest(
        grantType: json["grant_type"],
        refershToken: json["refersh_token"],
      );

  Map<String, dynamic> toJson() => {
        "grant_type": grantType,
        "refersh_token": refershToken,
      };
}

//
//

LoginResponse loginResponseFromJson(String str) =>
    LoginResponse.fromJson(json.decode(str));

String loginResponseToJson(LoginResponse data) => json.encode(data.toJson());

class LoginResponse {
  String? accessToken;
  String? tokenType;
  String? refreshToken;
  int? expiresIn;
  String? scope;
  String? organization;
  String? appssid;
  String? personInfoId;
  String? jti;

  LoginResponse({
    this.accessToken,
    this.tokenType,
    this.refreshToken,
    this.expiresIn,
    this.scope,
    this.organization,
    this.appssid,
    this.personInfoId,
    this.jti,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) => LoginResponse(
        accessToken: json["access_token"],
        tokenType: json["token_type"],
        refreshToken: json["refresh_token"],
        expiresIn: json["expires_in"],
        scope: json["scope"],
        organization: json["organization"],
        appssid: json["appssid"],
        personInfoId: json["personInfoID"],
        jti: json["jti"],
      );

  Map<String, dynamic> toJson() => {
        "access_token": accessToken,
        "token_type": tokenType,
        "refresh_token": refreshToken,
        "expires_in": expiresIn,
        "scope": scope,
        "organization": organization,
        "appssid": appssid,
        "personInfoID": personInfoId,
        "jti": jti,
      };
}

EmailResponse emailResponseFromJson(String str) =>
    EmailResponse.fromJson(json.decode(str));

String emailResponseToJson(EmailResponse data) => json.encode(data.toJson());

class EmailResponse {
  String? emailId;

  EmailResponse({
    this.emailId,
  });

  factory EmailResponse.fromJson(Map<String, dynamic> json) => EmailResponse(
        emailId: json["EmailID"],
      );

  Map<String, dynamic> toJson() => {
        "EmailID": emailId,
      };
}

OtpRequest otpRequestFromJson(String str) =>
    OtpRequest.fromJson(json.decode(str));

String otpRequestToJson(OtpRequest data) => json.encode(data.toJson());

class OtpRequest {
  Requestotp? request;
  int? pageMode;

  OtpRequest({
    this.request,
    this.pageMode,
  });

  factory OtpRequest.fromJson(Map<String, dynamic> json) => OtpRequest(
        request: json["Request"] == null
            ? null
            : Requestotp.fromJson(json["Request"]),
        pageMode: json["PageMode"],
      );

  Map<String, dynamic> toJson() => {
        "Request": request?.toJson(),
        "PageMode": pageMode,
      };
}

class Requestotp {
  String? userCode;
  String? emailId;

  Requestotp({
    this.userCode,
    this.emailId,
  });

  factory Requestotp.fromJson(Map<String, dynamic> json) => Requestotp(
        userCode: json["UserCode"],
        emailId: json["EmailID"],
      );

  Map<String, dynamic> toJson() => {
        "UserCode": userCode,
        "EmailID": emailId,
      };
}

OtpResponse otpResponseFromJson(String str) =>
    OtpResponse.fromJson(json.decode(str));

String otpResponseToJson(OtpResponse data) => json.encode(data.toJson());

class OtpResponse {
  String? verificationCode;

  OtpResponse({
    this.verificationCode,
  });

  factory OtpResponse.fromJson(Map<String, dynamic> json) => OtpResponse(
        verificationCode: json["VerificationCode"],
      );

  Map<String, dynamic> toJson() => {
        "VerificationCode": verificationCode,
      };
}

VerifyOtpRequest verifyOtpRequestFromJson(String str) =>
    VerifyOtpRequest.fromJson(json.decode(str));

String verifyOtpRequestToJson(VerifyOtpRequest data) =>
    json.encode(data.toJson());

class VerifyOtpRequest {
  VerifyOtpDetails? request;
  int? pageMode;

  VerifyOtpRequest({
    this.request,
    this.pageMode,
  });

  factory VerifyOtpRequest.fromJson(Map<String, dynamic> json) =>
      VerifyOtpRequest(
        request: json["Request"] == null
            ? null
            : VerifyOtpDetails.fromJson(json["Request"]),
        pageMode: json["PageMode"],
      );

  Map<String, dynamic> toJson() => {
        "Request": request?.toJson(),
        "PageMode": pageMode,
      };
}

class VerifyOtpDetails {
  String? userCode;
  String? verificationCode;

  VerifyOtpDetails({
    this.userCode,
    this.verificationCode,
  });

  factory VerifyOtpDetails.fromJson(Map<String, dynamic> json) =>
      VerifyOtpDetails(
        userCode: json["UserCode"],
        verificationCode: json["VerificationCode"],
      );

  Map<String, dynamic> toJson() => {
        "UserCode": userCode,
        "VerificationCode": verificationCode,
      };
}
