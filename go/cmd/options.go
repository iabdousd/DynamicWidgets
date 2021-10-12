package main

import (
	"github.com/go-flutter-desktop/go-flutter"
	file_picker "github.com/miguelpruivo/flutter_file_picker/go"
)

var options = []flutter.Option{
	flutter.WindowInitialDimensions(1280, 1280),
	flutter.AddPlugin(&file_picker.FilePickerPlugin{}),
}
