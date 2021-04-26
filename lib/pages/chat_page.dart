
import 'dart:io';

import 'package:chat_app/widgets/chat_message.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with TickerProviderStateMixin {

  final _textController = new TextEditingController();
  final _focusNode = new FocusNode();

  List<ChatMessage> _messages = [];
    // ChatMessage( texto: 'Holiwis', uid: '123',),
    // ChatMessage( texto: 'Holiwis', uid: '123',),
    // ChatMessage( texto: 'Que pasa', uid: '122',),
    // ChatMessage( texto: 'Que pasa', uid: '122',),
    // ChatMessage( texto: 'Que pasa', uid: '122',)

  bool _estaEscribiendo = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 1,
        title: Column(
          children: [
            CircleAvatar(
              child: Text('Te', style: TextStyle(fontSize:  12)),
              backgroundColor: Colors.blue[100],
              maxRadius: 14,
            ),
            SizedBox( height: 3,),
            Text('Alejandra Murillo', style: TextStyle( color: Colors.black87, fontSize: 12), )
          ],
        ),
      ),
      body: Container(
        child: Column(
          children: [
            Flexible(
              child: ListView.builder(
                reverse: true,
                physics: BouncingScrollPhysics(),
                itemCount: _messages.length,
                itemBuilder: (_, i) => _messages[i]
              )
            ),

            Divider( height : 1),

            Container(
              color: Colors.white,
              child: _inputChat(),
            )

          ],
        ),
      )
    );
  }

  Widget _inputChat(){
    return SafeArea(
      child: Container(
        margin: EdgeInsets.symmetric( horizontal:  8),
        child: Row(
          children: [
            Flexible(
              child: TextField(
                controller: _textController,
                onSubmitted: _handlerSubmit,
                onChanged: (String text){
                  //cuando hay un valor, para poder postear
                  setState(() {
                    _estaEscribiendo = (text.trim().length > 0) ? true : false;
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Enviar Mensaje'
                ),
                focusNode: _focusNode,
              ),
            ),

            //Boton de enviar 
            Container(
              margin: EdgeInsets.symmetric( horizontal:  4),
              child: Platform.isIOS
              ? CupertinoButton(
                child: Text('Enviar'), 
                onPressed: _estaEscribiendo 
                  ? () => _handlerSubmit(_textController.text.trim())
                  : null,
              )
              : Container(
                margin: EdgeInsets.symmetric( horizontal: 4 ),
                child: IconTheme(
                  data: IconThemeData( color: Colors.blue[400] ),
                  child: IconButton(
                    highlightColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    icon: Icon( Icons.send,),
                    onPressed: _estaEscribiendo 
                     ? () => _handlerSubmit(_textController.text.trim())
                     : null,
                  ),
                ),
              ),

            )
          ],
        ),
      ),
    );
  }

  _handlerSubmit(String texto) {
    
    if( texto.length == 0 ) return;

    print(texto);
    _textController.clear();
    _focusNode.requestFocus();

    final newMessage = new ChatMessage(
      uid: '123', 
      texto: texto,
      animationController: AnimationController(vsync: this, duration: Duration(milliseconds: 400)),
    );
    _messages.insert(0, newMessage);
    newMessage.animationController.forward();

    setState(() => _estaEscribiendo = false );
  }

  @override
  void dispose() {
    // TODO: off del socket

    for (ChatMessage message in _messages) {
      message.animationController.dispose();
    }

    super.dispose();
  }

}