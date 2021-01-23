class Cards {
  final int id;
  final String row;
  final int seq_num;
  final String text;

  Cards({this.id, this.row, this.seq_num, this.text});

  factory Cards.fromJson(Map<String, dynamic> json) {
    return Cards(
        id: json['id'],
        row: json['row'],
        seq_num: json['seq_num'],
        text: json['text']);
  }
}
