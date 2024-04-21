part of 'create_work_page.dart';

class _BottomSheet {
  static Widget build(BuildContext context, BuildContext parentContext) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
      child: BlocProvider.value(
        value: parentContext.read<BottomSheetBloc>(),
        child: const _BottomSheetForm(),
      ),
    );
  }
}

final class _BottomSheetForm extends StatelessWidget {
  const _BottomSheetForm();

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.6,
      maxChildSize: 0.9,
      minChildSize: 0.3,
      builder: (context, controller) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const _BottomSheetSearchInput(),
          const SizedBox(height: 16),
          Expanded(
            child: _BottomSheetAddressListView(
              scrollController: controller,
            ),
          ),
        ],
      ),
    );
  }
}

final class _BottomSheetSearchInput extends StatelessWidget {
  const _BottomSheetSearchInput();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BottomSheetBloc, BottomSheetState>(
      buildWhen: (previous, current) => previous.address != current.address,
      builder: (context, state) => TextFormField(
        initialValue: state.address.value,
        decoration: InputDecoration(
          labelText: 'Address',
          hintText: 'Enter work address',
          errorText: state.address.displayError?.getMessage(context),
        ),
        onChanged: (value) {
          context
              .read<BottomSheetBloc>()
              .add(BottomSheetAddressChanged(address: value));
        },
      ),
    );
  }
}

final class _BottomSheetAddressListView extends StatelessWidget {
  const _BottomSheetAddressListView({
    required this.scrollController,
  });

  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BottomSheetBloc, BottomSheetState>(
      buildWhen: (previous, current) =>
          previous.suggestions != current.suggestions ||
          previous.pending != current.pending,
      builder: (context, state) {
        return Column(
          children: [
            Expanded(
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 400),
                opacity: state.pending ? 0.2 : 1,
                child: ListView.separated(
                  controller: scrollController,
                  separatorBuilder: (context, index) => const Divider(
                    height: 0,
                  ),
                  itemCount: state.suggestions.length,
                  itemBuilder: (context, index) => ListTile(
                    title: Text(
                      state.suggestions[index].structuredFormat.mainText,
                    ),
                    subtitle: Text(
                      state.suggestions[index].structuredFormat.secondaryText,
                    ),
                    onTap: () {
                      context
                          .read<BottomSheetBloc>()
                          .add(BottomSheetLocationSelected(index: index));
                    },
                  ),
                ),
              ),
            ),
            const Divider(
              height: 0,
            ),
            ListTile(
              leading: const Icon(Icons.pin_drop_rounded),
              title: const Text('My location'),
              subtitle: const Text(
                'Use your current location as work address.',
              ),
              onTap: () {
                context
                    .read<BottomSheetBloc>()
                    .add(const BottomSheetLocationSelected(index: -1));
              },
            ),
          ],
        );
      },
    );
  }
}
