import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:video_player_win/video_player_win_method_channel.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const channel = MethodChannel('video_player_win');
  final calls = <MethodCall>[];

  setUp(() {
    calls.clear();
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (MethodCall call) async {
      calls.add(call);
      return true;
    });
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });

  test('seekTo passes the playAfterSeek flag', () async {
    final platform = MethodChannelVideoPlayerWin();

    await platform.seekTo(42, 1500);
    await platform.seekTo(42, 0, playAfterSeek: true);

    final seeks = calls.where((call) => call.method == 'seekTo').toList();
    expect(seeks, hasLength(2));
    expect(seeks[0].arguments['ms'], 1500);
    expect(seeks[0].arguments['playAfterSeek'], isFalse);
    expect(seeks[1].arguments['ms'], 0);
    expect(seeks[1].arguments['playAfterSeek'], isTrue);
  });
}
