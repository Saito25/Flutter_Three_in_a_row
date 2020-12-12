import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

void main() {
  debugPaintSizeEnabled = true;
  debugPaintLayerBordersEnabled = true;
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  static const String _title = 'Three in a row';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text(_title),
        ),
        body: GameBoard(),
      ),
    );
  }
}

class GameBoard extends StatefulWidget {
  final int _rowsXColumns = 4;

  @override
  _GameBoardState createState() => _GameBoardState();
}

class _GameBoardState extends State<GameBoard> {
  List<List<int>> _tilesStatus;
  int _rowsXColumns2;
  int _turn = 1;

  void _handleTilesStatus(int axisX, int axisY) {
    print(_tilesStatus);
    setState(() {
      _turn % 2 != 0
          ? _tilesStatus[axisX][axisY] = 1
          : _tilesStatus[axisX][axisY] = 2;
      _turn++;
    });
  }

  @override
  void initState() {
    _tilesStatus = List.generate(
        widget._rowsXColumns, (index) => List.filled(widget._rowsXColumns, 0));
    print(_tilesStatus);
    _rowsXColumns2 = widget._rowsXColumns;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: generateGameBoard(_rowsXColumns2),
      ),
    );
  }

  List<Widget> generateGameBoard(int rowNumbers) {
    List<Widget> rowsList = [];

    for (int i = 0; i < rowNumbers; i++) {
      rowsList.add(rowGenerator(i, rowNumbers));
    }

    return rowsList;
  }

  Widget rowGenerator(int axisY, tileNumbers) {
    List<Widget> tilesList = [];
    for (int i = 0; i < tileNumbers; i++) {
      tilesList.add(
        Expanded(
          child: GameTile(
            onChange: _handleTilesStatus,
            axisX: i,
            axisY: axisY,
            tileStatus: _tilesStatus[i][axisY],
          ),
        ),
      );
    }
    return Expanded(child: Row(children: tilesList));
  }
}

class GameTile extends StatelessWidget {
  final int axisX;
  final int axisY;
  final int tileStatus;
  final void Function(int axisX, int axisY) onChange;

  const GameTile(
      {Key key,
      this.tileStatus = 0,
      @required this.onChange,
      @required this.axisX,
      @required this.axisY})
      : super(key: key);

  void _handleStatus() {
    print('S: $tileStatus, X: $axisX, Y: $axisY');
    if (tileStatus == 0) {
      onChange(axisX, axisY);
    }
  }

  @override
  Widget build(BuildContext context) {
    final Widget _iconToShow = (tileStatus == 0
        ? null
        : (tileStatus == 1 ? Icon(Icons.cancel_outlined) : Icon(Icons.cancel)));

    return GestureDetector(
      onTap: _handleStatus,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[300],
          border: Border.all(color: Colors.black87, width: 1.5),
        ),
        child: _iconToShow,
      ),
    );
  }
}
