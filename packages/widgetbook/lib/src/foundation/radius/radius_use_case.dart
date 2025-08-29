import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import '../../widgetbook_components/widgetbook_components.dart';

@widgetbook.UseCase(
  name: 'Radius',
  type: Radius,
  path: '[foundation]/',
)
Widget buildWdsRadiusUseCase(BuildContext context) {
  return const RadiusUseCase();
}

class RadiusUseCase extends StatelessWidget {
  const RadiusUseCase({super.key});

  @override
  Widget build(BuildContext context) {
    return WidgetbookPageLayout(
      title: 'Border Radius Tokens',
      children: [
        _buildRadiusTable(),
      ],
    );
  }

  Widget _buildRadiusTable() {
    final radiusTokens = [
      {
        'name': 'WdsAtomicRadius.v0',
        'value': WdsAtomicRadius.v0,
        'label': '0px',
      },
      {
        'name': 'WdsAtomicRadius.v4',
        'value': WdsAtomicRadius.v4,
        'label': '4px',
      },
      {
        'name': 'WdsAtomicRadius.v8',
        'value': WdsAtomicRadius.v8,
        'label': '8px',
      },
      {
        'name': 'WdsAtomicRadius.v12',
        'value': WdsAtomicRadius.v12,
        'label': '12px',
      },
      {
        'name': 'WdsAtomicRadius.v20',
        'value': WdsAtomicRadius.v20,
        'label': '16px',
      },
      {
        'name': 'WdsAtomicRadius.v20',
        'value': WdsAtomicRadius.v20,
        'label': '20px',
      },
      {
        'name': 'WdsAtomicRadius.v30',
        'value': WdsAtomicRadius.v30,
        'label': '30px',
      },
      {
        'name': 'WdsAtomicRadius.full',
        'value': WdsAtomicRadius.full,
        'label': '99999px',
      },
    ];

    return Table(
      columnWidths: const {
        0: FlexColumnWidth(2),
        1: FlexColumnWidth(),
        2: FlexColumnWidth(2),
      },
      children: [
        // Table Header
        TableRow(
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
          ),
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'Token',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade700,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'Value',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade700,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'Visual',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade700,
                ),
              ),
            ),
          ],
        ),
        // Table Body
        ...radiusTokens.map(
          (token) => TableRow(
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
            ),
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      token['name']! as String,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Primitive',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  token['label']! as String,
                  style: TextStyle(
                    color: Colors.grey.shade700,
                    fontSize: 16,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: _buildRadiusVisual(token['value']! as double),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRadiusVisual(double radius) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: const Color(0xFFE3F2FD), // Light blue background
          borderRadius: BorderRadius.circular(radius),
          border: Border.all(
            color: const Color(0xFF1976D2), // Darker blue border
            width: 2,
          ),
        ),
      ),
    );
  }
}
