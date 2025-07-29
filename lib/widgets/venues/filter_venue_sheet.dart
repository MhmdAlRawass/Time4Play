import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:time4play/widgets/venues/area_card.dart';

class FilterVenuesSheet extends StatefulWidget {
  final void Function(List<String>, List<String>) onApplyFilters;
  final List<String> availableAreas;
  final List<String> availableSports;
  final List<String> initialSelectedAreas;
  final List<String> initialSelectedSports;

  const FilterVenuesSheet({
    super.key,
    required this.onApplyFilters,
    required this.availableAreas,
    required this.availableSports,
    required this.initialSelectedAreas,
    required this.initialSelectedSports,
  });

  @override
  State<FilterVenuesSheet> createState() => _FilterVenuesSheetState();
}

class _FilterVenuesSheetState extends State<FilterVenuesSheet> {
  late List<String> selectedAreas;
  late List<String> selectedSports;

  @override
  void initState() {
    super.initState();
    selectedAreas = List.from(widget.initialSelectedAreas);
    selectedSports = List.from(widget.initialSelectedSports);
  }

  void _handleAreaSelection(String area, bool isSelected) {
    setState(() {
      if (isSelected) {
        selectedAreas.remove(area);
      } else {
        selectedAreas.add(area);
      }
    });
  }

  void _handleSportSelection(String sport, bool isSelected) {
    setState(() {
      if (isSelected) {
        selectedSports.remove(sport);
      } else {
        selectedSports.add(sport);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Container(
      height: size.height * 0.65,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Filter Venues',
                  style: GoogleFonts.inter(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                  color: theme.colorScheme.onSurface,
                ),
              ],
            ),
            const Divider(),

            // Areas Section
            _buildSectionHeader('Select Area', isDarkMode),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: widget.availableAreas.map((area) {
                final isSelected = selectedAreas.contains(area);
                return AreaCard(
                  value: area,
                  isSelected: isSelected,
                  onTap: () => _handleAreaSelection(area, isSelected),
                  isDarkMode: isDarkMode,
                );
              }).toList(),
            ),

            const SizedBox(height: 24),

            // Sports Section
            _buildSectionHeader('Select Sport', isDarkMode),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: widget.availableSports.map((sport) {
                final isSelected = selectedSports.contains(sport);
                return AreaCard(
                  value: sport,
                  isSelected: isSelected,
                  onTap: () => _handleSportSelection(sport, isSelected),
                  isDarkMode: isDarkMode,
                );
              }).toList(),
            ),

            const Spacer(),

            // Apply Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  widget.onApplyFilters(selectedAreas, selectedSports);
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.primaryColor,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text(
                  'Apply Filters',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, bool isDarkMode) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: isDarkMode ? Colors.blueGrey[300] : Colors.blueGrey[800],
      ),
    );
  }
}
