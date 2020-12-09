class Metas {
  MetaDiaria metaDiaria;
  MetaMensal metaMensal;
  MetaAnual metaAnual;

  Metas({this.metaMensal, this.metaAnual, this.metaDiaria});

  factory Metas.fromJson(Map<String, dynamic> json) {
    return Metas(
      metaDiaria: json['metaDiaria'] != null
          ? MetaDiaria.fromJson(json['metaDiaria'])
          : MetaDiaria(metaAtual: 0, metaDefinida: 0, tipo: -1),
      metaMensal: json['metaMensal'] != null
          ? MetaMensal.fromJson(json['metaMensal'])
          : MetaMensal(metaAtual: 0, metaDefinida: 0, tipo: -1),
      metaAnual: json['metaAnual'] != null
          ? MetaAnual.fromJson(json['metaAnual'])
          : MetaAnual(metaAtual: 0, metaDefinida: 0, tipo: -1),
    );
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> metas = {};

    if (metaDiaria != null) metas['metaDiaria'] = metaDiaria.toJson();

    if (metaMensal != null) metas['metaMensal'] = metaMensal.toJson();

    if (metaAnual != null) metas['metaAnual'] = metaAnual.toJson();

    return metas;
  }
}

class Meta {
  int metaAtual;
  int tipo;
  int metaDefinida;

  Meta({
    this.metaAtual,
    this.metaDefinida,
    this.tipo,
  });

  Map<String, dynamic> toJson() {
    Map<String, dynamic> meta = {};

    if (metaAtual != null) meta['metaAtual'] = metaAtual;

    if (metaDefinida != null) meta['metaDefinida'] = metaDefinida;

    if (tipo != null) meta['tipo'] = tipo;

    return meta;
  }

  factory Meta.fromJson(Map<String, dynamic> json) {
    return Meta(
      metaAtual: json['metaAtual'] != null ? json['metaAtual'] : 0,
      tipo: json['tipo'] != null ? json['tipo'] : -1,
      metaDefinida: json['metaDefinida'] != null ? json['metaDefinida'] : 0,
    );
  }
}

class MetaDiaria extends Meta {
  MetaDiaria({metaAtual, tipo, metaDefinida})
      : super(
          metaAtual: metaAtual,
          tipo: tipo,
          metaDefinida: metaDefinida,
        );

  factory MetaDiaria.fromJson(Map<String, dynamic> json) {
    final meta = Meta.fromJson(json);
    return MetaDiaria(
      metaAtual: meta.metaAtual,
      tipo: meta.tipo,
      metaDefinida: meta.metaDefinida,
    );
  }
}

class MetaMensal extends Meta {
  MetaMensal({int metaAtual, int tipo, int metaDefinida})
      : super(
          metaAtual: metaAtual,
          tipo: tipo,
          metaDefinida: metaDefinida,
        );

  factory MetaMensal.fromJson(Map<String, dynamic> json) {
    final meta = Meta.fromJson(json);
    return MetaMensal(
      metaAtual: meta.metaAtual,
      tipo: meta.tipo,
      metaDefinida: meta.metaDefinida,
    );
  }
}

class MetaAnual extends Meta {
  MetaAnual({int metaAtual, int tipo, int metaDefinida})
      : super(
          metaAtual: metaAtual,
          tipo: tipo,
          metaDefinida: metaDefinida,
        );

  factory MetaAnual.fromJson(Map<String, dynamic> json) {
    final meta = Meta.fromJson(json);
    return MetaAnual(
      metaAtual: meta.metaAtual,
      tipo: meta.tipo,
      metaDefinida: meta.metaDefinida,
    );
  }
}
