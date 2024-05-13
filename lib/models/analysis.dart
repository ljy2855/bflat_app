enum InstrumentType { guitar, vocal, bass, drum }

class Track {
  double startTime;
  double endTime;

  Track(this.startTime, this.endTime);
}

class Instrument {
  late InstrumentType type;
  late String audioFileUrl;
  late double volume;
  late List<Track> timingErrors;
}

class AnalysisResult {
  String name;
  DateTime created;
  Duration length;
  String originalRecordFile;
  List<Instrument> instruments;

  AnalysisResult(this.name, this.created, this.length, this.originalRecordFile,
      this.instruments);
}
