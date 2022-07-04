import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';


class Imc extends StatefulWidget {
  const Imc({ Key? key }) : super(key: key);

  @override
  State<Imc> createState() => _ImcState();
}

class _ImcState extends State<Imc> {


TextEditingController pesoController = TextEditingController();
TextEditingController alturaController = TextEditingController();

String _infoText = 'Informe seus dados!';
String idUsuarioLogado = '';
String url2 = '';


void limpaTeclado(){
  pesoController.text = "";
  alturaController.text = "";
    setState(() {
      _infoText = "Informe seus dados!";
      //_formKey = GlobalKey<FormState>();
    });
  }
 void _calculate(){
    setState(() {
      double peso = double.parse( pesoController.text);
      double altura = double.parse( alturaController.text) / 100;
      double imc = peso / (altura * altura);
      if(imc < 18.5){
        _infoText = "Abaixo do Peso (${imc.toStringAsPrecision(4)})";
      } else if(imc >= 18.5 && imc < 24.9){
        _infoText = "Peso Ideal (${imc.toStringAsPrecision(4)})";
      } else if(imc >= 25 && imc < 30){
        _infoText = "Levemente Acima do Peso (${imc.toStringAsPrecision(4)})";
      } else if(imc >= 30 && imc < 35){
        _infoText = "Obeso (${imc.toStringAsPrecision(4)})";
      } else if(imc > 35){
        _infoText = "Obesidade Extrema (${imc.toStringAsPrecision(4)})";
      } 

      
    });
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
    // TODO: implement initState
    super.initState();
    _recuperaDadosUsuario();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
 
      child: SingleChildScrollView(
         
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        
        children:  [

         Padding(padding: EdgeInsets.only(top: 40 )),
           
          Image.asset('imagens/logo1.png', height: 150, width: 150,),
                   
           IconButton(
                 icon: const Icon(Icons.refresh),
                 color: Color.fromARGB(255, 97, 26, 104),
                 iconSize: 32,
                 onPressed: () {  
               limpaTeclado();
                 },
                ),
            

           Padding(
             padding: const EdgeInsets.all(20),
             child:  TextFormField(
                controller: alturaController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                    labelText: "Altura (cm)",
                    labelStyle: TextStyle(color: Color.fromARGB(255, 97, 26, 104))),
                textAlign: TextAlign.center,
                style: const TextStyle(color: Color.fromARGB(255, 97, 26, 104), fontSize: 25.0),
               
             
              ), 
             ),
            Padding(
             padding: const EdgeInsets.all(20),
             child:  TextFormField(
              controller: pesoController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                    labelText: "Peso (kg)",
                    labelStyle: TextStyle(color: Color.fromARGB(255, 97, 26, 104))),
                textAlign: TextAlign.center,
                style: const TextStyle(color: Color.fromARGB(255, 97, 26, 104), fontSize: 25.0),
                
             
              ), 
             ),
             


                Padding(
                    padding: const EdgeInsets.all(22),
                    child: ElevatedButton(
                      child: const Text(
                        'Caucular',
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
                     _calculate();
                    },
                    ),

                       
               ),
              Padding(
                 padding: EdgeInsets.all(20),
                 child:  Text(
                _infoText,
                textAlign: TextAlign.center,
                style: TextStyle(color: Color.fromARGB(255, 97, 26, 104), fontSize: 25.0),
              ),
                 ),

                  
                



        ],
      ),
      ),
  

    );
  }
}

