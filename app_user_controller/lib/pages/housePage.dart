import 'package:app_user_controller/common/infomessage.dart';
import 'package:app_user_controller/common/input.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Casa ID ${widget.houseId}'),
        actions: [
          IconButton(onPressed: () => {}, icon: const Icon(Icons.edit))
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
                      widget.houseId,
                      messageController.text
                    );

                    if (response) {
                      setState(() {
                        isAdded = response;
                      });
                    }
                    
                    if (isAdded) {
                      Infomessage(
                        message: isAdded ? 'Se realizo el envió' : 'Ha habido un error', 
                        color: isAdded ? Colors.green : Colors.red, 
                        textColor: Colors.white, 
                        icon: isAdded ? Icons.done : Icons.warning, 
                        size: 20
                      ).show(context);
                    } else {
                      Infomessage(
                        message: 'Ha habido un error', 
                        color: Colors.red, 
                        textColor: Colors.white, 
                        icon: Icons.warning, 
                        size: 20
                      ).show(context);
                    }
                  }, 
                  icon: const Icon(Icons.add),
                ),
              ],
            ),
            IconButton(
              onPressed: () async{
                final response = await helpAction(widget.houseId);

                if (response) {
                  Infomessage(
                    message: 'Se realizo la acción de ayuda', 
                    color: Colors.green, 
                    textColor: Colors.white, 
                    icon: Icons.done, 
                    size: 20
                  ).show(context);
                }
              }, 
              icon: const Icon(Icons.security_update_warning, size: 100, color: Colors.red,)
            )
          ],
        ),
      ),
    );
  }
}
