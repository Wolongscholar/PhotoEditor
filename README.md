# photo_editor

This is a sample Flutter project to edit photos:
- Take picture from camera or pick from gallery.
- Support filter and sticker effects.
- Save to gallery, save draft.

## Screens
- Home screen: show draft photos grid view.
- Photo edit screen: edit photo.
- Sticker screen: select sticker.

## Source code structures
- lib/Screen: home, photo edit, sticker selection screens
- lib/View: camera live view, filter view, sticker view, draft grid view
- lib/Model: draft, sticker model, database service
- lib/Bloc: draft cubit
- lib/Provider: filter provider

## References

I refer source codes:
- Take picture from camera:
https://flutter.dev/docs/cookbook/plugins/picture-using-camera
- Filter effect:
https://flutter.dev/docs/cookbook/effects/photo-filter-carousel

Other packages:
- Hive database for saving draft photos.
- Bloc for emitting new drafts.
- Provider for emitting new filter color.
- Path provider for saving photo to app document directory.
- Image picker for picking photo from device gallery.
- Image gallery saver for saving photo to gallery.

## Note

This sample has just been configured and tested for iOS device, not Androids yet. iOS simulator still can work without camera live view.

There are still some problems:
- Drag, scale and rotate sticker are conflicted so can not perform them all.
