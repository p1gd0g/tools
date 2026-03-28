// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'timestamp.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(UserInputTimestamp)
final userInputTimestampProvider = UserInputTimestampProvider._();

final class UserInputTimestampProvider
    extends $NotifierProvider<UserInputTimestamp, String> {
  UserInputTimestampProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'userInputTimestampProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$userInputTimestampHash();

  @$internal
  @override
  UserInputTimestamp create() => UserInputTimestamp();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$userInputTimestampHash() =>
    r'fb209a132997f55a63db93a49fce0f6272a72041';

abstract class _$UserInputTimestamp extends $Notifier<String> {
  String build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<String, String>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<String, String>,
              String,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(UserInputDateTime)
final userInputDateTimeProvider = UserInputDateTimeProvider._();

final class UserInputDateTimeProvider
    extends $NotifierProvider<UserInputDateTime, DateTime> {
  UserInputDateTimeProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'userInputDateTimeProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$userInputDateTimeHash();

  @$internal
  @override
  UserInputDateTime create() => UserInputDateTime();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DateTime value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DateTime>(value),
    );
  }
}

String _$userInputDateTimeHash() => r'2cc91bef351e25d46aac94be8d93deb4cd568a40';

abstract class _$UserInputDateTime extends $Notifier<DateTime> {
  DateTime build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<DateTime, DateTime>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<DateTime, DateTime>,
              DateTime,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(timerTick)
final timerTickProvider = TimerTickProvider._();

final class TimerTickProvider
    extends $FunctionalProvider<AsyncValue<int>, int, Stream<int>>
    with $FutureModifier<int>, $StreamProvider<int> {
  TimerTickProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'timerTickProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$timerTickHash();

  @$internal
  @override
  $StreamProviderElement<int> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<int> create(Ref ref) {
    return timerTick(ref);
  }
}

String _$timerTickHash() => r'f258ded46122373fcb8d60ad13f4524e8d45762f';
