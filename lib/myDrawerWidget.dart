import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_math_fork/flutter_math.dart';
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

class _MyDrawerWidgetState extends State<MyDrawerWidget> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text('Formulario'),
        ),
        body: ListView(
          shrinkWrap: false,
          children: [
            ProfileDrawerWidget(),
            PreferitiWidget(),
            RecentiWidget(),
          ],
        ),
      ),
    );
  }
}

class ProfileDrawerWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.account_box_rounded),
      title: Text('Profilo'),
      onTap: () {
        //vai al profilo
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
    return ListView(
      shrinkWrap: true,
      children: [
        Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
            initiallyExpanded: expanded,
            onExpansionChanged: (e) {
              setState(() {
                expanded = !expanded;
              });
            },
            leading: Icon(Icons.favorite),
            title: InkWell(
              onTap: () => Navigator.push(context, formulePreferitePAge()),
              child: Text('Formule preferite'),
            ),
            children: widgetPreferiti,
          ),
        )
      ],
    );
  }

  List<ListTile> get widgetPreferiti {
    return Assets.instance.formulePreferite.isEmpty
        ? [
            ListTile(
              title: Text(
                'Non hai formule tra i preferiti',
                style: TextStyle(color: Colors.grey),
              ),
            )
          ]
        : Assets.instance.formulePreferite
            .map((e) => ListTile(
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
                  title: Math.tex(e.testo),
                  subtitle: Text(e.titolo),
                ))
            .toList();
  }

  MaterialPageRoute formulePreferitePAge() {
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
          padding: const EdgeInsets.only(top: 100),
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
                            Icons.favorite,
                            color: Colors.red,
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
                child: FormuleManager(
                  formule: Assets.instance.formulePreferite,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class RecentiWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _RecentiWidgetState();
  }
}

class _RecentiWidgetState extends State<RecentiWidget> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      children: [
        Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
          child: Column(
            children: [
              ExpansionTile(
                initiallyExpanded: false,
                leading: Icon(
                  Icons.history,
                  color: Colors.grey,
                ),
                title: Text(
                  'Recenti',
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
                children: recentiWidget(context),
              ),
              ListTile(
                  onTap: () => setState(() {
                        Assets.instance.clearRecenti();
                      }),
                  title: Text(
                    'Rimuovi recenti',
                    style: TextStyle(color: Colors.grey),
                  ))
            ],
          ),
        )
      ],
    );
  }

  List<ListTile> recentiWidget(context) {
    List<ListTile> recenti = _getMaterieRecentiWidget(context);
    recenti.addAll(_getFormuleRecentiWidget(context));
    return recenti;
  }

  List<ListTile> _getMaterieRecentiWidget(context) => Assets
      .instance.materieRecenti
      .map((materia) => MaterieSearch.instance
          .materiaSuggeritaTile(materia, context, true, false))
      .toList();
  List<ListTile> _getFormuleRecentiWidget(context) => Assets
      .instance.formuleRecenti
      .map((formula) => MaterieSearch.instance
          .formulaSuggeriteTile(formula, context, true, false))
      .toList();
}