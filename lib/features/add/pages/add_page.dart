import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:moja_apka/features/add/pages/cubit/add_cubit.dart';
import 'package:moja_apka/features/add/pages/cubit/add_state.dart';
import 'package:moja_apka/repositories/goal_repository.dart';

class AddPage extends StatefulWidget {
  const AddPage({
    Key? key,
  }) : super(key: key);

  @override
  State<AddPage> createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  String? _title;
  String? _goal;
  String? _imageURL;
  DateTime? _endDate;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AddCubit(GoalRepository()),
      child: BlocListener<AddCubit, AddState>(
        listener: (context, state) {
          if (state.saved) {
            Navigator.of(context).pop();
          }
          if (state.errorMessage.isNotEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Row(
                  children: [
                    const Icon(
                      Icons.info_outline,
                      color: Colors.white,
                    ),
                    Expanded(
                      child:
                          Text(state.errorMessage, textAlign: TextAlign.center),
                    ),
                  ],
                ),
                backgroundColor: Colors.red,
                duration: const Duration(seconds: 3),
              ),
            );
          }
        },
        child: BlocBuilder<AddCubit, AddState>(
          builder: (context, state) {
            return Scaffold(
              appBar: AppBar(
                title: const Center(
                  child: Text('Dodaj cel'),
                ),
                actions: [
                  IconButton(
                    onPressed: _title == null ||
                            _goal == null ||
                            _imageURL == null ||
                            _endDate == null
                        ? null
                        : () {
                            context.read<AddCubit>().add(
                                  _title!,
                                  _goal!,
                                  _imageURL!,
                                  _endDate!,
                                );
                          },
                    icon: const Icon(Icons.check),
                  )
                ],
              ),
              body: _AddPageBody(
                onTitleChanged: (newValue) {
                  setState(
                    () {
                      _title = newValue;
                    },
                  );
                },
                onGoalChanged: (newValue) {
                  setState(
                    () {
                      _goal = newValue;
                    },
                  );
                },
                onImageUrlChanged: (newValue) {
                  setState(
                    () {
                      _imageURL = newValue;
                    },
                  );
                },
                onDateChanged: (newValue) {
                  setState(
                    () {
                      _endDate = newValue;
                    },
                  );
                },
                selectedDateFormatted: _endDate == null
                    ? null
                    : DateFormat.yMMMMEEEEd().format(_endDate!),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _AddPageBody extends StatelessWidget {
  const _AddPageBody(
      {Key? key,
      required this.onTitleChanged,
      required this.onGoalChanged,
      required this.onImageUrlChanged,
      required this.onDateChanged,
      this.selectedDateFormatted})
      : super(key: key);
  final Function(String) onTitleChanged;
  final Function(String) onGoalChanged;
  final Function(String) onImageUrlChanged;
  final Function(DateTime?) onDateChanged;
  final String? selectedDateFormatted;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(30),
      children: [
        TextField(
          decoration: const InputDecoration(
            labelText: 'Aktywność',
            hintText: 'Jazda na rowerze',
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black, width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.green, width: 2),
            ),
          ),
          onChanged: onTitleChanged,
        ),
        const SizedBox(height: 20),
        TextField(
          decoration: const InputDecoration(
            labelText: 'Cel',
            hintText: 'km',
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black, width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.green, width: 2),
            ),
          ),
          onChanged: onGoalChanged,
        ),
        const SizedBox(height: 20),
        TextField(
          decoration: const InputDecoration(
            labelText: 'Adres linku zdjęcia',
            hintText: 'https://...',
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black, width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.green, width: 2),
            ),
          ),
          onChanged: onImageUrlChanged,
        ),
        const SizedBox(height: 30),
        ElevatedButton(
          onPressed: () async {
            final selectedDate = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime.now(),
              lastDate: DateTime.now().add(
                const Duration(days: 365 * 100),
              ),
            );
            onDateChanged(selectedDate);
          },
          child: Text(selectedDateFormatted ?? 'Wybierz datę wykonania celu'),
        )
      ],
    );
  }
}
