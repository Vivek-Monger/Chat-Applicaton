class Message {
  Message({
    required this.told,
    required this.type,
    required this.msg,
    required this.read,
    required this.fromId,
    required this.sent,
  });
  late final String told;
  late final String msg;
  late final String read;
  late final String fromId;
  late final String sent;
  late final Type type;
  
  Message.fromJson(Map<String, dynamic> json){
    told = json['told'].toString();
    type = json['type'].toString() == Type.image.name ? Type.image : Type.text;
    msg = json['msg'].toString();
    read = json['read'].toString();
    fromId = json['fromId'].toString();
    sent = json['sent'].toString();
  }

  get name => null;

  get lastActive => null;

  get isOnline => null;

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['told'] = told;
    data['type'] = type.name;
    data['msg'] = msg;
    data['read'] = read;
    data['fromId'] = fromId;
    data['sent'] = sent;
    return data;
  }

  
}
enum Type{text, image}