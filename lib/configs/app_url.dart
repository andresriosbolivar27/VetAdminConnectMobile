

class AppUrl {
  //static var baseUrl = 'https://vetadminconnectbackend.azurewebsites.net' ;
  static var baseUrl = 'http://192.168.10.15:82' ;

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

  static var getVetsEndpoint = '$baseUrl/api/Vets';

  //Pets
  static var addPetsApiEndPoint =  '$baseUrl/api/pets/createpet';

  //Specie
  static var getSpecieComboEndpoint = '$baseUrl/api/Species/combo/';

  //Breed
  static var getBreedComboEndpoint = '$baseUrl/api/Breeds/combo/';

}