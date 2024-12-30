// enhancedd enums
enum MessageEnums {
  text('text'),
  image('image'),
  audio('audio'),
  video('video'),
  gif('gif');

  const MessageEnums(this.type);
  final String type;
}



extension ConvertMessage on String {
  MessageEnums toEnum() {
    switch (this) {
      case 'audio':
        return MessageEnums.audio;
      case 'image':
        return MessageEnums.image;
      case 'text':
        return MessageEnums.text;
      case 'gif':
        return MessageEnums.gif;
      case 'video':
        return MessageEnums.video;
      default:
        return MessageEnums.text; 
    }
  }
}
