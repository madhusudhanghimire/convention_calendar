import 'package:flutter/material.dart';

class CustomDropDownWidget extends StatefulWidget {
  final String selectedValue;
  final List<String> items;
  final double? height, width;
  final void Function(String value)? onSelected;
  const CustomDropDownWidget(
      {super.key,
      required this.selectedValue,
      this.onSelected,
      this.height,
      this.width,
      required this.items});

  @override
  State<CustomDropDownWidget> createState() => _CustomDropDownWidgetState();
}

class _CustomDropDownWidgetState extends State<CustomDropDownWidget> {
  final ScrollController _controller = ScrollController();
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      padding: const EdgeInsets.all(0),
      offset: const Offset(0, 50),
      onSelected: widget.onSelected,
      color: Colors.white,
      itemBuilder: (context) => [
        PopupMenuItem<String>(
          padding: EdgeInsets.zero,
          enabled: false,
          child: SizedBox(
            height: 300,
            width: 200,
            child: Theme(
              data: ThemeData(
                  scrollbarTheme: ScrollbarThemeData(
                thumbColor: WidgetStatePropertyAll(Colors.grey.shade500),
              )),
              child: Scrollbar(
                controller: _controller,
                trackVisibility: true,
                thumbVisibility: true,
                thickness: 3,
                radius: const Radius.circular(2),
                child: ListView(
                  controller: _controller,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  children: widget.items
                      .map((item) => PopupMenuItem<String>(
                            padding: EdgeInsets.zero,
                            value: item,
                            child: Container(
                                alignment: Alignment.centerLeft,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 12),
                                height: 46,
                                width: MediaQuery.of(context).size.width,
                                color: item == widget.selectedValue
                                    ? Colors.grey.shade200
                                    : null,
                                child: Text(item)),
                          ))
                      .toList(),
                ),
              ),
            ),
          ),
        ),
      ],
      constraints: BoxConstraints.tightFor(
        height: widget.height ?? 300,
        width: widget.width ?? 100,
      ),
      child: Container(
        height: 46,
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              widget.selectedValue,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const Icon(Icons.arrow_drop_down)
          ],
        ),
      ),
    );
  }
}
