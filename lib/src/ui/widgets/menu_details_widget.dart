import 'package:flutter/material.dart';

import 'package:tv_randshow/src/data/tvshow_details.dart';
import 'package:tv_randshow/src/ui/widgets/fav_button_widget.dart';
import 'package:tv_randshow/src/ui/widgets/image_widget.dart';
import 'package:tv_randshow/src/ui/widgets/info_box_widget.dart';
import 'package:tv_randshow/src/ui/widgets/random_button_widget.dart';

class MenuPanelWidget extends StatelessWidget {
  const MenuPanelWidget({this.tvshowDetails, this.inDatabase});
  final TvshowDetails tvshowDetails;
  final bool inDatabase;

  @override
  Widget build(BuildContext context) {
    return Stack(
        alignment: Alignment.topCenter,
        overflow: Overflow.visible,
        children: <Widget>[
          Positioned(
              top: -22.5,
              child: inDatabase
                  ? RandomButtonWidget(tvshowDetails: tvshowDetails)
                  : FavButtonWidget(id: tvshowDetails.id)),
          Container(
            margin: const EdgeInsets.only(top: 20),
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  flex: 4,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: ImageWidget(
                            url: tvshowDetails.posterPath, isModal: true),
                      ),
                      const SizedBox(width: 8.0),
                      Expanded(
                        flex: 3,
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            tvshowDetails.name,
                            softWrap: true,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 3,
                            style: TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 20),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 5,
                  child: Row(
                    children: <Widget>[
                      InfoBoxWidget(
                          typeInfo: 0,
                          value: tvshowDetails.numberOfSeasons ?? '--'),
                      InfoBoxWidget(
                          typeInfo: 1,
                          value: tvshowDetails.numberOfEpisodes ?? '--'),
                      InfoBoxWidget(
                          typeInfo: 2,
                          // TODO(deandreamatias): Bad state: no element error
                          value: tvshowDetails.episodeRunTime.first)
                    ],
                  ),
                ),
                const Text('Sinopse',
                    style:
                        TextStyle(fontWeight: FontWeight.w500, fontSize: 20)),
                Expanded(
                  flex: 6,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Text(tvshowDetails.overview),
                  ),
                ),
              ],
            ),
          ),
        ]);
  }
}
