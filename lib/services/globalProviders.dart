

import 'package:quick_blox_aleph/providers/dialogProvider.dart';

class GlobalProviders {

  static final GlobalProviders _singleton = GlobalProviders._internal();

  DialogProvider dialogProvider = DialogProvider();

  factory GlobalProviders(){
    return _singleton;
  }

  GlobalProviders._internal();

}