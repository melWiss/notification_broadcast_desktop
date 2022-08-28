import 'package:flutter/material.dart';
import 'package:notification_broadcast_desktop/client/src/blocs/qr.dart';
import 'package:notification_broadcast_desktop/client/src/enums/qr.dart';
import 'package:notification_broadcast_desktop/client/src/models/qr.dart';
import 'package:qr_flutter/qr_flutter.dart';

class ClientWidget extends StatefulWidget {
  const ClientWidget({Key? key}) : super(key: key);

  @override
  State<ClientWidget> createState() => _ClientWidgetState();
}

class _ClientWidgetState extends State<ClientWidget> {
  QrBloc qrBloc = QrBloc();

  @override
  void initState() {
    // TODO: implement initState
    qrBloc.stream.listen((event) {
      if (event == QrState.generatePassword) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Generating new password..."),
          ),
        );
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QrState>(
        stream: qrBloc.stream,
        builder: (context, snapshot) {
          if (snapshot.data == null || snapshot.data == QrState.loading) {
            return const Center(
              child: SingleChildScrollView(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          }
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    height: 300,
                    width: 300,
                    child: QrImage(
                      data: qrBloc.state.encode(),
                    ),
                  ),
                ),
                Text(qrBloc.state.device ?? "DEVICE NAME"),
                Text(qrBloc.state.ip ?? "IP ADDRESS"),
                Text(qrBloc.state.pass ?? "PASSWORD"),
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: FloatingActionButton.extended(
                          backgroundColor: Colors.black,
                          onPressed: qrBloc.generate,
                          label: const Text("Generate"),
                          icon: const Icon(Icons.qr_code),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: FloatingActionButton.extended(
                          backgroundColor: Colors.black,
                          onPressed: qrBloc.generate,
                          label: const Text("Start"),
                          icon: const Icon(Icons.play_arrow),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
