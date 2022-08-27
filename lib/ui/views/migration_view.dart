import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:tv_randshow/core/tvshow/domain/models/migration_model.dart';
import 'package:tv_randshow/core/tvshow/domain/models/migration_status.dart';
import 'package:tv_randshow/core/utils/constants.dart';
import 'package:tv_randshow/ui/states/migration_state.dart';
import 'package:unicons/unicons.dart';

class MigrationView extends StatefulWidget {
  const MigrationView({Key? key}) : super(key: key);

  @override
  State<MigrationView> createState() => _MigrationViewState();
}

class _MigrationViewState extends State<MigrationView> {
  MigrationState migrationState = MigrationState();

  @override
  void initState() {
    migrationState.initMigration();
    super.initState();
  }

  @override
  void dispose() {
    migrationState.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: ValueListenableBuilder<MigrationModel>(
            valueListenable: migrationState,
            child: OutlinedButton.icon(
              label: Text(translate('app.migration.home_button')),
              icon: const Icon(UniconsLine.home),
              onPressed: () => Navigator.pushReplacementNamed(
                context,
                RoutePaths.TAB,
              ),
            ),
            builder: (context, value, child) {
              final order = value.status.getOrder();
              return Column(
                children: [
                  Text(
                    translate('app.migration.title'),
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    translate('app.migration.subtitle'),
                    style: Theme.of(context).textTheme.subtitle2,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  if (order < MigrationStatus.complete.getOrder() &&
                      value.error.isEmpty)
                    CircularProgressIndicator(),
                  if (!kIsWeb) ...[
                    _Checkpoint(
                      label: 'app.migration.loaded_old',
                      checked: order >= MigrationStatus.loadedOld.getOrder(),
                    ),
                    if (order == MigrationStatus.emptyOld.getOrder()) ...[
                      const SizedBox(height: 8),
                      _Checkpoint(
                          label: 'app.migration.empty_old', checked: true),
                    ] else ...[
                      const SizedBox(height: 8),
                      _Checkpoint(
                        label: 'app.migration.saved_to_new',
                        checked: order >= MigrationStatus.savedToNew.getOrder(),
                      ),
                      const SizedBox(height: 8),
                      _Checkpoint(
                        label: 'app.migration.verify_data',
                        checked: order >= MigrationStatus.verifyData.getOrder(),
                      ),
                      const SizedBox(height: 8),
                      _Checkpoint(
                        label: 'app.migration.deleted_old',
                        checked: order >= MigrationStatus.deletedOld.getOrder(),
                      ),
                      const SizedBox(height: 8),
                      _Checkpoint(
                        label: 'app.migration.complete_database',
                        checked: order >=
                            MigrationStatus.completeDatabase.getOrder(),
                      ),
                    ],
                  ],
                  const SizedBox(height: 8),
                  _Checkpoint(
                    label: 'app.migration.add_streaming',
                    checked: order >= MigrationStatus.addStreaming.getOrder(),
                  ),
                  const SizedBox(height: 8),
                  _Checkpoint(
                    label: 'app.migration.complete',
                    checked: order >= MigrationStatus.complete.getOrder(),
                  ),
                  const SizedBox(height: 8),
                  if (value.error.isNotEmpty)
                    Text(
                        '${translate('app.migration.error')}:\n ${value.error}'),
                  const SizedBox(height: 24),
                  child!,
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _Checkpoint extends StatelessWidget {
  final bool checked;
  final String label;
  const _Checkpoint({
    Key? key,
    this.checked = false,
    required this.label,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(translate(label)),
        checked
            ? Icon(UniconsLine.check, color: Colors.green)
            : Icon(UniconsLine.times, color: Colors.red),
      ],
    );
  }
}
