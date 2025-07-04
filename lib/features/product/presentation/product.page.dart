import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_validator/form_validator.dart';
import 'package:intl/intl.dart';
import '../../core/presentation/widgets/app_dialog.dart' show AppDialog;

import '../shared.dart';
import 'widgets/image_selector.dart';

/// PaymentPage
class ProductPage extends ConsumerStatefulWidget {
  const ProductPage({super.key});

  @override
  ConsumerState<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends ConsumerState<ProductPage> {
  final GlobalKey<FormState> _formState = GlobalKey<FormState>();
  final TextEditingController _productNameTextController =
      TextEditingController();
  final TextEditingController _productDescriptionTextController =
      TextEditingController();
  final TextEditingController _productAccessoriesTextController =
      TextEditingController();
  final TextEditingController _productPriceTextController =
      TextEditingController();

  final double _verticalPaddingLarge = 16;
  final double _verticalPaddingSmall = 8;

  List<Uint8List> _productImages = List.empty();
  List<Uint8List> _accessoriesImages = List.empty();

  final _maxAccessoryTextLength = 2;

  bool isUploading = false;

  final currencyFormat = NumberFormat('#,##0.00', 'de_DE');

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('mBot Konfigurator'),
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

          // Artikelname
          SizedBox(
            height: _verticalPaddingLarge,
          ),
          Text(
            'Artikelname',
            style: textTheme.labelLarge,
          ),
          SizedBox(
            height: _verticalPaddingSmall,
          ),
          TextFormField(
            controller: _productNameTextController,
            decoration: const InputDecoration(
              hintText: 'Artikelname',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(5),
                ),
              ),
            ),
            validator: ValidationBuilder(localeName: 'de')
                .required()
                .maxLength(
                  20,
                  'Der Artikelname darf maximal 20 Zeichen lang sein',
                )
                .build(),
          ),

          // Beschreibung des Produkts
          SizedBox(
            height: _verticalPaddingLarge,
          ),
          Text(
            'Beschreibung',
            style: textTheme.labelLarge,
          ),
          SizedBox(
            height: _verticalPaddingSmall,
          ),
          TextFormField(
            controller: _productDescriptionTextController,
            decoration: const InputDecoration(
              hintText: "Beschreibung des mBot's",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(5),
                ),
              ),
            ),
            maxLines: 5,
            // TODO(team): füge eine Beschränkung der Zeichen für die
            //  Beschreibung hinzu
            validator: ValidationBuilder(localeName: 'de').required().build(),
          ),

          // Bilder des Produktes (mBot selbst)
          SizedBox(
            height: _verticalPaddingLarge,
          ),
          Text(
            'Bilder (optional)',
            style: textTheme.labelLarge,
          ),
          SizedBox(
            height: _verticalPaddingSmall,
          ),
          ImageSelector(
            images: _productImages,
            onImagePickedFromCamera: _addImageToProductImages,
            onImagesPickedFromGallery: _addImagesToProductImages,
            onImageDeleted: _deleteImageFromProductImages,
          ),

          // Zubehör
          SizedBox(
            height: _verticalPaddingLarge,
          ),
          Text(
            'Zubehör',
            style: textTheme.labelLarge,
          ),
          SizedBox(
            height: _verticalPaddingSmall,
          ),
          TextFormField(
            controller: _productAccessoriesTextController,
            decoration: const InputDecoration(
              hintText: 'Zubehör',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(5),
                ),
              ),
            ),
            maxLines: 5,
            // TODO(team): Beschränke die Eingabe auf 300 Zeichen
            maxLength: _maxAccessoryTextLength,
            validator: ValidationBuilder(localeName: 'de').required().build(),
          ),

          // Bilder des Zubehörs
          SizedBox(
            height: _verticalPaddingLarge,
          ),
          Text(
            'Bilder vom Zubehör (optional)',
            style: textTheme.labelLarge,
          ),
          SizedBox(
            height: _verticalPaddingSmall,
          ),
          ImageSelector(
            images: _accessoriesImages,
            onImagePickedFromCamera: _addImageToAccessoriesImages,
            onImagesPickedFromGallery: _addImagesToAccessoriesImages,
            onImageDeleted: _deleteImageFromAccessoriesImages,
          ),
          // Preis
          SizedBox(
            height: _verticalPaddingLarge,
          ),
          Text(
            'Preis (in Euro)',
            style: textTheme.labelLarge,
          ),
          SizedBox(
            height: _verticalPaddingSmall,
          ),
          TextFormField(
            inputFormatters: _currencyFormatters(),
            decoration: const InputDecoration(
              // TODO(team): füge einen sinnvollen Hinweistext hinzu, sodass
              //  der Nutzer weiß, was er in dieses TextFormField eingeben muss.
              //  Tipp: Schaue dir dazu folgende Seite an:
              //  https://api.flutter.dev/flutter/material/TextFormField-class.html
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(5),
                ),
              ),
            ),
            keyboardType: TextInputType.number,
            controller: _productPriceTextController,
            validator: _priceValidator,
          ),

          const Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton(
                onPressed: () => _submit(context),
                child: Row(
                  children: [
                    if (isUploading)
                      const SizedBox(
                        width: 10,
                        height: 10,
                        child: CircularProgressIndicator.adaptive(),
                      )
                    else
                      const Icon(Icons.upload),
                    const SizedBox(
                      width: 10,
                    ),
                    const Text('Produkt speichern'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _deleteImageFromProductImages(int page) {
    setState(() {
      _productImages.removeAt(page);
    });
  }

  void _addImagesToProductImages(List<Uint8List> images) {
    setState(() {
      _productImages = [..._productImages, ...images];
    });
  }

  void _addImageToProductImages(Uint8List image) {
    setState(() {
      _productImages = [..._productImages, image];
    });
  }

  void _deleteImageFromAccessoriesImages(int page) {
    setState(() {
      _accessoriesImages.removeAt(page);
    });
  }

  void _addImagesToAccessoriesImages(List<Uint8List> images) {
    setState(() {
      _accessoriesImages = [..._accessoriesImages, ...images];
    });
  }

  void _addImageToAccessoriesImages(Uint8List image) {
    setState(() {
      _accessoriesImages.add(image);
    });
  }

  String? _priceValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Dieses Feld ist erforderlich';
    }
    if (value == '0.0' || value == '0.00') {
      return 'Ungültiger Preis';
    }
    return null;
  }

  List<TextInputFormatter> _currencyFormatters() => [
        FilteringTextInputFormatter.digitsOnly,
        TextInputFormatter.withFunction(
          (oldValue, newValue) {
            final text = newValue.text;
            final selection = newValue.selection;
            if (text.isEmpty) {
              return TextEditingValue(selection: selection);
            } else if (text.length == 1) {
              final number = int.tryParse(text);
              if (number == null) {
                return oldValue;
              } else {
                final newText = '0.${number.toString()}';
                return TextEditingValue(
                  text: newText,
                  selection: TextSelection.collapsed(offset: newText.length),
                );
              }
            } else {
              final price = double.parse(text.replaceAll('.', '')) / 100;
              final newText = currencyFormat.format(price);
              final newSelectionIndex =
                  newText.length - (text.length - selection.end);
              return TextEditingValue(
                text: newText,
                selection: TextSelection.collapsed(offset: newSelectionIndex),
              );
            }
          },
        ),
      ];

  Future<void> _submit(BuildContext context) async {
    if (_formState.currentState!.validate()) {
      setState(() {
        isUploading = true;
      });
      await ref.read(ProductProviders.productRepository).createProduct(
            productName: _productNameTextController.text,
            productDescription: _productDescriptionTextController.text,
            accessoriesDescription: _productAccessoriesTextController.text,
            productPrice: _parsePrice(),
            productImages: _productImages,
            accessoriesImages: _accessoriesImages,
          );
      ref.invalidate(ProductProviders.getAllProducts);
      _clearFields();

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
      setState(() {
        isUploading = false;
      });
      if (!context.mounted) return;
      await AppDialog.showActionDialog(
        cupertinoDialogActions: [cupertinoDialogAction],
        androidActions: [androidDialogAction],
        context,
        'Prima!',
        const Text('Produkt erfolgreich erstellt.'),
      );
    }
  }

  double _parsePrice() {
    return double.parse(
            _productPriceTextController.text.replaceAll(',', '.'),
          );
  }

  void _clearFields() {
    // TODO(team): Setze alle TextController zurück. Damit ist gemeint, dass
    //  nach dem erfolgreichen erstellen / hochladen eines Produktes die Werte
    //  in den Textfeldern geleert / aufgeräumt werden, um direkt und bequem
    //  ein neues Produkt anlegen zu können.
    //  Tipp 1: schau dir an was die TextController alles können und wähle die
    //  richtige Methode aus
    //  Tipp 2: Achte darauf dass du alle TextController aufräumst
    _productImages = [];
    _accessoriesImages = [];
  }
}
