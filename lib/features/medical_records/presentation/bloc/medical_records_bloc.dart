import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nabd/features/medical_records/data/datasources/medical_records_remote_datasource.dart';
import 'package:nabd/features/medical_records/data/repositories/medical_records_repository_impl.dart';
import 'package:nabd/features/medical_records/domain/repositories/medical_records_repository.dart';
import 'package:nabd/features/medical_records/presentation/bloc/medical_records_event.dart';
import 'package:nabd/features/medical_records/presentation/bloc/medical_records_state.dart';

class MedicalRecordsBloc
    extends Bloc<MedicalRecordsEvent, MedicalRecordsState> {
  final MedicalRecordsRepository repository;

  MedicalRecordsBloc({required this.repository})
    : super(const MedicalRecordsState()) {
    on<GetVisitHistoryEvent>(_onGetVisitHistory);
    on<GetVisitDetailsEvent>(_onGetVisitDetails);
    on<GetAllergiesEvent>(_onGetAllergies);
    on<GetAllergyDetailsEvent>(_onGetAllergyDetails);
    on<GetChronicDiseasesEvent>(_onGetChronicDiseases);
    on<GetChronicDiseaseDetailsEvent>(_onGetChronicDiseaseDetails);
    on<GetMedicalHistoryEvent>(_onGetMedicalHistory);
    on<GetMedicalHistoryDetailsEvent>(_onGetMedicalHistoryDetails);
    on<GetPrescriptionsEvent>(_onGetPrescriptions);
    on<GetPrescriptionDetailsEvent>(_onGetPrescriptionDetails);
    on<ExportPrescriptionEvent>(_onExportPrescription);
    on<GetLabResultsEvent>(_onGetLabResults);
    on<GetLabResultDetailsEvent>(_onGetLabResultDetails);
    on<GetLabAnalysisEvent>(_onGetLabAnalysis);
    on<ExportLabResultEvent>(_onExportLabResult);
    on<ResetMedicalRecordsEvent>(_onReset);
  }

  factory MedicalRecordsBloc.create() {
    final remoteDataSource = MedicalRecordsRemoteDataSourceImpl();
    final repository = MedicalRecordsRepositoryImpl(
      remoteDataSource: remoteDataSource,
    );
    return MedicalRecordsBloc(repository: repository);
  }

  // ==================== Visits ====================

  Future<void> _onGetVisitHistory(
    GetVisitHistoryEvent event,
    Emitter<MedicalRecordsState> emit,
  ) async {
    if (event.isLoadMore) {
      emit(state.copyWith(visitsStatus: RequestStatus.loadingMore));
    } else {
      emit(state.copyWith(visitsStatus: RequestStatus.loading));
    }
    final result = await repository.getVisitHistory(
      pageIndex: event.pageIndex,
      pageSize: event.pageSize,
      visitNumber: event.visitNumber,
      visitStatus: event.visitStatus,
    );
    result.fold(
      (failure) => emit(
        state.copyWith(
          visitsStatus: RequestStatus.error,
          visitsError: failure.message,
        ),
      ),
      (paginatedResponse) {
        final newVisits = event.isLoadMore
            ? [...state.visits, ...paginatedResponse.data]
            : paginatedResponse.data;
        emit(
          state.copyWith(
            visitsStatus: RequestStatus.success,
            visits: newVisits,
            visitsCurrentPage: paginatedResponse.currentPage,
            visitsHasMore: paginatedResponse.hasNextPage,
          ),
        );
      },
    );
  }

  Future<void> _onGetVisitDetails(
    GetVisitDetailsEvent event,
    Emitter<MedicalRecordsState> emit,
  ) async {
    emit(state.copyWith(visitDetailsStatus: RequestStatus.loading));
    final result = await repository.getVisitDetails(event.visitId);
    result.fold(
      (failure) => emit(
        state.copyWith(
          visitDetailsStatus: RequestStatus.error,
          visitDetailsError: failure.message,
        ),
      ),
      (details) => emit(
        state.copyWith(
          visitDetailsStatus: RequestStatus.success,
          visitDetails: details,
        ),
      ),
    );
  }

  // ==================== Allergies ====================

  Future<void> _onGetAllergies(
    GetAllergiesEvent event,
    Emitter<MedicalRecordsState> emit,
  ) async {
    if (event.isLoadMore) {
      emit(state.copyWith(allergiesStatus: RequestStatus.loadingMore));
    } else {
      emit(state.copyWith(allergiesStatus: RequestStatus.loading));
    }
    final result = await repository.getAllergies(
      pageIndex: event.pageIndex,
      pageSize: event.pageSize,
    );
    result.fold(
      (failure) => emit(
        state.copyWith(
          allergiesStatus: RequestStatus.error,
          allergiesError: failure.message,
        ),
      ),
      (paginatedResponse) {
        final newAllergies = event.isLoadMore
            ? [...state.allergies, ...paginatedResponse.data]
            : paginatedResponse.data;
        emit(
          state.copyWith(
            allergiesStatus: RequestStatus.success,
            allergies: newAllergies,
            allergiesCurrentPage: paginatedResponse.currentPage,
            allergiesHasMore: paginatedResponse.hasNextPage,
          ),
        );
      },
    );
  }

  Future<void> _onGetAllergyDetails(
    GetAllergyDetailsEvent event,
    Emitter<MedicalRecordsState> emit,
  ) async {
    emit(state.copyWith(allergyDetailsStatus: RequestStatus.loading));
    final result = await repository.getAllergyDetails(event.id);
    result.fold(
      (failure) => emit(
        state.copyWith(
          allergyDetailsStatus: RequestStatus.error,
          allergyDetailsError: failure.message,
        ),
      ),
      (details) => emit(
        state.copyWith(
          allergyDetailsStatus: RequestStatus.success,
          allergyDetails: details,
        ),
      ),
    );
  }

  // ==================== Chronic Diseases ====================

  Future<void> _onGetChronicDiseases(
    GetChronicDiseasesEvent event,
    Emitter<MedicalRecordsState> emit,
  ) async {
    emit(state.copyWith(chronicDiseasesStatus: RequestStatus.loading));
    final result = await repository.getChronicDiseases();
    result.fold(
      (failure) => emit(
        state.copyWith(
          chronicDiseasesStatus: RequestStatus.error,
          chronicDiseasesError: failure.message,
        ),
      ),
      (diseases) => emit(
        state.copyWith(
          chronicDiseasesStatus: RequestStatus.success,
          chronicDiseases: diseases,
        ),
      ),
    );
  }

  Future<void> _onGetChronicDiseaseDetails(
    GetChronicDiseaseDetailsEvent event,
    Emitter<MedicalRecordsState> emit,
  ) async {
    emit(state.copyWith(chronicDiseaseDetailsStatus: RequestStatus.loading));
    final result = await repository.getChronicDiseaseDetails(event.id);
    result.fold(
      (failure) => emit(
        state.copyWith(
          chronicDiseaseDetailsStatus: RequestStatus.error,
          chronicDiseaseDetailsError: failure.message,
        ),
      ),
      (details) => emit(
        state.copyWith(
          chronicDiseaseDetailsStatus: RequestStatus.success,
          chronicDiseaseDetails: details,
        ),
      ),
    );
  }

  // ==================== Medical History ====================

  Future<void> _onGetMedicalHistory(
    GetMedicalHistoryEvent event,
    Emitter<MedicalRecordsState> emit,
  ) async {
    emit(state.copyWith(medicalHistoryStatus: RequestStatus.loading));
    final result = await repository.getMedicalHistory();
    result.fold(
      (failure) => emit(
        state.copyWith(
          medicalHistoryStatus: RequestStatus.error,
          medicalHistoryError: failure.message,
        ),
      ),
      (history) => emit(
        state.copyWith(
          medicalHistoryStatus: RequestStatus.success,
          medicalHistory: history,
        ),
      ),
    );
  }

  Future<void> _onGetMedicalHistoryDetails(
    GetMedicalHistoryDetailsEvent event,
    Emitter<MedicalRecordsState> emit,
  ) async {
    emit(state.copyWith(medicalHistoryDetailsStatus: RequestStatus.loading));
    final result = await repository.getMedicalHistoryDetails(event.id);
    result.fold(
      (failure) => emit(
        state.copyWith(
          medicalHistoryDetailsStatus: RequestStatus.error,
          medicalHistoryDetailsError: failure.message,
        ),
      ),
      (details) => emit(
        state.copyWith(
          medicalHistoryDetailsStatus: RequestStatus.success,
          medicalHistoryDetails: details,
        ),
      ),
    );
  }

  // ==================== Prescriptions ====================

  Future<void> _onGetPrescriptions(
    GetPrescriptionsEvent event,
    Emitter<MedicalRecordsState> emit,
  ) async {
    emit(state.copyWith(prescriptionsStatus: RequestStatus.loading));
    final result = await repository.getPrescriptions();
    result.fold(
      (failure) => emit(
        state.copyWith(
          prescriptionsStatus: RequestStatus.error,
          prescriptionsError: failure.message,
        ),
      ),
      (prescriptions) => emit(
        state.copyWith(
          prescriptionsStatus: RequestStatus.success,
          prescriptions: prescriptions,
        ),
      ),
    );
  }

  Future<void> _onGetPrescriptionDetails(
    GetPrescriptionDetailsEvent event,
    Emitter<MedicalRecordsState> emit,
  ) async {
    emit(state.copyWith(prescriptionDetailsStatus: RequestStatus.loading));
    final result = await repository.getPrescriptionDetails(event.id);
    result.fold(
      (failure) => emit(
        state.copyWith(
          prescriptionDetailsStatus: RequestStatus.error,
          prescriptionDetailsError: failure.message,
        ),
      ),
      (details) => emit(
        state.copyWith(
          prescriptionDetailsStatus: RequestStatus.success,
          prescriptionDetails: details,
        ),
      ),
    );
  }

  Future<void> _onExportPrescription(
    ExportPrescriptionEvent event,
    Emitter<MedicalRecordsState> emit,
  ) async {
    emit(state.copyWith(exportStatus: RequestStatus.loading));
    final result = await repository.exportPrescription(event.prescriptionId);
    result.fold(
      (failure) => emit(
        state.copyWith(
          exportStatus: RequestStatus.error,
          exportError: failure.message,
        ),
      ),
      (filePath) => emit(
        state.copyWith(
          exportStatus: RequestStatus.success,
          exportFilePath: filePath,
        ),
      ),
    );
  }

  // ==================== Lab Results ====================

  Future<void> _onGetLabResults(
    GetLabResultsEvent event,
    Emitter<MedicalRecordsState> emit,
  ) async {
    emit(state.copyWith(labResultsStatus: RequestStatus.loading));
    final result = await repository.getLabResults();
    result.fold(
      (failure) => emit(
        state.copyWith(
          labResultsStatus: RequestStatus.error,
          labResultsError: failure.message,
        ),
      ),
      (labResults) => emit(
        state.copyWith(
          labResultsStatus: RequestStatus.success,
          labResults: labResults,
        ),
      ),
    );
  }

  Future<void> _onGetLabResultDetails(
    GetLabResultDetailsEvent event,
    Emitter<MedicalRecordsState> emit,
  ) async {
    emit(state.copyWith(labResultDetailsStatus: RequestStatus.loading));
    final result = await repository.getLabResultDetails(event.id);
    result.fold(
      (failure) => emit(
        state.copyWith(
          labResultDetailsStatus: RequestStatus.error,
          labResultDetailsError: failure.message,
        ),
      ),
      (details) => emit(
        state.copyWith(
          labResultDetailsStatus: RequestStatus.success,
          labResultDetails: details,
        ),
      ),
    );
  }

  Future<void> _onGetLabAnalysis(
    GetLabAnalysisEvent event,
    Emitter<MedicalRecordsState> emit,
  ) async {
    emit(state.copyWith(labAnalysisStatus: RequestStatus.loading));
    final result = await repository.getLabAnalysis(event.id);
    result.fold(
      (failure) => emit(
        state.copyWith(
          labAnalysisStatus: RequestStatus.error,
          labAnalysisError: failure.message,
        ),
      ),
      (analysis) => emit(
        state.copyWith(
          labAnalysisStatus: RequestStatus.success,
          labAnalysis: analysis,
        ),
      ),
    );
  }

  Future<void> _onExportLabResult(
    ExportLabResultEvent event,
    Emitter<MedicalRecordsState> emit,
  ) async {
    emit(state.copyWith(exportLabStatus: RequestStatus.loading));
    final result = await repository.exportLabResult(event.labResultId);
    result.fold(
      (failure) => emit(
        state.copyWith(
          exportLabStatus: RequestStatus.error,
          exportLabError: failure.message,
        ),
      ),
      (filePath) => emit(
        state.copyWith(
          exportLabStatus: RequestStatus.success,
          exportLabFilePath: filePath,
        ),
      ),
    );
  }

  // ==================== Reset ====================

  void _onReset(
    ResetMedicalRecordsEvent event,
    Emitter<MedicalRecordsState> emit,
  ) {
    emit(const MedicalRecordsState());
  }
}
