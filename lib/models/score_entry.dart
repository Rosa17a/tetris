class ScoreEntry {
  final String name;
  final int score;
  final int lines;
  final int level;

  ScoreEntry({
    required this.name,
    required this.score,
    required this.lines,
    required this.level,
  });

  ScoreEntry.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        score = json['score'],
        lines = json['lines'],
        level = json['level'];

  Map<String, dynamic> toJson() => {
        'name': name,
        'score': score,
        'lines': lines,
        'level': level,
      };
}