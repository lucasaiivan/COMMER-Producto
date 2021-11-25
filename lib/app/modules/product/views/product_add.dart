import 'package:animate_do/animate_do.dart';
import 'package:clipboard/clipboard.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:get/get.dart';
import 'package:producto/app/utils/widgets_utils_app.dart';

class WidgetSeachProduct extends StatefulWidget {
  final String codigo;
  WidgetSeachProduct({required this.codigo});

  @override
  _WidgetSeachProductState createState() =>
      _WidgetSeachProductState(codigoBar: codigo);
}

class _WidgetSeachProductState extends State<WidgetSeachProduct> {
  Color colorFondo = Colors.deepPurple;
  Color colorTextButton = Colors.white;
  TextEditingController textEditingController = new TextEditingController();
  String codigoBar = "";
  bool buscando = false;
  String textoTextResult = "";
  bool buttonAddProduct = false;
  bool resultState = true;

  _WidgetSeachProductState({this.codigoBar = ""});

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    if (codigoBar != null) {
      getIdProducto(id: codigoBar);
    }
    textEditingController = TextEditingController(text: codigoBar);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    colorFondo =
        (resultState == true ? Get.theme.primaryColor : Colors.red[400])!;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: colorFondo,
      appBar: appbar(),
      body: _body(),
    );
  }

  /* WIDGETS */
  PreferredSizeWidget appbar() {
    return AppBar(
      elevation: 0.0,
      backgroundColor: colorFondo,
      title: Text(resultState ? "Buscar" : "Sin resultados"),
      bottom: buscando ? linearProgressBarApp(color: colorTextButton) : null,
    );
  }

  Widget _body() {
    return Center(
      child:
          ListView(padding: EdgeInsets.all(0.0), shrinkWrap: true, children: [
        FadeInRight(
          child: buttonAddProduct ? Container() : WidgetOtrosProductosGlobal(),
        ),
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              textField(),
              IconButton(
                padding: EdgeInsets.all(12.0),
                icon: Icon(Icons.content_copy, color: colorTextButton),
                onPressed: () {
                  FlutterClipboard.paste().then((value) {
                    // Do what ever you want with the value.
                    setState(() {
                      textEditingController.text = value;
                      buttonAddProduct = false;
                      codigoBar = value;
                      resultState = true;
                    });
                  });
                },
              ),
              SizedBox(height: 12.0),
              !buscando
                  ? FadeInRight(
                      child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          if (textEditingController.text != "") {
                            setState(() {
                              getIdProducto(id: codigoBar ?? "");
                            });
                          }
                        },
                        style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.all(12.0),
                            primary: colorTextButton,
                            onPrimary: Colors.purple,
                            textStyle: TextStyle(color: Colors.black)),
                        icon: Icon(Icons.search,
                            color: Theme.of(context).primaryColorLight),
                        label: Text("Buscar",
                            style: TextStyle(
                                color: Theme.of(context).primaryColorLight)),
                      ),
                    ))
                  : Container(),
              !buscando ? SizedBox(width: 12.0, height: 12.0) : Container(),
              !buscando
                  ? FadeInLeft(
                      child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          scanBarcodeNormal(context: context);
                        },
                        style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.all(12.0),
                            primary: colorTextButton,
                            onPrimary: Colors.purple,
                            textStyle: TextStyle(color: Colors.black)),
                        icon: Image(
                            color: Theme.of(context).primaryColorLight,
                            height: 20.0,
                            width: 20.0,
                            image: AssetImage('assets/barcode.png'),
                            fit: BoxFit.contain),
                        label: Text("Escanear código",
                            style: TextStyle(
                                color: Theme.of(context).primaryColorLight)),
                      ),
                    ))
                  : Container(),
              buttonAddProduct
                  ? SizedBox(width: 12.0, height: 12.0)
                  : Container(),
              buttonAddProduct
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Si el producto aún no existe, ayúdenos con contribuciones de contenido para que esta aplicación sea aún más útil para la comunidad 💪",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 18.0),
                      ),
                    )
                  : Container(),
              buttonAddProduct
                  ? SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          // Navigator.of(context).pushReplacement( MaterialPageRoute( builder: (BuildContext context) => ProductNew(id: this.codigoBar)));
                        },
                        style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.all(12.0),
                            primary: colorTextButton,
                            onPrimary: Colors.purple,
                            textStyle: TextStyle(color: Colors.black)),
                        icon: Icon(Icons.add,
                            color: Theme.of(context).primaryColorLight),
                        label: Text("Agregar nuevo producto",
                            style: TextStyle(
                                color: Theme.of(context).primaryColorLight)),
                      ),
                    )
                  : Container(),
              SizedBox(width: 50.0, height: 50.0),
            ],
          ),
        ),
      ] //your list view content here
              ),
    );
  }

  /* WIDGETS COMPONENT */
  Widget textField() {
    return TextField(
      controller: textEditingController,
      keyboardType: TextInputType.numberWithOptions(decimal: false),
      inputFormatters: [
        FilteringTextInputFormatter.allow(new RegExp('[1234567890]'))
      ],
      onChanged: (value) {
        setState(() {
          codigoBar = value;
          buttonAddProduct = false;
        });
      },
      decoration: InputDecoration(
          suffixIcon: IconButton(
            onPressed: () {
              setState(() {
                textEditingController.clear();
                buttonAddProduct = false;
                resultState = true;
              });
            },
            icon: textEditingController.text != ""
                ? Icon(Icons.clear, color: colorTextButton)
                : Container(),
          ),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: colorTextButton)),
          border: OutlineInputBorder(
              borderSide: BorderSide(color: colorTextButton)),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: colorTextButton)),
          labelStyle: TextStyle(color: colorTextButton),
          labelText: "Escribe el código",
          suffixStyle: TextStyle(color: colorTextButton)),
      style: TextStyle(fontSize: 30.0, color: colorTextButton),
      textInputAction: TextInputAction.search,
      onSubmitted: (value) {
        if (textEditingController.text != "") {
          setState(() {
            getIdProducto(id: codigoBar);
          });
        }
      },
    );
  }
  /* FUNCTIONS */

  void getIdProducto({required String id}) {
    buscando = true;
    buttonAddProduct = false;
    if (id == "") {
      id = "null";
    }

    /* Global.getProductosPrecargado(idProducto: id)
        .getDataProductoGlobal()
        .then((product) {
      if (product != null) {
        if (product.convertProductoNegocio() != null) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (BuildContext context) =>
                  ProductScreen(producto: product.convertProductoNegocio()),
            ),
          );
        } else {
          buscando = false;
          buttonAddProduct = true;
          colorFondo = Colors.red[400];
          resultState = false;
          setState(() {});
        }
      } else {
        buttonAddProduct = true;
        buscando = false;
        colorFondo = Colors.red[400];
        resultState = false;
        setState(() {});
      }
    }); */
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> scanBarcodeNormal({required BuildContext context}) async {
    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          "#ff6666", "Cancel", true, ScanMode.BARCODE);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    setState(() {
      textEditingController.text = barcodeScanRes;
      codigoBar = barcodeScanRes;
      buscando = true;
      buttonAddProduct = false;
      getIdProducto(id: barcodeScanRes);
    });
  }
}

/* CLASS COMPONENTS */
class WidgetOtrosProductosGlobal extends StatelessWidget {
  const WidgetOtrosProductosGlobal();

  @override
  Widget build(BuildContext context) {
    return Container();
    /* return Container(
      width: double.infinity,
      height: 200.0,
      child: FutureBuilder(
        future: Global.getProductAll().getDataProductoAll(favorite: true),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Producto> listProductos = snapshot.data;
            if (listProductos.length == 0) return Container();
            return CarouselSlider.builder(
                itemCount: listProductos.length,
                options: CarouselOptions(
                    height: 200,
                    enableInfiniteScroll:
                        listProductos.length == 1 ? false : true,
                    autoPlay: listProductos.length == 1 ? false : true,
                    aspectRatio: 2.0,
                    enlargeCenterPage: true,
                    scrollDirection: Axis.horizontal,
                    viewportFraction: 0.8),
                itemBuilder: (BuildContext context, int itemIndex) {
                  return ProductoItemHorizontalSmall(
                      producto:
                          listProductos[itemIndex].convertProductoNegocio());
                });
          } else {
            return Container();
          }
        },
      ),
    ); */
  }
}
