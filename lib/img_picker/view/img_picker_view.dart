import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:go_router/go_router.dart';
import 'package:profile_repository/profile_repository.dart';
import 'package:workaround/img_picker/bloc/img_picker_bloc.dart';
import 'package:workaround/img_picker/utils.dart';
import 'package:workaround/l10n/l10n.dart';
import 'package:workaround/sign_up/models/models.dart';
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
        child: const Text("asd"),
      ),
    );
  }
}

// class _ImagePickerView extends StatelessWidget {
//   const _ImagePickerView();

//   Future<void> _selectImg(BuildContext context) async {
//     final picked = await pickImage();
//     if (picked != null) {
//       // ignore: use_build_context_synchronously
//       context.read<ImgPickerBloc>().add(ImgPickChange(picked));
//     }
//   }
//   void _error(BuildContext context, SubmissionError error) {
//     final l10n = context.l10n;

//     final message = switch (error) {
//       final SubmissionErrorUnknown unknown =>
//         l10n.signUpSubmitErrorUnknown(unknown.code),
//     };
//     ScaffoldMessenger.of(context)
//       ..hideCurrentSnackBar()
//       ..showSnackBar(
//         SnackBar(
//           content: Text(message),
//         ),
//       );
//   }

//   void _sucess(BuildContext context) {
//     const message = 'Success update';
//     ScaffoldMessenger.of(context)
//       ..hideCurrentSnackBar()
//       ..showSnackBar(
//         const SnackBar(
//           content: Text(message),
//         ),
//       );

//     context.pop();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     return BlocListener<ImgPickerBloc, ImgPickerState>(
//       listener: (context, state) {
//         print(state.submission.error);
//         if (state.submission.error != null) {
//           _error(context, state.submission.error!);
//         }
//         if (state.submission.status.isSuccess) {
//           _sucess(context);
//         }
//       },
//       listenWhen: (previous, current) =>
//           previous.submission != current.submission,
//       child: Stack(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(8),
//             child: BlocBuilder<ImgPickerBloc, ImgPickerState>(
//               builder: (context, state) {
//                 return state.file != null
//                     ? GestureDetector(
//                         onTap: () {
//                           _selectImg(context);
//                         },
//                         child: SizedBox(
//                             height: 150,
//                             width: double.infinity,
//                             child: ClipRRect(
//                                 borderRadius: BorderRadius.circular(10),
//                                 child: Image.file(
//                                   state.file!,
//                                   fit: BoxFit.contain,
//                                 ))),
//                       )
//                     : GestureDetector(
//                         onTap: () {
//                           _selectImg(context);
//                         },
//                         child: DottedBorder(
//                           color: theme.hintColor,
//                           dashPattern: const [20, 4],
//                           radius: const Radius.circular(10),
//                           borderType: BorderType.RRect,
//                           strokeCap: StrokeCap.round,
//                           child: Container(
//                             height: 150,
//                             width: double.infinity,
//                             child: const Column(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 Icon(
//                                   Icons.folder_open,
//                                   size: 40,
//                                 ),
//                                 SizedBox(height: 15),
//                                 Text(
//                                   'Select your image',
//                                   style: TextStyle(fontSize: 15),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       );
//               },
//             ),
//           ),
//           Positioned(
//             bottom: 0,
//             left: 0,
//             right: 0,
//             child: Row(
//               children: [
//                 Expanded(
//                   child: Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 10),
//                     child: _SubmitButton(theme: theme),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class _SubmitButton extends StatelessWidget {
//   const _SubmitButton({
//     super.key,
//     required this.theme,
//   });

//   final ThemeData theme;

//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<ImgPickerBloc, ImgPickerState>(
//       buildWhen: (previous, current) =>
//           previous.submission != current.submission ||
//           previous.isValid != current.isValid,
//       builder: (context, state) {
//         return MaterialButton(
//           color: theme.colorScheme.primary,
//           onPressed: !state.isValid || state.submission.status.isInProgress
//               ? null
//               : () {
//                   context.read<ImgPickerBloc>().add(const ImgPickerSubmitted());
//                 },
//           child: Text(
//             'Save',
//             style: theme.textTheme.displayMedium!.copyWith(
//               color: theme.colorScheme.onSecondary,
//               fontWeight: FontWeight.w300,
//               fontSize: 18,
//             ),
//           ),
//         );
//       },
//     );
//   }
// }
