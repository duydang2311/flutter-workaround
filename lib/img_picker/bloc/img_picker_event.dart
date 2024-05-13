part of 'img_picker_bloc.dart';

sealed class ImgPickerEvent extends Equatable {
  const ImgPickerEvent();

  @override
  List<Object> get props => [];
}


final class ImgPickChange extends ImgPickerEvent {
  const ImgPickChange(this.file);
  final File file;
  @override
  List<Object> get props => [file];
}

final class ImgPickerSubmitted extends ImgPickerEvent {
  const ImgPickerSubmitted();
}