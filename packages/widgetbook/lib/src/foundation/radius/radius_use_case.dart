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
        'name': 'none',
        'value': WdsAtomicRadius.none,
        'label': '0px',
      },
      {
        'name': 'xs',
        'value': WdsAtomicRadius.xs,
        'label': '4px',
      },
      {
        'name': 'sm',
        'value': WdsAtomicRadius.sm,
        'label': '8px',
      },
      {
        'name': 'md',
        'value': WdsAtomicRadius.md,
        'label': '12px',
      },
      {
        'name': 'lg',
        'value': WdsAtomicRadius.lg,
        'label': '16px',
      },
      {
        'name': 'xl',
        'value': WdsAtomicRadius.xl,
        'label': '20px',
      },
      {
        'name': 'xxl',
        'value': WdsAtomicRadius.xxl,
        'label': '30px',
      },
      {
        'name': 'full',
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
