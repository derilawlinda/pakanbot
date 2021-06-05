import 'package:flutter/material.dart';
import 'package:pattern_formatter/pattern_formatter.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:splashscreen/splashscreen.dart';

extension Ex on double {
  double toPrecision(int n) => double.parse(toStringAsFixed(n));
}

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
        title: new Text(
          'Parab Bot',
          style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
        ),
        image: new Image.asset("assets/icons/1.png"),
        backgroundColor: Colors.white,
        styleTextUnderTheLoader: new TextStyle(),
        photoSize: 100.0,
        onClick: () => print("Parab Bot"),
        loaderColor: Colors.blue);
  }
}

class AfterSplash extends StatefulWidget {
  @override
  _AfterSplashState createState() => _AfterSplashState();
}

class _AfterSplashState extends State<AfterSplash> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController benurController = new TextEditingController();
  TextEditingController docController = new TextEditingController();
  TextEditingController targetADGController = new TextEditingController();
  TextEditingController turbidityController = new TextEditingController();
  TextEditingController suhuPagiController = new TextEditingController();
  TextEditingController suhuSoreController = new TextEditingController();
  TextEditingController adg10HariController = new TextEditingController();
  double pakan = 0;
  double benur = 0;
  double doc = 0;
  double targetADG = 0;
  bool _isBenurButtonDisabled = true;
  bool _isDoCButtonDisabled = true;
  bool _isADGButtonDisabled = true;
  decreaseBenurControllerText() {
    if (benurController.value.text == '' || benurController.value.text == '0') {
      return null;
    } else {
      double benurValue =
          double.parse(benurController.text.replaceAll(RegExp('[^0-9]'), ''));
      double benurNewValue = benurValue - 10000;
      setState(() {
        if (benurNewValue == 0) {
          this._isBenurButtonDisabled = true;
        }
        this.pakan = hitungPakan();
      });
      benurController.value = ThousandsFormatter().formatEditUpdate(
          TextEditingValue(text: benurValue.toString()),
          TextEditingValue(text: benurNewValue.toString()));
    }
  }

  decreaseDoCControllerText() {
    if (docController.value.text == '' || docController.value.text == '0') {
      return null;
    } else {
      double docValue = double.parse(docController.text);
      double docNewValue = docValue - 1;

      docController.value = TextEditingValue(text: docNewValue.toString());
      setState(() {
        if (docNewValue == 0) {
          this._isDoCButtonDisabled = true;
        }
        this.pakan = hitungPakan();
      });
    }
  }

  decreaseADGControllerText() {
    if (targetADGController.value.text == '' ||
        targetADGController.value.text == '0') {
      return null;
    } else {
      double adgValue = double.parse(targetADGController.text).toPrecision(1);
      double adgNewValue = adgValue.toPrecision(1) - 0.1;

      setState(() {
        if (adgNewValue == 0) {
          this._isADGButtonDisabled = true;
        }
        this.pakan = hitungPakan();
      });
      targetADGController.value =
          TextEditingValue(text: adgNewValue.toPrecision(1).toString());
    }
  }

  double hitungPakan() {
    String benurText = benurController.text.replaceAll(RegExp('[^0-9]'), '');
    String docText = docController.text;
    String targetADGText = targetADGController.text;

    if (double.tryParse(benurText) != null) {
      benur = double.parse(benurText);
    }

    if (double.tryParse(docText) != null) {
      doc = double.parse(docText);
    }

    if (double.tryParse(targetADGText) != null) {
      targetADG = double.parse(targetADGText);
    }
    return (benur / 100000) * doc * targetADG;
  }

  int counter = 0;
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
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.remove,
                          color: Theme.of(context).accentColor,
                        ),
                        padding: EdgeInsets.symmetric(
                            vertical: 4.0, horizontal: 18.0),
                        iconSize: 32.0,
                        color: Theme.of(context).primaryColor,
                        onPressed: _isBenurButtonDisabled
                            ? null
                            : decreaseBenurControllerText,
                      ),
                      Flexible(
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          onChanged: (value) {
                            String benurText =
                                value.replaceAll(RegExp('[^0-9]'), '');
                            if (double.tryParse(benurText) != null) {
                              benur = double.parse(benurText);
                            }
                            setState(() {
                              this.pakan = hitungPakan();
                              this.benur = benur;
                              if (benur > 10000) {
                                this._isBenurButtonDisabled = false;
                              }
                            });
                          },
                          inputFormatters: [
                            ThousandsFormatter(),
                          ],
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
                      IconButton(
                        icon: Icon(
                          Icons.add,
                          color: Theme.of(context).accentColor,
                        ),
                        padding: EdgeInsets.symmetric(
                            vertical: 4.0, horizontal: 18.0),
                        iconSize: 32.0,
                        color: Theme.of(context).primaryColor,
                        onPressed: () {
                          if (benurController.text == '') {
                            benurController.text = '0';
                          }
                          double benurValue = double.parse(benurController.text
                              .replaceAll(RegExp('[^0-9]'), ''));
                          double benurNewValue = benurValue + 10000;
                          benurController.value = ThousandsFormatter()
                              .formatEditUpdate(
                                  TextEditingValue(text: benurValue.toString()),
                                  TextEditingValue(
                                      text: benurNewValue.toString()));
                          setState(() {
                            this._isBenurButtonDisabled = false;
                            this.pakan = hitungPakan();
                          });
                        },
                      )
                    ]),
                Padding(padding: EdgeInsets.only(bottom: 10)),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.remove,
                          color: Theme.of(context).accentColor,
                        ),
                        padding: EdgeInsets.symmetric(
                            vertical: 4.0, horizontal: 18.0),
                        iconSize: 32.0,
                        color: Theme.of(context).primaryColor,
                        onPressed: _isDoCButtonDisabled
                            ? null
                            : decreaseDoCControllerText,
                      ),
                      Flexible(
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          onChanged: (value) {
                            setState(() {
                              this.pakan = hitungPakan();
                              if (double.parse(value) > 0) {
                                this._isDoCButtonDisabled = false;
                              }
                            });
                          },
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
                      IconButton(
                        icon: Icon(
                          Icons.add,
                          color: Theme.of(context).accentColor,
                        ),
                        padding: EdgeInsets.symmetric(
                            vertical: 4.0, horizontal: 18.0),
                        iconSize: 32.0,
                        color: Theme.of(context).primaryColor,
                        onPressed: () {
                          if (docController.text == '') {
                            docController.text = '0';
                          }
                          double docValue = double.parse(docController.text);
                          double docNewValue = docValue + 1;
                          docController.value =
                              TextEditingValue(text: docNewValue.toString());
                          setState(() {
                            this._isDoCButtonDisabled = false;
                            this.pakan = hitungPakan();
                          });
                        },
                      )
                    ]),
                Padding(padding: EdgeInsets.only(bottom: 10)),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.remove,
                          color: Theme.of(context).accentColor,
                        ),
                        padding: EdgeInsets.symmetric(
                            vertical: 4.0, horizontal: 18.0),
                        iconSize: 32.0,
                        color: Theme.of(context).primaryColor,
                        onPressed: _isADGButtonDisabled
                            ? null
                            : decreaseADGControllerText,
                      ),
                      Flexible(
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          controller: targetADGController,
                          decoration: new InputDecoration(
                            labelText: "Target ADG (gr/hari)",
                            border: OutlineInputBorder(
                                borderRadius: new BorderRadius.circular(5.0)),
                          ),
                          onChanged: (value) {
                            setState(() {
                              this.pakan = hitungPakan();
                            });
                          },
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Tidak boleh kosong';
                            }
                            return null;
                          },
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.add,
                          color: Theme.of(context).accentColor,
                        ),
                        padding: EdgeInsets.symmetric(
                            vertical: 4.0, horizontal: 18.0),
                        iconSize: 32.0,
                        color: Theme.of(context).primaryColor,
                        onPressed: () {
                          if (targetADGController.text == '') {
                            targetADGController.text = '0';
                          }
                          double adgValue =
                              double.parse(targetADGController.text)
                                  .toPrecision(1);
                          double adgNewValue = adgValue.toPrecision(1) + 0.1;
                          targetADGController.value = TextEditingValue(
                              text: adgNewValue.toPrecision(1).toString());
                          setState(() {
                            this._isADGButtonDisabled = false;
                            this.pakan = hitungPakan();
                          });
                        },
                      )
                    ]),

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
                Padding(
                  padding: const EdgeInsets.only(top: 30, left: 8, right: 8),
                  child: Text(
                    'Rekomendasi Pakan',
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(15.0),
                  padding: const EdgeInsets.all(3.0),
                  decoration:
                      BoxDecoration(border: Border.all(color: Colors.black)),
                  child: Text(
                    '$pakan kg/hari',
                    style: TextStyle(fontSize: 30.0),
                  ),
                ),
                // ElevatedButton(
                //   child: Text(
                //     "Hitung",
                //     style: TextStyle(color: Colors.white, fontSize: 20),
                //   ),
                //   style: ElevatedButton.styleFrom(
                //     primary: Colors.blue,
                //     onPrimary: Colors.white,
                //     minimumSize: Size(150, 60),
                //   ),
                //   onPressed: () {
                //     if (_formKey.currentState!.validate()) {
                //       String benurText =
                //           benurController.text.replaceAll(RegExp('[^0-9]'), '');
                //       String docText = docController.text;
                //       String targetADGText = targetADGController.text;
                //       double benur = double.parse(benurText);
                //       double doc = double.parse(docText);
                //       double targetADG = double.parse(targetADGText);
                //       //showAlertDialog(context, benur, doc, targetADG);
                //     }
                //   },
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
