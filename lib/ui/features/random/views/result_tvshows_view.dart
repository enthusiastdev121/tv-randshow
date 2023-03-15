import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:tv_randshow/ui/features/random/states/random_tvshows_state.dart';
import 'package:tv_randshow/ui/features/random/widgets/random_again_button.dart';
import 'package:tv_randshow/ui/features/random/widgets/result_base_view.dart';
import 'package:tv_randshow/ui/features/random/widgets/streaming_button.dart';
import 'package:tv_randshow/ui/shared/styles.dart';
import 'package:tv_randshow/ui/widgets/error_message.dart';
import 'package:tv_randshow/ui/widgets/info_box.dart';
import 'package:tv_randshow/ui/widgets/loaders/loader.dart';
import 'package:tv_randshow/ui/widgets/text_title_large.dart';
import 'package:tv_randshow/ui/widgets/text_title_medium.dart';

class ResultTvshowsView extends StatelessWidget {
  const ResultTvshowsView({super.key});
  @override
  Widget build(BuildContext context) {
    return ResultBaseView(
      actionButton: Consumer(
        builder: (context, ref, child) {
          return RandomAgainButton(
            labelKey: 'app.result.episode.button_random',
            onPressed: () => ref.invalidate(randomTvshowsProvider),
          );
        },
      ),
      titleKey: 'app.result.episode.title',
      child: const _TvshowResultInfo(),
    );
  }
}

class _TvshowResultInfo extends StatelessWidget {
  const _TvshowResultInfo();

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        return ref.watch(randomTvshowsProvider).when(
              data: (tvshowResult) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    TextTitleLarge(tvshowResult.name),
                    Flexible(
                      flex: 2,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          InfoBox(
                            typeInfo: InfoTypeBox.season,
                            value: tvshowResult.randomSeason,
                          ),
                          InfoBox(
                            typeInfo: InfoTypeBox.episode,
                            value: tvshowResult.randomEpisode,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: Styles.small),
                    TextTitleMedium(tvshowResult.episodeName),
                    const SizedBox(height: Styles.small),
                    Flexible(
                      flex: 3,
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: Text(tvshowResult.episodeDescription),
                      ),
                    ),
                    const SizedBox(height: Styles.small),
                    if (tvshowResult.streamings.isNotEmpty) ...[
                      TextTitleMedium(
                        translate('app.result.episode.streaming_title'),
                      ),
                      const SizedBox(height: Styles.small),
                      Wrap(
                        spacing: Styles.small,
                        runSpacing: Styles.small,
                        children: tvshowResult.streamings
                            .map(
                              (streaming) => StreamingButton(
                                streamingDetail: streaming,
                              ),
                            )
                            .toList(),
                      ),
                    ],
                    if (tvshowResult.streamings.isEmpty)
                      TextTitleMedium(
                        translate('app.result.episode.no_streaming_title'),
                      ),
                  ],
                );
              },
              error: (error, stackTrace) => ErrorMessage(
                keyText: 'app.result.episode.error_load',
                error: error,
              ),
              loading: () => const Loader(),
            );
      },
    );
  }
}
