import 'dart:convert';
import 'dart:io';

import 'package:bcrypt/bcrypt.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:random_password_generator/random_password_generator.dart';
import 'package:device_info_plus/device_info_plus.dart';

class Qr {
  // TODO: [Qr] add your missing properties and methods here.
  String? device;
  String? ip;
  String? pass;
  Qr({
    this.device,
    this.ip,
    this.pass,
  });

  Qr copyWith({
    String? device,
    String? ip,
    String? pass,
  }) {
    return Qr(
      device: device ?? this.device,
      ip: ip ?? this.ip,
      pass: pass ?? this.pass,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'device': device,
      'ip': ip,
      'pass': pass,
    };
  }

  factory Qr.fromMap(Map<String, dynamic> map) {
    return Qr(
      device: map['device'],
      ip: map['ip'],
      pass: map['pass'],
    );
  }

  String toJson() => json.encode(toMap());

  String crypt() => BCrypt.hashpw("$device#$ip#$pass", BCrypt.gensalt());

  factory Qr.fromJson(String source) => Qr.fromMap(json.decode(source));

  static Future<Qr> generate() async {
    Qr qr = Qr();
    qr.generatePassword();
    await qr.getDeviceIp();
    await qr.getDeviceName();
    return qr;
  }

  @override
  String toString() => 'Qr(device: $device, ip: $ip, pass: $pass)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Qr &&
        other.device == device &&
        other.ip == ip &&
        other.pass == pass;
  }

  @override
  int get hashCode => device.hashCode ^ ip.hashCode ^ pass.hashCode;

  generatePassword() {
    final password = RandomPasswordGenerator();
    String newPassword = password.randomPassword(
      letters: true,
      numbers: true,
      passwordLength: 10,
      specialChar: false,
      uppercase: true,
    );
    pass = newPassword;
  }

  Future getDeviceName() async {
    var deviceInfo = DeviceInfoPlugin();
    var deviceLinux = await deviceInfo.linuxInfo;
    device = deviceLinux.name;
  }

  Future getDeviceIp() async {
    ip = await NetworkInfo().getWifiIP();
  }
}
