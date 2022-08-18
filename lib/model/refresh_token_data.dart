
class RefreshTokenData {
  final String clientId = 'barbri_mobile_client_2016';
  final String grantType = 'refresh_token';
  final String refreshToken;
  RefreshTokenData({required this.refreshToken});

  RefreshTokenData.fromJson(Map<String, dynamic> json)
      : refreshToken = json['refresh_token'];

  Map<String, dynamic> toJson() => {
    'client_id': clientId,
    'grant_type': grantType,
    'refresh_token': refreshToken,
  };

  Map<String, String> toMap() => {
    'client_id': clientId,
    'grant_type': grantType,
    'refresh_token': refreshToken,
  };
}
