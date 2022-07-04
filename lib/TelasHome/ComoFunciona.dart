import 'package:flutter/material.dart';

class ComoFuncciona extends StatefulWidget {
  const ComoFuncciona({ Key? key }) : super(key: key);

  @override
  State<ComoFuncciona> createState() => _ComoFunccionaState();
}

class _ComoFunccionaState extends State<ComoFuncciona> {
  @override
  Widget build(BuildContext context) {
    return Container(
       child:  Center(
        child: Image.asset('imagens/imc.JPG'),
      ),


    );
  }
}