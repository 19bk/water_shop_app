import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

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
      case AppView.sale:
        return _buildSalePage();
      case AppView.statistics:
        return const StatisticsPage();
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

  Widget _buildSalePage() {
    return SalePage(onSaleComplete: () {
      // Handle sale completion (e.g., update sales data, return to overview)
      _changeView(AppView.overview);
    });
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
        IconButton(
          icon: const Icon(Icons.shopping_cart),
          onPressed: () => _changeView(AppView.sale),
          color: _currentView == AppView.sale ? Colors.blue : null,
        ),
        IconButton(
          icon: const Icon(Icons.bar_chart),
          onPressed: () => _changeView(AppView.statistics),
          color: _currentView == AppView.statistics ? Colors.blue : null,
        ),
        IconButton(icon: const Icon(Icons.settings), onPressed: () {}),
      ],
    );
  }
}

enum AppView { overview, tank1, tank2, tank3, sale, statistics }

class SalePage extends StatefulWidget {
  final VoidCallback onSaleComplete;

  const SalePage({Key? key, required this.onSaleComplete}) : super(key: key);

  @override
  _SalePageState createState() => _SalePageState();
}

class _SalePageState extends State<SalePage> {
  bool _hasBottle = false;
  int _selectedVolume = 0;
  String _mpesaNumber = '';
  bool _isProcessing = false;

  final List<int> _availableVolumes = [5, 10, 20];

  double get _subtotal {
    double bottlePrice = _hasBottle ? 0 : 50;
    double waterPrice = _selectedVolume * 10; // Assuming 10 KES per liter
    return bottlePrice + waterPrice;
  }

  double get _vat => _subtotal * 0.16; // 16% VAT
  double get _total => _subtotal + _vat;

  void _initiatePayment() {
    setState(() {
      _isProcessing = true;
    });
    // Simulate payment processing
    Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        _isProcessing = false;
      });
      // Show success message and return to overview
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Payment successful!')),
      );
      widget.onSaleComplete();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('New Sale'),
        backgroundColor: theme.appBarTheme.backgroundColor,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Complete the sale by providing the following details',
                style: theme.textTheme.bodyMedium?.copyWith(color: theme.hintColor),
              ),
              const SizedBox(height: 20),
              Text('Does the customer have a refillable bottle?', style: theme.textTheme.titleMedium),
              const SizedBox(height: 10),
              _buildToggleButtons(theme),
              const SizedBox(height: 20),
              Text('Select volume:', style: theme.textTheme.titleMedium),
              const SizedBox(height: 10),
              _buildVolumeSelection(theme),
              const SizedBox(height: 20),
              _buildTextField('M-Pesa Number', TextInputType.phone, (value) => setState(() => _mpesaNumber = value), theme),
              const SizedBox(height: 20),
              _buildPriceRow('Subtotal', _subtotal, theme),
              _buildPriceRow('VAT (16%)', _vat, theme),
              Divider(color: theme.dividerColor),
              _buildPriceRow('Total', _total, theme, isTotal: true),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: (_selectedVolume > 0 && _mpesaNumber.isNotEmpty && !_isProcessing)
                      ? _initiatePayment
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary,
                    foregroundColor: theme.colorScheme.onPrimary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: _isProcessing
                      ? CircularProgressIndicator(color: theme.colorScheme.onPrimary)
                      : Text('Pay ${_total.toStringAsFixed(2)} KES'),
                ),
              ),
              const SizedBox(height: 10),
              Center(
                child: Text(
                  'Payments are processed securely via M-Pesa',
                  style: theme.textTheme.bodySmall?.copyWith(color: theme.hintColor),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildToggleButtons(ThemeData theme) {
    return Container(
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildToggleButton('Yes', _hasBottle, () => setState(() => _hasBottle = true), theme),
          ),
          Expanded(
            child: _buildToggleButton('No', !_hasBottle, () => setState(() => _hasBottle = false), theme),
          ),
        ],
      ),
    );
  }

  Widget _buildToggleButton(String text, bool isSelected, VoidCallback onPressed, ThemeData theme) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected ? theme.colorScheme.primary : Colors.transparent,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: Text(text, style: TextStyle(color: isSelected ? theme.colorScheme.onPrimary : theme.hintColor)),
    );
  }

  Widget _buildVolumeSelection(ThemeData theme) {
    return Wrap(
      spacing: 10,
      children: _availableVolumes.map((volume) {
        return ElevatedButton(
          onPressed: () => setState(() => _selectedVolume = volume),
          style: ElevatedButton.styleFrom(
            backgroundColor: _selectedVolume == volume ? theme.colorScheme.primary : theme.cardColor,
            foregroundColor: _selectedVolume == volume ? theme.colorScheme.onPrimary : theme.hintColor,
          ),
          child: Text('$volume L'),
        );
      }).toList(),
    );
  }

  Widget _buildTextField(String label, TextInputType keyboardType, Function(String) onChanged, ThemeData theme) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: theme.hintColor),
        filled: true,
        fillColor: theme.inputDecorationTheme.fillColor ?? theme.cardColor,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
      ),
      style: theme.textTheme.bodyLarge,
      keyboardType: keyboardType,
      onChanged: onChanged,
    );
  }

  Widget _buildPriceRow(String label, double amount, ThemeData theme, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: isTotal ? theme.textTheme.titleMedium : theme.textTheme.bodyMedium),
          Text(
            '${amount.toStringAsFixed(2)} KES',
            style: isTotal 
                ? theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)
                : theme.textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}

