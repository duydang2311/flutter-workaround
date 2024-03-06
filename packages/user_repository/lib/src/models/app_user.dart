import 'package:equatable/equatable.dart';

class AppUser extends Equatable {
  const AppUser(this.id);

  final String id;

  @override
  List<Object?> get props => [id];

  static const empty = AppUser('-');
}
