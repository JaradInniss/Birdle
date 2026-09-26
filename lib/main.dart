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
    return AnimatedContainer(
      /// A Container is a convenience widget that wraps several core styling widgets,
      /// such as Padding, ColoredBox, SizedBox, and DecoratedBox.
      /// An AnimatedContainer is like a Container, 
      /// but it automatically animates changes to its properties over a specified duration
      duration: Duration(milliseconds: 500),
      curve: Curves.easeIn, // Curves change the speed of the animation at different points throughout the animation
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

/// GuessInput Widget is responsible for allowing users to type in their guesses
/// requires a callback function as an argument - onSubmitGuess
class GuessInput extends StatefulWidget {
  GuessInput({super.key, required this.onSubmitGuess});

  final void Function(String) onSubmitGuess;

  @override
  State<GuessInput> createState() => _GuessInputState();
}

class _GuessInputState extends State<GuessInput> {
  // A TextEditingController is used to read, clear, and modify the text in a TextField
  final TextEditingController _textEditingController = TextEditingController();
  // A FocusNode manages the keyboard focus. You can use FocusNode to request that a TextField gain focus, (making the keyboard appear on mobile), or to know when a field has focus.
  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _textEditingController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onSubmit () {
    widget.onSubmitGuess(_textEditingController.text.trim());
    _textEditingController.clear();
    _focusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        /// When a child of a Row or Column is wrapped in Expanded, it tells that child to fill all the available space
        /// along the main axis (horizontal forRow, vertical for Column) that hasn't been taken by other children. 
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              maxLength: 5,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                ),
                focusColor: Color(Colors.blueGrey.hashCode),
              ),
              controller: _textEditingController,
              autofocus: true,
              focusNode: _focusNode, // Allows focus even after the 'Enter' key is pressed
              onSubmitted: (input) {
                // onSubmitted is used to capture the text when the user presses the 'Enter' key when the 
                _onSubmit();
              },
            ),
          )
        ),
        IconButton(
          /// IconButton widget requires two arguments (in addition to their optional arguments) 
          /// 1) A callback function passed to onPressed.
          /// 2) A widget that makes up the content of the button (often Text or an Icon).
          padding: EdgeInsets.zero,
          icon: const Icon(Icons.send_rounded),
          onPressed: () {
            _onSubmit();
          },
        ),
      ],
    );
  }
}


class GamePage extends StatefulWidget {
  /// StatefulWidget and it's companion State allow a Widget's data/appearance to change during it's lifetime
  /// StatefulWidget is immutable but the State object is long-lived and can hold mutable data so it can be used to rebuild UI when its data changes
  GamePage({super.key});

  @override
  State<GamePage> createState() => _GamePageState(); // This is the state
}

class _GamePageState extends State<GamePage> {
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
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (final letter in guess)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2.5, vertical: 2.5),
                    child: Tile(letter.char, letter.type,),
                  ),
              ],
            ),
          
          GuessInput(
            onSubmitGuess: (String guess) {
              setState(() {
                // setState signals the framework to update the UI and call the build method again.
                _game.guess(guess);
              });
            }
          ),
        ],
      ),
    );
  }
}