import 'dart:async';
import 'dart:convert';
import 'dart:io';

enum FilterType { allOptions, contains, equals }

class Leitor {
  final _fileName = 'C:/ops/nomes.txt'; // 223739216 lines
  final _outputFile = 'C:/ops/output.txt';

  final FilterType _filterType;
  String _filter;
  List<String> _words = [];

  Leitor(this._filter, [this._filterType = FilterType.contains]) {
    _filter = _filter.toLowerCase();
    _words = _filter.split(' ');
  }

  void readFileStream() {
    Stopwatch stopwatch = Stopwatch()..start();

    Stream<List<int>> stream = File(_fileName).openRead();
    StringBuffer buffer = StringBuffer();
    stream.transform(utf8.decoder).transform(LineSplitter()).listen(
      (data) {
        if (_filtraData(data.toLowerCase().split('|')[1])) {
          print(data);
          buffer.write('$data\n');
        }
      },
      onDone: () {
        File(_outputFile).writeAsString(buffer.toString());
        print('process finished: ${stopwatch.elapsed.inSeconds}');
        stopwatch.stop();
      },
      onError: (e) => print('error $e'),
    );
  }

  bool _filtraData(String value) {
    switch (_filterType) {
      case FilterType.allOptions:
        return _allOptionsFilter(value);
      case FilterType.equals:
        return _equalsFilter(value);
      case FilterType.contains:
        return _containsFilter(value);
    }
  }

  bool _allOptionsFilter(String value) {
    var values = value.split(' ');
    for (var word in _words) {
      for (var val in values) {
        if (word == val) return true;
      }
    }
    return false;
  }

  bool _equalsFilter(String value) {
    return value == _filter;
  }

  bool _containsFilter(String value) {
    return value.contains(_filter);
  }
}
