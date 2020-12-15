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
  int _turn;
  int _winner = 0;
  bool _thereIsWinner = false;

  void _handleTilesStatus(int axisY, int axisX) {
    if (!_thereIsWinner) {
      int _currentPlayerTurn = _turn % 2;
      int _numberOfPlayer = _currentPlayerTurn != 0 ? 1 : 2;
      _currentPlayerTurn != 0
          ? _tilesStatus[axisY][axisX] = 1
          : _tilesStatus[axisY][axisX] = 2;
      _turn++;
      _determineteIfWinner(axisY, axisX, _numberOfPlayer, _rowsXColumns2);
    }
  }

  void _determineteIfWinner(
      int axisY, int axisX, int currentPlayer, int numberToMatch) {
    print('currentPlayer: $currentPlayer');
    setState(() {
      if (_matchThreeInARow(axisY, axisX, currentPlayer, numberToMatch)) {
        _winner = currentPlayer;
        _thereIsWinner = true;
      }
    });
  }

  bool _matchThreeInARow(int axisY, int axisX, int player, int numberToMatch) {
    int _accumulator = 0;
    int auxiliar = 0;
    int coordinateY;
    int coordinateX;

    // Mirar vertical: Cambia la Y, X se mantiene.
    for (int i = 0; i < _tilesStatus.length; i++) {
      if (_tilesStatus[i][axisX] == player) {
        _accumulator++;
      } else {
        _accumulator = 0;
      }

      if (_accumulator == numberToMatch) {
        return true;
      }
    }
    _accumulator = 0;

    //Mirar horizontal: Cambia la X, Y se mantiene.
    for (int i = 0; i < _tilesStatus[axisY].length; i++) {
      if (_tilesStatus[axisY][i] == player) {
        _accumulator++;
      } else {
        _accumulator = 0;
      }

      if (_accumulator == numberToMatch) {
        return true;
      }
    }
    _accumulator = 0;

    // Mirar diagonal izquierda: Cambia tanto X como Y.
    coordinateY = axisY;
    coordinateX = axisX;

    while(coordinateX != (_tilesStatus[axisY].length - 1) && coordinateY != (_tilesStatus.length - 1)) {
      coordinateX++;
      coordinateY++;
    }
    auxiliar = coordinateY <= coordinateX ? coordinateY : coordinateX;
    for (int i = 0; i <= auxiliar; i++) {

      if (_tilesStatus[coordinateY--][coordinateX--] == player) {
        _accumulator++;
      } else {
        _accumulator = 0;
      }
      if (_accumulator == numberToMatch) {
        return true;
      }
    }
    _accumulator = 0;

    // Mirar diagonal Derecha: Cambia tanto X como Y.
    coordinateY = axisY;
    coordinateX = axisX;

    while(coordinateX != 0 && coordinateY != (_tilesStatus.length - 1)) {
      coordinateX--;
      coordinateY++;
    }

    auxiliar = (coordinateX - coordinateY).abs();
    for (int i = 0; i <= auxiliar; i++) {
      if (_tilesStatus[coordinateY--][coordinateX++] == player) {
        _accumulator++;
      } else {
        _accumulator = 0;
      }
      if (_accumulator == numberToMatch) {
        return true;
      }
    }

    return false;
  }

  @override
  void initState() {
    _tilesStatus = List.generate(
        widget._rowsXColumns, (index) => List.filled(widget._rowsXColumns, 0));
    _rowsXColumns2 = widget._rowsXColumns;
    _turn = 1;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget _playerOneNoWinnerYet = _turn % 2 != 0
        ? Text(
            'Player one',
            style: TextStyle(fontSize: 25.0),
          )
        : Text(
            'Player one',
            style: TextStyle(fontSize: 20.0),
          );
    Widget _playerOneSelectedWinner = _winner == 1
        ? Text(
            'Winner',
            style: TextStyle(fontSize: 25.0),
          )
        : Text(
            'Loser',
            style: TextStyle(fontSize: 20.0),
          );
    Widget _playerTwoNoWinnerYet = _turn % 2 == 0
        ? Text(
            'Player two',
            style: TextStyle(fontSize: 25.0),
            textAlign: TextAlign.end,
          )
        : Text(
            'Player two',
            style: TextStyle(fontSize: 20.0),
            textAlign: TextAlign.end,
          );
    Widget _playerTwoSelectedWinner = _winner == 2
        ? Text(
            'Winner',
            style: TextStyle(fontSize: 25.0),
            textAlign: TextAlign.end,
          )
        : Text(
            'Loser',
            style: TextStyle(fontSize: 20.0),
            textAlign: TextAlign.end,
          );

    Widget _playerOneTitle =
        _winner == 0 ? _playerOneNoWinnerYet : _playerOneSelectedWinner;
    Widget _playerTwoTitle =
        _winner == 0 ? _playerTwoNoWinnerYet : _playerTwoSelectedWinner;

    Widget _playerListTile = Container(
      margin: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
      padding: EdgeInsets.all(10.0),
      decoration: BoxDecoration(
          color: Colors.lightBlue, borderRadius: BorderRadius.circular(8.0)),
      child: ListTile(
        title: _playerOneTitle,
        leading: CircleAvatar(
          child: Image.asset('assets/images/light_side/c3p0.png'),
        ),
      ),
    );
    Widget _enemyListTile = Container(
      margin: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
      padding: EdgeInsets.all(10.0),
      decoration: BoxDecoration(
          color: Colors.grey, borderRadius: BorderRadius.circular(8.0)),
      child: ListTile(
        title: _playerTwoTitle,
        trailing: CircleAvatar(
          child: Image.asset('assets/images/dark_side/clone_trooper.png'),
        ),
      ),
    );

    return Column(
      children: [
        _playerListTile,
        _enemyListTile,
        Expanded(
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: generateGameBoard(_rowsXColumns2),
            ),
          ),
        ),
      ],
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
        : (tileStatus == 1
            ? Icon(
                Icons.cancel_outlined,
                size: 50.0,
              )
            : Icon(Icons.cancel, size: 50.0)));

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
