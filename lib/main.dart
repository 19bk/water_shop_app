import 'package:flutter/material.dart';

void main() {
  runApp(const WaterShopApp());
}

class WaterShopApp extends StatefulWidget {
  const WaterShopApp({super.key});

  @override
  State<WaterShopApp> createState() => _WaterShopAppState();
}

class _WaterShopAppState extends State<WaterShopApp> {
  bool _isDarkMode = false;

  void _toggleTheme() {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Water Shop',
      theme: _isDarkMode ? ThemeData.dark() : ThemeData.light(),
      home: WaterShopHomePage(
        isDarkMode: _isDarkMode,
        toggleTheme: _toggleTheme,
      ),
    );
  }
}

class WaterShopHomePage extends StatefulWidget {
  final bool isDarkMode;
  final VoidCallback toggleTheme;

  const WaterShopHomePage({
    super.key,
    required this.isDarkMode,
    required this.toggleTheme,
  });

  @override
  State<WaterShopHomePage> createState() => _WaterShopHomePageState();
}

class _WaterShopHomePageState extends State<WaterShopHomePage> {
  AppView _currentView = AppView.overview;

  // Sensor data (you would update these with real data)
  double _tankLevel = 75.0; // percentage
  double _phLevel = 7.2;
  double _temperature = 22.5; // Celsius
  double _humidity = 60.0; // percentage

  // Tank levels (you would update these with real data)
  List<double> _tankLevels = [80.0, 65.0, 90.0]; // percentages

  // Sales data (you would update this with real data)
  int _salesMade = 150;
  double _revenue = 7500.0;

  void _changeView(AppView view) {
    setState(() {
      _currentView = view;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 20),
              _buildTabButtons(),
              const SizedBox(height: 20),
              Expanded(child: _buildCurrentView()),
              _buildBottomNavBar(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Water Shop',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        Row(
          children: [
            IconButton(
              icon: Icon(widget.isDarkMode ? Icons.light_mode : Icons.dark_mode),
              onPressed: widget.toggleTheme,
            ),
            IconButton(
              icon: const Icon(Icons.notifications_outlined),
              onPressed: () {},
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTabButtons() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildTabButton('Overview', AppView.overview),
          _buildTabButton('Tank 1', AppView.tank1),
          _buildTabButton('Tank 2', AppView.tank2),
          _buildTabButton('Tank 3', AppView.tank3),
        ],
      ),
    );
  }

  Widget _buildTabButton(String text, AppView view) {
    bool isSelected = _currentView == view;
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: ElevatedButton(
        onPressed: () => _changeView(view),
        style: ElevatedButton.styleFrom(
          backgroundColor: isSelected ? Colors.blue : Colors.grey[300],
          foregroundColor: isSelected ? Colors.white : Colors.black,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        ),
        child: Text(text),
      ),
    );
  }

  Widget _buildCurrentView() {
    switch (_currentView) {
      case AppView.overview:
        return _buildOverviewView();
      case AppView.tank1:
        return _buildTankView('Tank 1', _tankLevels[0]);
      case AppView.tank2:
        return _buildTankView('Tank 2', _tankLevels[1]);
      case AppView.tank3:
        return _buildTankView('Tank 3', _tankLevels[2]);
    }
  }

  Widget _buildOverviewView() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSensorDataCard(),
          const SizedBox(height: 20),
          _buildWaterLevelsCard(),
          const SizedBox(height: 20),
          _buildSalesCard(),
        ],
      ),
    );
  }

  Widget _buildSensorDataCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Sensor Data', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 10),
            _buildSensorItem(Icons.water, 'Tank Level', '$_tankLevel%'),
            _buildSensorItem(Icons.science, 'pH Level', '$_phLevel'),
            _buildSensorItem(Icons.thermostat, 'Temperature', '$_temperature°C'),
            _buildSensorItem(Icons.water_drop, 'Humidity', '$_humidity%'),
          ],
        ),
      ),
    );
  }

  Widget _buildSensorItem(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon),
          const SizedBox(width: 10),
          Text(label),
          const Spacer(),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildWaterLevelsCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Water Levels', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildTankLevel('Tank 1', _tankLevels[0], Colors.blue[200]!, Colors.blue),
                _buildTankLevel('Tank 2', _tankLevels[1], Colors.green[200]!, Colors.green),
                _buildTankLevel('Tank 3', _tankLevels[2], Colors.orange[200]!, Colors.orange),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTankLevel(String label, double level, Color backgroundColor, Color foregroundColor) {
    return Column(
      children: [
        SizedBox(
          height: 100,
          width: 60,
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: backgroundColor,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: FractionallySizedBox(
                  heightFactor: level / 100,
                  child: Container(
                    decoration: BoxDecoration(
                      color: foregroundColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Text(label),
        Text('${level.toInt()}%', style: const TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildSalesCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Sales', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 10),
            _buildSalesItem(Icons.shopping_cart, 'Sales Made', '$_salesMade'),
            _buildSalesItem(Icons.attach_money, 'Revenue', '\$$_revenue'),
          ],
        ),
      ),
    );
  }

  Widget _buildSalesItem(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon),
          const SizedBox(width: 10),
          Text(label),
          const Spacer(),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildTankView(String tankName, double level) {
    return Column(
      children: [
        Text('$tankName Details', style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 20),
        _buildTankLevel(tankName, level, Colors.blue[200]!, Colors.blue),
        // Add more details specific to each tank here
      ],
    );
  }

  Widget _buildBottomNavBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        IconButton(
          icon: const Icon(Icons.home),
          onPressed: () => _changeView(AppView.overview),
          color: _currentView == AppView.overview ? Colors.blue : null,
        ),
        IconButton(icon: const Icon(Icons.bar_chart), onPressed: () {}),
        IconButton(icon: const Icon(Icons.location_on), onPressed: () {}),
        IconButton(icon: const Icon(Icons.settings), onPressed: () {}),
      ],
    );
  }
}

enum AppView { overview, tank1, tank2, tank3 }