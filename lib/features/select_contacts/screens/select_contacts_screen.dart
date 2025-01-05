import 'package:connectus/colors.dart';
import 'package:connectus/common/widgets/error.dart';
import 'package:connectus/common/widgets/loader.dart';
import 'package:connectus/features/select_contacts/controller/select_contact_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SelectContactsScreen extends ConsumerStatefulWidget {
  static const String routeName = '/select-contact';
  const SelectContactsScreen({super.key});

  @override
  ConsumerState<SelectContactsScreen> createState() =>
      _SelectContactsScreenState();
}

class _SelectContactsScreenState extends ConsumerState<SelectContactsScreen> {
  final TextEditingController searchController = TextEditingController();
  List<Contact> searchResults = [];
  bool isSearching = false;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    searchController.dispose();
  }

  void searhContact(String query, List<Contact> contacts) {
    if (query.isNotEmpty) {
      setState(() {
        isSearching = true;
        searchResults =
            contacts
                .where(
                  (contacts) => contacts.displayName.toLowerCase().contains(
                    query.toLowerCase(),
                  ),
                )
                .toList();
      });
    } else {
      setState(() {
        isSearching = false;
        searchResults = contacts;
      });
    }
  }

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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            isSearching
                ? TextField(
                  controller: searchController,
                  decoration: InputDecoration(
                    hintText: "Search Contacts...",
                    border: InputBorder.none,
                    hintStyle: TextStyle(color: greyColor),
                  ),
                  style: const TextStyle(color: Colors.white),
                  onChanged:
                      (value) => ref
                          .watch(getContactProvider)
                          .whenData(
                            (contacts) => searhContact(value, contacts),
                          ),
                )
                : Text("Select Contact"),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                isSearching = !isSearching;
                if (!isSearching) {
                  searchController.clear();
                  searchResults = [];
                } else {
                  ref.read(getContactProvider).whenData((contacts) {
                    setState(() {
                      searchResults = contacts;
                    });
                  });
                }
              });
            },
            icon: Icon(Icons.search),
          ),
          IconButton(onPressed: () {}, icon: Icon(Icons.more_vert)),
        ],
      ),
      body: ref
          .watch(getContactProvider)
          .when(
            data:
                (contactList) =>
                    isSearching && searchResults.isEmpty
                        ? Container()
                        : ListView.builder(
                          itemCount:
                              isSearching
                                  ? searchResults.length
                                  : contactList.length,
                          itemBuilder: (context, index) {
                            final contact =
                                isSearching
                                    ? searchResults[index]
                                    : contactList[index];
                            return InkWell(
                              onTap: () => selectContact(ref, contact, context),
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
