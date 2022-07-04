class Usuario{

  String _nome = '';
  String _email = '';
  String _senha = '';


 Usuario();

Map<String, dynamic> toMap(){ //Esse método será chamado no método _cadastrarUsuario do arquivo cadastro.dart,
                              //e será retornado um Map de nome map.
  Map<String, dynamic> map  = {
    'nome' : this._nome,
   ' email' : this._email,

  };

  return map;

}

 get nome => this._nome;

 set nome( value) => this._nome = value;

  get email => this._email;

 set email( value) => this._email = value;

  get senha => this._senha;

 set senha( value) => this._senha = value;
  
  


 


}