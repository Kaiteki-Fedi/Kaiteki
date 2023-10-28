import "package:animations/animations.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:fpdart/fpdart.dart" show FpdartOnIterable;
import "package:intl/intl.dart";
import "package:kaiteki/constants.dart";
import "package:kaiteki/di.dart";
import "package:kaiteki/theming/text_theme.dart";
import "package:kaiteki_core/model.dart";

const _kSecondsPerYear = Duration.secondsPerDay * 365;
const _kSecondsPerMonth = Duration.secondsPerDay * 30;
const _kSecondsPerWeek = Duration.secondsPerDay * 7;
const kFiveYears = Duration(days: 365 * 5);

class PollDialog extends ConsumerStatefulWidget {
  final PollDraft? poll;

  const PollDialog({super.key, this.poll});

  @override
  ConsumerState<PollDialog> createState() => _PollDialogState();
}

class _PollDialogState extends ConsumerState<PollDialog> {
  final _controllers = <TextEditingController>[];
  late final TextEditingController _durationController;
  final _formKey = GlobalKey<FormState>();
  var _allowMultipleVotes = false;
  var _timeOption = _TimeOption.endAfter;
  var _timeUnit = _TimeUnit.minutes;
  var _time = TimeOfDay.now();
  var _date = DateTime.now();

  @override
  void initState() {
    super.initState();

    final poll = widget.poll;

    int? durationSeconds;

    if (poll == null) {
      _timeOption = _TimeOption.endAfter;
    } else {
      final deadline = poll.deadline;
      switch (deadline) {
        case AbsoluteDeadline():
          _timeOption = _TimeOption.endAt;
          _time = TimeOfDay.fromDateTime(deadline.endsAt);
          _date = deadline.endsAt;
        case RelativeDeadline():
          _timeOption = _TimeOption.endAfter;
          durationSeconds = deadline.duration.inSeconds;
          _timeUnit = _TimeUnit.fromSeconds(durationSeconds);
          durationSeconds = durationSeconds ~/ _timeUnit.inSeconds;

        case null:
          _timeOption = _TimeOption.indefinite;
      }
    }

    _durationController =
        TextEditingController(text: durationSeconds?.toString());

    if (poll != null) {
      for (final option in poll.options) {
        _addController(option);
      }
    }

    _addController();
  }

