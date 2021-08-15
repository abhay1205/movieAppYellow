final String tableMovie = 'movie';
class MovieFields {

  static final List<String> values = [
    id, movieName, dirName, rating, time, filePath
  ];
  
  static final String id = '_id';
  static final String movieName = 'movieName';
  static final String dirName = 'dirName';
  static final String rating = 'rating';
  static final String filePath = 'filePath';
  static final String time = 'time';
}
class Movie {
  final int id;
  final String movieName;
  final String dirName;
  final String filePath;
  final double rating;
  final DateTime created;

  const Movie({
    this.id, 
    this.movieName, 
    this.dirName, 
    this.filePath,
    this.rating,
    this.created,
  });

  Movie copy({int id})=>
    Movie(
      id: id ?? this.id,
      movieName: movieName ?? this.movieName,
      dirName: dirName ?? this.dirName,
      rating: rating ?? this.rating,
      filePath: filePath ?? this.filePath,
      created: created ?? this.created,
    );
  
  static Movie fromJson(Map<String, Object> json)=>Movie(
    id: json[MovieFields.id] as int,
    movieName: json[MovieFields.movieName] as String,
    dirName: json[MovieFields.dirName] as String,
    rating: json[MovieFields.rating] as double,
    filePath: json[MovieFields.filePath] as String,
    created: DateTime.parse(json[MovieFields.time] as String)
  );
  Map<String, Object> toJson()=>{
    MovieFields.id: id,
    MovieFields.movieName: movieName,
    MovieFields.dirName: dirName,
    MovieFields.rating: rating,
    MovieFields.filePath: filePath,
    MovieFields.time: created.toIso8601String()
  };
}