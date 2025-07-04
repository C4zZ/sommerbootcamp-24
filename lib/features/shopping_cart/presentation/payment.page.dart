import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/presentation/widgets/app_dialog.dart' show AppDialog;

import '../../product_selection/shared.dart';
import '../shared.dart';

enum PaymentMethod { sepa, paypal, klarna }

/// PaymentPage
class PaymentPage extends ConsumerStatefulWidget {
  const PaymentPage({super.key});

  @override
  ConsumerState<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends ConsumerState<PaymentPage> {
  final GlobalKey<FormState> _formState = GlobalKey<FormState>();
  final TextEditingController _strasseTextController = TextEditingController();
  final TextEditingController _hausnummerTextController =
      TextEditingController();
  final TextEditingController _stadtTextController = TextEditingController();
  final TextEditingController _postleitzahlTextController =
      TextEditingController();

  PaymentMethod? _paymentMethod;

  final double _verticalPaddingLarge = 16;
  final double _verticalPaddingSmall = 8;

  bool isPaymentProcessing = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Kasse'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: _productForm(textTheme),
        ),
      ),
    );
  }

  Widget _productForm(TextTheme textTheme) {
    return Form(
      key: _formState,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: _verticalPaddingLarge,
          ),

          // Straße
          SizedBox(
            height: _verticalPaddingLarge,
          ),
          Text(
            'Straße',
            style: textTheme.labelLarge,
          ),
          SizedBox(
            height: _verticalPaddingSmall,
          ),
          TextFormField(
            controller: _strasseTextController,
            decoration: const InputDecoration(
              hintText: 'Straße',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(5),
                ),
              ),
            ),
            validator: _requiredValidator,
          ),

          // Hausnummer
          SizedBox(
            height: _verticalPaddingLarge,
          ),
          Text(
            'Hausnummer',
            style: textTheme.labelLarge,
          ),
          SizedBox(
            height: _verticalPaddingSmall,
          ),
          TextFormField(
            controller: _hausnummerTextController,
            decoration: const InputDecoration(
              hintText: 'Hausnummer',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(5),
                ),
              ),
            ),
            validator: _requiredValidator,
          ),

          // Stadt
          SizedBox(
            height: _verticalPaddingLarge,
          ),
          Text(
            'Stadt',
            style: textTheme.labelLarge,
          ),
          SizedBox(
            height: _verticalPaddingSmall,
          ),
          TextFormField(
            controller: _stadtTextController,
            decoration: const InputDecoration(
              hintText: 'Stadt',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(5),
                ),
              ),
            ),
            validator: _requiredValidator,
          ),

          // Postleitzahl
          SizedBox(
            height: _verticalPaddingLarge,
          ),
          Text(
            'Postleitzahl',
            style: textTheme.labelLarge,
          ),
          SizedBox(
            height: _verticalPaddingSmall,
          ),
          TextFormField(
            controller: _postleitzahlTextController,
            decoration: const InputDecoration(
              hintText: 'Postleitzahl',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(5),
                ),
              ),
            ),
            validator: _requiredValidator,
          ),

          Column(
            children: <Widget>[
              ListTile(
                title: const Text('SEPA'),
                leading: Radio<PaymentMethod>(
                  value: PaymentMethod.sepa,
                  groupValue: _paymentMethod,
                  onChanged: (PaymentMethod? value) {
                    setState(() {
                      _paymentMethod = value;
                    });
                  },
                ),
              ),
              ListTile(
                title: const Text('PayPal'),
                leading: Radio<PaymentMethod>(
                  value: PaymentMethod.paypal,
                  groupValue: _paymentMethod,
                  onChanged: (PaymentMethod? value) {
                    setState(() {
                      _paymentMethod = value;
                    });
                  },
                ),
              ),
              ListTile(
                title: const Text('Klarna'),
                leading: Radio<PaymentMethod>(
                  value: PaymentMethod.klarna,
                  groupValue: _paymentMethod,
                  onChanged: (PaymentMethod? value) {
                    setState(() {
                      _paymentMethod = value;
                    });
                  },
                ),
              ),
            ],
          ),

          const Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton(
                onPressed: () => _submit(context),
                child: Row(
                  children: [
                    if (isPaymentProcessing)
                      const SizedBox(
                        width: 10,
                        height: 10,
                        child: CircularProgressIndicator.adaptive(),
                      )
                    else
                      const Icon(Icons.add_shopping_cart),
                    const SizedBox(
                      width: 10,
                    ),
                    const Text('Bestellung aufgeben'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String? _requiredValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Bitte fülle dieses Feld aus';
    }
    return null;
  }

  Future<void> _submit(BuildContext context) async {

    // TODO(team): Validiere das Form. Falls der Nutzer vergessen hat etwas
    //  einzugeben

    // TODO(team): Prüfe ob der Nutzer eine Bezahlmethode ausgewählt hat. Wenn
    //  er keine Bezahlmethode ausgewählt hat, dann darf er keine Bestellung
    //  aufgeben. Zusätzlich soll ein Dialog angezeigt werden, der den Nutzer
    //  darauf hinweist, dass er keine Bezahlmethode angegeben hat. Schaue dir
    //  hierzu die Klasse lib/features/core/presentation/widgets/app_dialog.dart
    //  an

    setState(() {
      isPaymentProcessing = true;
    });
    await _simulatePayment();
    setState(() {
      isPaymentProcessing = false;
    });

    // TODO(team): bringe folgende Zeilen / Funktionen in die richtige
    //  Reihenfolge
    _goBackToProductSelectionPage();
    _clearFields();
    await _showSuccessDialog();
    _clearShoppingCart();

  }

  Future<void> _simulatePayment() async {
    final seconds = Random().nextInt(10);
    await Future.delayed(Duration(seconds: seconds));
  }

  Future<void> _showSuccessDialog() async {
    final cupertinoDialogAction = CupertinoDialogAction(
      child: CupertinoButton(
        child: const Text('Ok'),
        onPressed: () => Navigator.pop(context),
      ),
    );

    final androidDialogAction = TextButton(
      onPressed: () => Navigator.pop(context),
      child: const Text('Ok'),
    );

    if (!context.mounted) return;
    // TODO(team): Erstellen einen Dialog der dem Nutzer mitteilt, dass die
    //  Bestellung erfolgreich aufgegeben wurde. Schaue dir hierzu die
    //  Klasse lib/features/core/presentation/widgets/app_dialog.dart an
  }

  void _clearShoppingCart() {
    ref
        .read(ShoppingCartProviders.shoppingCartController.notifier)
        .clearShoppingCart();
    if (!context.mounted) return;
  }

  void _goBackToProductSelectionPage() {
    context.goNamed(ProductSelectionRoutes.productSelectionRootPage.name);
  }

  void _clearFields() {
    // TODO(team): Setze alle TextController zurück. Damit ist gemeint, dass
    //  nach dem erfolgreichen aufgeben einer Bestellung die Werte
    //  in den Textfeldern geleert / aufgeräumt werden.
    //  Tipp 1: schau dir an was die TextController alles können und wähle die
    //  richtige Methode aus
    //  Tipp 2: Achte darauf dass du alle TextController aufräumst
  }
}
