import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:async';


class Configuracoes extends StatefulWidget {
  const Configuracoes({ Key? key }) : super(key: key);

  @override
  State<Configuracoes> createState() => _ConfiguracoesState();
}

class _ConfiguracoesState extends State<Configuracoes> {

TextEditingController _controllerNome = TextEditingController();

 //=========================SELECIONA imagem=======================


File? _image;
ImageSource? imagemSelecionada ;
String _idUsuarioLogado = '';
PlatformFile?  pickedFile;
UploadTask? uploadTask;
double? progress;
double? x;
String url =  '';
String url2 = '';


Widget buildProgress() => StreamBuilder<TaskSnapshot>(
      stream: uploadTask?.snapshotEvents,
      builder: (context, snapshot) {
           
        if (snapshot.hasData) {
          final data = snapshot.data!;
          double progress = data.bytesTransferred / data.totalBytes;
          return SizedBox(
            height: 50,
            child: Stack(
              fit: StackFit.expand,
              children: [
                LinearProgressIndicator(
                  value: progress,
                  backgroundColor: const Color.fromARGB(255, 247, 247, 248),
                  color: const Color.fromARGB(255, 72, 50, 78),
                ),
                Center(
                  
                  child: Text(
                    '${(100 * progress).roundToDouble()}%',
                    style: const TextStyle(color: Color.fromARGB(255, 248, 249, 255)),
                  ),
                
                  
                )
              ],
            ),
          );
     
          
          
        } else {
          return const SizedBox(
            height: 50,
            
          );
        }
        
      },
     
      
    );
     



//--------------------------ABRE GALERIA--------------------------------------------
Future getImageGaleria(ImageSource source) async {
  try{
  final image = await ImagePicker().pickImage(source: ImageSource.gallery);

  if(image == null) return;

  //final imageTemporary = File(image.path);
  final imagePermanent = await saveFilePermanently(image.path);

  setState(() {
    _image = imagePermanent;
  });

  } on PlatformException catch (e){
    print('falied to pick image: $e' );
  } 
  
}
//----------------------------ABRE CAMERA------------------------------------------
Future getImageCamera(ImageSource source) async {
  try{
  final image = await ImagePicker().pickImage(source: ImageSource.camera);

  if(image == null) return;

  //final imageTemporary = File(image.path);
  final imagePermanent = await saveFilePermanently(image.path);

  setState(() {
    _image = imagePermanent;
  });

  } on PlatformException catch (e){
    print('falied to pick image: $e' );
  } 
  return _image;
}
//----------------------------------------------------------------------


Future<File> saveFilePermanently(String imagePath) async{
  final directory = await getApplicationSupportDirectory();
  final name = basename(imagePath);
  final image = File('${directory.path}/$name');

  return File(imagePath).copy(image.path);
}


//============================================================================

 //............................................................
Future UploadImagem_E_AtualizaNome()async{

if(pickedFile != null){
final path = 'files/${pickedFile!.name}';

 _image = File(pickedFile!.path!);


final ref = FirebaseStorage.instance.ref().child(path);
setState(() {
  uploadTask = ref.putFile(_image!);
});

final snapshot = await uploadTask!.whenComplete( () {});

final urDownload = await snapshot.ref.getDownloadURL();

print('link da url: $urDownload');

setState(() {
  uploadTask = null;
});

url = await  ref.getDownloadURL();

atualizaIMGfirestore(url2);

setState(() {
  url2 = url;
});

}

//----------ATUALIZA O NOME DE USUÁRIO----------
String nome = _controllerNome.text;

FirebaseFirestore db = FirebaseFirestore.instance;

Map<String,dynamic> dadosAtualizar = {
  'nome' : nome
};

db.collection('usuarios')
.doc(_idUsuarioLogado)
.update(dadosAtualizar);
//----------------------------

}

