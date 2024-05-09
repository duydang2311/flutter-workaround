import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:profile_repository/profile_repository.dart';
import 'package:workaround/img_picker/bloc/img_picker_bloc.dart';
import 'package:workaround/img_picker/utils.dart';
import 'package:workaround/theme/theme.dart';

class ImagePickerPage extends StatelessWidget {
  const ImagePickerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const ThemedAppBar(
        title: ThemedAppBarTitle('Edit Display Name'),
      ),
      body: BlocProvider(
        create: (context) => ImgPickerBloc(
          profileRepository: RepositoryProvider.of<ProfileRepository>(context),
        ),
        child: const _ImagePickerView(),
      ),
    );
  }
}

class _ImagePickerView extends StatelessWidget {
  const _ImagePickerView();

  Future<void> _selectImg(BuildContext context) async {
    final picked = await pickImage();
    if (picked != null) {
      // ignore: use_build_context_synchronously
      context.read<ImgPickerBloc>().add(ImgPickChange(picked));
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(8),
      child: BlocBuilder<ImgPickerBloc, ImgPickerState>(
        builder: (context, state) {
          return state.file != null
              ? GestureDetector(
                  onTap: () {
                    _selectImg(context);
                  },
                  child: SizedBox(
                      height: 150,
                      width: double.infinity,
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.file(
                            state.file!,
                            fit: BoxFit.contain,
                          ))),
                )
              : GestureDetector(
                  onTap: () {
                    _selectImg(context);
                  },
                  child: DottedBorder(
                    color: theme.hintColor,
                    dashPattern: const [20, 4],
                    radius: const Radius.circular(10),
                    borderType: BorderType.RRect,
                    strokeCap: StrokeCap.round,
                    child: Container(
                      height: 150,
                      width: double.infinity,
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.folder_open,
                            size: 40,
                          ),
                          SizedBox(height: 15),
                          Text(
                            'Select your image',
                            style: TextStyle(fontSize: 15),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
        },
      ),
    );
  }
}