  PollDraft get draft {
    return PollDraft(
      allowMultipleChoices: _allowMultipleVotes,
      options: _controllers
          .take(_controllers.length - 1)
          .map((e) => e.text)
          .toList(),
      deadline: switch (_timeOption) {
        _TimeOption.endAfter => RelativeDeadline(
            Duration(
              seconds:
                  _timeUnit.inSeconds * int.parse(_durationController.text),
            ),
          ),
        _TimeOption.endAt => AbsoluteDeadline(
            _date.copyWith(hour: _time.hour, minute: _time.minute),
          ),
        _TimeOption.indefinite => null,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    const horizontalPadding = EdgeInsets.symmetric(horizontal: 20);

    return AlertDialog(
      title: Text(widget.poll == null ? "Add poll" : "Edit poll"),
      scrollable: true,
      contentPadding: const EdgeInsets.fromLTRB(0, 20, 0, 24),
      content: ConstrainedBox(
        constraints: kDialogConstraints.copyWith(
          minWidth: kDialogConstraints.maxWidth,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: horizontalPadding,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // TextFormField(
                    //   decoration: InputDecoration(
                    //     labelText: "Question",
                    //     border: const OutlineInputBorder(),
                    //   ),
                    //   validator: (value) {
                    //     if (value == null || value.isEmpty) {
                    //       return "Please enter a question";
                    //     }
                    //     return null;
                    //   },
                    // ),
                    // const SizedBox(height: 16),
                    ..._controllers.map<Widget>(
                      (e) {
                        if (e == _controllers.last) {
                          return _buildPlaceholderOptionTextField(e);
                        }

                        return _buildOptionTextField(e);
                      },
                    ).intersperse(const SizedBox(height: 8)),
                    if (_controllers.length >= 2) ...[
                      const SizedBox(height: 8),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text("${_controllers.length - 1} options"),
                      ),
                    ],
                    const Divider(height: 32 + 1),
                    _TimeOptionSelector(
                      value: _timeOption,
                      onChanged: (value) => setState(() => _timeOption = value),
                      showIndefinite: ref
                          .read(adapterProvider)
                          .capabilities
                          .supportsIndefinitePolls,
                    ),
                  ],
                ),
              ),
              AnimatedCrossFade(
                duration: const Duration(milliseconds: 200),
                firstChild: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 16),
                    PageTransitionSwitcher(
                      reverse: _timeOption == _TimeOption.endAfter,
                      duration: const Duration(milliseconds: 200),
                      transitionBuilder: _buildTransition,
                      child: _timeOption == _TimeOption.endAfter
                          ? Padding(
                              key: const ValueKey(_TimeOption.endAfter),
                              padding: horizontalPadding,
                              child: _DurationSelector(
                                controller: _durationController,
                                timeUnit: _timeUnit,
                                onTimeUnitChanged: (value) =>
                                    setState(() => _timeUnit = value),
                              ),
                            )
                          : Padding(
                              key: const ValueKey(_TimeOption.endAt),
                              padding: horizontalPadding,
                              child: Row(
                                children: [
                                  Expanded(
                                    child: TextFormField(
                                      controller: TextEditingController(
                                        text: DateFormat.yMd(
                                          Localizations.localeOf(context)
                                              .toString(),
                                        ).format(_date),
                                      ),
                                      decoration: InputDecoration(
                                        labelText: "Date",
                                        border: const OutlineInputBorder(),
                                        suffixIcon: IconButton(
                                          icon:
                                              const Icon(Icons.calendar_today),
                                          tooltip: "Select date",
                                          onPressed: _selectDate,
                                        ),
                                      ),
                                      style: Theme.of(context)
                                          .ktkTextTheme
                                          ?.monospaceTextStyle,
                                      readOnly: true,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: TextFormField(
                                      controller: TextEditingController(
                                        text: _time.format(context),
                                      ),
                                      decoration: InputDecoration(
                                        labelText: "Time",
                                        border: const OutlineInputBorder(),
                                        suffixIcon: IconButton(
                                          icon: const Icon(
                                            Icons.watch_later_outlined,
                                          ),
                                          tooltip: "Select time",
                                          onPressed: _selectTime,
                                        ),
                                      ),
                                      style: Theme.of(context)
                                          .ktkTextTheme
                                          ?.monospaceTextStyle,
                                      readOnly: true,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                    ),
                  ],
                ),
                secondChild: const SizedBox(),
                crossFadeState: _timeOption == _TimeOption.indefinite
                    ? CrossFadeState.showSecond
                    : CrossFadeState.showFirst,
              ),
              Divider(
                height: 32 + 1,
                indent: horizontalPadding.left,
                endIndent: horizontalPadding.right,
              ),
              SwitchListTile(
                contentPadding: horizontalPadding,
                value: _allowMultipleVotes,
                onChanged: (value) =>
                    setState(() => _allowMultipleVotes = value),
                title: const Text("Allow multiple votes"),
                subtitle: const Text("Users can choose multiple options"),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(context.materialL10n.cancelButtonLabel),
        ),
        TextButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              Navigator.of(context).pop(draft);
            }
          },
          child: Text(context.materialL10n.saveButtonLabel),
        ),
      ],
    );
  }

  Widget _buildTransition(
    Widget child,
    Animation<double> primaryAnimation,
    Animation<double> secondaryAnimation,
  ) {
    return SharedAxisTransition(
      animation: primaryAnimation,
      secondaryAnimation: secondaryAnimation,
      transitionType: SharedAxisTransitionType.horizontal,
      fillColor: Colors.transparent,
      child: child,
    );
  }

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    _durationController.dispose();
    super.dispose();
  }

  void _addController([String? text]) {
    final controller = TextEditingController(text: text)
      ..addListener(() {
        if (_controllers.lastOrNull?.text.isEmpty != true) {
          setState(_addController);
        }
      });

    _controllers.add(controller);
  }

  Widget _buildOptionTextField(TextEditingController controller) {
    return TextFormField(
      key: ValueKey(controller.hashCode),
      controller: controller,
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        isDense: true,
        suffixIcon: IconButton(
          icon: const Icon(Icons.close_rounded),
          onPressed: () {
            setState(() => _controllers.remove(controller));
          },
        ),
      ),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Option cannot be empty";
        }

        return null;
      },
    );
  }

  Widget _buildPlaceholderOptionTextField(TextEditingController controller) {
    return TextFormField(
      key: ValueKey(controller.hashCode),
      controller: controller,
      decoration: const InputDecoration(
        hintText: "Add an option",
        border: OutlineInputBorder(),
        isDense: true,
      ),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (value) {
        if (_controllers.length < 3) {
          return "Please enter at least 2 options";
        }

        return null;
      },
    );
  }

  Future<void> _selectDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(kFiveYears),
    );
    if (date == null) return;
    setState(() => _date = date);
  }

  Future<void> _selectTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: _time,
    );
    if (time == null) return;
    setState(() => _time = time);
  }
}

