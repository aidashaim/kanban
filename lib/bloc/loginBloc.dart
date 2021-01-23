import 'dart:async';
import 'dart:convert';
import 'package:kanban/bloc/Validator.dart';
import 'package:rxdart/rxdart.dart';
import 'package:http/http.dart' as http;
import 'package:toast/toast.dart';

class LoginBloc extends Validators {
  final _loginController = BehaviorSubject<String>();
  final _passwordController = BehaviorSubject<String>();

  final _tokenController = BehaviorSubject<String>();
  final _authenticated = BehaviorSubject<bool>();

//  add data to stream
  Function(String) get changeLogin => _loginController.sink.add;

  Function(String) get changePassword => _passwordController.sink.add;

//  retrieve data from the stream
  Stream<String> get loginStream =>
      _loginController.stream.transform(validateLogin);

  Stream<String> get passwordStream =>
      _passwordController.stream.transform(validatePassword);

  Stream<bool> get isAuthenticated =>
      _authenticated.stream.transform(authCheck);

//  rx dart getter
// we return true because we just care there are no errors in the 2 stream
  Stream<bool> get submitValid =>
      Rx.combineLatest2(loginStream, passwordStream, (a, b) => true);

  submit() async {
    final validLogin = _loginController.value;
    final validPassword = _passwordController.value;
    if (validLogin != '' && validPassword != '') {
      String token = await login().then((value) => value);
      if (token != null) {
        _authenticated.sink.add(true);
      }
    }
  }

  Future<String> login() async {
    http.Client client = new http.Client();
    Map<String, String> data = {
      "username": "armada",
      "password": "FSH6zBZ0p9yH"
    };
    String body = json.encode(data);
    var response = await client.post(
      'https://trello.backend.tests.nekidaem.ru/api/v1/users/login/',
      headers: {
        'content-type': 'application/json',
        "accept": "application/json",
      },
      body: body,
    );
    var responseBody = await json.decode(response.body);
    if (response.statusCode == 200) {
      return await responseBody['token'];
    } else {
      return null;
    }
  }

  logout() {
    _loginController.sink.add('');
    _authenticated.sink.add(false);
    _tokenController.sink.add('');
  }

  dispose() {
    _loginController.close();
    _passwordController.close();
  }
}
