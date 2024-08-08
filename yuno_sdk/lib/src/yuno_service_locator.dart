import 'package:yuno_sdk_core/commons/src/injector.dart';

class YunoServiceLocator {
  static final _instance = Injector();


  Future<void> init()async{

    
  }

  Future<void> destroy()async{
    _instance.unregister();
  }
  
}

