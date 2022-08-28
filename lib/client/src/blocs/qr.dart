import 'package:shared_preferences/shared_preferences.dart';

import '../models/qr.dart';
import 'package:rxdart/rxdart.dart';
import '../enums/qr.dart';

class QrBloc {
  // TODO: [Qr] add your missing properties and methods here.

  /// the controller of QrBloc states
  BehaviorSubject<QrState> _controller =
      BehaviorSubject<QrState>.seeded(QrState.loaded);

  /// the stream of Qr states
  Stream<QrState> get stream => _controller.stream;

  /// the state variable of Qr
  Qr _state = Qr();

  /// the state getter of Qr
  Qr get state => _state;

  /// the current event of Qr stream
  QrState get event => _controller.value;

  /// the singleton
  static final QrBloc instance = QrBloc._();

  /// private constructor
  QrBloc._() {
    // TODO: [Qr] load and sync your data here
    fetch();
  }

  /// factory constructor, don't touch it
  factory QrBloc() {
    return instance;
  }

  /// fetches all Qr
  fetch() async {
    _controller.add(QrState.loading);
    SharedPreferences preferences = await SharedPreferences.getInstance();
    if (preferences.containsKey("device") &&
        preferences.containsKey("ip") &&
        preferences.containsKey("pass")) {
      _state.device = preferences.getString("device");
      _state.ip = preferences.getString("ip");
      _state.pass = preferences.getString("pass");
    } else {
      _state = await Qr.generate();
      await save();
    }
    _controller.add(QrState.loaded);
  }

  save() async {
    _controller.add(QrState.loading);
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setString("device", _state.device!);
    await preferences.setString("ip", _state.ip!);
    await preferences.setString("pass", _state.pass!);
    _controller.add(QrState.loaded);
  }

  generate() async {
    _controller.add(QrState.generatePassword);
    _state.generatePassword();
    await save();
  }
}
