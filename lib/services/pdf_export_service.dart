import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../core/utils/date_utils.dart';
import '../models/daily_entry.dart';

/// Erzeugt einen PDF-Export des kompletten Verlaufs.
///
/// Premium-only Feature. Bewusst simpel: eine Liste, keine Diagramme,
/// keine Layout-Optionen.
class PdfExportService {
  Future<void> exportAndShare(List<DailyEntry> entries) async {
    final doc = pw.Document();

    doc.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (context) => [
          pw.Header(
            level: 0,
            child: pw.Text(
              '1% Better – Mein Verlauf',
              style: pw.TextStyle(
                fontSize: 24,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
          ),
          pw.SizedBox(height: 12),
          pw.Text('Anzahl Einträge: ${entries.length}'),
          pw.SizedBox(height: 20),
          pw.TableHelper.fromTextArray(
            headers: ['Datum', 'Was ich 1 % besser gemacht habe'],
            data: entries
                .map(
                  (e) => [AppDateUtils.formatFull(e.date), e.text],
                )
                .toList(),
            headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
            cellAlignment: pw.Alignment.centerLeft,
            columnWidths: {
              0: const pw.FixedColumnWidth(80),
              1: const pw.FlexColumnWidth(),
            },
          ),
        ],
      ),
    );

    await Printing.sharePdf(
      bytes: await doc.save(),
      filename: '1-percent-better-verlauf.pdf',
    );
  }
}
