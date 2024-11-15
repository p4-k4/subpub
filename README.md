# SubPub

A lightweight and efficient state management solution for Flutter that implements the publisher-subscriber pattern with automatic dependency tracking.

![SubPub Example](https://github.com/p4-k4/subpub/raw/main/screenshots/screenshot1.png)

## Features

- 🎯 **Simple Publisher-Subscriber Pattern**: Easy-to-understand state management approach
- 🔄 **Automatic Dependency Tracking**: Subscribers automatically track their dependencies
- 🛠 **Macro-powered**: Uses Dart macros for clean and efficient code generation
- 🎨 **Flutter-first**: Designed specifically for Flutter applications
- 🔒 **Type-safe**: Fully type-safe state management
- 🏃 **Minimal Boilerplate**: Create publishers with minimal code

## Installation

Add `subpub` to your `pubspec.yaml`:

```yaml
dependencies:
  subpub: ^0.0.1
```

## Important Note About Dart Macros

SubPub uses Dart's experimental macros feature. Due to the current experimental state, there are some important setup steps and known issues to be aware of:

1. Enable the macros experiment in your project's `analysis_options.yaml`:
```yaml
analyzer:
  enable-experiment:
    - macros
```

2. **Known VS Code Issue**: Due to a current limitation in how VS Code handles macro definitions from external packages ([dart-lang/sdk#55670](https://github.com/dart-lang/sdk/issues/55670)), you might encounter issues where the analyzer doesn't detect macro-generated definitions. If this happens:

   **Workaround**: 
   - Go to the definition of the `@Publish` macro (using "Go to Definition" in your IDE)
   - Then return to your project files
   - The definitions should now be correctly detected and available

   This is a temporary limitation of the experimental macros feature and will be resolved in future updates.

## Usage

### Basic Example: Single Publisher

First, let's look at a simple counter example using a single publisher:

```dart
// Define your publisher
@Publish()
class CounterPublisher extends Publisher {
  int _count = 0;
  
  void increment() {
    _count++;
    notifyListeners();
  }
}

// Use it in a widget
class CounterWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final counter = CounterPublisher.instance;
    
    return Subscriber((context) => Column(
      children: [
        Text('Count: ${counter.count}'),
        ElevatedButton(
          onPressed: () => counter.increment(),
          child: Text('Increment'),
        ),
      ],
    ));
  }
}
```

### Advanced Example: Multiple Publishers

Now let's look at how to use multiple publishers together:

```dart
// Define multiple publishers
@Publish()
class ThemePublisher extends Publisher {
  bool _isDarkMode = false;
  
  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }
}

@Publish()
class UserPublisher extends Publisher {
  String _username = '';
  
  void updateUsername(String newName) {
    _username = newName;
    notifyListeners();
  }
}

// Use multiple publishers in a single widget
class DashboardWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final counter = CounterPublisher.instance;
    final theme = ThemePublisher.instance;
    final user = UserPublisher.instance;
    
    return Subscriber((context) => Container(
      color: theme.isDarkMode ? Colors.black : Colors.white,
      child: Column(
        children: [
          Text('Welcome, ${user.username}!'),
          Text('Count: ${counter.count}'),
          ElevatedButton(
            onPressed: () => theme.toggleTheme(),
            child: Text('Toggle Theme'),
          ),
          ElevatedButton(
            onPressed: () => counter.increment(),
            child: Text('Increment Counter'),
          ),
        ],
      ),
    ));
  }
}
```

The `@Publish` macro automatically:
- Creates a singleton instance
- Generates getters for private fields
- Handles dependency tracking

## How it Works

1. The `Publisher` class extends `ChangeNotifier` to provide state change notifications
2. `Subscriber` widget automatically tracks which publishers are accessed during the build
3. When a publisher's state changes, only the dependent subscribers are rebuilt
4. The `@Publish` macro generates boilerplate code for better developer experience

## Best Practices

- Keep publishers focused on a single responsibility
- Use private fields with public getters for read-only state
- Call `notifyListeners()` after state changes
- Use the singleton instance provided by the `@Publish` macro

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
