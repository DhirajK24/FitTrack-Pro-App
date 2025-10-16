import 'package:flutter/material.dart';

void main() {
  runApp(const FitTrackWebTest());
}

class FitTrackWebTest extends StatelessWidget {
  const FitTrackWebTest({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FitTrack Pro - Web Test',
      theme: ThemeData.dark(),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  int _waterIntake = 0;
  int _workoutCount = 0;
  double _sleepHours = 0.0;

  final List<Map<String, dynamic>> _workouts = [
    {'name': 'Push-ups', 'sets': 3, 'reps': 15},
    {'name': 'Squats', 'sets': 3, 'reps': 20},
    {'name': 'Plank', 'sets': 3, 'reps': 30},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F0F),
      appBar: AppBar(
        title: const Text('FitTrack Pro'),
        backgroundColor: const Color(0xFF202020),
        foregroundColor: Colors.white,
      ),
      body: _buildBody(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        backgroundColor: const Color(0xFF202020),
        selectedItemColor: const Color(0xFF5DD62C),
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Dashboard'),
          BottomNavigationBarItem(
            icon: Icon(Icons.fitness_center),
            label: 'Workout',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.water_drop), label: 'Water'),
          BottomNavigationBarItem(icon: Icon(Icons.bedtime), label: 'Sleep'),
        ],
      ),
    );
  }

  Widget _buildBody() {
    switch (_selectedIndex) {
      case 0:
        return _buildDashboard();
      case 1:
        return _buildWorkout();
      case 2:
        return _buildWater();
      case 3:
        return _buildSleep();
      default:
        return _buildDashboard();
    }
  }

  Widget _buildDashboard() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Dashboard',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  'Workouts',
                  _workoutCount.toString(),
                  Icons.fitness_center,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildStatCard(
                  'Water (ml)',
                  _waterIntake.toString(),
                  Icons.water_drop,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  'Sleep (hrs)',
                  _sleepHours.toStringAsFixed(1),
                  Icons.bedtime,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildStatCard(
                  'Calories',
                  '0',
                  Icons.local_fire_department,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Text(
            'Recent Activity',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: ListView(
              children: [
                _buildActivityItem('Completed Push-ups workout', '2 hours ago'),
                _buildActivityItem('Drank 500ml water', '1 hour ago'),
                _buildActivityItem('Logged 7.5 hours sleep', 'Yesterday'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWorkout() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Workout Tracker',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _workoutCount++;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Workout logged!'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: const Text('Log Workout'),
          ),
          const SizedBox(height: 20),
          const Text(
            'Available Exercises',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount: _workouts.length,
              itemBuilder: (context, index) {
                final workout = _workouts[index];
                return Card(
                  color: const Color(0xFF202020),
                  child: ListTile(
                    leading: const Icon(
                      Icons.fitness_center,
                      color: Color(0xFF5DD62C),
                    ),
                    title: Text(
                      workout['name'],
                      style: const TextStyle(color: Colors.white),
                    ),
                    subtitle: Text(
                      '${workout['sets']} sets x ${workout['reps']} reps',
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWater() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Water Tracker',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 20),
          Center(
            child: Column(
              children: [
                Text(
                  '$_waterIntake ml',
                  style: const TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF5DD62C),
                  ),
                ),
                const Text(
                  'Today\'s Intake',
                  style: TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildWaterButton(250, '250ml'),
                    _buildWaterButton(500, '500ml'),
                    _buildWaterButton(1000, '1L'),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSleep() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Sleep Tracker',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 20),
          Center(
            child: Column(
              children: [
                Text(
                  '${_sleepHours.toStringAsFixed(1)} hrs',
                  style: const TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF5DD62C),
                  ),
                ),
                const Text('Last Night', style: TextStyle(color: Colors.grey)),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildSleepButton(6.0, '6h'),
                    _buildSleepButton(7.5, '7.5h'),
                    _buildSleepButton(8.0, '8h'),
                    _buildSleepButton(9.0, '9h'),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon) {
    return Card(
      color: const Color(0xFF202020),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Icon(icon, color: const Color(0xFF5DD62C), size: 32),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Text(title, style: const TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityItem(String title, String time) {
    return Card(
      color: const Color(0xFF202020),
      child: ListTile(
        leading: const Icon(Icons.check_circle, color: Color(0xFF5DD62C)),
        title: Text(title, style: const TextStyle(color: Colors.white)),
        subtitle: Text(time, style: const TextStyle(color: Colors.grey)),
      ),
    );
  }

  Widget _buildWaterButton(int amount, String label) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          _waterIntake += amount;
        });
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF5DD62C),
        foregroundColor: Colors.black,
      ),
      child: Text(label),
    );
  }

  Widget _buildSleepButton(double hours, String label) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          _sleepHours = hours;
        });
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF5DD62C),
        foregroundColor: Colors.black,
      ),
      child: Text(label),
    );
  }
}
