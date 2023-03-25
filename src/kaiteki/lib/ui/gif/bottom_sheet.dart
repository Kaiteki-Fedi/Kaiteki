import "dart:convert";

import "package:flutter/material.dart";
import "package:http/http.dart";
import "package:infinite_scroll_pagination/infinite_scroll_pagination.dart";
import "package:kaiteki/fediverse/model/gif.dart";
import "package:kaiteki/ui/shared/search_bar.dart";

class GifBottomSheet extends StatefulWidget {
  const GifBottomSheet({super.key});

  @override
  State<GifBottomSheet> createState() => _GifBottomSheetState();
}

class _GifBottomSheetState extends State<GifBottomSheet> {
  final _searchController = TextEditingController();
  PagingController<String?, Gif>? _pagingController;

  @override
  void initState() {
    super.initState();
  }

  Future<void> _onPageRequest(String? pageKey) async {
    final query = _searchController.text;
    final response = await get(
      Uri.parse(
        "https://tenor.googleapis.com/v2/search?key=AIzaSyBY_XdxFdGOA35nhK2cFaRyI-L3egctaGQ&q=$query",
      ),
    );

    final json = jsonDecode(response.body) as Map<String, dynamic>;
    final next = json["next"] as String;
    final results =
        (json["results"] as List<dynamic>).cast<Map<String, dynamic>>().map(
      (e) {
        final media = e["media_formats"] as Map<String, dynamic>;
        debugPrint(media.toString());
        return Gif(
          Uri.parse(media["mediumgif"]["url"] as String),
          Uri.parse(media["gifpreview"]["url"] as String),
          null,
        );
      },
    );

    _pagingController!.appendPage(results.toList(), next);
  }

  @override
  Widget build(BuildContext context) {
    return BottomSheet(
      onClosing: () {},
      builder: (context) {
        return CustomScrollView(
          slivers: [
            const SliverToBoxAdapter(child: SizedBox(height: 8)),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      "Search for GIFs",
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    KaitekiSearchBar(
                      controller: _searchController,
                      onSubmitted: (query) {
                        setState(
                          () => _pagingController =
                              PagingController(firstPageKey: null)
                                ..addPageRequestListener(_onPageRequest),
                        );
                      },
                      hintText: "Search for GIFs",
                    ),
                  ],
                ),
              ),
            ),

            // SliverToBoxAdapter(
            //   child: Image.asset("attributions/tenor.png", height: 16),
            // ),
            if (_pagingController != null)
              SliverPadding(
                padding: const EdgeInsets.all(18),
                sliver: PagedSliverGrid(
                  pagingController: _pagingController!,
                  builderDelegate: PagedChildBuilderDelegate<Gif>(
                    itemBuilder: (context, item, index) {
                      return InkWell(
                        onTap: () {},
                        child: Image.network(
                          item.previewUrl.toString(),
                          fit: BoxFit.cover,
                        ),
                      );
                    },
                  ),
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 300,
                    childAspectRatio: 16 / 9,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
