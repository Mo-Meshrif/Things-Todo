part of 'help_bloc.dart';

abstract class HelpState extends Equatable {
  const HelpState();

  @override
  List<Object?> get props => [];
}

class HelpInitial extends HelpState {}

class HomeTranstion extends HelpState {
  @override
  List<Object?> get props => [];
}

class HomeFailure extends HelpState {
  final String msg;
  const HomeFailure({required this.msg});

  @override
  List<Object?> get props => [msg];
}

class MessageLoading extends HelpState {
  @override
  List<Object> get props => [];
}

class MessageLoaded extends HelpState {
  final bool val;

  const MessageLoaded({required this.val});
  @override
  List<Object> get props => [val];
}

class MessageFailure extends HelpState {
  final String msg;

  const MessageFailure({required this.msg});
  @override
  List<Object> get props => [msg];
}

class ProblemLoading extends HelpState {
  @override
  List<Object> get props => [];
}

class ProblemLoaded extends HelpState {
  final bool val;

  const ProblemLoaded({required this.val});
  @override
  List<Object> get props => [val];
}

class ProblemFailure extends HelpState {
  final String msg;

  const ProblemFailure({required this.msg});
  @override
  List<Object> get props => [msg];
}
