import 'package:gg_copy/ui/models/button_model.dart';

class EmptyViewModel {
  final String title;
  final String description;
  final List<ButtonModel> buttons;

  EmptyViewModel(
      {required this.title, required this.description, required this.buttons});
}
