import 'package:get/get.dart';
import 'package:gg_copy/screens/feed_screen/controllers/post_controller.dart';

class FavoritesController extends PostController {
  static const _controllersNeededToUpdate = [
    'feed',
    'profileFeed',
    'search',
    'searchFeed'
  ];

  @override
  Future<void> addToFavorites(int index, Function(int e)? onError) async {
    for (final controllerTag in _controllersNeededToUpdate) {
      final post = posts[index];
      try {
        final controller = Get.find<PostController>(tag: controllerTag);
        final resultIndex = controller.posts.indexWhere((e) => e.id == post.id);

        if (resultIndex != -1) {
          controller.posts[resultIndex].isFavorites = !post.isFavorites;
          controller.updateAllTags();
        }
      } catch (_) {}
    }

    await super.addToFavorites(index, onError);
  }
}
