import 'package:flutter_test/flutter_test.dart';
import 'package:reflexive/main.dart';
import 'package:reflexive/core/di/injection_container.dart' as di;
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    // Setup mock for SharedPreferences before DI initialization
    SharedPreferences.setMockInitialValues({});
    
    // Initialize dependency injection
    await di.init();

    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that the app title or a known widget exists
    // Using a slight delay to allow DI and initialization to complete in the test environment
    await tester.pumpAndSettle();
    
    expect(find.byType(MyApp), findsOneWidget);
  });
}
