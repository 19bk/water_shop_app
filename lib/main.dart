import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.light;

  void _toggleTheme() {
    setState(() {
      _themeMode = _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Demo Shop',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.light,
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.dark,
        useMaterial3: true,
      ),
      themeMode: _themeMode,
      home: HomePage(toggleTheme: _toggleTheme),
    );
  }
}

class HomePage extends StatefulWidget {
  final VoidCallback toggleTheme;

  const HomePage({Key? key, required this.toggleTheme}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  int waterLevel = 750;
  final int tankCapacity = 2000;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Demo Shop'),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Theme.of(context).brightness == Brightness.light
                ? Icons.dark_mode
                : Icons.light_mode),
            onPressed: widget.toggleTheme,
          ),
        ],
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          _buildDashboard(),
          _buildSalesView(),
          _buildRefillHistoryView(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.attach_money),
            label: 'Sales',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'Refill History',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }

  Widget _buildDashboard() {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        _buildWaterLevelCard(),
        const SizedBox(height: 16),
        _buildSensorDataCard(),
        const SizedBox(height: 16),
        _buildQuickActionsCard(),
      ],
    );
  }

  Widget _buildWaterLevelCard() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('Tank Water Level', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 200,
                  height: 200,
                  child: CircularProgressIndicator(
                    value: waterLevel / tankCapacity,
                    strokeWidth: 10,
                    backgroundColor: Colors.grey[300],
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '$waterLevel L',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    Text('of $tankCapacity L'),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSensorDataCard() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Sensor Data', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            _buildSensorData('Water Temperature', '22°C'),
            _buildSensorData('pH Level', '7.2'),
            _buildSensorData('TDS (Total Dissolved Solids)', '150 ppm'),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActionsCard() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Quick Actions', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              children: [
                ElevatedButton.icon(
                  onPressed: () {/* TODO: Implement onboard customer action */},
                  icon: const Icon(Icons.person_add),
                  label: const Text('Onboard Customer'),
                ),
                ElevatedButton.icon(
                  onPressed: () {/* TODO: Implement report issue action */},
                  icon: const Icon(Icons.report_problem),
                  label: const Text('Report an Issue'),
                ),
                ElevatedButton.icon(
                  onPressed: () {/* TODO: Implement make purchase action */},
                  icon: const Icon(Icons.shopping_cart),
                  label: const Text('Make Purchase'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSalesView() {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        _buildMetricCard('Today\'s Sales', 'KSh 1,250', Icons.monetization_on),
        _buildMetricCard('Water Sold Today', '500 L', Icons.water_drop),
        _buildMetricCard('Customers Served', '25', Icons.people),
        _buildMetricCard('Average Transaction', 'KSh 50', Icons.calculate),
      ],
    );
  }

  Widget _buildRefillHistoryView() {
    return ListView.builder(
      itemCount: 10,
      itemBuilder: (context, index) {
        return ListTile(
          leading: const Icon(Icons.water_drop),
          title: Text('Refill #${10 - index}'),
          subtitle: Text('Date: ${DateTime.now().subtract(Duration(days: index)).toString().split(' ')[0]}'),
          trailing: const Text('1000 L'),
        );
      },
    );
  }

  Widget _buildSensorData(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildMetricCard(String title, String value, IconData icon) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Icon(icon, size: 48, color: Theme.of(context).primaryColor),
            const SizedBox(height: 8),
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 4),
            Text(value, style: Theme.of(context).textTheme.headlineSmall),
          ],
        ),
      ),
    );
  }
}