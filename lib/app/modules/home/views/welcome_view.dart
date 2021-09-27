import 'package:producto/app/modules/home/controllers/welcome_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WelcomeView extends GetView<WelcomeController> {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Obx(()=> controller.load==false?Text('profile load...'):Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'User Profile',
              style: TextStyle(fontSize: 30, color: Colors.white),
            ),
            SizedBox(
              height: 16,
            ),
           CircleAvatar(
              radius: 70,
              backgroundImage: NetworkImage( controller.userProfile.urlfotoPerfil ),
            ), 
            SizedBox(
              height: 10,
            ),
            Text(
              'Display Name : ${controller.userProfile.keyName}',
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
            SizedBox(
              height: 10,
            ),
            Obx(()=>Text(
              controller.userProfile.email ,
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),),
            SizedBox(
              height: 10,
            ),
            ConstrainedBox(
              constraints: BoxConstraints.tightFor(width: 120),
              child: ElevatedButton(
                child: Text(
                  "Logout",
                  style: TextStyle(fontSize: 16, color: Colors.black),
                ),
                onPressed: () {
                  controller.logout();
                },
              ),
            ),
            

          ],
        ),
      )),
    );
  }
}
