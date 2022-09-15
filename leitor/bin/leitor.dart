import 'package:leitor/leitor.dart';

void main(List<String> arguments) async {
  Leitor leitor = Leitor('Algum nome', FilterType.equals);
  leitor.readFileStream();
}
