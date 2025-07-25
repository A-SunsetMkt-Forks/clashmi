import 'package:flutter/material.dart';
import 'package:clashmi/i18n/strings.g.dart';
import 'package:clashmi/screens/dialog_utils.dart';
import 'package:clashmi/screens/theme_config.dart';
import 'package:clashmi/screens/theme_define.dart';
import 'package:clashmi/screens/widgets/framework.dart';

class ListAddScreen extends LasyRenderingStatefulWidget {
  static RouteSettings routSettings(String viewTag) {
    return RouteSettings(name: "ListAddScreen:$viewTag");
  }

  final String title;
  final List<String> data;
  final Set<String> invalidData;
  final String dialogTitle;
  final String dialogTextHit;
  final Future<String?> Function()? onTapAdd;
  const ListAddScreen({
    super.key,
    required this.title,
    required this.data,
    this.invalidData = const {},
    this.dialogTitle = "",
    this.dialogTextHit = "",
    this.onTapAdd,
  });

  @override
  State<ListAddScreen> createState() =>
      _ServerSelectSearchSettingsScreenState();
}

class _ServerSelectSearchSettingsScreenState
    extends LasyRenderingState<ListAddScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size windowSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.zero,
        child: AppBar(),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () => Navigator.pop(context),
                      child: const SizedBox(
                        width: 50,
                        height: 30,
                        child: Icon(
                          Icons.arrow_back_ios_outlined,
                          size: 26,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: windowSize.width - 50 * 2,
                      child: Text(
                        widget.title,
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontWeight: ThemeConfig.kFontWeightTitle,
                            fontSize: ThemeConfig.kFontSizeTitle),
                      ),
                    ),
                    InkWell(
                      onTap: () async {
                        onTapAdd();
                      },
                      child: const SizedBox(
                        width: 50,
                        height: 30,
                        child: Icon(
                          Icons.add_outlined,
                          size: 26,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Expanded(
                child: _loadListView(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _loadListView() {
    Size windowSize = MediaQuery.of(context).size;
    return Scrollbar(
        child: ListView.builder(
      itemCount: widget.data.length,
      itemExtent: ThemeConfig.kListItemHeight2,
      itemBuilder: (BuildContext context, int index) {
        var current = widget.data[index];
        return createWidget(index, current, windowSize);
      },
    ));
  }

  Widget createWidget(int index, dynamic current, Size windowSize) {
    const double rightWidth = 30.0;
    double centerWidth = windowSize.width - rightWidth - 20;

    return Container(
      margin: const EdgeInsets.only(bottom: 2),
      child: Material(
        borderRadius: ThemeDefine.kBorderRadius,
        child: InkWell(
          onTap: () {
            Navigator.pop(context, current);
          },
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
            ),
            width: double.infinity,
            child: Row(
              children: [
                Row(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(children: [
                          SizedBox(
                            width: centerWidth,
                            child: Text(
                              current,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: ThemeConfig.kFontSizeGroupItem,
                                color: widget.invalidData.contains(current)
                                    ? Colors.red
                                    : null,
                              ),
                            ),
                          ),
                          SizedBox(
                              width: rightWidth,
                              height: ThemeConfig.kListItemHeight2 - 2,
                              child: InkWell(
                                onTap: () async {
                                  onTapDelete(current);
                                },
                                child: const Icon(
                                  Icons.remove_circle_outlined,
                                  size: 26,
                                  color: Colors.red,
                                ),
                              ))
                        ]),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void onTapAdd() async {
    String? text;
    if (widget.onTapAdd != null) {
      text = await widget.onTapAdd!();
    } else {
      final tcontext = Translations.of(context);
      text = await DialogUtils.showTextInputDialog(
          context,
          widget.dialogTitle.isNotEmpty
              ? widget.dialogTitle
              : tcontext.meta.add,
          "",
          widget.dialogTextHit.isNotEmpty ? widget.dialogTextHit : "",
          null,
          null, (text) {
        text = text.trim();
        if (text.isEmpty) {
          return false;
        }

        return true;
      });
    }

    if (text == null) {
      return;
    }
    if (widget.data.contains(text)) {
      return;
    }
    widget.data.add(text);
    setState(() {});
  }

  void onTapDelete(String text) {
    widget.data.remove(text);

    setState(() {});
  }
}