  atualizaIMGfirestore(String url2){//coloca o link da imagem no firestore | esse método
  //é chamado no método uloadFile acima

    FirebaseFirestore db = FirebaseFirestore.instance;
    Map<String, dynamic> dadosAtualizar = {
      "urlImagem" : url
    };

    db.collection("usuarios")
        .doc(_idUsuarioLogado)
        .update( dadosAtualizar );


  }

//............................................................

Future selectFile() async{
  final result = await FilePicker.platform.pickFiles();
  if(result == null);
  setState(() {
    if(result != null){
    pickedFile = result.files.first;
    }
   
  });

 
}

//............................................................


_recuperaDadosUsuario()async{

  FirebaseAuth auth = FirebaseAuth.instance;
   User? usuarioLogado = await auth.currentUser;//recupera usuario atual
   _idUsuarioLogado = usuarioLogado!.uid; //recebe id do usuario

   
FirebaseFirestore db = FirebaseFirestore.instance;

 DocumentSnapshot snapshot = await db.collection('usuarios')//pega os dados do usuário, e alguns como nome
   .doc(_idUsuarioLogado)                                 //e url serão adicionados Map de nome dados abaixo
   .get();
    Map dados = snapshot.data() as Map;
   _controllerNome.text = dados['nome'];

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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 72, 50, 78),
        title: const Text('configurações'),
      ),

      body: Container(

        padding: const EdgeInsets.all(16),
        child: Center(
          child:  SingleChildScrollView(
              child: Column(
                children: <Widget> [

               //_image != null
              url != null
               ?
                  /*
              ClipOval(
                //child: Image.file(_image!, width: 180,height:180,fit: BoxFit.fill,),
                 child: Image.network(url2, width: 180,height:180,fit: BoxFit.fill,),
              )
              */
              CircleAvatar(
                backgroundColor: Colors.grey,
                backgroundImage: NetworkImage(url2),
                maxRadius: 80,
              )
               : 
               const CircleAvatar(
                 backgroundColor: Colors.grey,
                 radius: 100,
               ),
               
               
                //Image.network(url),
                 const SizedBox(width: 40),
 //............................................................
 /*
                 if(PickedFile != null)
                Expanded(
                  child: Container(
                    child: Center(
                      child: Image.file(
                        File(pickedFile!.path!),
                        width: double.infinity,
                        fit: BoxFit.cover,
                      )
                    ),
                  ),
                ),
                */
  //............................................................           
           
                  const Padding(padding: EdgeInsets.all(18)),//espaçamento entre a foto e os botões
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget> [
                      
              //---------------------------------------
  Custombutton(title:'Galeria',icon:Icons.image_outlined,onClick:() => selectFile(),     
                ),
              const Padding(padding: EdgeInsets.all(20)),  
              Custombutton(
              title: 'Camera', icon: Icons.camera, onClick: () => getImageCamera(ImageSource.camera),
                ),
              //---------------------------------------
 

                    ],
                  ),
                  const Padding(padding: EdgeInsets.only(top:20)),
                  Padding(
                       padding: const EdgeInsets.only(bottom:18),
                       child: TextField(
                         controller: _controllerNome,
                         autofocus: true,
                         keyboardType: TextInputType.text,
                         style: const TextStyle(fontSize: 20),
                         decoration: const InputDecoration(
                           contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                           filled: true,
                           fillColor: Colors.white,
                          
                         ),
                       ),
                       ),

                       ElevatedButton(
                      child: const Text(
                        'Salvar',
                        style: TextStyle(
                          fontSize: 18,
                        ),
                        ),
                      style: ElevatedButton.styleFrom(
                          primary: const Color.fromARGB(255, 97, 26, 104),
                          fixedSize: const Size(130, 50),
                          shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50))
                          
                  ),
                    onPressed: () {
                      //_atualizarNomeFireStore();
                       UploadImagem_E_AtualizaNome();
                    },

                    ), 
                 //.....................................
                 const Padding(padding: EdgeInsets.only(top: 24)),
                  buildProgress(),
                  
                   //.............................
                       
                ],
              ),

          ),
        ),
        
      ),
    );

  

  }
}


//-------------------
Widget  Custombutton( {required String title,required IconData icon,required VoidCallback onClick})
{
  return Container(
     
      width: 140,
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
                          primary: const Color.fromARGB(255, 97, 26, 104),
                          fixedSize: const Size(200, 58),
                          shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50))
                  ),
        onPressed: onClick,
        child: Row(
          children:  [
              Icon(icon),
              const SizedBox(width: 20,),
              Text(title),
          ],
        ),
      ),
  );
}


 