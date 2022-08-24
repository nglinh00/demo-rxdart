import 'dart:async';

import 'package:demo/loading/loading_screen_controller.dart';
import 'package:flutter/material.dart';

class LoadingScreen {
  // singleton
  LoadingScreen._sharedInstance();
  static final LoadingScreen _shared = LoadingScreen._sharedInstance();
  factory LoadingScreen.instance() => _shared;

  LoadingScreenController? controller;

  void show(BuildContext context, String text) {
    if (controller?.update(text) ?? false) {
      return;
    } else {
      controller = _showOverlay(context: context, text: text);
    }
  }

  void hide() {
    controller?.close();
    controller = null;
  }

  LoadingScreenController _showOverlay({
    required BuildContext context,
    required String text,
  }) {
    final _text = StreamController<String>();
    _text.add(text);

    final renderBox = context.findRenderObject() as RenderBox;
    final availableSize = renderBox.size;

    final overlay = OverlayEntry(
        builder: (context) => Material(
              color: Colors.black.withAlpha(150),
              child: Center(
                child: Container(
                  constraints: BoxConstraints(
                    maxWidth: availableSize.width * 0.8,
                    minWidth: availableSize.width * 0.5,
                    maxHeight: availableSize.height * 0.8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(height: 10.0),
                          const CircularProgressIndicator(),
                          const SizedBox(height: 10.0),
                          StreamBuilder<String>(
                            stream: _text.stream,
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return Text(
                                  snapshot.requireData,
                                  textAlign: TextAlign.center,
                                );
                              } else {
                                return const SizedBox.shrink();
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ));

    final state = Overlay.of(context);
    state?.insert(overlay);

    return LoadingScreenController(close: () {
      _text.close();
      overlay.remove();
      return true;
    }, update: (text) {
      _text.add(text);
      return true;
    });
  }
}
