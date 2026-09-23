import 'package:flutter/material.dart';
import 'game.dart';

void main() {
  // runApp is a flutter SDK method that takes a widget argument and makes it the root of the widget tree
  runApp(const MainApp());
}

// MainApp is the root widget in this case - the widget passed to runApp()
class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        /// Scaffold is a convenience widget that provides a Material-style page layout, 
        /// making it simple to add an app bar, drawer, navigation bar, and more to a page of your app
        appBar: AppBar(
          title: const Align(
            alignment: Alignment.centerLeft,
            child: Text('Birdle'),
          ),
        ),
        body: Center(
          child: GamePage()
        ),
      ),
    );
  }
}

class Tile extends StatelessWidget {
  const Tile(this.letter, this.hitType, {super.key});

  final String letter; // A String representing the guessed letter of the tile
  final HitType hitType; // A HitType enum value represent the guess result and used to determine the color of the tile. For example, HitType.hit results in a green tile.

  // The build() method must be defined for every widget and always returns another widget
  @override
  Widget build(BuildContext context) {
    return Container(
      /// Container is a convenience widget that wraps several core styling widgets,
      /// such as Padding, ColoredBox, SizedBox, and DecoratedBox.
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        /// BoxDecoration is an object that knows how to add any number of decorations to a widget,
        /// from background color to borders to box shadows and more.
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
        color: switch (hitType) {
          HitType.hit => Colors.green,
          HitType.partial => Colors.yellow,
          HitType.miss => Colors.orange,
          _ => Colors.grey
        },
      ),
      /// the widget's child or children properties pass a widget or a list of widgets, respectively
      child: Center(
        child: Text(
          letter.toUpperCase(),
          style: Theme.of(context).textTheme.titleLarge,
        ),
      )
    );
  }
}

class GamePage extends StatelessWidget {
  GamePage({super.key});

  final Game _game = Game();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Column(
        spacing: 5.0,
        children: [
          for (final guess in _game.guesses)
          /// This for loop is called a 'collection for element', a Dart syntax that allows you to 
          /// iteratively add items to a collection when it is built at runtime.
            Row(
              spacing: 5.0,
              children: [
                for (final letter in guess)
                  Tile(letter.char, letter.type,)
              ],
            )
        ],
      ),
    );
  }
}