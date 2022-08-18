class Quote {
  String quote = '';
  String author = '';
  Quote({this.quote = '', this.author = ''});
  Quote.fromJson(Map<String, dynamic> json)
      : quote = json['quote'],
        author = json['author'];

  Map<String, dynamic> toJson() => {
        'quote': quote,
        'grant_type': author,
      };

  Map<String, String> toMap() => {
        'client_id': quote,
        'grant_type': author,
      };
}
