import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomDataTable extends StatelessWidget {
  final List<DataColumn> columns;
  final List<DataRow> rows;

  const CustomDataTable({super.key, required this.columns, required this.rows});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.grey[200]),
        child: DataTable(
          headingRowColor: MaterialStateProperty.all(Colors.grey[50]),
          headingTextStyle: GoogleFonts.plusJakartaSans(
            fontWeight: FontWeight.bold,
            color: Colors.grey[700],
            fontSize: 14,
          ),
          dataTextStyle: GoogleFonts.plusJakartaSans(
            color: Colors.black87,
            fontSize: 14,
          ),
          columnSpacing: 20,
          horizontalMargin: 20,
          columns: columns,
          rows: rows,
        ),
      ),
    );
  }
}
