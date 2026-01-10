import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiendita/repositories/company_repository.dart';
import '../model/company_model.dart';
import 'database_provider.dart';

final companyRepositoryProvider = Provider<CompanyRepository>((ref){
    final database = ref.watch(databaseProvider);
    return CompanyRepository(database);
});

// to show data fast
final companyStreamProvider = StreamProvider<CompanyModel?>((ref){
  final repository = ref.watch(companyRepositoryProvider);
  return repository.watchCompany();
});

//
final companyLogoStreamProvider = StreamProvider<String?>((ref){
  final repository = ref.watch(companyRepositoryProvider);
  return repository.watchCompany().map((company) => company?.logoCompany);
});

//state notifier (to update)
final companyNotifierProvider = StateNotifierProvider<CompanyNotifier, AsyncValue<CompanyModel?>>((ref){
  final repository = ref.watch(companyRepositoryProvider);
  return CompanyNotifier(repository);
});

class CompanyNotifier extends StateNotifier<AsyncValue<CompanyModel?>> {
  final CompanyRepository _repository;
  CompanyNotifier(this._repository) : super(const AsyncValue.loading());

  Future<void> loadCompany() async {
    state = const AsyncValue.loading();
    try {
      final company = await _repository.getCompany();
      state = AsyncValue.data(company);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> saveCompany(CompanyModel company) async {
    try {
      final exists = await _repository.companyExists();

      if (exists && company.idCompany != null) {
        await _repository.updateCompanyById(company);
      } else {
        await _repository.createCompany(company);
      }

      await loadCompany();
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      rethrow;
    }
  }
}