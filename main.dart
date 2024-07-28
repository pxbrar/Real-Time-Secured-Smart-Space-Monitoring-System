import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:bus/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'BUS Project',
    home: LoginPage(),
  ));
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  //credentials
  final String _validEmail = 'n01402350@humber.ca';
  final String _validPassword = '1234';

  void _login() {
    String enteredEmail = _emailController.text;
    String enteredPassword = _passwordController.text;

    // Check if entered credentials match hardcoded ones
    if (enteredEmail == _validEmail && enteredPassword == _validPassword) {
      // Navigate to the home page if credentials are valid
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    } else {
      //AlertDialog for wrong credentials
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Login Failed'),
            content: const Text('You Are Not Authorized'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Welcome, Login to Your Account',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 50), 
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start, 
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'assets/humberLogo.png',
              height: 300,
              width: 300,
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                filled: true,
                fillColor: Colors.white.withOpacity(0.5),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
                filled: true,
                fillColor: Colors.white.withOpacity(0.5),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _login,
              child: const Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});
   static const Map<String, String> roomImages = {
    'Room 1': 'assets/J207.jpg',
    'Room 2': 'assets/J201.jpg',
    'Room 3': 'assets/J202.jpg',
    'Room 4': 'assets/J212.jpg',
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Humber J Building - 2nd Floor',
          style: TextStyle(letterSpacing: 2, color: Colors.white, fontSize: 30),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 4,
        backgroundColor: const Color.fromRGBO(0, 39, 93, 1),
        shadowColor: Colors.white,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const UserAccountsDrawerHeader(
              accountName: Text('Prabhdeep Brar'),
              accountEmail: Text('n01402350@humber.ca'),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(
                  Icons.person,
                  size: 48.0,
                  color: Colors.blue,
                ),
              ),
              decoration: BoxDecoration(
                color: Color.fromRGBO(0, 39, 93, 1),
              ),
            ),
            ListTile(
              title: const Text('Settings'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Logout'),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                );
              },
            ),
          ],
        ),
      ),
      body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 200,
                        height: 100,
                        child: RoomButton(
                          roomName: 'Room 1',
                          sensorData: SensorDataView(),
                        ),
                      ),
                      SizedBox(height: 20),
                      SizedBox(
                        width: 200,
                        height: 100,
                        child: RoomButton(
                          roomName: 'Room 2',
                          sensorData: SensorDataView(),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 200, 
                        height: 100,
                        child: RoomButton(
                          roomName: 'Room 3',
                          sensorData: HardcodedSensorDataView(),
                        ),
                      ),
                      SizedBox(height: 20),
                      SizedBox(
                        width: 200,
                        height: 100,
                        child: RoomButton(
                          roomName: 'Room 4',
                          sensorData: HardcodedSensorDataView(),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
            Image.asset('assets/humberj.jpg', width: 400),
            const SizedBox(height: 50),
            Image.asset('assets/humberLogo.png', width: 300),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}

class RoomButton extends StatelessWidget {
  final String roomName;
  final Widget sensorData;

  const RoomButton({super.key, required this.roomName, required this.sensorData});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        final snackBar = SnackBar(
          content: Text('Entering $roomName'),
          duration: const Duration(seconds: 2),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RoomPage(
              roomName: roomName,
              sensorData: sensorData,
              //image path from the map using room name
              roomImage: HomePage.roomImages[roomName] ?? '',
            ),
          ),
        );
      },
      child: Text(roomName),
    );
  }
}

class RoomPage extends StatelessWidget {
  final String roomName;
  final Widget sensorData;
  final String roomImage;

