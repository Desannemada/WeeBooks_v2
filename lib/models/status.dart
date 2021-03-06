class Status {
  String title;
  String date;
  String categoria;

  Status({
    this.title,
    this.date,
    this.categoria,
  });

  Status.fromJson(Map<String, dynamic> json)
      : title = json['title'],
        date = json['date'],
        categoria = json['categoria'];

  Map<String, dynamic> toJson() => {
        'title': title,
        'date': date,
        'categoria': categoria,
      };
}
