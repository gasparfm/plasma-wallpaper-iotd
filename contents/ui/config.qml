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


import QtQuick 2.5
import QtQuick.Dialogs 1.2
import QtQuick.Layouts 1.3
import QtQuick.Controls 1.4

import org.kde.plasma.core 2.0 as Plasmacore
import org.kde.plasma.wallpapers.image 2.0 as Wallpaper
import org.kde.kquickcontrolsaddons 2.0

ColumnLayout {
    id: root;
    objectName: "root";

    property alias cfg_Color;
    property alias cfg_FillMode;
    property alias cfg_ChangeInterval;

    property alias cfg_SourceBing;

    Label {
        text: i18n("General")
    }

    Row {
        Label {
            id: sizePositionLabel;
            text: i18n("Size and Position:")
        }

        ComboBox {
            id: sizePositionCombo;
            model: [
                { "label": i18n("Scaled and Cropped"), "fillMode": Image.PreserveAspectCrop },
                { "label": i18n("Scaled"), "fillMode": Image.Stretch },
                { "label": i18n("Scaled, Keep Proportions"), "fillMode": Image.PreserveAspectFit },
                { "label": i18n("Centered"), "fillMode": Image.Pad },
                { "label": i18n("Tiled"), "fillMode": Image.Tile }
            ]
            textRole: "label"
            onCurrentIndexChanged: cfg_FillMode = model[currentIndex]["fillMode"]
        }
    }

    Row {
        Label {
            id: colorLabel;
            text: i18n("Default Color:")
        }

        Rectangle {
            color: cfg_Color;
        }
    }
}
