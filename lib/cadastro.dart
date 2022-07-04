import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:indicedemassacorporal/home.dart';
import 'package:indicedemassacorporal/model/usuario.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Cadastro extends StatefulWidget {
  const Cadastro({ Key? key }) : super(key: key);

  @override
  State<Cadastro> createState() => _CadastroState();
}

class _CadastroState extends State<Cadastro> {

TextEditingController _controllerNome = TextEditingController();
TextEditingController _controllerEmail = TextEditingController();
TextEditingController _controllerSenha = TextEditingController(text: '1234567');
String _mensagemErro = '';

_validarCampos(){

  //recupera dados dos campos
  String nome = _controllerNome.text;
  String email = _controllerEmail.text;
  String senha = _controllerSenha.text;
  

  //valida campos
  if(nome.isNotEmpty && nome.length > 2){
       if(email.isNotEmpty && email.contains('@')){
            if(senha.isNotEmpty && senha.length > 6){


                setState(() {
                  _mensagemErro = '';
                });
                
                Usuario usuario = Usuario();//instancia classe Usuario
                usuario.nome = nome;
                usuario.email = email;
                usuario.senha = senha;
                _cadastrarUsuario(usuario);
                

                }else{
                setState(() {
                  _mensagemErro = 'a senha precisa ter 7 ou mais caracter!';
                });
              }   
        }else{
          setState(() {
            _mensagemErro = 'email invalido!';
          });
        }
  }else{
    setState(() {
      _mensagemErro = 'Preencha o nome corretamente!';
    });
  }


}


_cadastrarUsuario(Usuario usuario){

   FirebaseAuth auth = FirebaseAuth.instance;
   auth.createUserWithEmailAndPassword(
     email: usuario.email,
     password: usuario.senha,
     ).then(
       (firebaseUser) {

         //salva os dados do usuario no firebase
         FirebaseFirestore db = FirebaseFirestore.instance;
           db.collection("usuarios").doc(firebaseUser.user?.uid).set(
                 usuario.toMap()
                );

          //enia usuario para home
          Navigator.pushReplacement(
              context, 
              MaterialPageRoute(builder: (context) => const Home())
              );
       }

       ).catchError(
         (erro){
            _mensagemErro = 'Erro ao cadastrar Usuário, verifique os campos.';
         }
       );
  
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastro'),
        backgroundColor: const Color.fromARGB(255, 72, 50, 78),
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
                    padding: const EdgeInsets.only(bottom: 32),
                    child: Image.asset('imagens/logo5.png',width: 200,height: 200,),
                    ),

                   Padding(
                       padding: const EdgeInsets.only(bottom:18),
                       child: TextField(
                         controller: _controllerNome,
                         autofocus: true,
                         keyboardType: TextInputType.text,
                         style: const TextStyle(fontSize: 20),
                         decoration: InputDecoration(
                           contentPadding: const EdgeInsets.fromLTRB(32, 16, 32, 16),
                           hintText: 'Nome',
                           filled: true,
                           fillColor: Colors.white,
                           border: OutlineInputBorder(
                             borderRadius: BorderRadius.circular(32)
                           )
                         ),
                       ),
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
                        'Cadastrar',
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
                   child: Text(
                     _mensagemErro,
                     style: const TextStyle(
                       color: Colors.red,
                       fontSize: 20,
                       fontWeight: FontWeight.bold,
                     ),
                     ),
                 )
                 
                    
                    

                    



              ],
            ),
         )
       ),
     ),
    );
  }
}