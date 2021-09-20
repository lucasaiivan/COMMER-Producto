import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:producto/app/modules/splash/controllers/splash_controller.dart';

class HomeView extends GetView<SplashController>  {
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(
        ),
      ),
    );
  }
}

