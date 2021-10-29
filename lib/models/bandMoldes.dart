

class Band{

  String  id;
  String  name;
  int     votes;

  Band({
    this.id,
    this.name,
    this.votes
  });

  factory Band.fromMap( Map<String, dynamic> obj)
  => Band(
      id:    (obj.containsKey('id'))    ? obj['id']    : 'No existe un ID',
      name:  (obj.containsKey('nname'))  ? obj['nname']  : 'No existe un Nombre',
      votes: (obj.containsKey('vvotes')) ? obj['vvotes'] : 0,
  //La idea del factory Constructor es regresar una nu eva instancia de mi Clase
  );
  

}