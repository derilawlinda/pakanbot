import 'package:flutter/material.dart';
import 'package:pattern_formatter/pattern_formatter.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:splashscreen/splashscreen.dart';

void main() {
  runApp(MaterialApp(
    title: "Parab Bot",
    home: ParabBotHome(),
  ));
}


showAlertDialog(BuildContext context, benur, doc, targetADG) {

  // set up the button
  Widget okButton = TextButton(
    child: Text("OK"),
    onPressed: () {
      Navigator.pop(context);
    },
  );

  // set up the AlertDialog
  var rekomendasiPakan = (benur / 100000) * doc * targetADG;
  AlertDialog alert = AlertDialog(
    title: Text("Rekomendasi Pakan"),
    content: Text(rekomendasiPakan.toString() + " kg/hari"),
    actions: [
      okButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
class ParabBotHome extends StatefulWidget {
  @override
  _ParabFormState createState() => _ParabFormState();
}
class _ParabFormState extends State<ParabBotHome> {
  Widget build(BuildContext context) {
    return new SplashScreen(
        seconds: 4,
        navigateAfterSeconds: new AfterSplash(),
        title: new Text('Parab Bot',
          style: new TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20.0
          ),),
        image: new Image.asset("assets/icons/1.png"),
        backgroundColor: Colors.white,
        styleTextUnderTheLoader: new TextStyle(),
        photoSize: 100.0,
        onClick: ()=>print("Parab Bot"),
        loaderColor: Colors.blue
    );
  }
}

class AfterSplash extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  TextEditingController benurController = new TextEditingController();
  TextEditingController docController = new TextEditingController();
  TextEditingController targetADGController = new TextEditingController();
  TextEditingController turbidityController = new TextEditingController();
  TextEditingController suhuPagiController = new TextEditingController();
  TextEditingController suhuSoreController = new TextEditingController();
  TextEditingController adg10HariController = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Parab Bot"),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(20.0),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    inputFormatters: [ThousandsFormatter(),],
                    controller: benurController,
                    decoration: new InputDecoration(
                      labelText: "Benur",
                      border: OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(5.0)),
                    ),
                    validator: (value) {
                        if (value!.isEmpty) {
                          return 'Tidak boleh kosong';
                        }
                        return null;
                    },
                  ),
                ),
                 Padding(
                   padding: const EdgeInsets.all(8.0),
                   child: TextFormField(
                     keyboardType: TextInputType.number,
                     controller: docController,
                     decoration: new InputDecoration(
                       labelText: "DoC (umur hari)",
                       border: OutlineInputBorder(
                           borderRadius: new BorderRadius.circular(5.0)),
                     ),
                     validator: (value) {
                         if (value!.isEmpty) {
                           return 'Tidak boleh kosong';
                         }
                         return null;
                     },
                   ),
                 ),
                 Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      controller: targetADGController,
                      decoration: new InputDecoration(
                        labelText: "Target ADG (gr/hari)",
                        border: OutlineInputBorder(
                            borderRadius: new BorderRadius.circular(5.0)),
                      ),
                      validator: (value) {
                          if (value!.isEmpty) {
                            return 'Tidak boleh kosong';
                          }
                          return null;
                      },
                    ),
                  ),
                 Padding(
                     padding: const EdgeInsets.all(8.0),
                     child: TextFormField(
                       keyboardType: TextInputType.number,
                       controller: turbidityController,
                       decoration: new InputDecoration(
                         labelText: "Turbidity (FTU)",
                         border: OutlineInputBorder(
                             borderRadius: new BorderRadius.circular(5.0)),
                       ),
                     ),
                   ),
                 Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      controller: suhuPagiController,
                      decoration: new InputDecoration(
                        labelText: "Suhu Pagi H-1 (°C)",
                        border: OutlineInputBorder(
                            borderRadius: new BorderRadius.circular(5.0)),
                      ),
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    controller: suhuSoreController,
                    decoration: new InputDecoration(
                      labelText: "Suhu Sore H-1 (°C)",
                      border: OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(5.0)),
                    ),
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      controller: adg10HariController,
                      decoration: new InputDecoration(
                        labelText: "ADG 10 hari terakhir (gr)",
                        border: OutlineInputBorder(
                            borderRadius: new BorderRadius.circular(5.0)),
                      ),
                    ),
                  ),
                ElevatedButton(

                  child: Text(
                    "Hitung",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),

                  style: ElevatedButton.styleFrom(
                    primary: Colors.blue,
                    onPrimary: Colors.white,
                    minimumSize: Size(150,60),
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      String benurText = benurController.text.replaceAll(RegExp('[^0-9]'), '');
                      String docText = docController.text;
                      String targetADGText = targetADGController.text;
                      double benur = double.parse(benurText);
                      double doc = double.parse(docText);
                      double targetADG = double.parse(targetADGText);
                      showAlertDialog(context, benur, doc, targetADG);
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}