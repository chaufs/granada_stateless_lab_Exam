import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stateless_lab_exam/main.dart';
import 'package:stateless_lab_exam/shopping_cart_page.dart';

void main() {
  testWidgets('ShoppingCartPage renders all required sections and items',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    // 1. AppBar
    expect(find.text('My Cart'), findsOneWidget);
    expect(find.byIcon(Icons.arrow_back), findsOneWidget);
    expect(find.byIcon(Icons.shopping_bag_outlined), findsOneWidget);
    expect(find.text('3'), findsAtLeastNWidgets(1));

    // 2. Intro Section
    expect(find.text('CAMPUS STORE'), findsOneWidget);
    expect(find.text('Ready for checkout'), findsOneWidget);
    expect(
      find.text('Review your items before placing your order.'),
      findsOneWidget,
    );

    // 3. Delivery Card
    expect(find.textContaining('Deliver to'), findsOneWidget);
    expect(find.text('Matina, Davao City'), findsOneWidget);
    expect(find.text('Change'), findsOneWidget);

    // 4. Order Items
    expect(find.text('Order Items'), findsOneWidget);
    expect(find.text('3 items'), findsOneWidget);
    expect(find.byType(CartItemCard), findsNWidgets(3));
    expect(find.text('Wireless Mouse'), findsOneWidget);
    expect(find.text('USB-C Hub'), findsOneWidget);
    expect(find.text('Laptop Stand'), findsOneWidget);

    // 5. Discount Banner
    expect(find.text('STUDENT10 applied'), findsOneWidget);
    expect(find.text('10% discount on items'), findsOneWidget);

    // 6. Payment Summary
    expect(find.text('Payment Summary'), findsOneWidget);
    expect(find.text('Subtotal'), findsOneWidget);
    expect(find.text('PHP 2,000.00'), findsOneWidget);
    expect(find.text('Discount (10%)'), findsOneWidget);
    expect(find.text('- PHP 200.00'), findsOneWidget);
    expect(find.text('Delivery Fee'), findsOneWidget);
    expect(find.text('PHP 50.00'), findsOneWidget);
    expect(find.text('Total'), findsOneWidget);
    expect(find.text('PHP 1,850.00'), findsOneWidget);

    // 7. Place Order Button
    expect(find.text('Place Order'), findsOneWidget);
  });

  testWidgets('Button callbacks test', (WidgetTester tester) async {
    final List<String> logs = [];

    // Capture debugPrint logs
    final originalDebugPrint = debugPrint;
    debugPrint = (String? message, {int? wrapWidth}) {
      if (message != null) logs.add(message);
    };

    await tester.pumpWidget(const MyApp());

    // Back button
    await tester.tap(find.byIcon(Icons.arrow_back));
    expect(logs.contains('Back clicked'), isTrue);

    // Cart button
    await tester.tap(find.byIcon(Icons.shopping_bag_outlined));
    expect(logs.contains('Cart clicked'), isTrue);

    // Change button
    await tester.tap(find.text('Change'));
    expect(logs.contains('Change delivery address clicked'), isTrue);

    // Delete first item
    await tester.tap(find.byIcon(Icons.delete_outline).first);
    expect(logs.contains('Remove item: Wireless Mouse'), isTrue);

    // Minus first item
    await tester.tap(find.byIcon(Icons.remove).first);
    expect(logs.contains('Decrease quantity: Wireless Mouse'), isTrue);

    // Plus first item
    await tester.tap(find.byIcon(Icons.add).first);
    expect(logs.contains('Increase quantity: Wireless Mouse'), isTrue);

    // Place order
    await tester.ensureVisible(find.text('Place Order'));
    await tester.tap(find.text('Place Order'));
    expect(logs.contains('Place order clicked! Total: PHP 1850.00'), isTrue);

    debugPrint = originalDebugPrint;
  });
}
