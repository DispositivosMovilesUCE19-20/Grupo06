import 'dart:convert';

class Objeto {
  int id;
  String name;
  String descripcion;
  String categoria;
  String foto;

  Objeto(
      this.id,this.name,this.descripcion,this.categoria,this.foto
  );
  List<Objeto> listaObjeto = new List();
  Objeto.fromJsonList(List<dynamic> jsonList){
    if(json == null) return;
    for(var item in jsonList){
      final mensaje = new Objeto.fromJsonMap(item);
      listaObjeto.add(mensaje);
    }
  }

  Map<String, dynamic> toJson()=>
  {
    'id' : id,
    'name' : name,
    'descripcion' : descripcion,
    'Categoria' : categoria,
    'foto' : foto,
  };


   Objeto.fromJsonMap(Map<String, dynamic> json){
    id = json['id'];
    name=json['name'];
    descripcion=json['descripcion'];
    categoria=json['Categoria'];
    foto=json['foto'];
  }
  

  @override
  String toString() {
    return 'Objeto{id: $id, name: $name, descripcion: $descripcion, foto: $foto}';
  }

}
