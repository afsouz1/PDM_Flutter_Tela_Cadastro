import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});



  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  TextEditingController cLogin = TextEditingController();
  TextEditingController cEmail = TextEditingController();
  TextEditingController cSenha = TextEditingController();

  late String login, email, senha;

  void _incrementCounter() {

    setState(() {
      _counter++;
      login = cLogin.text;
      email = cEmail.text;
      senha = cSenha.text;
      enviar_requisicao(login, email, senha);

    });
  }

  Future<void> enviar_requisicao(String login, String email, String senha) async {
    var client = http.Client();
    try {
      Map<String,String> headers = {'Content-Type':'application/json' };
      final msg = jsonEncode( {'username': login, 'email': email, 'password': senha});

      var response = await client.post(
        Uri.https('linuxjf.com', '/apij/auth/register'),
        headers: headers,
        body: msg,
      );


      print('resposta: $response \n');

      if(response.statusCode==201) { // 201 - CREATED
        var jsonresposta = jsonDecode(
            utf8.decode(response.bodyBytes)) as Map;
        _showAlertDialog(context, "Usuario cadastrado com sucesso.");
      } else{
        _showAlertDialog(context, "Falha ao cadastrar usuario.");
      }


    }  catch (e) {
      _showAlertDialog(context, "Erro ao cadastrar usuario: $e");
    } finally {
      client.close(); // apenas fecha a conexão
    }


  }


  void _showAlertDialog(BuildContext context, String texto) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Cadastrar usuário'),
          content: Text(texto),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(

        backgroundColor: Theme.of(context).colorScheme.inversePrimary,

        title: Text(widget.title),
      ),
      body: Center(
        child: Container( width: 300,
          child: Column(

            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[

              //Text('Login'),
              TextField(
                controller: cLogin,
                decoration: const InputDecoration(
                  labelText: 'Username',
                  hintText: 'Input your username',
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  ),
                ),

              ),
              //Text('E-mail'),
              SizedBox(height: 30,),
              TextField(
                  controller: cEmail,
                  decoration: const InputDecoration(
                    labelText: 'E-mail',
                    hintText: 'Input your e-mail',
                    prefixIcon: Icon(Icons.email),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    ),
                  ),
              ),
              //Text('Senha'),
              SizedBox(height: 30,),
              TextField(
                  obscureText: true,
                  controller: cSenha,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    hintText: 'Input your password',
                    prefixIcon: Icon(Icons.password),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    ),
                  ),
              ),
              SizedBox(height: 25,),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _incrementCounter,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  child: const Text(
                      'Sign up',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      )
                  ),
                ),
              ),
            ],
          ),


        )


      ),
      //floatingActionButton: FloatingActionButton(
      //  onPressed: _incrementCounter,
      //  tooltip: 'Increment',
      //  child: const Icon(Icons.add),
      //), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