class _DurationSelector extends StatelessWidget {
  final TextEditingController controller;
  final _TimeUnit timeUnit;
  final ValueChanged<_TimeUnit> onTimeUnitChanged;

  const _DurationSelector({
    required this.controller,
    required this.timeUnit,
    required this.onTimeUnitChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 3,
          child: TextFormField(
            controller: controller,
            decoration: const InputDecoration(
              labelText: "Duration",
              hintText: "10",
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
            ],
            autocorrect: false,
            textInputAction: TextInputAction.next,
            textAlign: TextAlign.right,
            onChanged: (value) {},
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Please enter a duration";
              }
              return null;
            },
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          flex: 2,
          child: DropdownButtonFormField<_TimeUnit>(
            value: timeUnit,
            items: const [
              DropdownMenuItem(
                value: _TimeUnit.seconds,
                child: Text("second(s)"),
              ),
              DropdownMenuItem(
                value: _TimeUnit.minutes,
                child: Text("minute(s)"),
              ),
              DropdownMenuItem(
                value: _TimeUnit.hours,
                child: Text("hour(s)"),
              ),
              DropdownMenuItem(
                value: _TimeUnit.days,
                child: Text("day(s)"),
              ),
              DropdownMenuItem(
                value: _TimeUnit.weeks,
                child: Text("week(s)"),
              ),
              DropdownMenuItem(
                value: _TimeUnit.months,
                child: Text("month(s)"),
              ),
              DropdownMenuItem(
                value: _TimeUnit.years,
                child: Text("year(s)"),
              ),
            ],
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
            ),
            onChanged: (value) {
              if (value != null) onTimeUnitChanged(value);
            },
          ),
        ),
      ],
    );
  }
}

enum _TimeOption { endAfter, endAt, indefinite }

enum _TimeUnit {
  seconds(1),
  minutes(Duration.secondsPerMinute),
  hours(Duration.secondsPerHour),
  days(Duration.secondsPerDay),
  weeks(_kSecondsPerWeek),
  months(_kSecondsPerMonth),
  years(_kSecondsPerYear);

  final int inSeconds;

  const _TimeUnit(this.inSeconds);

  factory _TimeUnit.fromSeconds(int seconds) {
    if (seconds % _kSecondsPerYear == 0) return _TimeUnit.years;
    if (seconds % _kSecondsPerMonth == 0) return _TimeUnit.months;
    if (seconds % _kSecondsPerWeek == 0) return _TimeUnit.weeks;
    if (seconds % Duration.secondsPerDay == 0) return _TimeUnit.days;
    if (seconds % Duration.secondsPerHour == 0) return _TimeUnit.hours;
    if (seconds % Duration.secondsPerMinute == 0) return _TimeUnit.minutes;
    return _TimeUnit.seconds;
  }
}

class _TimeOptionSelector extends StatelessWidget {
  final _TimeOption value;
  final ValueChanged<_TimeOption> onChanged;
  final bool showIndefinite;

  const _TimeOptionSelector({
    required this.value,
    required this.onChanged,
    required this.showIndefinite,
  });

  @override
  Widget build(BuildContext context) {
    return FocusTraversalGroup(
      policy: WidgetOrderTraversalPolicy(),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          ChoiceChip(
            label: const Text("End after"),
            selected: value == _TimeOption.endAfter,
            onSelected: (_) => onChanged(_TimeOption.endAfter),
          ),
          ChoiceChip(
            label: const Text("End at"),
            selected: value == _TimeOption.endAt,
            onSelected: (_) => onChanged(_TimeOption.endAt),
          ),
          if (showIndefinite)
            ChoiceChip(
              label: const Text("Indefinite"),
              selected: value == _TimeOption.indefinite,
              onSelected: (_) => onChanged(_TimeOption.indefinite),
            ),
        ],
      ),
    );
  }
}
