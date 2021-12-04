import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:producto/app/modules/product/controllers/product_edit_controller.dart';
import 'package:producto/app/utils/widgets_utils_app.dart';

class ProductEdit extends StatelessWidget {
  ProductEdit({Key? key}) : super(key: key);

  ControllerProductsEdit controller = Get.find();
  Widget space = SizedBox(
    height: 16.0,
    width: 16.0,
  );

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ControllerProductsEdit>(
      id: 'updateAll',
      init: ControllerProductsEdit(),
      initState: (_) {},
      builder: (_) {
        return Scaffold(
          appBar: appBar(contextPrincipal: context),
          body: ListView(
            children: [
               widgetsImagen(),
              widgetFormEditText(),
            ],
          ),
        );
      },
    );
  }

  // WIDGETS VIEWS
  PreferredSizeWidget appBar({required BuildContext contextPrincipal}) {
    return AppBar(
      elevation: 0.0,
      backgroundColor: Get.theme.scaffoldBackgroundColor,
      iconTheme: Theme.of(contextPrincipal).iconTheme.copyWith(
          color: Theme.of(contextPrincipal).textTheme.bodyText1!.color),
      title: controller.getSaveIndicator
          ? Text("Actualizando...",
              style: TextStyle(
                  fontSize: 18.0,
                  color: Theme.of(contextPrincipal).textTheme.bodyText1!.color))
          : Row(
              children: <Widget>[
                controller.getProduct.verificado == true
                    ? Padding(
                        padding: EdgeInsets.only(right: 3.0),
                        child: new Image.asset('assets/icon_verificado.png',
                            width: 16.0, height: 16.0))
                    : new Container(),
                Text(controller.getProduct.id,
                    style: TextStyle(
                        fontSize: 18.0,
                        color: Theme.of(contextPrincipal)
                            .textTheme
                            .bodyText1!
                            .color)),
              ],
            ),
      actions: <Widget>[
        IconButton(
            icon: controller.getSaveIndicator == false
                ? Icon(Icons.check)
                : Container(),
            onPressed: () {
              // TODO: Editar para produccion
              /* editable
                  ? guardarDeveloper(buildContext: context)
                  : guardar(buildContext: contextBuilder); */
            }),
      ],
      bottom: controller.getSaveIndicator ? linearProgressBarApp() : null,
    );
  }

  Widget widgetsImagen() {
    return Column(
      children: [
        controller.loadImage(),
        controller.getNewProduct?
        Row(
          children: [
            Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: FloatingActionButton.extended(
                    heroTag:'' ,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5)),
                    backgroundColor: Get.theme.primaryColor,
                    foregroundColor: Colors.white,
                    onPressed: controller.getLoadImageGalery,
                    icon: Icon(Icons.photo_library, color: Colors.white),
                    label: Text('Galeria', style: TextStyle(color: Colors.white)),
                  ),
                )),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: FloatingActionButton(
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5)),
                backgroundColor: Get.theme.primaryColor,
                foregroundColor: Colors.white,
                onPressed: controller.getLoadImageCamera,
                child: Icon(Icons.camera_alt, color: Colors.white),
              ),
            ),
          ],
        ):Container(),
      ],
    );
  }

  Widget widgetFormEditText() {
    return Container(
      padding: EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [],
          ),
          buttonsCategory(),
          space,
          controller.getMarkSelected.id == ''
              ? SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: controller.showModalSelectMarca,
                    child: Text("Marca"),
                    style: ButtonStyle(
                        padding: MaterialStateProperty.all<EdgeInsets>(
                            EdgeInsets.all(16))),
                  ),
                )
              : Container(),
          space,
          TextField(
            minLines: 1,
            maxLines: 5,
            keyboardType: TextInputType.multiline,
            //enabled: !producto.verificado,
            onChanged: (value) => controller.getProduct.descripcion = value,
            decoration: InputDecoration(
                border: OutlineInputBorder(),
                disabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: controller.getEditable
                            ? Colors.grey
                            : Colors.transparent,
                        width: 2)),
                labelText: "Descripción"),
            //style: controller.getProduct.verificado ? textStyle_disabled : textStyle,
            controller: controller.controllerTextEdit_descripcion,
          ),
          space,
          TextField(
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            onChanged: (value) => controller.getProduct.precioCompra =
                controller.controllerTextEdit_precio_compra.numberValue,
            decoration: InputDecoration(
                border: OutlineInputBorder(), labelText: "Precio de compra"),
            //style: textStyle,
            controller: controller.controllerTextEdit_precio_compra,
          ),
          space,
          TextField(
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            onChanged: (value) => controller.getProduct.precioVenta =
                controller.controllerTextEdit_precio_venta.numberValue,
            decoration: InputDecoration(
                border: OutlineInputBorder(), labelText: "Precio de venta"),
            //style: textStyle,
            controller: controller.controllerTextEdit_precio_venta,
          ),
          space,
          controller.getNewProduct?Container():SizedBox(
            width: double.infinity,
            child: button(
                colorAccent: Colors.white,
                colorButton: Colors.red,
                icon: Icon(Icons.delete),
                text: 'Eliminar de mi catálogo',
                onPressed: () {}),
          ),
          /* SizedBox(height: 25.0),
          enCatalogo?saveIndicador == false ? buttonDeleteProducto(context: builderContext):Container():Container(),
          SizedBox(height: 20.0),
          /* OPCIONES PARA DESARROLLADOR - ELIMINAR ESTE CÓDIGO PARA PRODUCCION */
          SizedBox(height: 20.0),
          Row(children: [Expanded(child: Divider(height:2.0,endIndent:12.0,indent: 12.0,)),Text("Opciones para desarrollador"),Expanded(child: Divider(height:1.0,endIndent:12.0,indent: 12.0))],),
          SizedBox(height: 20.0),
          buttonAddFavorite(context: builderContext),
          SizedBox(height: !editable?20.0:0.0),
          !editable?buttonEditProductoOPTDeveloper(context:builderContext ):Container(),
          SizedBox(height: 20.0),
          editable?buttonDeleteProductoOPTDeveloper(context:builderContext):Container(),
          SizedBox(height: 50.0),  */
        ],
      ),
    );
  }

  /* WIDGETS COMPONENT */
  Widget buttonsCategory() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          flex: 1,
          child: OutlinedButton(
            onPressed: () {},
            child: Text("Categoría"),
            style: ButtonStyle(
                padding:
                    MaterialStateProperty.all<EdgeInsets>(EdgeInsets.all(16))),
          ),
        ),
        SizedBox(width: 5),
        Expanded(
          flex: 1,
          child: OutlinedButton(
            onPressed: () {},
            child: Text("Subcategoría"),
            style: ButtonStyle(
                padding:
                    MaterialStateProperty.all<EdgeInsets>(EdgeInsets.all(16))),
          ),
        )
      ],
    );
  }

  Widget button(
      {required Widget icon,
      String text = '',
      required dynamic onPressed,
      double padding = 12.0,
      Color colorButton = Colors.purple,
      Color colorAccent = Colors.white}) {
    return FadeInRight(
        child: Padding(
      padding: EdgeInsets.all(padding),
      child: ElevatedButton.icon(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
            padding: EdgeInsets.all(12.0),
            primary: colorButton,
            textStyle: TextStyle(color: colorAccent)),
        icon: icon,
        label: Text(text, style: TextStyle(color: colorAccent)),
      ),
    ));
  }

  // TODO: OPCIONES PARA EL DESARROLLADOR ( Eliminar para producción )
  /* Widget buttonAddFavorite({@required BuildContext context}) {
    return this.producto.favorite? SizedBox(
            width: double.infinity,
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {setState(() {this.producto.favorite=!this.producto.favorite;});},
                style: ElevatedButton.styleFrom(padding:EdgeInsets.all(12.0),primary: Colors.grey[900],onPrimary: Colors.white30,textStyle: TextStyle(color: Colors.black)),
                icon: Icon(Icons.favorite, color: Colors.white),
                label: Text("Quitar de favoritos",style: TextStyle(color: Colors.white)),
              ),
            ),
          )
        : SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {setState(() {this.producto.favorite=!this.producto.favorite;});},
              style: ElevatedButton.styleFrom(padding:EdgeInsets.all(12.0),primary: Colors.orange[400],onPrimary: Colors.white30,textStyle: TextStyle(color: Colors.black)),
              icon: Icon(Icons.favorite, color: Colors.white),
              label: Text("Agregar a favoritos",style: TextStyle( color: Colors.white)),
            ),
          );
  } */
  Widget buttonEditProductoOPTDeveloper({required BuildContext context}) {
    return Container();
    /* return editable == false? deleteIndicador == false ?SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () {setState(() { editable = true;producto.verificado = false; });},
            style: ElevatedButton.styleFrom(padding:EdgeInsets.all(12.0),primary:editable ? Colors.green[400] : Colors.orange[400],onPrimary: Colors.white30,textStyle: TextStyle(color: Colors.black)),
            icon: Icon(Icons.security, color: Colors.white),
            label: Text("Editar",style: TextStyle( color: Colors.white)),
          ),
        ):Container():Container(); */
  }

  Widget buttonDeleteProductoOPTDeveloper({required BuildContext context}) {
    return Container();
    /* return deleteIndicador == false
        ? SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                showDialogDeleteOPTDeveloper(buildContext: context);
              },
              style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.all(12.0),
                  primary: Colors.red[400],
                  onPrimary: Colors.white30,
                  textStyle: TextStyle(color: Colors.black)),
              icon: Icon(Icons.security, color: Colors.white),
              label: Text("Borrar producto (Moderador)",
                  style: TextStyle(color: Colors.white)),
            ),
          )
        : Container(); */
  }

  void showDialogDeleteOPTDeveloper({required BuildContext buildContext}) {
    showDialog(
      context: buildContext,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text(
              "¿Seguro que quieres eliminar este producto definitivamente? (Desarrollador)"),
          content: new Text(
              "El producto será eliminado de tu catálogo ,de la base de dato global y toda la información acumulada menos el historial de precios registrado"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Cancelar"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            new FlatButton(
              child: new Text("Borrar"),
              onPressed: () {
                Navigator.of(context).pop();
                deleteProductOPTDeveloper(context: buildContext);
              },
            ),
          ],
        );
      },
    );
  }

  void deleteProductOPTDeveloper({required BuildContext context}) async {
    /* setState(() {
      deleteIndicador = true;
    });
    // Storage ( delete )
    if (producto.urlimagen != "") {
      StorageReference ref = FirebaseStorage.instance
          .ref()
          .child("APP")
          .child("ARG")
          .child("PRODUCTOS")
          .child(producto.id);
      await ref.delete(); // Procede a eliminar el archivo de la base de datos
    }
    // Firebase ( delete )
    await Global.getDataProductoNegocio(
            idNegocio: Global.prefs.getIdNegocio, idProducto: producto.id)
        .deleteDoc(); // Procede a eliminar el documento de la base de datos del catalogo de la cuenta
    await Global.getProductosPrecargado(idProducto: producto.id)
        .deleteDoc(); // Procede a eliminar el documento de la base de datos del catalogo de la cuenta
    // Emula un retardo de 2 segundos
    Future.delayed(const Duration(milliseconds: 5000), () {
      Navigator.pop(context);
    }); */
  }

  void guardarDeveloper({required BuildContext buildContext}) async {
    /* if (this.categoria != null) {
      if (this.subcategoria != null) {
        if (controllerTextEdit_descripcion.text != "") {
          if (this.marca != null) {
            if (controllerTextEdit_precio_venta.numberValue != 0.0) {
              // Firebase set
              updateProductoGlobalDeveloper();
              guardar(buildContext: buildContext);
            } else {
              showSnackBar(
                  context: buildContext, message: 'Asigne un precio de venta');
            }
          } else {
            showSnackBar(
                context: buildContext, message: 'Debe seleccionar una marca');
          }
        } else {
          showSnackBar(
              context: buildContext, message: 'Debe elegir una descripción');
        }
      } else {
        showSnackBar(
            context: buildContext, message: 'Debe elegir una subcategoría');
      }
    } else {
      showSnackBar(context: buildContext, message: 'Debe elegir una categoría');
    } */
  }

  void updateProductoGlobalDeveloper() async {
    // set ( id del usuario que actualizo el producto )
    /* producto.id_negocio = Global.oPerfilNegocio.id;
    producto.timestamp_actualizacion = Timestamp.fromDate(new DateTime.now());
    producto.verificado = true;
    // Firebase set
    await Global.getProductosPrecargado(idProducto: producto.id)
        .upSetPrecioProducto(producto.convertProductoDefault().toJson()); */
  }
}
