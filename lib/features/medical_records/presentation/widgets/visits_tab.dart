import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nabd/core/theme/app_colors.dart';
import 'package:nabd/core/utils/navigation.dart';
import 'package:nabd/features/medical_records/presentation/bloc/medical_records_bloc.dart';
import 'package:nabd/features/medical_records/presentation/bloc/medical_records_event.dart';
import 'package:nabd/features/medical_records/presentation/bloc/medical_records_state.dart';
import 'package:nabd/features/medical_records/presentation/pages/visit_details_page.dart';
import 'package:nabd/features/medical_records/presentation/widgets/empty_records_widget.dart';
import 'package:nabd/features/medical_records/presentation/widgets/visit_card.dart';

class VisitsTab extends StatefulWidget {
  const VisitsTab({super.key});

  @override
  State<VisitsTab> createState() => _VisitsTabState();
}

class _VisitsTabState extends State<VisitsTab> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _loadVisits();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _loadVisits() {
    context.read<MedicalRecordsBloc>().add(GetVisitHistoryEvent());
  }

  void _onScroll() {
    if (_isBottom) {
      final state = context.read<MedicalRecordsBloc>().state;
      if (state.visitsHasMore &&
          state.visitsStatus != RequestStatus.loadingMore) {
        context.read<MedicalRecordsBloc>().add(
              GetVisitHistoryEvent(
                pageIndex: state.visitsCurrentPage + 1,
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
        if (state.visitsStatus == RequestStatus.loading) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primaryColor),
          );
        }

        // Error
        if (state.visitsStatus == RequestStatus.error) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(state.visitsError),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _loadVisits,
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        // Empty
        if (state.visits.isEmpty) {
          return const EmptyRecordsWidget(
            title: 'No Visits Found',
            subtitle: 'Your visit history will appear here',
            icon: Icons.event_note_outlined, message: '',
          );
        }

        // Success
        return RefreshIndicator(
          onRefresh: () async => _loadVisits(),
          color: AppColors.primaryColor,
          child: ListView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
            itemCount: state.visits.length + (state.visitsHasMore ? 1 : 0),
            itemBuilder: (context, index) {
              // Loading More
              if (index == state.visits.length) {
                return const Padding(
                  padding: EdgeInsets.all(16),
                  child: Center(
                    child: CircularProgressIndicator(
                      color: AppColors.primaryColor,
                    ),
                  ),
                );
              }

              final visit = state.visits[index];
              return VisitCard(
                visit: visit,
                onTap: () {
                  pushTo(
                    context,
                    VisitDetailsPage(visitId: visit.visitId),
                  );
                },
              );
            },
          ),
        );
      },
    );
  }
}