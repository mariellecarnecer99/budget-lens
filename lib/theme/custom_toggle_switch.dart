import 'package:flutter/material.dart';

class CustomToggleSwitch extends StatefulWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const CustomToggleSwitch({super.key, required this.value, required this.onChanged});

  @override
  State<CustomToggleSwitch> createState() => _CustomToggleSwitchState();
}

class _CustomToggleSwitchState extends State<CustomToggleSwitch> {
  @override
  Widget build(BuildContext context) {
    bool isDarkMode = widget.value;

    return GestureDetector(
      onTap: () {
        widget.onChanged(!isDarkMode);
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        width: 60,
        height: 30,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: isDarkMode ? Colors.blueAccent : Colors.grey.withOpacity(0.3),
        ),
        child: Stack(
          children: [
            Center(
              child: AnimatedSwitcher(
                duration: Duration(milliseconds: 300),
                child: isDarkMode
                    ? Icon(
                  Icons.nightlight_round,
                  key: ValueKey<int>(1),
                  color: Colors.white,
                  size: 20,
                )
                    : Icon(
                  Icons.wb_sunny,
                  key: ValueKey<int>(0),
                  color: Colors.yellow,
                  size: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
