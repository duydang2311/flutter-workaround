part of 'img_picker_bloc.dart';

final class ImgPickerState extends Equatable {
  
  const ImgPickerState({
    required this.file,
  });

  final File? file;

  ImgPickerState copyWith({
    File? file,
  }) =>
      ImgPickerState(
        file: file ?? this.file,
      );
  @override
  List<Object?> get props => [file];
}

