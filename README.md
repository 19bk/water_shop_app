# Water Shop App

## Description

The Water Shop App is a Flutter-based mobile application designed to manage and streamline operations for a water distribution business. It provides features for monitoring water tank levels, processing sales, and viewing sales statistics.

## Features

- **Dashboard Overview**: View current water levels in multiple tanks at a glance.
- **Sales Processing**: Easily process new sales, including options for refillable bottles and different water volumes.
- **M-Pesa Integration**: Seamless integration with M-Pesa for mobile payments.
- **Sales Statistics**: Comprehensive sales data visualization with customizable time periods.
- **Dark Mode Support**: Fully responsive UI that adapts to both light and dark modes.

## Installation

1. Ensure you have Flutter installed on your machine. For installation instructions, see [Flutter's official documentation](https://flutter.dev/docs/get-started/install).

2. Clone the repository:
   ```
   git clone https://github.com/yourusername/water-shop-app.git
   ```

3. Navigate to the project directory:
   ```
   cd water-shop-app
   ```

4. Install dependencies:
   ```
   flutter pub get
   ```

5. Run the app:
   ```
   flutter run
   ```

## Dependencies

- flutter: ^2.5.0
- intl: ^0.17.0

For a full list of dependencies, see the `pubspec.yaml` file.

## Configuration

### M-Pesa Integration

To configure M-Pesa integration:

1. Obtain API credentials from Safaricom Developer Portal.
2. Add your credentials to the `lib/config/mpesa_config.dart` file (create if it doesn't exist):

'''
class MpesaConfig {
static const String consumerKey = 'YOUR_CONSUMER_KEY';
static const String consumerSecret = 'YOUR_CONSUMER_SECRET';
// Add other necessary configuration variables
}
'''

## Usage

1. **Dashboard**: Upon launching the app, you'll see the main dashboard with tank levels and quick access to sales and statistics.

2. **Process a Sale**:
   - Tap the 'New Sale' button.
   - Select whether the customer has a refillable bottle.
   - Choose the water volume.
   - Enter the customer's M-Pesa number.
   - Confirm the payment.

3. **View Statistics**:
   - Navigate to the Statistics tab.
   - Use the dropdown to select a time period.
   - View total revenue, total liters sold, and individual sale details.

## Contributing

We welcome contributions to the Water Shop App! Please follow these steps to contribute:

1. Fork the repository.
2. Create a new branch: `git checkout -b feature-branch-name`.
3. Make your changes and commit them: `git commit -m 'Add some feature'`.
4. Push to the branch: `git push origin feature-branch-name`.
5. Submit a pull request.

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details.

## Contact

For any queries or support, please contact:

Your Name - email@example.com

Project Link: https://github.com/yourusername/water-shop-app

## Acknowledgments

- Flutter team for the excellent framework
- Safaricom for M-Pesa API integration
- All contributors who have helped shape this project