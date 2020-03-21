import 'package:fluttertoast/fluttertoast.dart';

void show(String msg) {
  Fluttertoast.showToast(
    msg: msg,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIos: 1,
    toastLength: Toast.LENGTH_SHORT
  );
}

void cancel() {
  Fluttertoast.cancel();
}