class StatisticsPage extends StatefulWidget {
  const StatisticsPage({Key? key}) : super(key: key);

  @override
  _StatisticsPageState createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage> {
  String _selectedPeriod = 'This Week';
  final List<String> _periods = ['Today', 'This Week', 'This Month', 'This Year', 'All Time'];

  // Use a ValueNotifier to avoid unnecessary rebuilds
  final ValueNotifier<List<Sale>> _filteredSales = ValueNotifier<List<Sale>>([]);

  // Dummy data for demonstration
  final List<Sale> _allSales = [
    Sale(DateTime.now().subtract(Duration(days: 1)), 20, 200),
    Sale(DateTime.now().subtract(Duration(days: 2)), 15, 150),
    Sale(DateTime.now().subtract(Duration(days: 5)), 30, 300),
    Sale(DateTime.now().subtract(Duration(days: 10)), 25, 250),
    Sale(DateTime.now().subtract(Duration(days: 20)), 40, 400),
    Sale(DateTime.now().subtract(Duration(days: 40)), 35, 350),
  ];

  @override
  void initState() {
    super.initState();
    _updateFilteredSales();
  }

  void _updateFilteredSales() {
    final now = DateTime.now();
    _filteredSales.value = _allSales.where((sale) {
      switch (_selectedPeriod) {
        case 'Today':
          return sale.date.isAfter(DateTime(now.year, now.month, now.day));
        case 'This Week':
          return sale.date.isAfter(now.subtract(Duration(days: 7)));
        case 'This Month':
          return sale.date.isAfter(DateTime(now.year, now.month, 1));
        case 'This Year':
          return sale.date.isAfter(DateTime(now.year, 1, 1));
        case 'All Time':
        default:
          return true;
      }
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sales Statistics'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: DropdownButton<String>(
              value: _selectedPeriod,
              items: _periods.map((String period) {
                return DropdownMenuItem<String>(
                  value: period,
                  child: Text(period),
                );
              }).toList(),
              onChanged: (String? newValue) {
                if (newValue != null && newValue != _selectedPeriod) {
                  setState(() {
                    _selectedPeriod = newValue;
                    _updateFilteredSales();
                  });
                }
              },
            ),
          ),
          ValueListenableBuilder<List<Sale>>(
            valueListenable: _filteredSales,
            builder: (context, sales, child) {
              double totalRevenue = sales.fold(0, (sum, sale) => sum + sale.revenue);
              int totalLiters = sales.fold(0, (sum, sale) => sum + sale.liters);
              return _buildSummaryCards(totalRevenue, totalLiters);
            },
          ),
          Expanded(
            child: ValueListenableBuilder<List<Sale>>(
              valueListenable: _filteredSales,
              builder: (context, sales, child) {
                return ListView.builder(
                  itemCount: sales.length,
                  itemBuilder: (context, index) {
                    final sale = sales[index];
                    return ListTile(
                      title: Text('${sale.liters} Liters'),
                      subtitle: Text(DateFormat('yyyy-MM-dd').format(sale.date)),
                      trailing: Text('${sale.revenue} KES'),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCards(double totalRevenue, int totalLiters) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Expanded(
            child: _buildSummaryCard('Total Revenue', '$totalRevenue KES', Icons.monetization_on),
          ),
          SizedBox(width: 16),
          Expanded(
            child: _buildSummaryCard('Total Liters', '$totalLiters L', Icons.water_drop),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(String title, String value, IconData icon) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Icon(icon, size: 32),
            SizedBox(height: 8),
            Text(title, style: Theme.of(context).textTheme.titleSmall),
            SizedBox(height: 4),
            Text(value, style: Theme.of(context).textTheme.headlineSmall),
          ],
        ),
      ),
    );
  }
}

class Sale {
  final DateTime date;
  final int liters;
  final double revenue;

  Sale(this.date, this.liters, this.revenue);
}