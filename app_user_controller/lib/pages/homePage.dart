import 'package:app_user_controller/common/infomessage.dart';
import 'package:app_user_controller/common/input.dart';
import 'package:app_user_controller/common/link.dart';
import 'package:app_user_controller/common/popUpForm.dart';
import 'package:app_user_controller/common/selectBox.dart';
import 'package:app_user_controller/controller/HomeAssistantController.dart';
import 'package:app_user_controller/functions/authCallback.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _urlController = TextEditingController();
  final TextEditingController _tokenController = TextEditingController();
  final TextEditingController _panicBtn = TextEditingController();
  final TextEditingController _areaData = TextEditingController();

  bool isDone = false;
  List<dynamic> homes = [];

  @override
  void initState() {
    super.initState();
    _loadHomes();
  }

  Future<void> _loadHomes() async {
    final List<dynamic> fetchedHomes = await getHomes();
    setState(() {
      homes = fetchedHomes;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              removeTokens();
              Navigator.pushNamed(context, '/');
            },
            icon: const Icon(Icons.logout),
          )
        ],
      ),
      body: Column(
        children: [
          Link(
            text: "Agregar una casa ",
            icon: const Icon(Icons.add_home_outlined),
            onPress: () async {
              bool isWithData = false;
              Map<int, String> areas = await getAreas();
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return StatefulBuilder(
                    builder: (context, setState) {
                      return PopUpForm(
                        title: 'Ingresar nuevo Home Assistant',
                        onPress: () async {
                          final String url = _urlController.text;
                          final String token = _tokenController.text;
                          final String area = _areaData.text;
                          final String panicBtn = _panicBtn.text;

                          if (url.isNotEmpty && token.isNotEmpty) {
                            bool isAdded = await addNewHouse(
                                url, token, int.parse(area), panicBtn);

                            if (isAdded) {
                              Navigator.pop(context);

                              setState(() {
                                _urlController.clear();
                                _tokenController.clear();
                                _areaData.clear();
                                _panicBtn.clear();
                                _loadHomes();
                              });
                            } else {
                              Navigator.pop(context);
                            }
                          } else {
                            setState(() {
                              isWithData = true;
                            });
                          }
                        },
                        context: context,
                        children: [
                          Input(
                            text: 'URL*',
                            controller: _urlController,
                            obscureText: false,
                          ),
                          Input(
                            text: 'Token*',
                            controller: _tokenController,
                            obscureText: true,
                          ),
                          Input(
                            text: 'Botón de pánico*',
                            controller: _panicBtn,
                            obscureText: false,
                          ),
                          SelectBox(
                            items: areas,
                            onSelect: (value) {
                              setState(() {
                                _areaData.text = value.toString();
                              });
                            },
                          ),
                          if (isWithData) const SizedBox(height: 10),
                          const Text(
                            'Por favor, llene todos los campos',
                            style: TextStyle(color: Colors.red),
                          ),
                        ],
                      );
                    },
                  );
                },
              );
              setState(() {
                isDone = isWithData;
              });

              if (isDone) {
                Infomessage(
                  message: 'Casa agregada correctamente',
                  color: Colors.green,
                  textColor: Colors.white,
                  icon: Icons.check,
                  size: 20,
                ).show(context);
              }
            },
          ),
          Expanded(
            child: homes.isNotEmpty
                ? ListView.builder(
                    itemCount: homes.length,
                    itemBuilder: (context, index) {
                      final home = homes[index];
                      return ListTile(
                        title: Text('Casa N°${index + 1}'),
                        subtitle:
                            Text('url: ${home['url']}\nArea: ${home['area']}'),
                        trailing: home['is_deleted']
                            ? const Icon(Icons.disabled_by_default_rounded,
                                color: Colors.red)
                            : const Icon(Icons.home, color: Colors.green),
                        onTap: () {
                          Navigator.pushNamed(context, '/house',
                              arguments: home['id']);
                        },
                      );
                    },
                  )
                : const Center(child: Text("No homes available")),
          ),
        ],
      ),
    );
  }
}
