# p1gd0g flutte template

## build

```
$ENV:build_vsn='0.7.0'
flutter build web --build-name $ENV:build_vsn --dart-define vsn=$ENV:build_vsn --output public
```

## generate icon

1. Setup the config file

Run the following command to create a new config automatically:

```shell
dart run flutter_launcher_icons:generate
```

This will create a new file called `flutter_launcher_icons.yaml` in your `flutter` project's root directory.

2. Run the package

After setting up the configuration, all that is left to do is run the package.

```shell
flutter pub get
dart run flutter_launcher_icons
```