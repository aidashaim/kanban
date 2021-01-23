import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:kanban/bloc/Provider.dart';
import 'package:kanban/bloc/loginBloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

singIn(String login, password) async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  http.Client client = new http.Client();

  ///LOGIN
  /*List<dynamic> data = [
      {"request": "login", "name": "test", "password": "1234"}
    ];
    String body = json.encode(data);
    print(body);
    var response_post = await client.post(
      'http://fitpad.me/api/auth',
      headers: {
        'content-type': 'application/json',
        "accept": "application/json",
      },
      body: body,
    );
    print(response_post.statusCode);
    List<dynamic> profile = json.decode(response_post.body);
    print(profile);
    if (response_post.statusCode == 302) {
      var strCookie = response_post.headers['set-cookie'];
    }
    setState(() {
      _isLoading = false;
    });*/

  ///REG
  /*List<dynamic> data = [
      {"request": "register", "email": "test123@mail.ru", "password": "1234"}
    ];
    String body = json.encode(data);
    print(body);
    var response_post = await client.post(
      'http://fitpad.me/api/auth',
      headers: {
        'content-type': 'application/json',
        "accept": "application/json",
      },
      body: body,
    );
    print(response_post.statusCode);
    List<dynamic> profile = json.decode(response_post.body);
    print(profile);
    setState(() {
      _isLoading = false;
    });*/
  Map data = {'name': login, 'pass': password, 'form_id': 'user_login_block'};
  var response_post = await client.post('http://fitpad.me/', body: data);
  if (response_post.statusCode == 302) {
    var strCookie = response_post.headers['set-cookie'];
    sharedPreferences.setString(
        'cookie', strCookie.substring(0, strCookie.indexOf(';')));

    ///
    var strLocation = response_post.headers['location'];
    sharedPreferences.setString('location', strLocation);
    var response_get =
        await client.get(strLocation, headers: {'cookie': strCookie});
    /*if (response_get.statusCode == 200) {
        var response_get_name = await client
            .get('http://fitpad.me/?q=user', headers: {'cookie': strCookie});

        var strName = response_get_name.body.substring(
            response_get.body.lastIndexOf(login),
            response_get.body.lastIndexOf(login) + login.length);
        sharedPreferences.setString('accountName', strName);
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
                builder: (BuildContext context) =>
                new ProfilePage(name: strName)),
                (Route<dynamic> route) => false);
        setState(() {
          _isLoading = false;
        });
      }
    } else {
      setState(() {
        _isLoading = false;
      });
      print('ERROR ');
      ToastMessage().showToast(context, "Неверный логин или пароль");
    }*/
  }
}

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Kanban'.toUpperCase()),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width / 6,
            vertical: MediaQuery.of(context).size.height / 6),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            _loginField(bloc),
            _passwordField(bloc),
            SizedBox(height: MediaQuery.of(context).size.height / 12),
            _submitButton(bloc),
          ],
        ),
      ),
      resizeToAvoidBottomPadding: false,
    );
  }

  Widget _loginField(LoginBloc bloc) {
    return StreamBuilder(
      stream: bloc.loginStream,
      builder: (context, snapshot) {
        return TextField(
          onChanged: bloc.changeLogin,
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
              hintText: 'your login',
              labelText: 'Login',
              errorText: snapshot.error,
              labelStyle: TextStyle(color: Theme.of(context).primaryColor)),
        );
      },
    );
  }

  Widget _passwordField(LoginBloc bloc) {
    return StreamBuilder(
      stream: bloc.passwordStream,
      builder: (context, snapshot) {
        return TextField(
          onChanged: bloc.changePassword,
          obscureText: true,
          decoration: InputDecoration(
              hintText: 'your password',
              labelText: 'Password',
              errorText: snapshot.error,
              labelStyle: TextStyle(color: Theme.of(context).primaryColor)),
        );
      },
    );
  }

  Widget _submitButton(LoginBloc bloc) {
    return StreamBuilder(
      stream: bloc.submitValid,
      builder: (context, snapshot) {
        return FlatButton(
          onPressed: snapshot.hasData ? bloc.submit : null,
          minWidth: MediaQuery.of(context).size.width / 3 * 2,
          shape: Border.all(width: 1.0, color: Theme.of(context).primaryColor),
          padding: EdgeInsets.symmetric(vertical: 15.0),
          child: Text(
            'Войти'.toUpperCase(),
            style: Theme.of(context).textTheme.headline1,
          ),
        );
      },
    );
  }
}
