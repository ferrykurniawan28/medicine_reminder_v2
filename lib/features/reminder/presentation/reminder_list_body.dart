import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medicine_reminder/features/reminder/bloc/reminder_bloc.dart';
import 'package:medicine_reminder/features/reminder/domain/entities/reminder.dart';
import 'package:medicine_reminder/features/user/bloc/user_bloc.dart';
import 'package:medicine_reminder/helpers/helpers.dart';
import 'package:medicine_reminder/ui/main/widgets/widgets.dart';

class ReminderListBody extends StatefulWidget {
  const ReminderListBody({super.key});

  @override
  State<ReminderListBody> createState() => _ReminderListBodyState();
}

class _ReminderListBodyState extends State<ReminderListBody> {
  late final int userId;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchReminders();
  }

  void _fetchReminders() {
    if (_isLoading || !mounted) return;

    _isLoading = true; // Set loading flag to true

    try {
      UserHelper.executeWithUserId(context, (int userId) {
        context.read<ReminderBloc>().add(LoadReminders(userId));
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error fetching reminders: $e'),
          ),
        );
      }
    } finally {
      _isLoading = false; // Reset loading flag
    }
  }

  void _loadReminders() {
    if (_isLoading) return;
    _isLoading = true;
    context.read<ReminderBloc>().add(LoadReminders(userId));
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        _isLoading = false;
        _loadReminders();
      },
      child: BlocConsumer<ReminderBloc, ReminderState>(
        listener: (context, state) {
          _isLoading = false;
          if (state is ReminderError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          return _buildContent(state);
        },
      ),
    );
  }

  Widget _buildContent(ReminderState state) {
    if (state is ReminderLoading) {
      return const _ShimmerLoadingList();
    } else if (state is ReminderLoaded) {
      if (state.reminders.isEmpty) {
        return const _EmptyRemindersList();
      }
      return _RemindersList(reminders: state.reminders);
    } else if (state is ReminderError) {
      return _ErrorView(
        message: state.message,
        onRetry: () {
          _isLoading = false;
          _loadReminders();
        },
      );
    } else {
      return const Center(child: CircularProgressIndicator());
    }
  }
}

class _ShimmerLoadingList extends StatelessWidget {
  const _ShimmerLoadingList();

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics:
          const NeverScrollableScrollPhysics(), // Disable scroll during loading
      itemCount: 6,
      itemBuilder: (context, index) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
        child: _ShimmerPlaceholder(
            index: index), // Pass index for staggered animation
      ),
    );
  }
}

class _ShimmerPlaceholder extends StatefulWidget {
  final int index;

  const _ShimmerPlaceholder({required this.index});

  @override
  State<_ShimmerPlaceholder> createState() => _ShimmerPlaceholderState();
}

class _ShimmerPlaceholderState extends State<_ShimmerPlaceholder>
    with SingleTickerProviderStateMixin {
  late AnimationController _shimmerController;
  late Animation<double> _shimmerAnimation;

  @override
  void initState() {
    super.initState();

    _shimmerController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _shimmerAnimation = Tween<double>(
      begin: -1.0,
      end: 2.0,
    ).animate(CurvedAnimation(
      parent: _shimmerController,
      curve: Curves.easeInOut,
    ));

    // Stagger the animation start based on index to reduce simultaneous redraws
    Future.delayed(Duration(milliseconds: widget.index * 100), () {
      if (mounted) {
        _shimmerController.repeat();
      }
    });
  }

  @override
  void dispose() {
    _shimmerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _shimmerAnimation,
      builder: (context, child) {
        return Container(
          height: 80,
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Stack(
            children: [
              // Base content
              Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    margin: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade400,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  const Expanded(
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _ShimmerBox(width: double.infinity, height: 14),
                          SizedBox(height: 8),
                          _ShimmerBox(width: 100, height: 12),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              // Shimmer overlay
              Positioned.fill(
                child: Transform.translate(
                  offset: Offset(_shimmerAnimation.value * 300, 0),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.transparent,
                          Colors.white.withOpacity(0.3),
                          Colors.transparent,
                        ],
                        stops: const [0.0, 0.5, 1.0],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ShimmerBox extends StatelessWidget {
  final double width;
  final double height;

  const _ShimmerBox({required this.width, required this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      color: Colors.grey.shade400,
    );
  }
}

class _EmptyRemindersList extends StatelessWidget {
  const _EmptyRemindersList();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('You have no reminders yet, add one!'),
    );
  }
}

class _RemindersList extends StatelessWidget {
  final List<Reminder> reminders;

  const _RemindersList({required this.reminders});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: reminders.length,
      // Add caching and performance optimizations
      cacheExtent: 250.0, // Cache items outside viewport
      physics: const BouncingScrollPhysics(), // Smoother scrolling
      itemBuilder: (context, index) {
        final reminder = reminders[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: RepaintBoundary(
            child: CardReminder(
              key: ValueKey(reminder.id), // Key for efficient rebuilds
              reminder: reminder,
            ),
          ),
        );
      },
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 48, color: Colors.red),
          const SizedBox(height: 16),
          Text(message),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: onRetry,
            style: ElevatedButton.styleFrom(
              backgroundColor: kPrimaryColor,
            ),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}
