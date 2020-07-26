class MMCard {
  final String id;
  final String name;

  String get getid => this.id;
  String get getname => this.name;

  MMCard({
    this.name,
    this.id,
  });

  factory MMCard.fromJson(Map<String, dynamic> parsedJson) {
    return MMCard(
      name: parsedJson['name'],
      id: parsedJson['id'],
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'id': id,
      };
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'id': id,
    };
  }

  factory MMCard.fromMap(Map<String, dynamic> map) {
    return MMCard(
      name: map['name'],
      id: map['id'],
    );
  }
  @override
  String toString() {
    return 'MMCard{name: $name, id:$id,}';
  }
}

List<MMCard> mCardList=[
  MMCard(name:'Mokkon 24',id: '0032320'),
  MMCard(id: '0032321',name: 'MOKKON'),
  MMCard(id:'0032322',name: 'ABC'),
  MMCard(id: '0032323',name: 'G&G'),
  MMCard(id:'0032324', name: 'ONE STOP'),
  MMCard(id:'0000000',name:'Add'),
];
