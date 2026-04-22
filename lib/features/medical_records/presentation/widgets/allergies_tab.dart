import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nabd/core/theme/app_colors.dart';
import 'package:nabd/core/utils/navigation.dart';
import 'package:nabd/features/medical_records/presentation/bloc/medical_records_bloc.dart';
import 'package:nabd/features/medical_records/presentation/bloc/medical_records_event.dart';
import 'package:nabd/features/medical_records/presentation/bloc/medical_records_state.dart';
import 'package:nabd/features/medical_records/presentation/pages/allergy_details_page.dart';
import 'package:nabd/features/medical_records/presentation/widgets/allergy_card.dart';
import 'package:nabd/features/medical_records/presentation/widgets/empty_records_widget.dart';

class AllergiesTab extends StatefulWidget {
  const AllergiesTab({super.key});

  @override
  State<AllergiesTab> createState() => _AllergiesTabState();
}

class _AllergiesTabState extends State<AllergiesTab> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _loadAllergies();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _loadAllergies() {
    context.read<MedicalRecordsBloc>().add(GetAllergiesEvent());
  }

  void _onScroll() {
    if (_isBottom) {
      final state = context.read<MedicalRecordsBloc>().state;
      if (state.allergiesHasMore &&
          state.allergiesStatus != RequestStatus.loadingMore) {
        context.read<MedicalRecordsBloc>().add(
          GetAllergiesEvent(
            pageIndex: state.allergiesCurrentPage + 1,
            isLoadMore: true,
          ),
        );
      }
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MedicalRecordsBloc, MedicalRecordsState>(
      builder: (context, state) {
        // Loading
        if (state.allergiesStatus == RequestStatus.loading) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primaryColor),
          );
        }

        // Error
        if (state.allergiesStatus == RequestStatus.error) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(state.allergiesError),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _loadAllergies,
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        // Empty
        if (state.allergies.isEmpty) {
          return const EmptyRecordsWidget(
            title: 'No Allergies Found',
            subtitle: 'Your allergy records will appear here',
            icon: Icons.warning_amber_outlined,
          );
        }

        // Success
        return RefreshIndicator(
          onRefresh: () async => _loadAllergies(),
          color: AppColors.primaryColor,
          child: ListView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
            itemCount:
                state.allergies.length + (state.allergiesHasMore ? 1 : 0),
            itemBuilder: (context, index) {
              // Loading More
              if (index == state.allergies.length) {
                return const Padding(
                  padding: EdgeInsets.all(16),
                  child: Center(
                    child: CircularProgressIndicator(
                      color: AppColors.primaryColor,
                    ),
                  ),
                );
              }

              final allergy = state.allergies[index];
              return AllergyCard(
                allergy: allergy,
                onTap: () {
                  pushTo(context, AllergyDetailsPage(allergyId: allergy.id));
                },
              );
            },
          ),
        );
      },
    );
  }
}
