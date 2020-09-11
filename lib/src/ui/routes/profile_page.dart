import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:nour/src/models/user.dart';
import 'package:nour/src/services/utils.dart';
import 'package:nour/src/ui/res/colors.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  User _user, _userWithNewFeatures;
  bool _editUsername = false;
  bool _editPhoneNumber = false;
  TextEditingController _usernameController;
  TextEditingController _phoneNumberController;

  @override
  void initState() {
    super.initState();
    _user = Provider.of<User>(context, listen: false);
    _userWithNewFeatures = _user.copyWith(phoneNumber: '0000 000 0000');
    print(_user == _userWithNewFeatures);
    print(_userWithNewFeatures.phoneNumber);
    _usernameController = TextEditingController(text: _user.username);
    _phoneNumberController =
        TextEditingController();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _phoneNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    //String usernameToShow = _userWithNewFeatures.username;
    //_usernameController.text ?? _user.username;
    //String phoneNumberToShow = _userWithNewFeatures.phoneNumber;
    //_phoneNumberController.text ?? _user.phoneNumber;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        elevation: 0.0,
        centerTitle: true,
        title: Text(
          'Profile',
          style: TextStyle(
            fontSize: 22,
          ),
        ),
        backgroundColor: Colors.transparent,
      ),
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: double.infinity,
                    height: screenSize.height / 3,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Container(
                          child: CircleAvatar(
                            radius: 48,
                            backgroundColor: lgc1,
                            child: CircleAvatar(
                              radius: 42,
                              backgroundImage:
                                  CachedNetworkImageProvider(_user.photoUrl),
                              child: Align(
                                alignment: Alignment(2.3, 2.3),
                                child: IconButton(
                                  icon: Icon(
                                    Icons.edit,
                                    color: lgc1,
                                  ),
                                  onPressed: () {},
                                ),
                              ),
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            _editUsername
                                ? Container(
                                    width: 300,
                                    height: 30,
                                    child: TextField(
                                      controller: _usernameController,
                                      decoration: InputDecoration(
                                          contentPadding: EdgeInsets.all(4),
                                          filled: false,
                                          hintText: _user.email,
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(8),
                                            ),
                                          )),
                                      autofocus: true,
                                      textAlign: TextAlign.center,
                                      keyboardType: TextInputType.text,
                                      onSubmitted: (text) {
                                        setState(() {
                                          _userWithNewFeatures.username = text;
                                          _editUsername = false;
                                        });
                                      },
                                    ),
                                  )
                                : Text(
                                    _userWithNewFeatures.username,
                                    style: TextStyle(
                                      fontSize: 24,
                                    ),
                                  ),
                            IconButton(
                              icon: Icon(
                                _editUsername ? Icons.close : Icons.edit,
                                color: lgc1,
                              ),
                              onPressed: () {
                                setState(() {
                                  _editUsername = !_editUsername;
                                });
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Divider(),
                  Container(
                    //color: Colors.blue,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        ListTile(
                          leading: Icon(
                            Icons.phone,
                            color: lgc1,
                          ),
                          trailing: IconButton(
                            color: lgc1,
                            icon: Icon(
                              _editPhoneNumber ? Icons.cancel : Icons.edit,
                              color: lgc1, //Colors.white,
                            ),
                            onPressed: () {
                              setState(() {
                                _editPhoneNumber = !_editPhoneNumber;
                              });
                            },
                          ),
                          title: Text(
                            'phone',
                            style: TextStyle(
                              fontSize: 14,
                              color: lgc1,
                            ),
                          ),
                          subtitle: _editPhoneNumber
                              ? TextField(
                                  controller: _phoneNumberController,
                                  decoration: InputDecoration(
                                      contentPadding: EdgeInsets.all(4),
                                      filled: false,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(8),
                                        ),
                                      )),
                                  autofocus: true,
                                  enableInteractiveSelection: true,
                                  maxLength: 11,
                                  textAlign: TextAlign.center,
                                  keyboardType: TextInputType.phone,
                                  
                                  onChanged: (text) {},
                                  onSubmitted: (text) {
                                    setState(() {
                                      if (_isValidPhoneNumber(
                                          text)) {
                                        _userWithNewFeatures.phoneNumber = text;
                                      }
                                      _editPhoneNumber = false;
                                    });
                                  },
                                )
                              : Text(
                                  _userWithNewFeatures.phoneNumber??
                                   '0000 000 0000'
                                   ,
                                  style: TextStyle(
                                    fontSize: 18,
                                  ),
                                ),
                        ),
                        SizedBox(height: 16),
                        ListTile(
                          //contentPadding: const EdgeInsets.symmetric(horizontal: 4),
                          leading: Icon(
                            Icons.email,
                            color: lgc1,
                          ),
                          title: Text(
                            'email',
                            style: TextStyle(
                              fontSize: 14,
                              color: lgc1,
                            ),
                          ),
                          subtitle: SelectableText(
                            _user.email,
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                        ),
                        SizedBox(height: 16),
                        ListTile(
                          //contentPadding: const EdgeInsets.symmetric(horizontal: 4),
                          leading: Icon(
                            Icons.perm_contact_calendar,
                            color: lgc1,
                          ),

                          title: Text(
                            'joined since',
                            style: TextStyle(
                              fontSize: 14,
                              color: lgc1,
                            ),
                          ),
                          subtitle: Text(
                            _getDate(_user.joinedSince),
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            _user == _userWithNewFeatures
                ? SizedBox()
                : Align(
                    alignment: Alignment(1, 1),
                    child: ButtonBar(
                      alignment: MainAxisAlignment.end,
                      children: <Widget>[
                        FlatButton(
                          shape: Border.all(
                            color: lgc1,
                            width: 2.0,
                          ),
                          color: Colors.white,
                          textColor: lgc1,
                          onPressed: () {
                            _userWithNewFeatures = _user.copyWith();
                          },
                          child: Text('Cancel'),
                        ),
                        MaterialButton(
                          color: lgc1,
                          child: Text(
                            'Save',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                          onPressed: () {},
                        ),
                      ],
                    ),
                  )
          ],
        ),
      ),
    );
  }

  String _getDate(int millisecondsSinceEpoch) {
    final date = DateTime.fromMillisecondsSinceEpoch(millisecondsSinceEpoch);
    if (isToday(date)) {
      return 'Today';
    } else if (isYesterday(date)) {
      return 'Yesterday';
    }
    return majorDateModified(date);
  }

  bool _isValidPhoneNumber(String text) {
    try {
      final s = text[text.length - 1];
      int tmp = int.parse(s);
      return text.length >= 10 &&
        List<int>.generate(10, (i) => i, growable: false).contains(int.parse(s));
    } catch (e) {
      return false;
    }
    
    
    
  }
}
