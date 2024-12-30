import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectus/common/utils/utils.dart';
import 'package:connectus/models/user_model.dart';
import 'package:connectus/features/chat/screens/mobile_chat_screen.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final SelectContactsRepositoryProvider = Provider(
  (ref) =>
      SelectContactRepository(firebaseFirestore: FirebaseFirestore.instance),
);

class SelectContactRepository {
  final FirebaseFirestore firebaseFirestore;

  SelectContactRepository({required this.firebaseFirestore});

  Future<List<Contact>> getContact() async {
    List<Contact> contacts = [];
    try {
      if (await FlutterContacts.requestPermission()) {
        contacts = await FlutterContacts.getContacts(withProperties: true);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return contacts;
  }

  void selectContact(Contact selectedContact,BuildContext context) async{
    try {
      var userCollection= await firebaseFirestore.collection('users').get();
      bool isFound= false;

      for(var document in userCollection.docs){
        var userData=  UserModel.fromMap(document.data());
        String selectedPhoneNum= selectedContact.phones[0].number.replaceAll(' ','');
        if(selectedPhoneNum == userData.phoneNumber){
          isFound=true;
          Navigator.pushNamed(context, MobileChatScreen.routeName,arguments: {
            'name': userData.name,
            'uid': userData.uid
          }); 
        }
        print(selectedPhoneNum);
      }
      if(!isFound){
        showSnackBar(context: context, content: "This number does not exist on this app");
      }
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }
}
