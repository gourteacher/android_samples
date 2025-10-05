import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';
class DataRepository {

  static String firstName = "";
  static String emailAddress ="";
  static String lastName = "";
  static String phoneNumber = "";
  static String login = "Rosa";

  static void loadData(){
    EncryptedSharedPreferences prefs = EncryptedSharedPreferences();

  }

  static void saveData(){

  }
}