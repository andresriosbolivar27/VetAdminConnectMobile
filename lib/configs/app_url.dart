

class AppUrl {
  static var baseUrl = 'http://192.168.10.22:82' ;

  //Account
  static var loginEndPoint =  '$baseUrl/api/accounts/login' ;
  static var registerApiEndPoint =  '$baseUrl/api/accounts/createuser';

  //Client
  static var getClientEndpoint =  '$baseUrl/api/Clients/ByStringId/';

  //Country
  static var getCountryComboEndpoint = '$baseUrl/api/Countries/combo/';

  //State
  static var getStateComboEndpoint = '$baseUrl/api/States/combo/';

  //City
  static var getCityComboEndpoint = '$baseUrl/api/Cities/combo/';

}