import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:indicedemassacorporal/cadastro.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'home.dart';
import 'model/usuario.dart';






class Login extends StatefulWidget {
  const Login({ Key? key }) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {


TextEditingController _controllerEmail = TextEditingController();
TextEditingController _controllerSenha = TextEditingController(text: '1234567');
String _mensagemErro = '';

_validarCampos(){

  //recupera dados dos campos
 
  String email = _controllerEmail.text;
  String senha = _controllerSenha.text;
  

  //valida campos
   if(email.isNotEmpty && email.contains("@")  ){

      if( senha.isNotEmpty && senha.length >= 6){

        setState(() {
          _mensagemErro = "";
        });

        Usuario usuario = Usuario();
        usuario.email = email;//recebe o email passado pelo usuário no campo email
        usuario.senha = senha;//recebe a senha passado pelo usuário no campo senha

        _logarUsuario( usuario );


      }else{
        setState(() {
          _mensagemErro = "Preencha a senha!";
        });
      }

    }else{
      setState(() {
        _mensagemErro = "Preencha o E-mail corretamente!";
      });
    }

}


_logarUsuario(Usuario usuario){

  FirebaseAuth auth = FirebaseAuth.instance;
  auth.signInWithEmailAndPassword(
    email: usuario.email, 
    password: usuario.senha,
    
    ).then(
      (firebaseUser){

            Navigator.pushReplacement(//envia o usuario para tela Home após fazer login
              context, 
              MaterialPageRoute(builder: (context) => const Home())
              );

    }).catchError(
      (erro){
        setState(() {
          _mensagemErro = 'Erro ao fazer login, verifique email e senha!';
        });
      }
    );

} 

Future _verificaUsuarioLogado()async{
    FirebaseAuth auth = FirebaseAuth.instance;
    //auth.signOut(); //desloga usuario
    User? usuarioLogado = await auth.currentUser;
    if( usuarioLogado != null ){//logado
        Navigator.pushReplacement(//envia o usuario para tela Home se já estiver logado no aolicativo
              context, 
              MaterialPageRoute(builder: (context) => const Home())
              );
        }else{//deslogado
          print("Usuario atual está DESLOGADO!!");
 }


}





@override
  void initState() {
    _verificaUsuarioLogado();
    super.initState();

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 72, 50, 78),
        title: const Text('Login'),
        centerTitle: true,
      ),
     
     body: Container(
       decoration: const BoxDecoration(color: Color.fromARGB(255, 72, 50, 78)),
       padding: const EdgeInsets.all(18),
       child: Center(
         child: SingleChildScrollView(

            child: Column( //COLUNA

             
              crossAxisAlignment: CrossAxisAlignment.stretch,

              children:  <Widget> [

                   

                  Padding(
                    padding: const EdgeInsets.only(bottom: 2, top: 2),
                    child: Image.asset('imagens/logo1.png'),
                    ),


                  Padding(
                       padding: const EdgeInsets.only(bottom:18),
                       child: TextField(
                         controller: _controllerEmail,
                         autofocus: true,
                         keyboardType: TextInputType.emailAddress,
                         style: const TextStyle(fontSize: 20),
                         decoration: InputDecoration(
                           contentPadding: const EdgeInsets.fromLTRB(32, 16, 32, 16),
                           hintText: 'E-mail',
                           filled: true,
                           fillColor: Colors.white,
                           border: OutlineInputBorder(
                             borderRadius: BorderRadius.circular(32)
                           )
                         ),
                       ),
                       ),

                 
                  TextField(
                        controller: _controllerSenha,
                        obscureText: true,
                         keyboardType: TextInputType.text,
                         style: const TextStyle(fontSize: 20),
                         decoration: InputDecoration(
                           contentPadding: const EdgeInsets.fromLTRB(32, 16, 32, 16),
                           hintText: 'Senha',
                           filled: true,
                           fillColor: Colors.white,
                           border: OutlineInputBorder(
                             borderRadius: BorderRadius.circular(32)
                           )
                         ),
                       ),
                       
                   Padding(
                     padding: const EdgeInsets.only(bottom:24 , top:22, ),
                    child: ElevatedButton(
                      child: const Text(
                        'Entrar',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        ),
                      style: ElevatedButton.styleFrom(
                          primary: const Color.fromARGB(255, 97, 26, 104),
                          fixedSize: const Size(200, 58),
                          shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50))
                  ),

                    onPressed: () {
                      _validarCampos();
                    },
                    ),

                       
                       ),
                    Center(
                      child: GestureDetector(
                        child: const Text(
                          'Não tem conta, cadastre-se!',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                          ),
                          onTap: (){
                              Navigator.push(
                                context, 
                                MaterialPageRoute(builder: (context) => const Cadastro())
                                );
                          },
                      ),
                    ),

                  Padding(

                    padding: const EdgeInsets.only(top: 18),
                    child:  Center(
                    child: Text(
                     _mensagemErro,
                     style: const TextStyle(
                       color: Colors.red,
                       fontSize: 20,
                       fontWeight: FontWeight.bold,
                     ),
                     ),
                 )
                 ,
                    ),

                    const SizedBox(
                      height: 45,
                    )
                 
                    
                    

                    



              ],
            ),
         )
       ),
     ),
      
    );
  }
}