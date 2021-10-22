import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:producto/app/modules/splash/controllers/splash_controller.dart';
import 'package:shimmer/shimmer.dart';

class SplashInit extends GetView<SplashController> {
  @override
  Widget build(BuildContext context) => LoadingInitView();
}

class LoadingInitView extends StatelessWidget {
  const LoadingInitView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext buildContext) {
    Color color = Theme.of(buildContext).brightness == Brightness.dark
        ? Colors.white54
        : Colors.black38;
    Color color1 =
        Colors.black12; //Theme.of(buildContext).canvasColor.withOpacity(0.50);
    Color color2 = Colors.grey;

    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Theme.of(buildContext).canvasColor,
        iconTheme: Theme.of(buildContext)
            .iconTheme
            .copyWith(color: Theme.of(buildContext).textTheme.bodyText1!.color),
        title: InkWell(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 12.0),
            child: Shimmer.fromColors(
              baseColor: color1,
              highlightColor: color2,
              child: Row(
                children: <Widget>[
                  Text("Mi catálogo",
                      style: TextStyle(
                          color: Theme.of(buildContext)
                              .textTheme
                              .bodyText1!
                              .color),
                      overflow: TextOverflow.ellipsis,
                      softWrap: false),
                  Icon(Icons.keyboard_arrow_down),
                ],
              ),
            ),
          ),
        ),
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Shimmer.fromColors(
                baseColor: color1,
                highlightColor: color2,
                child: Icon(Icons.brightness_4)),
          )
        ],
      ),
      body: Shimmer.fromColors(
        baseColor: color1,
        highlightColor: color2,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              InkWell(
                borderRadius: BorderRadius.all(Radius.circular(30.0)),
                splashColor: Theme.of(buildContext).primaryColor,
                onTap: () {},
                child: Container(
                  margin: const EdgeInsets.all(0.0),
                  padding: const EdgeInsets.all(30.0),
                  decoration: BoxDecoration(
                      color: Colors.transparent,
                      border: Border.all(width: 0.2, color: color),
                      borderRadius: BorderRadius.all(Radius.circular(30.0))),
                  child: Image(
                      color: color,
                      height: 200.0,
                      width: 200.0,
                      image: AssetImage('assets/barcode.png'),
                      fit: BoxFit.contain),
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 40.0),
                child: Text("Escanea un producto para conocer su precio",
                    style: TextStyle(
                        fontFamily: "POPPINS_FONT",
                        fontWeight: FontWeight.bold,
                        color: color,
                        fontSize: 24.0),
                    textAlign: TextAlign.center),
              ),
              RaisedButton(
                  padding:
                      EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                  color: Colors.deepPurple[200],
                  child: Text("Buscar",
                      style:
                          TextStyle(fontSize: 24.0, color: Colors.deepPurple)),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      side: BorderSide(color: Colors.transparent)),
                  onPressed: () {}),
            ],
          ),
        ),
      ),
    );
  }
}
