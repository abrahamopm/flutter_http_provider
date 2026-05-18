import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_http_provider/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());
    
    // Verify that our rejuvenated app builds and renders root successfully.
    expect(find.byType(MyApp), findsOneWidget);
  });
}
