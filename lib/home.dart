import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:indicedemassacorporal/TelasHome/ComoFunciona.dart';
import 'package:indicedemassacorporal/TelasHome/imc.dart';
import 'package:indicedemassacorporal/configuracoes.dart';
import 'package:indicedemassacorporal/login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class Home extends StatefulWidget {
  const Home({ Key? key }) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {


  TabController? _tabController;
  String _emailUsuario = '';
  List<String> itensMenu = [
    'configurações','Sair'
  ];

  String idUsuarioLogado = '';
  String url2 = '';




Future _recuperarEmail()async{
    FirebaseAuth auth = FirebaseAuth.instance;
    User usuarioLogado = await auth.currentUser!;
    setState(() {
      _emailUsuario = usuarioLogado.email!;
    });
}

_escolhaMenuItem(String itemEscolhido){
    switch(itemEscolhido){
        case 'configurações':
          Navigator.push(//envia o usuario de login
              context, 
              MaterialPageRoute(builder: (context) =>  Configuracoes())
              );
          break;
        case 'Sair':
        _deslogarUsuario();
          break;
    }
}

_deslogarUsuario()async{
    FirebaseAuth auth = FirebaseAuth.instance;
    await auth.signOut();
      Navigator.pushReplacement(//envia o usuario de login
              context, 
              MaterialPageRoute(builder: (context) => const Login())
              );
      
}

_recuperaDadosUsuario()async{

  FirebaseAuth auth = FirebaseAuth.instance;
  User? usuarioLogado = await auth.currentUser;//recupera usuario atual
  idUsuarioLogado = usuarioLogado!.uid; //recebe id do usuario


  FirebaseFirestore db = FirebaseFirestore.instance;

  DocumentSnapshot snapshot = await db.collection('usuarios')//pega os dados do usuário, e alguns como nome
      .doc(idUsuarioLogado)                                 //e url serão adicionados Map de nome dados abaixo
      .get();
  Map dados = snapshot.data() as Map;


  if( dados["urlImagem"] != null ){
    setState(() {
      url2 = dados["urlImagem"];
    });
  }

}




  @override
  void initState() {
    _recuperarEmail();
    _tabController = TabController(
      length: 2, 
      vsync: this,
      );
  _recuperaDadosUsuario();

    super.initState();
  }
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 72, 50, 78),
         title: Row(
           children:  [
            
              CircleAvatar(
              backgroundColor: Color.fromARGB(255, 255, 255, 255),  
              maxRadius: 24 ,
               backgroundImage: NetworkImage(url2),
             )
           ],
         ),
        //centerTitle: true,

        bottom: TabBar(
          indicatorWeight: 4,
          labelStyle: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
          controller: _tabController,
          indicatorColor: Colors.white,
          tabs: const [
            Tab(text: 'Cauculo IMC',),
            Tab(text: 'Como Funciona',)
          ]
          ),

          actions: <Widget> [
            PopupMenuButton<String>(
              color:  Color.fromARGB(255, 215, 215, 224),
              //child: const Icon(Icons.settings),
              onSelected: _escolhaMenuItem,
              itemBuilder: (context){
                  return itensMenu.map(
                    (String item) {
                      return  PopupMenuItem<String>(
                         value: item,
                         child: Text(item),
                        );
                    }
                    ).toList();
              },

              ),
            
          ],

      ),

      body: TabBarView(
        controller: _tabController,
        children: const <Widget>[
          Imc(),
          ComoFuncciona(),
        ],
        )
      
    );
  }
}