import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:esc_pos_utils_plus/esc_pos_utils_plus.dart';

void main() {
  FlutterBluePlus.setLogLevel(LogLevel.verbose, color: true);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  BluetoothAdapterState _adapterState = BluetoothAdapterState.unknown;
  late StreamSubscription<BluetoothAdapterState> _adapterSub;

  @override
  void initState() {
    super.initState();
    _adapterSub = FlutterBluePlus.adapterState.listen((state) {
      _adapterState = state;
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _adapterSub.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget screen = _adapterState == BluetoothAdapterState.on
        ? const ScanScreen()
        : BluetoothOffScreen(adapterState: _adapterState);

    return MaterialApp(debugShowCheckedModeBanner: false, home: screen);
  }
}

class BluetoothOffScreen extends StatelessWidget {
  final BluetoothAdapterState adapterState;
  const BluetoothOffScreen({super.key, required this.adapterState});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'Bluetooth ${adapterState.name}',
          style: const TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}

class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key});

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  List<BluetoothDevice> devices = [];

  void startScan() async {
    devices.clear();
    setState(() {});
    FlutterBluePlus.startScan(timeout: const Duration(seconds: 5));
    FlutterBluePlus.scanResults.listen((results) {
      for (var r in results) {
        if (!devices.any((d) => d.remoteId == r.device.remoteId)) {
          setState(() => devices.add(r.device));
        }
      }
    });
    await Future.delayed(const Duration(seconds: 5));
    await FlutterBluePlus.stopScan();
  }

  @override
  void initState() {
    super.initState();
    startScan();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Scan BLE Devices')),
      body: ListView.builder(
        itemCount: devices.length,
        itemBuilder: (context, index) {
          final d = devices[index];
          return ListTile(
            title: Text(d.name.isEmpty ? d.remoteId.id : d.name),
            subtitle: Text(d.remoteId.id),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => DeviceScreen(device: d)),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.refresh),
        onPressed: startScan,
      ),
    );
  }
}

class DeviceScreen extends StatefulWidget {
  final BluetoothDevice device;
  const DeviceScreen({super.key, required this.device});

  @override
  State<DeviceScreen> createState() => _DeviceScreenState();
}

class _DeviceScreenState extends State<DeviceScreen> {
  BluetoothCharacteristic? writeChar;
  bool connected = false;

  @override
  void initState() {
    super.initState();
    connectDevice();
  }

  Future<void> connectDevice() async {
    try {
      await widget.device.connect(autoConnect: false);

      // Khám phá services
      List<BluetoothService> services = await widget.device.discoverServices();
      BluetoothCharacteristic? writeChar;
      BluetoothCharacteristic? statusChar;

      for (var s in services) {
        for (var c in s.characteristics) {
          // Characteristic để gửi lệnh in
          if (c.properties.write || c.properties.writeWithoutResponse) {
            writeChar = c;
          }
          // Characteristic để đọc status hoặc device info
          if (c.properties.read || c.properties.notify) {
            statusChar = c;
          }
        }
      }
      List<int> deviceInfoCmd = [0x1D, 0x49, 0x01];
      await writeChar!.write(deviceInfoCmd, withoutResponse: true);

      if (statusChar != null) {}

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('✅ Connected to ${widget.device.name}')),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('❌ Connect error: $e')));
    }
  }

  Future<void> printDemo() async {
    if (writeChar == null) {
      print("Lỗi write : ${writeChar}");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('⚠️ Cannot find write characteristic')),
      );
      return;
    }

    final profile = await CapabilityProfile.load();
    final generator = Generator(PaperSize.mm80, profile);

    List<int> bytes = [];
    bytes += generator.text(
      'DEMO RECEIPT',
      styles: PosStyles(bold: true, align: PosAlign.center),
      linesAfter: 1,
    );
    bytes += generator.text(
      "HM-AU200U",
      styles: PosStyles(bold: true, align: PosAlign.center),
      linesAfter: 1,
    );

    bytes += generator.cut();

    await writeChar!.write(bytes, withoutResponse: true);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('✅ Print command sent')));
  }

  Future<void> disconnectDevice() async {
    try {
      await widget.device.disconnect();
      setState(() => connected = false);
      writeChar = null;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('✅ Bluetooth đã ngắt kết nối')),
      );
      Navigator.pop(context); // trở về màn hình scan
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('❌ Lỗi khi ngắt kết nối: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.device.name.isEmpty
              ? widget.device.remoteId.id
              : widget.device.name,
        ),
      ),
      body: Center(
        child: connected
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: printDemo,
                    child: const Text('In thử hóa đơn'),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: disconnectDevice,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                    child: const Text('Ngắt kết nối Bluetooth'),
                  ),
                ],
              )
            : const CircularProgressIndicator(),
      ),
    );
  }
}
