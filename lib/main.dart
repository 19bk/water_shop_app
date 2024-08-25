import 'package:flutter/material.dart';

void main() {
  runApp(const WaterShopApp());
}

class WaterShopApp extends StatelessWidget {
  const WaterShopApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Clean Water Shop',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
        fontFamily: 'Roboto',
      ),
      home: const WaterShopHomePage(),
    );
  }
}

class WaterShopHomePage extends StatefulWidget {
  const WaterShopHomePage({super.key});

  @override
  State<WaterShopHomePage> createState() => _WaterShopHomePageState();
}

class _WaterShopHomePageState extends State<WaterShopHomePage> {
  double _tankCapacity = 1000.0; // Liters
  double _currentWaterLevel = 800.0; // Liters
  int _totalSales = 0; // Liters
  double _totalRevenue = 0.0; // Kenyan Shillings
  double _pricePerLiter = 5.0; // Kenyan Shillings
  AppView _currentView = AppView.overview;

  void _sellWater(double amount) {
    setState(() {
      if (_currentWaterLevel >= amount) {
        _currentWaterLevel -= amount;
        _totalSales += amount.toInt();
        _totalRevenue += amount * _pricePerLiter;
      }
      _checkWaterLevel();
    });
  }

  void _checkWaterLevel() {
    if (_currentWaterLevel / _tankCapacity <= 0.2) {
      _refillTank();
    }
  }

  void _refillTank() {
    setState(() {
      _currentWaterLevel = _tankCapacity;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Tank refilled!')),
    );
  }

  void _changeView(AppView view) {
    setState(() {
      _currentView = view;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
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
          'Good morning!',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        IconButton(
          icon: const Icon(Icons.notifications_outlined),
          onPressed: () {},
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
        return _buildTankView('Tank 1');
      case AppView.tank2:
        return _buildTankView('Tank 2');
      case AppView.tank3:
        return _buildTankView('Tank 3');
    }
  }

  Widget _buildOverviewView() {
    return Column(
      children: [
        _buildWeatherCard(),
        const SizedBox(height: 20),
        _buildWaterLevelsCard(),
      ],
    );
  }

  Widget _buildTankView(String tankName) {
    return Column(
      children: [
        Text('$tankName Details', style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 20),
        _buildTankLevel(tankName, 0.6, Colors.blue[200]!, Colors.blue),
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

  Widget _buildWeatherCard() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Weather', style: Theme.of(context).textTheme.titleMedium),
                Row(
                  children: [
                    const Icon(Icons.cloud, color: Colors.blue),
                    const SizedBox(width: 8),
                    Text('+25°C', style: Theme.of(context).textTheme.titleMedium),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildWeatherItem(Icons.thermostat, '22°C', 'Water temp'),
                _buildWeatherItem(Icons.water_drop, '59%', 'Humidity'),
                _buildWeatherItem(Icons.air, '6 m/s', 'Wind'),
                _buildWeatherItem(Icons.umbrella, '0 mm', 'Precipitation'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeatherItem(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, color: Colors.blue),
        const SizedBox(height: 8),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        Text(label, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
      ],
    );
  }

  Widget _buildWaterLevelsCard() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Water Levels', style: Theme.of(context).textTheme.titleMedium),
                OutlinedButton(
                  onPressed: () {},
                  child: const Text('Today'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildTankLevel('Tank 1', 0.3, Colors.red[200]!, Colors.red),
                _buildTankLevel('Tank 2', 0.6, Colors.green[200]!, Colors.green),
                _buildTankLevel('Tank 3', 0.9, Colors.blue[200]!, Colors.blue),
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
                  heightFactor: level,
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
        Text('${(level * 100).toInt()}%', style: const TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }
}