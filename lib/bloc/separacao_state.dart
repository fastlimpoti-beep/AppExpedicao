part of 'separacao_bloc.dart';

abstract class SeparacaoState extends Equatable {
  const SeparacaoState();
  @override
  List<Object> get props => [];
}

class SeparacaoInitial extends SeparacaoState {}

class SeparacaoEmAndamento extends SeparacaoState {
  final DateTime? inicio;
  final DateTime? fim;
  final String? separador;

  const SeparacaoEmAndamento({this.inicio, this.fim, this.separador});

  SeparacaoEmAndamento copyWith({
    DateTime? inicio,
    DateTime? fim,
    String? separador,
  }) {
    return SeparacaoEmAndamento(
      inicio: inicio ?? this.inicio,
      fim: fim ?? this.fim,
      separador: separador ?? this.separador,
    );
  }

  @override
  List<Object> get props => [
        inicio ?? DateTime(0),
        fim ?? DateTime(0),
        separador ?? '',
      ];
}
