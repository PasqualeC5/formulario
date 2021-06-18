import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:formulario/assets.dart';
import 'package:formulario/constantsUtil.dart';
import 'package:formulario/materieManager.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:formulario/materieSearchDelegate.dart';
import 'package:formulario/myDrawerWidget.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  //titolo dell'applicazione
  static const String _title = 'Formulario';
  Brightness brightness = Brightness.light;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //Impostazione del tema generale dell'applicazione come colori e font
      theme: ThemeData(
        accentColor: MyAppColors.iconColor,
        brightness: brightness,
        primaryColor: MyAppColors.appBackground,
        fontFamily: 'Brandon-Grotesque-light',
      ),
      title: _title,

      /*Nella home passo un futurebuilder che rappresenta la schermata di caricamento
      alla fine di tale schermata apparirà la nostra interfaccia iniziale..*/
      home: FutureBuilder(
          future: Assets.instance.setup(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return LoadingScreen();
              case ConnectionState.done:
                return _MyHomePage();
              default:
                return Image.asset('assets/icons/home.png');
            }
          }),
    );
  }
}

class _MyHomePage extends StatelessWidget {
  /*Homepage in cui sono presenti un iconbutton per la ricerca, un drawer
   e il body della homePage   */
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFDEBDF),
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(
          color: MyAppColors.iconColor,
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search_rounded),
            onPressed: () {
              //alla pressione di questo pulsante si apre la schermata di ricerca
              showSearch(context: context, delegate: MaterieSearch.instance);
            },
          ),
        ],
      ),
      drawer: MyDrawerWidget(),
      body: _MyHomePageBody(),
    );
  }
}

class _MyHomePageBody extends StatelessWidget {
  //Layout grafico del body della homePage
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
            child: Image.asset('assets/icons/home.png'),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 40, right: 40),
            child: AspectRatio(
              aspectRatio: 6.95,
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: MyAppColors.iconColor,
                    borderRadius: const BorderRadius.all(Radius.circular(8))),
                child: AutoSizeText(
                  'FORMULARIO',
                  maxLines: 1,
                  minFontSize: 37,
                  style: TextStyle(
                      fontFamily: 'Brandon-Grotesque-black',
                      color: Colors.white,
                      letterSpacing: 2.5,
                      fontStyle: FontStyle.normal),
                ),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(70),
                      topRight: const Radius.circular(70)),
                  color: MyAppColors.formuleBackground,
                ),
                child: Padding(
                  padding: EdgeInsets.all(0),
                  //Parte del body della homePage che contiene i widget per navigare tra le materie
                  child: MaterieManagerWidget(
                    materieData: Assets.instance.materieNomi
                        .map((e) => Assets.instance.getMateriaData(e))
                        .toList(),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class LoadingScreen extends StatelessWidget {
  //Layout grafico della pagina di caricamento iniziale
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyAppColors.appBackground,
      body: Padding(
        padding: const EdgeInsets.only(top: 100),
        child: Column(
          children: [
            Container(
              alignment: Alignment.center,
              child: Column(
                children: [
                  Image.asset('assets/icons/home.png'),
                  Padding(
                    padding: EdgeInsets.only(left: 40, right: 40),
                    child: Row(
                      children: [
                        Expanded(
                          child: AspectRatio(
                            aspectRatio: 6.95,
                            child: Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  color: Color(0xFF332F2D),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8))),
                              child: AutoSizeText(
                                'FORMULARIO',
                                maxLines: 1,
                                minFontSize: 37,
                                style: TextStyle(
                                    fontFamily: 'Brandon-Grotesque-black',
                                    color: Colors.white,
                                    letterSpacing: 2.5,
                                    fontStyle: FontStyle.normal),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: SizedBox(
                width: 60,
                height: 60,
                child: CircularProgressIndicator(
                  backgroundColor: Colors.transparent,
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF332F2D)),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
