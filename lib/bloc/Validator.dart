import 'dart:async';

class Validators {
  final validateLogin =
      StreamTransformer<String, String>.fromHandlers(handleData: (login, sink) {
    if (login.length > 3) {
      sink.add(login);
    } else {
      sink.addError('Minimum is 4 characters');
    }
  });

  final validatePassword = StreamTransformer<String, String>.fromHandlers(
      handleData: (password, sink) {
    if (password.length > 7) {
      sink.add(password);
    } else {
      sink.addError('Minimum is 8 characters');
    }
  });

  final authCheck =
      StreamTransformer<bool, bool>.fromHandlers(handleData: (auth, sink) {
    if (auth == true) {
      sink.add(true);
    } else {
      sink.add(false);
      sink.addError('Must be Authenticated');
    }
  });
}
