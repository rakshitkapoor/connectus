import 'package:connectus/common/widgets/error.dart';
import 'package:connectus/common/widgets/loader.dart';
import 'package:connectus/features/select_contacts/controller/select_contact_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SelectContactsScreen extends ConsumerWidget {
  static const String routeName = '/select-contact';
  const SelectContactsScreen({super.key});

  void selectContact(
    WidgetRef ref,
    Contact selectedContact,
    BuildContext context,
  ) {
    ref
        .read(selectContactControllerProvider)
        .selectContact(selectedContact, context);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Select Contact"),
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.search)),
          IconButton(onPressed: () {}, icon: Icon(Icons.more_vert)),
        ],
      ),
      body: ref
          .watch(getContactProvider)
          .when(
            data:
                (contactList) => ListView.builder(
                  itemCount: contactList.length,
                  itemBuilder: (context, index) {
                    final contact = contactList[index];
                    return InkWell(
                      onTap: ()=> selectContact(ref,contact,context),
                      child: Padding(
                        padding: EdgeInsets.only(bottom: 8.0),
                        child: ListTile(
                          title: Text(
                            contact.displayName,
                            style: const TextStyle(fontSize: 18),
                          ),
                          leading:
                              contact.photo == null
                                  ? null
                                  : CircleAvatar(
                                    backgroundImage: MemoryImage(
                                      contact.photo!,
                                    ),
                                    radius: 30,
                                  ),
                        ),
                      ),
                    );
                  },
                ),
            error: (err, trace) => ErrorScreen(error: err.toString()),
            loading: () => const Loader(),
          ),
    );
  }
}
