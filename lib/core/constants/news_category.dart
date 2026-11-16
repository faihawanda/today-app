/// Kategori berita yang didukung oleh endpoint top-headlines NewsAPI.
enum NewsCategory {
  general('General'),
  business('Business'),
  technology('Technology'),
  science('Science'),
  health('Health'),
  sports('Sports'),
  entertainment('Entertainment');

  const NewsCategory(this.label);

  /// Label yang ditampilkan di UI.
  final String label;

  /// Nilai yang dikirim ke API.
  String get apiValue => name;
}
