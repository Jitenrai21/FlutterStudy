import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/counter_bloc.dart';
import '../bloc/counter_event.dart';
import '../bloc/counter_state.dart';

class BlocCounterScreen extends StatelessWidget {
  const BlocCounterScreen({super.key});

  final Color primaryColor = const Color(0xFF0ABAB5);
  final Color accentColor = const Color(0xFF56DFCF);
  final Color highlightColor = const Color(0xFFADEED9);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F6F8),
      appBar: AppBar(
        title: const Text('BLoC Counter'),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 4,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: BlocBuilder<CounterBloc, CounterState>(
              builder: (context, state) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "Current Count",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black54,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '${state.count}',
                      style: const TextStyle(
                        fontSize: 42,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: const CircleBorder(),
                            padding: const EdgeInsets.all(18),
                            backgroundColor: accentColor,
                            foregroundColor: Colors.white,
                            elevation: 4,
                          ),
                          onPressed: () => context
                              .read<CounterBloc>()
                              .add(DecrementEvent()),
                          child: const Icon(Icons.remove, size: 28),
                        ),
                        const SizedBox(width: 30),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: const CircleBorder(),
                            padding: const EdgeInsets.all(18),
                            backgroundColor: highlightColor,
                            foregroundColor: Colors.black,
                            elevation: 4,
                          ),
                          onPressed: () =>
                              context.read<CounterBloc>().add(IncrementEvent()),
                          child: const Icon(Icons.add, size: 28),
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
