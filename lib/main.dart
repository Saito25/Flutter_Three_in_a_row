import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

void main() {
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

  void _handleTilesStatus(int axisY, int axisX) {
    setState(() {
      _turn % 2 != 0
          ? _tilesStatus[axisY][axisX] = 1
          : _tilesStatus[axisY][axisX] = 2;
      _turn++;
    });
  }

  @override
  void initState() {
    _tilesStatus = List.generate(
        widget._rowsXColumns, (index) => List.filled(widget._rowsXColumns, 0));
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

    for (int y = 0; y < rowNumbers; y++) {
      rowsList.add(rowGenerator(y, rowNumbers));
    }

    return rowsList;
  }

  Widget rowGenerator(int axisY, tileNumbers) {
    List<Widget> tilesList = [];
    for (int x = 0; x < tileNumbers; x++) {
      tilesList.add(
        Expanded(
          child: GameTile(
            onChange: _handleTilesStatus,
            axisX: x,
            axisY: axisY,
            tileStatus: _tilesStatus[axisY][x],
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
    if (tileStatus == 0) {
      onChange(axisY, axisX);
    }
  }

  @override
  Widget build(BuildContext context) {
    final Widget _iconToShow = (tileStatus == 0
        ? null
        : (tileStatus == 1 ? Icon(Icons.cancel_outlined, size: 50.0,) : Icon(Icons.cancel, size: 50.0)));

    return GestureDetector(
      onTap: _handleStatus,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.red[300],
          border: Border.all(color: Colors.black87, width: 1.5),
        ),
        child: Center(child: _iconToShow),
      ),
    );
  }
}
