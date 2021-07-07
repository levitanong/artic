class DeserializationException implements Exception {
  final String message;
  DeserializationException({required this.message});
  @override
  String toString() {
    return "There was a problem deserializing data: $message";
  }
}

class ArticArtworkPagination {
  final int total;
  final int limit;
  final int offset;
  final int totalPages;
  final int currentPage;
  final String? nextUrl;
  ArticArtworkPagination(
      {required this.total,
      required this.limit,
      required this.offset,
      required this.totalPages,
      required this.currentPage,
      this.nextUrl});
  factory ArticArtworkPagination.fromJson(Map<String, dynamic> json) {
    return ArticArtworkPagination(
      total: json['total'],
      limit: json['limit'],
      offset: json['offset'],
      totalPages: json['total_pages'],
      currentPage: json['current_page'],
      nextUrl: json['next_url'],
    );
  }
}

class ArticArtworkThumbnail {
  final String data;
  final double width;
  final double height;
  final String altText;
  ArticArtworkThumbnail(
      {required this.data,
      required this.width,
      required this.height,
      required this.altText});
  factory ArticArtworkThumbnail.fromJson(Map<String, dynamic> json) {
    return ArticArtworkThumbnail(
        data: json["lqip"],
        width: json["width"].toDouble(),
        height: json["height"].toDouble(),
        altText: json["alt_text"]);
  }
}

class ArticArtwork {
  final String id;
  final String apiLink;
  final String title;
  final ArticArtworkThumbnail? thumbnail;
  final String mainReferenceNumber;
  final String dateDisplay;
  final String artistDisplay;
  final String dimensions;
  final String mediumDisplay;
  ArticArtwork(
      {required this.id,
      required this.apiLink,
      required this.title,
      required this.thumbnail,
      required this.mainReferenceNumber,
      required this.dateDisplay,
      required this.artistDisplay,
      required this.dimensions,
      required this.mediumDisplay});
  factory ArticArtwork.fromJson(Map<String, dynamic> json) {
    final thumbnailJson = json["thumbnail"];
    return ArticArtwork(
        id: json["id"].toString(),
        apiLink: json["api_link"],
        title: json["title"],
        thumbnail: thumbnailJson != null
            ? ArticArtworkThumbnail.fromJson(thumbnailJson)
            : null,
        mainReferenceNumber: json["main_reference_number"],
        artistDisplay: json["artist_display"],
        dateDisplay: json["date_display"],
        dimensions: json["dimensions"],
        mediumDisplay: json["medium_display"]);
  }
}

class ArticArtworkPayload {
  final ArticArtworkPagination pagination;
  final List<ArticArtwork> artworks;
  ArticArtworkPayload({required this.pagination, required this.artworks});
  factory ArticArtworkPayload.fromJson(Map<String, dynamic> json) {
    return ArticArtworkPayload(
        pagination: ArticArtworkPagination.fromJson(json['pagination']),
        artworks: json['data'].map<ArticArtwork>((artworkJson) {
          return ArticArtwork.fromJson(artworkJson);
        }).toList());
  }
}
