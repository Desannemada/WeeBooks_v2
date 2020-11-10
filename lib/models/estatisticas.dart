class Estatisticas {
  final int livros;
  final int fics;
  final int ebooks;

  Estatisticas({
    this.livros,
    this.fics,
    this.ebooks,
  });

  Estatisticas.fromJson(Map<String, dynamic> json)
      : livros = json['livros'] != null ? json['livros'] : 0,
        fics = json['fics'] != null ? json['fics'] : 0,
        ebooks = json['ebooks'] != null ? json['ebooks'] : 0;

  Map<String, dynamic> toJson() => {
        'livros': livros != null ? livros : 0,
        'fics': fics != null ? fics : 0,
        'ebooks': ebooks != null ? ebooks : 0,
      };
}
