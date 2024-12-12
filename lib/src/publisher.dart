import 'package:flutter/material.dart';

abstract class Publisher extends ChangeNotifier {
  T get<T>(T value) {
    final currentSubscriber = SubscriberState._currentState;
    if (currentSubscriber != null) {
      currentSubscriber.addNotifier(this);
    }
    return value;
  }
}

class Subscriber extends StatefulWidget {
  const Subscriber(this.builder, {super.key});
  final Widget Function(BuildContext context) builder;

  @override
  State<Subscriber> createState() => SubscriberState();
}

class SubscriberState extends State<Subscriber> {
  static SubscriberState? _currentState;
  final Set<ChangeNotifier> _notifiers = {};

  void addNotifier(ChangeNotifier notifier) {
    if (_notifiers.add(notifier)) {
      notifier.addListener(_update);
    }
  }

  void _update() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    for (var notifier in _notifiers) {
      notifier.removeListener(_update);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final previousSubscriber = _currentState;
    _currentState = this;
    final result = widget.builder(context);
    _currentState = previousSubscriber;
    return result;
  }
}
