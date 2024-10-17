import 'package:app_user_controller/common/infomessage.dart';
import 'package:app_user_controller/common/input.dart';
import 'package:app_user_controller/common/popUpForm.dart';
import 'package:app_user_controller/controller/HomeAssistantController.dart';
import 'package:app_user_controller/functions/helpAction.dart';
import 'package:flutter/material.dart';

class HousePage extends StatefulWidget {
  final int houseId;
  const HousePage({super.key, required this.houseId});

  @override
  _HousePageState createState() => _HousePageState();
}

class _HousePageState extends State<HousePage> {
  final TextEditingController messageController = TextEditingController();
  bool isAdded = false;
  late TextEditingController _urlController;
  late TextEditingController _tokenController;
  late TextEditingController _panicBtnController;

  @override
  void initState() {
    super.initState();
    _urlController = TextEditingController();
    _tokenController = TextEditingController();
    _panicBtnController = TextEditingController();

    _loadHouseDetails();
  }

  Future<void> _loadHouseDetails() async {
    final houseDetails = await getHome(widget.houseId);
    setState(() {
      _urlController.text = houseDetails['HomeAssistant_Url'];
      _tokenController.text = houseDetails['HomeAssistant_Token'];
      _panicBtnController.text = houseDetails['help_btn'];
    });
  }

  @override
  void dispose() {
    messageController.dispose();
    _urlController.dispose();
    _tokenController.dispose();
    _panicBtnController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.popAndPushNamed(context, '/home');
          },
          icon: const Icon(Icons.arrow_back),
        ),
        title: Text(_urlController.text),
        actions: [
          IconButton(
            onPressed: () {
              _showEditPopup(context);
            },
            icon: const Icon(Icons.edit),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Input(
                    text: 'Enviar mensaje',
                    controller: messageController,
                    obscureText: false,
                  ),
                ),
                IconButton(
                  onPressed: () async {
                    final bool response = await sendMessage(
                        widget.houseId, messageController.text);

                    if (response) {
                      setState(() {
                        isAdded = response;
                      });
                    }

                    if (isAdded) {
                      Infomessage(
                              message: isAdded
                                  ? 'Se realizó el envío'
                                  : 'Ha habido un error',
                              color: isAdded ? Colors.green : Colors.red,
                              textColor: Colors.white,
                              icon: isAdded ? Icons.done : Icons.warning,
                              size: 20)
                          .show(context);
                    } else {
                      Infomessage(
                              message: 'Ha habido un error',
                              color: Colors.red,
                              textColor: Colors.white,
                              icon: Icons.warning,
                              size: 20)
                          .show(context);
                    }
                  },
                  icon: const Icon(Icons.add),
                ),
              ],
            ),
            IconButton(
                onPressed: () async {
                  final response = await helpAction(widget.houseId);

                  if (response) {
                    Infomessage(
                            message: 'Se realizó la acción de ayuda',
                            color: Colors.green,
                            textColor: Colors.white,
                            icon: Icons.done,
                            size: 20)
                        .show(context);
                  }
                },
                icon: const Icon(
                  Icons.security_update_warning,
                  size: 100,
                  color: Colors.red,
                )),
          ],
        ),
      ),
      bottomSheet: IconButton(
          onPressed: () async {
            final isDeleted = await deleteHouseLogic(widget.houseId);
            if (isDeleted) {
              Infomessage(
                message: 'Casa eliminada correctamente',
                color: Colors.green,
                textColor: Colors.white,
                icon: Icons.check,
                size: 20,
              ).show(context);

              Navigator.popAndPushNamed(context, '/home');
            } else {
              Infomessage(
                message: 'Error al eliminar la casa',
                color: Colors.red,
                textColor: Colors.white,
                icon: Icons.error,
                size: 20,
              ).show(context);
            }
          },
          icon: const Icon(
            Icons.delete,
            size: 50,
            color: Colors.red,
          )),
    );
  }

  void _showEditPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return PopUpForm(
              title: 'Editar información de la casa',
              onPress: () async {
                final String url = _urlController.text;
                final String token = _tokenController.text;
                final String panicBtn = _panicBtnController.text;

                if (url.isNotEmpty && token.isNotEmpty) {
                  bool isUpdated = await updateHouseDetails(
                      widget.houseId, url, token, panicBtn);

                  if (isUpdated) {
                    Navigator.pop(context);
                    setState(() {
                      _urlController.clear();
                      _tokenController.clear();
                      _panicBtnController.clear();
                    });
                    Infomessage(
                      message: 'Casa actualizada correctamente',
                      color: Colors.green,
                      textColor: Colors.white,
                      icon: Icons.check,
                      size: 20,
                    ).show(context);
                  } else {
                    Infomessage(
                      message: 'Error al actualizar la casa',
                      color: Colors.red,
                      textColor: Colors.white,
                      icon: Icons.error,
                      size: 20,
                    ).show(context);
                  }
                }
              },
              context: context,
              children: [
                Input(
                  text: 'URL',
                  controller: _urlController,
                  obscureText: false,
                ),
                Input(
                  text: 'Token',
                  controller: _tokenController,
                  obscureText: true,
                ),
                Input(
                  text: 'Botón de pánico',
                  controller: _panicBtnController,
                  obscureText: false,
                ),
              ],
            );
          },
        );
      },
    );
  }
}
