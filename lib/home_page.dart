import 'package:contacts_app/contact.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

enum RadioButtons { A, B }

class _HomePageState extends State<HomePage> {
  List<Contact> contactList = List.empty(growable: true);

  String personal = 'Personal';
  String business = 'Business';

    List<Contact> get filterContactList {
    return contactList.where((Contact) {
      final name = Contact.contactType;
      if (filterContact == all) {
        return name.contains('');
      } else {
        return name.contains(filterContact);
      }
    }).toList();
  }
  String all = 'All';
  String searchText = '';

  String filterContact = 'All';

  String selectedRadioItem = 'Personal';

  TextEditingController contactNameController = TextEditingController();
  TextEditingController contactNumberController = TextEditingController();
  TextEditingController contactSearchController = TextEditingController();

  void reloadData() {
    setState(() {});
  }



  List<Contact> get searchContactList {
    return filterContactList.where((Contact) {
      final name = Contact.name.toLowerCase();
      final search = searchText.toLowerCase();

      return name.contains(search);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 231, 217, 234),
      appBar: AppBar(
        title: const Text('Contacts'),
        actions: <Widget>[
          IconButton(
              onPressed: () {
                showDialog(
                    barrierDismissible: true,
                    context: context,
                    builder: (context) {
                      return StatefulBuilder(builder: (context, setState) {
                        return AlertDialog(
                          title: const Text('Filter'),
                          content: SizedBox(
                            height: 240,
                            width: 200,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                RadioListTile(
                                    value: all,
                                    groupValue: filterContact,
                                    title: const Text('All'),
                                    onChanged: (value) {
                                      setState(() {
                                        filterContact = value.toString();
                                      });
                                    }),
                                RadioListTile(
                                    value: personal,
                                    groupValue: filterContact,
                                    title: const Text('Personal'),
                                    onChanged: (value) {
                                      setState(() {
                                        filterContact = value.toString();
                                      });
                                    }),
                                RadioListTile(
                                    value: business,
                                    groupValue: filterContact,
                                    title: const Text('Business'),
                                    onChanged: (value) {
                                      setState(() {
                                        filterContact = value.toString();
                                      });
                                    })
                              ],
                            ),
                          ),
                          backgroundColor: Colors.purple.shade100,
                          actions: [
                            TextButton(
                              onPressed: () {
                                reloadData();
                                Navigator.pop(context);
                              },
                              child: const Text("Okay"),
                            ),
                          ],
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                          ),
                        );
                      });
                    });
              },
              icon: const Icon(Icons.filter_list_rounded))
        ],
        backgroundColor: Colors.purple[800],
        elevation: 0.0,
      ),
      body: Column(
        children: [
          TextField(
            controller: contactSearchController,
            onChanged: (value) {
              setState(() {
                searchText = value;
              });
            },
            decoration: const InputDecoration(
                labelText: 'Search', prefixIcon: Icon(Icons.search)),
          ),
          Expanded(
              child: searchContactList.isNotEmpty
                  ? ListView.builder(
                      itemCount: searchContactList.length,
                      itemBuilder: (context, index) {
                        return getRow(index);
                      },
                    )
                  : const Center(child: Text('No Contact Availble!')))
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.purple[800],
        foregroundColor: Colors.white,
        onPressed: () {
          showDialog(
              barrierDismissible: true,
              context: context,
              builder: (context) {
                return StatefulBuilder(builder: (context, setState) {
                  return AlertDialog(
                    title: const Text('Create'),
                    content: SizedBox(
                      height: 240,
                      width: 200,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextField(
                            controller: contactNameController,
                            onChanged: (value) {},
                            decoration: const InputDecoration(hintText: "Name"),
                          ),
                          TextField(
                            keyboardType: TextInputType.number,
                            controller: contactNumberController,
                            maxLength: 10,
                            onChanged: (value) {},
                            decoration:
                                const InputDecoration(hintText: "Mobile No."),
                          ),
                          RadioListTile(
                              value: personal,
                              groupValue: selectedRadioItem,
                              title: const Text('Personal'),
                              onChanged: (value) {
                                setState(() {
                                  selectedRadioItem = value.toString();
                                });
                              }),
                          RadioListTile(
                              value: business,
                              groupValue: selectedRadioItem,
                              title: const Text('Business'),
                              onChanged: (value) {
                                setState(() {
                                  selectedRadioItem = value.toString();
                                });
                              })
                        ],
                      ),
                    ),
                    backgroundColor: Colors.purple.shade100,
                    actions: [
                      TextButton(
                        onPressed: () {
                          if (contactNameController.text.isNotEmpty &&
                              contactNumberController.text.isNotEmpty) {
                            contactList.add(Contact(
                                name: contactNameController.text,
                                number: contactNumberController.text,
                                contactType: selectedRadioItem));

                            contactNameController.text = '';
                            contactNumberController.text = '';
                            selectedRadioItem = personal;
                            reloadData();
                            Navigator.pop(context);
                          }
                        },
                        child: const Text("Add"),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text("Cancel"),
                      ),
                    ],
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                    ),
                  );
                });
              });
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget getRow(int index) {
    return ListTile(
      onTap: () {
        contactNameController.text = searchContactList[index].name;
        contactNumberController.text = searchContactList[index].number;
        selectedRadioItem = searchContactList[index].contactType;


        showDialog(
            barrierDismissible: false,
            context: context,
            builder: (context) {
              return StatefulBuilder(builder: (context, setState) {
                return AlertDialog(
                  title: const Text('Edit'),
                  content: SizedBox(
                    height: 240,
                    width: 200,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextFormField(
                          controller: contactNameController..text.toString(),
                          decoration: const InputDecoration(hintText: "Name"),
                        ),
                        TextField(
                          keyboardType: TextInputType.number,
                          controller: contactNumberController,
                          maxLength: 10,
                          decoration:
                              const InputDecoration(hintText: "Mobile No."),
                        ),
                        RadioListTile(
                            value: personal,
                            groupValue: selectedRadioItem,
                            title: const Text('Personal'),
                            onChanged: (value) {
                              setState(() {
                                selectedRadioItem = value.toString();
                              });
                            }),
                        RadioListTile(
                            value: business,
                            groupValue: selectedRadioItem,
                            title: const Text('Business'),
                            onChanged: (value) {
                              setState(() {
                                selectedRadioItem = value.toString();
                              });
                            })
                      ],
                    ),
                  ),
                  backgroundColor: Colors.purple.shade100,
                  actions: [
                    TextButton(
                      onPressed: () {
                        contactList.remove(contactList[index]);
                        reloadData();

                        Navigator.pop(context);
                      },
                      child: const Text("Delete"),
                    ),
                    TextButton(
                      onPressed: () {
                        String contactName = contactNameController.text;
                        String contactNumber = contactNumberController.text;

                        if (contactName.isNotEmpty &&
                            contactNumber.isNotEmpty) {
                          contactList[index].name = contactName;
                          contactList[index].number = contactNumber;
                          contactList[index].contactType = selectedRadioItem;

                          reloadData();

                          contactNameController.text = '';
                          contactNumberController.text = '';
                          selectedRadioItem = personal;

                          Navigator.pop(context);
                        }
                      },
                      child: const Text("Update"),
                    ),
                  ],
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                  ),
                );
              });
            });
      },
      leading: CircleAvatar(
        backgroundColor:
            index % 2 == 0 ? Colors.deepPurpleAccent : Colors.purple[500],
        foregroundColor: Colors.white,
        child: Text(contactList[index].name[0]),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                searchContactList[index].name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                children: [
                  Text(
                    searchContactList[index].contactType,
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Text(searchContactList[index].number)
                ],
              ),
              const Divider(
                color: Colors.black,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