  const RoomPage({super.key, required this.roomName, required this.sensorData, required this.roomImage});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(roomName, style: const TextStyle(color: Colors.white)),
        backgroundColor: const Color.fromRGBO(0, 39, 93, 1),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
            const snackBar = SnackBar(
              content: Text('Going back to Home'),
              duration: Duration(seconds: 2),
            );
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          },
        ),
      ),
      body: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            const TabBar(
              tabs: [
                Tab(text: 'Sensor Data'),
                Tab(text: 'Room Image'),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  sensorData,
                  Center(
                    child: Image.asset(roomImage),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SensorData {
  final double? pressure;
  final int? count;
  final double? humidity;
  final double? temperature;
  final double? oxygen;

  SensorData({
    this.pressure,
    this.count,
    this.humidity,
    this.temperature,
    this.oxygen,
  });
}

class SensorDataView extends StatefulWidget {
  const SensorDataView({super.key});

  @override
  State<SensorDataView> createState() => _SensorDataViewState();
}

class _SensorDataViewState extends State<SensorDataView> {
  SensorData? _sensorData;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeDataListener();
  }

  void _initializeDataListener() {
    final ref = FirebaseDatabase.instance.ref("sensorData");

    ref.onValue.listen((event) {
      final snapshot = event.snapshot;
      if (snapshot.exists) {
        final data = snapshot.value as Map<dynamic, dynamic>;
        final pressure = data["pressure"] as double?;
        final count = data["count"] as int?;
        final humidity = data["humidity"] as double?;
        final temperature = data["temperature"] as double?;
        final oxygenConcentration = data["OxygenConcentration"] as double?;

        setState(() {
          _sensorData = SensorData(
            pressure: pressure,
            count: count,
            humidity: humidity,
            temperature: temperature,
            oxygen: oxygenConcentration,
          );
          _isLoading = false;
        });
      } else {
        log("No sensor data found!");
        setState(() {
          _isLoading = false;
        });
      }
    }, onError: (error) {
      log("Error getting sensor data: $error");
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: _isLoading ? 0.5 : 1.0,
      duration: const Duration(milliseconds: 500),
      child: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              padding: const EdgeInsets.all(20),
              children: [
                _buildSensorDataItem(
                  title: 'Pressure',
                  value: _sensorData?.pressure?.toStringAsFixed(2) ?? 'N/A',
                  unit: 'hPa',
                  color: Colors.blue,
                  iconData: Icons.bar_chart,
                ),
                _buildSensorDataItem(
                  title: 'Occupancy',
                  value: _sensorData?.count?.toString() ?? 'N/A',
                  unit: 'People',
                  color: Colors.orange,
                  iconData: Icons.people,
                ),
                _buildSensorDataItem(
                  title: 'Temperature',
                  value: _sensorData?.temperature?.toString() ?? 'N/A',
                  unit: '°C',
                  color: Colors.red,
                  iconData: Icons.thermostat,
                ),
                _buildSensorDataItem(
                  title: 'Humidity',
                  value: _sensorData?.humidity?.toString() ?? 'N/A',
                  unit: '%',
                  color: Colors.green,
                  iconData: Icons.water_damage,
                ),
                _buildSensorDataItem(
                  title: 'Oxygen Concentration',
                  value: _sensorData?.oxygen?.toString() ?? 'N/A',
                  unit: '%Vol',
                  color: Colors.purple,
                  iconData: Icons.waves,
                ),
              ],
            ),
    );
  }

 Widget _buildSensorDataItem({
  required String title,
  required String value,
  required String unit,
  required Color color,
  required IconData iconData,
}) {
  return AnimatedContainer(
    duration: const Duration(milliseconds: 500),
    curve: Curves.easeInOut,
    padding: const EdgeInsets.all(10),
    decoration: BoxDecoration(
      color: color.withOpacity(0.5),
      borderRadius: BorderRadius.circular(10),
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          iconData,
          color: Colors.white,
          size: 70,
        ),
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          '$value $unit',
          style: const TextStyle(
            fontSize: 16,
          ),
        ),
      ],
    ),
  );
}
}

class HardcodedSensorDataView extends StatelessWidget {
  const HardcodedSensorDataView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Pressure: 1000 hPa',
            style: TextStyle(fontSize: 18),
          ),
          SizedBox(height: 10),
          Text(
            'Occupancy: 10 People',
            style: TextStyle(fontSize: 18),
          ),
          SizedBox(height: 10),
          Text(
            'Temperature: 25 °C',
            style: TextStyle(fontSize: 18),
          ),
          SizedBox(height: 10),
          Text(
            'Humidity: 50 %',
            style: TextStyle(fontSize: 18),
          ),
          SizedBox(height: 10),
          Text(
            'Oxygen Concentration: 20 %Vol',
            style: TextStyle(fontSize: 18),
          ),
        ],
      ),
    );
  }
}