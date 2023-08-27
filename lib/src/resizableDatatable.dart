import 'package:flutter/material.dart';
import 'package:resizable_datatable/src/model/datatableModel.dart';
import 'package:resizable_datatable/src/textsizeGetter.dart';

class ResizableDataTable extends StatefulWidget {
  final bool? autoFit;
  final List<ResizableHeader> header;
  final Color? backgroundColor;
  final List<List<String>> data;
  final double headerHeight;
  const ResizableDataTable(
      {super.key,
      this.headerHeight = 30,
      required this.header,
      required this.data,
      this.autoFit = false,
      this.backgroundColor});

  @override
  State<ResizableDataTable> createState() => _ResizableDataTableState();
}

class _ResizableDataTableState extends State<ResizableDataTable> {
  late final List<ResizableHeader> _header;
  late final List<List<String>> _data;
  late final double _headerHeight;
  final verticalScrollController = ScrollController();
  final horizontalScrollController = ScrollController();

  @override
  void dispose() {
    super.dispose();
    verticalScrollController.dispose();
    horizontalScrollController.dispose();
  }

  @override
  void initState() {
    super.initState();
    _header = widget.header;
    _data = widget.data;
    _headerHeight = widget.headerHeight;
    autoFitWidth();
  }

  void autoFitWidth() {
    if (widget.autoFit ?? false) {
      double width = 0;
      for (int colIndex = 0; colIndex < _header.length; colIndex++) {
        final col = _header[colIndex];
        final colSize =
            TextSizeGetter.textSize(text: col.columnName).width + 25;
        if (colSize > width) {
          width = colSize;
        }
        for (int dataIndex = 0; dataIndex < _data.length; dataIndex++) {
          final data = _data[dataIndex][colIndex];
          final dataSize = TextSizeGetter.textSize(text: data).width + 25;
          if (dataSize > width) {
            width = dataSize;
          }
        }
        //print('col ${colIndex} width $width');
        _header[colIndex].setWidth(width);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          color: widget.backgroundColor,
          child: Scrollbar(
            thumbVisibility: true,
            trackVisibility: false,
            controller: verticalScrollController,
            child: Scrollbar(
              thumbVisibility: true,
              trackVisibility: false,
              controller: horizontalScrollController,
              notificationPredicate: (notif) => notif.depth == 1,
              child: SingleChildScrollView(
                controller: verticalScrollController,
                scrollDirection: Axis.vertical,
                child: SingleChildScrollView(
                  controller: horizontalScrollController,
                  scrollDirection: Axis.horizontal,
                  child: body(constraints),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget body(BoxConstraints constraints) {
    return Column(
      children: [header(), data()],
    );
  }

  Widget header() {
    return Row(
      children: List.generate(
          _header.length,
          (index) => HeaderTile(
                header: _header[index],
                height: _headerHeight,
              )),
    );
  }

  Widget data() {
    return Column(
      children: List.generate(
          _data.length,
          (index) => DataRow(
                dataRow: _data[index],
                header: _header,
              )),
    );
  }
}

class HeaderTile extends StatefulWidget {
  final double height;
  final ResizableHeader header;
  const HeaderTile({super.key, required this.header, required this.height});

  @override
  State<HeaderTile> createState() => _HeaderTileState();
}

class _HeaderTileState extends State<HeaderTile> {
  @override
  Widget build(BuildContext context) {
    // print(
    //     'header ${widget.header.columnName} width ${widget.header.currentWidth}');
    return Container(
      decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.withOpacity(0.7))),
      width: widget.header.currentWidth.value,
      height: widget.height,
      child: Stack(
        children: [
          Container(
            margin: const EdgeInsets.only(left: 5),
            child: Text(
              widget.header.columnName,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              softWrap: false,
            ),
          ),
          adjustWidthWidget()
        ],
      ),
    );
  }

  Widget adjustWidthWidget() {
    return Positioned(
        right: 0,
        child: GestureDetector(
          onPanStart: (details) {
            widget.header.dragStart = details.globalPosition.dx;
          },
          onPanUpdate: (details) {
            final changed = details.globalPosition.dx - widget.header.dragStart;
            final minWidth = widget.header.minWidth;
            var newWidth = widget.header.currentWidth.value + changed;
            newWidth = newWidth < minWidth ? minWidth : newWidth;
            setState(() {
              widget.header.dragStart = details.globalPosition.dx;
              widget.header.setWidth(newWidth);
            });
          },
          child: MouseRegion(
            cursor: SystemMouseCursors.resizeColumn,
            child: SizedBox(
              width: 5,
              height: widget.height,
            ),
          ),
        ));
  }
}

class DataRow extends StatelessWidget {
  final List<ResizableHeader> header;
  final List<String> dataRow;
  const DataRow({super.key, required this.dataRow, required this.header});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(
          dataRow.length,
          (col) =>
              DataTile(data: dataRow[col], colWidth: header[col].currentWidth)),
    );
  }
}

class DataTile extends StatelessWidget {
  final ValueNotifier<double> colWidth;
  final String data;
  const DataTile({super.key, required this.data, required this.colWidth});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: colWidth,
      builder: (context, value, child) {
        return Container(
          decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.withOpacity(0.7))),
          width: value,
          height: 30,
          child: Container(
            margin: const EdgeInsets.only(left: 5),
            child: Text(
              data,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              softWrap: false,
            ),
          ),
        );
      },
    );
  }
}
