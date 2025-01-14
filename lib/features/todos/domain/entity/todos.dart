import 'package:equatable/equatable.dart';

class Todos extends Equatable {
  final int? id;
  final String name;
  final bool isCompleted;

  const Todos({
    this.id,
    required this.name,
    required this.isCompleted,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        isCompleted,
      ];
}
