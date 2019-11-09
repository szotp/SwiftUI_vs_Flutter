# SwiftUI vs Flutter

Here is some SwiftUI code

```swift
struct MyHomePage: View {
    @State var counter: Int
    @ObservedObject var notifierA: ValueNotifier<Int>
    @ObservedObject var notifierB: ValueNotifier<Int>
    
    func incrementCounter() {
        counter += 1
    }
    
    var body: some View {
        return VStack {
            Text("You have pushed the button this many times:")
            Text("\(counter)").font(.largeTitle)
            Button(action: incrementCounter) {
                Text("Increment")
            }
        }.navigationBarTitle("Title")
    }
}

```

The equivalent of it in Flutter is pretty verbose
```dart
class MyHomePage extends StatefulWidget {
  final int initialCounter;
  final ValueNotifier<int> notifierA;
  final ValueNotifier<int> notifierB;

  MyHomePage({
    Key key,
    this.notifierA,
    this.notifierB,
    this.initialCounter,
  }) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  @override
  void initState() {
    _counter = widget.initialCounter;
    super.initState();

    widget.notifierA.addListener(_onChanged);
    widget.notifierB.addListener(_onChanged);
  }

  @override
  void didUpdateWidget(MyHomePage oldWidget) {
    if (oldWidget.notifierA != widget.notifierA) {
      oldWidget.notifierA.removeListener(_onChanged);
      widget.notifierA.addListener(_onChanged);
    }

    if (oldWidget.notifierB != widget.notifierB) {
      oldWidget.notifierB.removeListener(_onChanged);
      widget.notifierB.addListener(_onChanged);
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    super.dispose();

    widget.notifierA.removeListener(_onChanged);
    widget.notifierB.removeListener(_onChanged);
  }

  void _onChanged() {
    setState(() {});
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Title'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('You have pushed the button this many times:'),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.title,
            ),
            FlatButton(
              onPressed: _incrementCounter,
              child: Text('Increment'),
            )
          ],
        ),
      ),
    );
  }
}
```

That code can be improved by flutter_hooks, but hooks are pretty hacky and force everything into the build method:

```dart
class MyHomePageHooks extends HookWidget {
  final int initialCounter;
  final ValueNotifier<int> notifierA;
  final ValueNotifier<int> notifierB;

  MyHomePageHooks({
    Key key,
    this.notifierA,
    this.notifierB,
    this.initialCounter,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _counter = useState(1);
    useValueListenable(notifierA);
    useValueListenable(notifierB);

    void _incrementCounter() {
      _counter.value += 1;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Title'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('You have pushed the button this many times:'),
            Text(
              '${_counter.value}',
              style: Theme.of(context).textTheme.title,
            ),
            FlatButton(
              onPressed: _incrementCounter,
              child: Text('Increment'),
            )
          ],
        ),
      ),
    );
  }
}
```