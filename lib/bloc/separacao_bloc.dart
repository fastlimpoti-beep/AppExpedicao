import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'separacao_event.dart';
part 'separacao_state.dart';

class SeparacaoBloc extends Bloc<SeparacaoEvent, SeparacaoState> {
  SeparacaoBloc() : super(SeparacaoInitial()) {
    on<SelecionarSeparador>((event, emit) {
      emit(
          (state as SeparacaoEmAndamento).copyWith(separador: event.separador));
    });

    on<IniciarSeparacao>((event, emit) {
      final agora = DateTime.now();
      emit(SeparacaoEmAndamento(inicio: agora));
    });

    on<FinalizarSeparacao>((event, emit) {
      final agora = DateTime.now();
      emit((state as SeparacaoEmAndamento).copyWith(fim: agora));
    });
  }
}
