import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
// import 'package:toast/toast.dart';

import 'view/plane.dart';
import 'view/pertamina.dart';
import 'view/profile.dart';

import 'helper/api.dart';
import 'view/toast.dart' as Toast;

void main(){
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Login(),
    theme: ThemeData(),
  ));
}

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

enum LoginStatus {notSignIn, signIn}

class _LoginState extends State<Login> {

  LoginStatus _loginStatus = LoginStatus.notSignIn;
  String email, password;
  final _key = GlobalKey<FormState>();

  bool _secureText = true;

  showHide(){
    setState((){
      _secureText = !_secureText;
    });
  }

  check(){
    final form = _key.currentState;
    if(form.validate()){
      form.save();
      login();
    }
  }

  login() async{
    final response = await http.post(
        BaseUrl.login,
        body: {
          "email": email,
          "password": password
        }
    );

    if (response.statusCode == 200) {

      Map<String, dynamic> data = jsonDecode(response.body);

      if (data.containsKey("data")) {
        
        int value = data['value'];
        String _pesan = data['message'];

        String _email = data['email'];
        String _fullname = data['fullname'];
        String _id = data['id'];

        if(value == 1){
          setState(() {
            _loginStatus = LoginStatus.signIn;
            savePref(
              value,
              _email,
              _fullname,
              _id,
            );
          });
          Toast.show("$_pesan, Selamat datang $_fullname");
          print(_pesan);
        } else {
          Toast.show("$_pesan, Periksa kembali data anda!");
          print(_pesan);
        }
      } else {

        Toast.show("Data Profil tidak ditemukan");
      }      

    } else {
      Toast.show("Gagal menghubungi Server");
      print("Status Code ${response.statusCode}");
    }
    
  }

  savePref(int value, String email, String fullname, String id) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      preferences.setInt("value", value);

      preferences.setString("email", email);
      preferences.setString("fullname", fullname);
      preferences.setString("id", id);
      // ignore: deprecated_member_use
      preferences.commit();
    });
  }

  var value;

  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      value = preferences.getInt("value");
      _loginStatus = value == 1 ? LoginStatus.signIn : LoginStatus.notSignIn;
    });
  }

  signOut() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      preferences.setInt("value", null);
      // ignore: deprecated_member_use
      preferences.commit();
      _loginStatus = LoginStatus.notSignIn;
    });
  }

  @override
  void initState(){
    super.initState();
    getPref();
  }

  @override
  Widget build(BuildContext context) {
    switch (_loginStatus) {
      case LoginStatus.notSignIn:
        return Scaffold(
          appBar: AppBar(
            title: const Text('Login'),
          ),
          body: Form(
            key: _key,
            child: ListView(
              padding: EdgeInsets.all(16.0),
              children: <Widget>[
                TextFormField(
                  validator: (e){
                    if(e.isEmpty){
                      return "Masukkan E-mail anda";
                    }
                  },
                  onSaved: (e) => email = e,
                  decoration: InputDecoration(
                    labelText: "E-mail",
                  ),
                ),
                TextFormField(
                  obscureText: _secureText,
                  onSaved: (e) => password = e,
                  decoration: InputDecoration(
                    labelText: "Password",
                    suffixIcon: IconButton(
                      onPressed: showHide,
                      icon: Icon(
                          _secureText ? Icons.visibility_off : Icons.visibility
                      ),
                    ),
                  ),
                  validator: (e){
                    if(e.isEmpty){
                      return "Masukkan Password anda";
                    }
                  },
                ),
                MaterialButton(onPressed: (){
                  check();
                },
                  child: Text("Login"),
                ),
                InkWell(
                  onTap: (){
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => Register())
                    );
                  },
                  child: Text(
                    "Tidak memiliki akun? Buat disini",
                    textAlign: TextAlign.center,
                  ),
                )
              ],
            ),
          ),
        );
        break;
      case LoginStatus.signIn:
        return MainMenu(signOut);
        break;
    }
  }
}

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  String email, password, fullname;
  final _key = new GlobalKey<FormState>();

  bool _secureText = true;

  showHide(){
    setState(() {
      _secureText = !_secureText;
    });
  }

  check(){
    final form = _key.currentState;
    if (form.validate()){
      form.save();
      save();
    }
  }

  save() async {
    final response = await http.post(
        BaseUrl.register,
        body: {
          "fullname": fullname,
          "email": email,
          "password": password
        }
    );

    final data = jsonDecode(response.body);

    int value = data['value'];
    String pesan = data['message'];

    if(value == 1){
      setState(() {
        Toast.show(pesan);
        Navigator.pop(context);
        print(pesan);
      });
    } else {
      Toast.show(pesan);
      print(pesan);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
      ),
      body: Form(
        key: _key,
        child: ListView(
          padding: EdgeInsets.all(16.0),
          children: <Widget>[
            TextFormField(
              validator: (e){
                if (e.isEmpty){
                  return "Masukkan nama lengkap";
                }
              },
              onSaved: (e) => fullname = e,
              decoration: InputDecoration(labelText: "Nama Lengkap"),
            ),
            TextFormField(
              validator: (e){
                if (e.isEmpty){
                  return "Masukkan E-mail";
                }
              },
              onSaved: (e) => email = e,
              decoration: InputDecoration(labelText: "E-mail"),
            ),
            TextFormField(
              obscureText: _secureText,
              onSaved: (e) => password = e,
              validator: (e){
                if (e.isEmpty){
                  return "Masukkan Password";
                }
              },
              decoration: InputDecoration(
                  labelText: "Password",
                  suffixIcon: IconButton(
                    onPressed: showHide,
                    icon: Icon(
                      _secureText ? Icons.visibility_off : Icons.visibility,
                    ),
                  )
              ),
            ),
            MaterialButton(
              onPressed: (){
                check();
              },
              child: Text("Register"),
            ),
          ],
        ),
      ),
    );
  }
}

class MainMenu extends StatefulWidget {

  final VoidCallback signOut;
  MainMenu(this.signOut);

  @override
  _MainMenuState createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {

  signOut(){
    setState(() {
      widget.signOut();
    });
  }

  String email = "", fullname = "";
  TabController tabController;

  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      email = preferences.getString("email");
      fullname = preferences.getString("fullname");
    });
  }

  @override
  void initState(){
    super.initState();
    getPref();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Kata(?)nya"),
          actions: <Widget>[
            IconButton(
              onPressed: (){
                signOut();
              },
              icon: Icon(Icons.lock_open),
            ),
          ],
        ),
        body: TabBarView(
          children: <Widget>[
            Plane(),
            Pertamina(),
            Profile(),
          ],
        ),
        bottomNavigationBar: TabBar(
          labelColor: Colors.blue,
          unselectedLabelColor: Colors.grey,
          indicator: UnderlineTabIndicator(
              borderSide: BorderSide(style: BorderStyle.none)
          ),
          tabs: <Widget>[
            Tab(
              icon: Icon(Icons.airplanemode_active),
              text: "Plane",
            ),
            Tab(
              icon: Icon(Icons.attach_money),
              text: "Pertamina",
            ),
            Tab(
              icon: Icon(Icons.account_circle),
              text: "Profile",
            ),
          ],
        ),
      ),
    );
  }
}