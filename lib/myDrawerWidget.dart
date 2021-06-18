import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import 'package:formulario/faqPage.dart';
import 'package:formulario/main.dart';
import 'package:formulario/profilePage.dart';
import 'package:formulario/assets.dart';
import 'package:formulario/constantsUtil.dart';
import 'package:formulario/formuleManager.dart';
import 'package:formulario/materieSearchDelegate.dart';

class MyDrawerWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyDrawerWidgetState();
  }
}

//Il nostro drawer si divide in ProfilePage, Recenti, Preferiti e le FAQ
class _MyDrawerWidgetState extends State<MyDrawerWidget> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 20),
              child: Image.asset('assets/icons/insegnante.png'),
            )
          ],
          title: Text(
            'Formulario',
            style: TextStyle(
              fontFamily: 'Brandon-Grotesque-black',
              fontStyle: FontStyle.normal,
              fontSize: 26,
            ),
          ),
        ),
        body: ListView(
          shrinkWrap: false,
          children: [
            ProfileDrawerWidget(),
            FaqWidget(),
            PreferitiWidget(),
            RecentiWidget(),
          ],
        ),
      ),
    );
  }
}

//Una volta cliccato sul nostro profilo apparirà il nome utente, email e le cose da fare, ovvero tutto ciò
//che viene inserito dall'utente nel proprio profilo
class ProfileDrawerWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        Icons.account_box_rounded,
        color: MyAppColors.iconColor,
      ),
      title: Text(
        'Profilo',
        style: TextStyle(
          fontSize: 20,
        ),
      ),
      onTap: () {
        Route route = MaterialPageRoute(builder: (context) => ProfilePage());
        Navigator.push(context, route); //vai al profilo
      },
    );
  }
}

class PreferitiWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _PreferitiWidgetState();
  }
}

class _PreferitiWidgetState extends State<PreferitiWidget> {
  bool expanded = false;
  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      childrenPadding: EdgeInsets.only(left: 20),
      initiallyExpanded: expanded,
      onExpansionChanged: (e) {
        setState(() {
          expanded = !expanded;
        });
      },
      leading: Icon(
        Icons.favorite_rounded,
        color: MyAppColors.shirtColor,
      ),
      title: InkWell(
        onTap: () => Navigator.push(context, formulePreferitePage()),
        child: Text(
          'Formule preferite',
          style: TextStyle(fontSize: 20),
        ),
      ),
      children: widgetPreferiti,
    );
  }

  //Nel caso in cui non ci fossero delle formule tra i preferiti comparirà una
  List<Widget> get widgetPreferiti {
    return Assets.instance.formulePreferite.isEmpty
        ? [
            ListTile(
              title: Text(
                'Non hai formule tra i preferiti',
                style: TextStyle(color: Colors.grey),
              ),
            ),
          ]
        : Assets.instance.formulePreferite
            .map(
              (e) => ListTile(
                onLongPress: () {
                  Scaffold.of(context).showSnackBar(SnackBar(
                    content: Text('Formula rimossa dai preferiti'),
                    duration: Duration(milliseconds: 1000),
                  ));
                  setState(() {
                    e.isFavourite = !e.isFavourite;
                  });

                  Assets.instance.updatePreferiti(e);
                },
                onTap: () =>
                    Navigator.push(context, e.getFormulaMaterialPage()),
                leading: Icon(Icons.functions_rounded),
                title: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Math.tex(e.testo),
                ),
                subtitle: Text(e.titolo),
              ),
            )
            .toList();
  }

  MaterialPageRoute formulePreferitePage() {
    return MaterialPageRoute(
      builder: (context) => Scaffold(
        backgroundColor: MyAppColors.appBackground,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: MyAppColors.iconColor,
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Padding(
          padding: const EdgeInsets.only(top: 65),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AspectRatio(
                aspectRatio: 6.95,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(50, 10, 50, 10),
                  child: AspectRatio(
                    aspectRatio: 6.95,
                    child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: Color(0xFF332F2D),
                          borderRadius: BorderRadius.all(Radius.circular(8))),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.favorite_rounded,
                            color: MyAppColors.shirtColor,
                          ),
                          AutoSizeText(
                            'Formule preferite',
                            maxLines: 1,
                            minFontSize: 1,
                            style: TextStyle(
                                fontFamily: 'Brandon-Grotesque-black',
                                color: Colors.white,
                                letterSpacing: 2.5,
                                fontStyle: FontStyle.normal),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 8,
                child: Assets.instance.formulePreferite.isEmpty
                    ? paginaVuotaPreferiti()
                    : FormuleManager(
                        formule: Assets.instance.formulePreferite,
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget paginaVuotaPreferiti() {
    return SizedBox(
      height: 200,
      child: Container(
        child: Column(
          children: [
            Icon(
              Icons.favorite_outline_rounded,
              size: 200,
              color: Colors.grey.withAlpha(100),
            ),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'Non hai formule tra i preferiti \n usa l\'icona',
                    style: TextStyle(
                      fontFamily: 'Brandon-Grotesque-black',
                      color: Colors.grey.withAlpha(100),
                      fontSize: 20,
                    ),
                  ),
                  WidgetSpan(
                    child: Icon(
                      Icons.favorite_outline_rounded,
                      color: MyAppColors.shirtColor,
                    ),
                  ),
                  TextSpan(
                    text: 'per aggiungerne',
                    style: TextStyle(
                      fontFamily: 'Brandon-Grotesque-black',
                      color: Colors.grey.withAlpha(100),
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FaqWidget extends StatelessWidget {
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        Icons.live_help_outlined,
        color: MyAppColors.iconColor,
      ),
      title: Text(
        'Faq',
        style: TextStyle(fontSize: 20),
      ),
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => NewPage1())); //vai al profilo
      },
    );
  }
}

class RecentiWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _RecentiWidgetState();
  }
}

class _RecentiWidgetState extends State<RecentiWidget> {
  @override
  Widget build(BuildContext context) {
    List<Widget> recenti = recentiWidget(context);
    return ExpansionTile(
      childrenPadding: EdgeInsets.only(left: 20),
      initiallyExpanded: false,
      leading: Icon(
        Icons.history,
        color: Colors.grey,
      ),
      title: Text(
        'Recenti',
        style: TextStyle(
          color: Colors.grey,
          fontSize: 20,
        ),
      ),
      trailing: InkWell(
        onTap: () => setState(() {
          Assets.instance.clearRecenti();
        }),
        child: Icon(
          Icons.delete_rounded,
          color: Colors.grey,
        ),
      ),
      children: recenti.isEmpty
          ? [
              ListTile(
                title: Text(
                  'Non ci sono dati recenti',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ]
          : recenti,
    );
  }

  List<Widget> recentiWidget(context) {
    List<Widget> recenti = _getMaterieRecentiWidget(context);
    recenti.addAll(_getFormuleRecentiWidget(context));
    return recenti;
  }

  List<Widget> _getMaterieRecentiWidget(context) =>
      Assets.instance.materieRecenti
          .map(
            (materia) => MaterieSearch.instance
                .materiaSuggeritaTile(materia, context, true, false),
          )
          .toList();
  List<Widget> _getFormuleRecentiWidget(context) =>
      Assets.instance.formuleRecenti
          .map(
            (formula) => MaterieSearch.instance
                .formulaSuggeriteTile(formula, context, true, false),
          )
          .toList();
}
