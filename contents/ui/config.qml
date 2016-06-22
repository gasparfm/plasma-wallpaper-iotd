/*
 *  Copyright (C) 2016 Boudhayan Gupta <bgupta@kde.org>
 *
 *  This program is free software; you can redistribute it and/or modify
 *  it under the terms of the GNU Lesser General Public License as published by
 *  the Free Software Foundation; either version 2 of the License, or
 *  (at your option) any later version.
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU Lesser General Public License
 *  along with this program; if not, write to the Free Software
 *  Foundation, Inc., 51 Franklin Street, Fifth Floor,
 *  Boston, MA 02110-1301, USA.
 */

import QtQuick 2.6
import QtQuick.Dialogs 1.2
import QtQuick.Layouts 1.3
import QtQuick.Controls 1.4

import org.kde.plasma.core 2.0 as PlasmaCore

Column {
    id: root;
    objectName: "root";

    property var cfg_FillMode;
    property int cfg_ChangeInterval;
    property string cfg_FallbackImage;

    property alias cfg_Color: bgColorDialog.color;
    property alias cfg_SourceBing: srcBing.checked;
    property alias cfg_SourceNasa: srcNasa.checked;
    property alias cfg_SourceUnsplash: srcUnsplash.checked;

    spacing: units.largeSpacing / 2;

    Row {
        spacing: units.largeSpacing / 2;
        topPadding: units.largeSpacing / 2;

        Label {
            text: i18n("General")

            font.pointSize: theme.defaultFont.pointSize * 1.25;
            font.bold: true;
        }
    }

    Row {
        id: sizePositionRow;
        spacing: units.largeSpacing / 2;

        Label {
            id: sizePositionLabel;
            text: i18n("Size and Position:")

            width: formAlignment - units.largeSpacing;
            anchors.verticalCenter: sizePositionCombo.verticalCenter;
            horizontalAlignment: Text.AlignRight;
        }

        ComboBox {
            id: sizePositionCombo;
            width: theme.mSize(theme.defaultFont).width * 24;

            model: [
                { "label": i18n("Scaled and Cropped"), "fillMode": Image.PreserveAspectCrop },
                { "label": i18n("Scaled"), "fillMode": Image.Stretch },
                { "label": i18n("Scaled, Keep Proportions"), "fillMode": Image.PreserveAspectFit },
                { "label": i18n("Centered"), "fillMode": Image.Pad },
                { "label": i18n("Tiled"), "fillMode": Image.Tile }
            ]
            textRole: "label";

            Component.onCompleted: { readSizePosition(); }
            onCurrentIndexChanged: { writeSizePosition(); }

            function readSizePosition() {
                for (var i in model) {
                    if (model[i]["fillMode"] == wallpaper.configuration.FillMode) {
                        sizePositionCombo.currentIndex = i;
                        return;
                    }
                }
            }

            function writeSizePosition() {
                cfg_FillMode = model[sizePositionCombo.currentIndex]["fillMode"];
            }
        }
    }

    Row {
        id: bgColorRow;
        spacing: units.largeSpacing / 2;

        Label {
            id: bgColorLabel;
            text: i18n("Background Color:");

            width: formAlignment - units.largeSpacing;
            anchors.verticalCenter: bgColorButton.verticalCenter;
            horizontalAlignment: Text.AlignRight;
        }

        Button {
            id: bgColorButton;
            width: units.gridUnit * 3;
            onClicked: { bgColorDialog.open(); }

            Rectangle {
                id: bgColorRect;
                anchors.centerIn: parent;
                width: parent.width - 2 * units.smallSpacing;
                height: theme.mSize(theme.defaultFont).height;
                color: bgColorDialog.color;
                radius: 2;
            }
        }
    }

    Row {
        id: intervalRow;
        spacing: units.largeSpacing / 2;

        Label {
            id: intervalLabel;
            text: i18n("Change Interval:");

            width: formAlignment - units.largeSpacing;
            anchors.verticalCenter: intervalSettingsRow.verticalCenter;
            horizontalAlignment: Text.AlignRight;
        }

        Row {
            id: intervalSettingsRow
            spacing: units.smallSpacing / 2;

            SpinBox {
                id: intervalHours;
                minimumValue: 0;
                maximumValue: 23;

                Component.onCompleted: {
                    value = Math.floor(wallpaper.configuration.ChangeInterval / 3600000);
                }
                onValueChanged: { intervalSettingsRow.validateChange(); }
            }

            Label {
                text: i18n("hours");
                anchors.verticalCenter: intervalHours.verticalCenter;
            }

            SpinBox {
                id: intervalMinutes;
                minimumValue: 0;
                maximumValue: 59;

                Component.onCompleted: {
                    value = Math.floor((wallpaper.configuration.ChangeInterval % 3600000) / 60000);
                }
                onValueChanged: { intervalSettingsRow.validateChange(); }
            }

            Label {
                text: i18n("minutes");
                anchors.verticalCenter: intervalMinutes.verticalCenter;
            }

            function validateChange() {
                if (intervalHours.value < 1) {
                    intervalMinutes.minimumValue = 15;
                } else {
                    intervalMinutes.minimumValue = 0;
                }

                var hours = intervalHours.value * 3600000;
                var minutes = intervalMinutes.value * 60000;
                cfg_ChangeInterval = hours + minutes;
            }
        }
    }

    Row {
        id: fallbackImageRow;
        spacing: units.largeSpacing / 2;

        Label {
            id: fallbackImageLabel;
            text: i18n("Fallback Image:");

            width: formAlignment - units.largeSpacing;
            anchors.verticalCenter: fallbackImageButton.verticalCenter;
            horizontalAlignment: Text.AlignRight;
        }

        Button {
            id: fallbackImageButton;
            width: theme.mSize(theme.defaultFont).width * 24;
            text: {
                var url = cfg_FallbackImage
                return url.substring(url.lastIndexOf("/") + 1);
            }
            onClicked: { fallbackImageDialog.open(); }

            FileDialog {
                id: fallbackImageDialog;

                title: i18n("Please choose an image")
                modality: Qt.WindowModal;
                folder: shortcuts.pictures;

                nameFilters: [ "Image files (*.jpg *.jpe *.jpeg *.png *.bmp *.svg *.svgz)" ];
                selectExisting: true;
                selectFolder: false;
                selectMultiple: false;

                onAccepted: { cfg_FallbackImage = fileUrl; }
            }
        }
    }

    Row {
        spacing: units.largeSpacing / 2;
        topPadding: units.largeSpacing / 2;
        bottomPadding: units.largeSpacing / 2;

        Label {
            text: i18n("Sources")

            font.pointSize: theme.defaultFont.pointSize * 1.25;
            font.bold: true;
        }
    }

    Column {
        spacing: units.largeSpacing / 2;
        leftPadding: units.gridUnit;

        CheckBox {
            id: srcBing;
            text: i18n("Bing");
        }

        CheckBox {
            id: srcNasa;
            text: i18n("NASA Astronomy Picture of the Day");
        }

        CheckBox {
            id: srcUnsplash;
            text: i18n("Featured Images from Unsplash.com");
        }
    }

    ColorDialog {
        id: bgColorDialog;
        objectName: "bgColorDialog";

        modality: Qt.WindowModal;
        showAlphaChannel: false;
        title: i18n("Background Color");
    }
}
